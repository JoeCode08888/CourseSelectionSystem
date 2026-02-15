CREATE INDEX IX_enrollments_student 
ON enrollments(student_id);

CREATE INDEX IX_enrollments_section 
ON enrollments(course_section_id);

CREATE INDEX IX_course_schedules_section 
ON course_schedules(course_section_id);

CREATE UNIQUE INDEX UX_student_course 
ON enrollments(student_id, course_section_id);

--------------------------------------------------------------------------------
-- CourseSelection_Engine_04.sql
-- 核心選課引擎 (Enrollment Engine)
-- 包含：
-- 1. sp_EnrollCourse  選課（含候補）
-- 2. sp_DropCourse    退選（自動補候補）
-- 3. sp_CheckMinCredits 學期最低學分檢查
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 系統參數表（可調整學分限制）
--------------------------------------------------------------------------------
IF OBJECT_ID('system_settings') IS NULL
BEGIN
    CREATE TABLE system_settings (
        setting_name NVARCHAR(50) PRIMARY KEY,
        setting_value INT
    );

    INSERT INTO system_settings(setting_name, setting_value) VALUES
    ('max_credit_per_semester', 25),
    ('min_credit_per_semester', 9);
END
GO

--------------------------------------------------------------------------------
-- 選課程序
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_EnrollCourse
    @student_id INT,
    @course_section_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @max_students INT, @course_id INT, @semester_id INT;
        DECLARE @current_credit INT = 0, @new_credit INT;
        DECLARE @max_credit INT;

        SELECT @max_credit = setting_value FROM system_settings WHERE setting_name='max_credit_per_semester';

        ------------------------------------
        -- 1. 鎖定課程班別（防止超賣）
        ------------------------------------
        SELECT 
            @max_students = max_students,
            @course_id = course_id,
            @semester_id = semester_id
        FROM course_sections WITH (UPDLOCK, HOLDLOCK)
        WHERE id = @course_section_id
          AND status = 'open';

        IF @max_students IS NULL
        BEGIN
            RAISERROR('課程不存在或未開放',16,1);
            ROLLBACK;
            RETURN;
        END

        ------------------------------------
        -- 2. 學生狀態檢查
        ------------------------------------
        IF NOT EXISTS (
            SELECT 1 FROM students
            WHERE id = @student_id
              AND status = 'active'
        )
        BEGIN
            RAISERROR('學生無選課資格',16,1);
            ROLLBACK;
            RETURN;
        END

        ------------------------------------
        -- 3. 重複選課檢查
        ------------------------------------
        IF EXISTS (
            SELECT 1
            FROM enrollments e
            JOIN course_sections cs ON e.course_section_id = cs.id
            WHERE e.student_id = @student_id
              AND cs.course_id = @course_id
              AND e.status = 'enrolled'
        )
        BEGIN
            RAISERROR('不可重複選同一門課',16,1);
            ROLLBACK;
            RETURN;
        END

        ------------------------------------
        -- 4. 衝堂檢查
        ------------------------------------
        IF EXISTS (
            SELECT 1
            FROM enrollments e
            JOIN course_schedules s1 ON e.course_section_id = s1.course_section_id
            JOIN course_schedules s2 ON s2.course_section_id = @course_section_id
            WHERE e.student_id = @student_id
              AND e.status = 'enrolled'
              AND s1.weekday = s2.weekday
              AND s1.start_period <= s2.end_period
              AND s1.end_period >= s2.start_period
        )
        BEGIN
            RAISERROR('課程時間衝突',16,1);
            ROLLBACK;
            RETURN;
        END

        ------------------------------------
        -- 5. 學分上限檢查
        ------------------------------------
        SELECT @current_credit = ISNULL(SUM(c.credits),0)
        FROM enrollments e
        JOIN course_sections cs ON e.course_section_id = cs.id
        JOIN courses c ON cs.course_id = c.id
        WHERE e.student_id = @student_id
          AND cs.semester_id = @semester_id
          AND e.status = 'enrolled';

        SELECT @new_credit = credits
        FROM courses
        WHERE id = @course_id;

        IF @current_credit + @new_credit > @max_credit
        BEGIN
            RAISERROR('超過學分上限',16,1);
            ROLLBACK;
            RETURN;
        END

        ------------------------------------
        -- 6. 先修課檢查
        ------------------------------------
        IF EXISTS (
            SELECT 1
            FROM course_prerequisites cp
            WHERE cp.course_id = @course_id
            AND NOT EXISTS (
                SELECT 1
                FROM enrollments e
                JOIN grades g ON g.enrollment_id = e.id
                WHERE e.student_id = @student_id
                  AND e.course_section_id = cp.prerequisite_course_id
                  AND g.score >= 60
            )
        )
        BEGIN
            RAISERROR('未完成先修課',16,1);
            ROLLBACK;
            RETURN;
        END

        ------------------------------------
        -- 7. 是否滿班
        ------------------------------------
        DECLARE @current_count INT;

        SELECT @current_count = COUNT(*)
        FROM enrollments
        WHERE course_section_id = @course_section_id
          AND status = 'enrolled';

        IF @current_count >= @max_students
        BEGIN
            -- 加入候補
            INSERT INTO enrollments(student_id, course_section_id, status)
            VALUES (@student_id, @course_section_id, 'waiting');

            COMMIT;
            RETURN;
        END

        ------------------------------------
        -- 8. 正式選課
        ------------------------------------
        INSERT INTO enrollments(student_id, course_section_id, status)
        VALUES (@student_id, @course_section_id, 'enrolled');

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO

--------------------------------------------------------------------------------
-- 退選程序（改進候補升格檢查衝堂與學分）
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_DropCourse
    @student_id INT,
    @course_section_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        ------------------------------------
        -- 0. 確認學生已選此課
        ------------------------------------
        IF NOT EXISTS (
            SELECT 1 FROM enrollments
            WHERE student_id = @student_id
              AND course_section_id = @course_section_id
              AND status = 'enrolled'
        )
        BEGIN
            RAISERROR('未選此課程',16,1);
            ROLLBACK;
            RETURN;
        END

        ------------------------------------
        -- 1. 刪除學生選課
        ------------------------------------
        DELETE FROM enrollments
        WHERE student_id = @student_id
          AND course_section_id = @course_section_id
          AND status = 'enrolled';

        ------------------------------------
        -- 2. 補候補（檢查衝堂與學分）
        ------------------------------------
        DECLARE @next_student INT;
        DECLARE @semester_id INT;
        DECLARE @max_credit INT;
        DECLARE @student_credit INT;
        DECLARE @new_course_credit INT;

        SELECT @semester_id = cs.semester_id
        FROM course_sections cs
        WHERE cs.id = @course_section_id;

        SELECT @max_credit = setting_value
        FROM system_settings
        WHERE setting_name='max_credit_per_semester';

        SELECT @new_course_credit = c.credits
        FROM courses c
        JOIN course_sections cs ON c.id = cs.course_id
        WHERE cs.id = @course_section_id;

        DECLARE candidate_cursor CURSOR FOR
        SELECT student_id
        FROM enrollments
        WHERE course_section_id = @course_section_id
          AND status = 'waiting'
        ORDER BY id;

        OPEN candidate_cursor;
        FETCH NEXT FROM candidate_cursor INTO @next_student;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- 檢查衝堂
            IF NOT EXISTS (
                SELECT 1
                FROM enrollments e
                JOIN course_schedules s1 ON e.course_section_id = s1.course_section_id
                JOIN course_schedules s2 ON s2.course_section_id = @course_section_id
                JOIN course_sections cs ON e.course_section_id = cs.id
                WHERE e.student_id = @next_student
                  AND e.status = 'enrolled'
                  AND s1.weekday = s2.weekday
                  AND s1.start_period <= s2.end_period
                  AND s1.end_period >= s2.start_period
            )
            BEGIN
                -- 檢查學分上限
                SELECT @student_credit = ISNULL(SUM(c.credits),0)
                FROM enrollments e
                JOIN course_sections cs ON e.course_section_id = cs.id
                JOIN courses c ON cs.course_id = c.id
                WHERE e.student_id = @next_student
                  AND cs.semester_id = @semester_id
                  AND e.status = 'enrolled';

                IF @student_credit + @new_course_credit <= @max_credit
                BEGIN
                    -- 升格為正式選課
                    UPDATE enrollments
                    SET status = 'enrolled'
                    WHERE student_id = @next_student
                      AND course_section_id = @course_section_id;

                    BREAK; -- 只升格一名候補
                END
            END

            FETCH NEXT FROM candidate_cursor INTO @next_student;
        END

        CLOSE candidate_cursor;
        DEALLOCATE candidate_cursor;

        COMMIT;

        ------------------------------------
        -- 3. 退選後學分提醒（警告，不阻止）
        ------------------------------------
        DECLARE @min_credit INT;
        DECLARE @total_credit INT;

        SELECT @min_credit = setting_value
        FROM system_settings
        WHERE setting_name='min_credit_per_semester';

        SELECT @total_credit = ISNULL(SUM(c.credits),0)
        FROM enrollments e
        JOIN course_sections cs ON e.course_section_id = cs.id
        JOIN courses c ON cs.course_id = c.id
        WHERE e.student_id = @student_id
          AND cs.semester_id = @semester_id
          AND e.status = 'enrolled';

        IF @total_credit < @min_credit
        BEGIN
            PRINT '警告：退選後學分低於最低要求 (' + CAST(@min_credit AS NVARCHAR) + '學分)，請注意！';
        END

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO

--------------------------------------------------------------------------------
-- 學期最低學分檢查
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_CheckMinCredits
    @student_id INT,
    @semester_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @total_credit INT;
    DECLARE @min_credit INT;

    -- 取得最低學分
    SELECT @min_credit = setting_value
    FROM system_settings
    WHERE setting_name = 'min_credit_per_semester';

    -- 計算學生已選學分
    SELECT @total_credit = ISNULL(SUM(c.credits), 0)
    FROM enrollments e
    JOIN course_sections cs ON e.course_section_id = cs.id
    JOIN courses c ON cs.course_id = c.id
    WHERE e.student_id = @student_id
      AND cs.semester_id = @semester_id
      AND e.status = 'enrolled';

    -- 檢查學分是否低於最低學分
    IF @total_credit < @min_credit
    BEGIN
        -- 使用 CAST 或 CONVERT 函數將數字轉為字串並進行拼接
        DECLARE @error_message NVARCHAR(200);
        SET @error_message = '未達最低學分限制 (' + CAST(@min_credit AS NVARCHAR(10)) + ' 學分)，請注意！';

        RAISERROR(@error_message, 16, 1);
    END
END
GO