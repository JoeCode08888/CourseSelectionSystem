USE CourseSelectionSystem;
GO

PRINT '================== 50學生隨機選課測試開始 ==================';

--------------------------------------------------------------------------------
-- 1. 不清空 enrollments 表，保證資料完整性
PRINT '不再清空 enrollments 表，保證資料完整性';
GO

--------------------------------------------------------------------------------
-- 2. 隨機選課函數 (每位學生 3~5 門課，重試避免衝堂/滿班)
DECLARE @semester_id INT = 1; -- 確保宣告 semester_id
DECLARE @student_id INT, @course_section_id INT;
DECLARE @num_courses INT, @counter INT, @try_count INT;

DECLARE student_cursor CURSOR FOR
SELECT id FROM students WHERE status='active';

OPEN student_cursor;
FETCH NEXT FROM student_cursor INTO @student_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- 每位學生隨機選 3~5 門課
    SET @num_courses = 3 + (ABS(CHECKSUM(NEWID())) % 3);
    SET @counter = 0;

    WHILE @counter < @num_courses
    BEGIN
        SET @try_count = 0;

        WHILE @try_count < 10 -- 最多重試 10 次，避免無法選到課
        BEGIN
            SELECT TOP 1 @course_section_id = cs.id
            FROM course_sections cs
            WHERE cs.semester_id = @semester_id
              AND cs.status = 'open' -- 確保只選擇開放的班別
            ORDER BY NEWID();

            BEGIN TRY
                EXEC sp_EnrollCourse @student_id = @student_id, @course_section_id = @course_section_id;
                BREAK; -- 成功選課，跳出重試
            END TRY
            BEGIN CATCH
                -- 遇到衝堂/重複課/滿班直接重試
                PRINT '學生 ' + CAST(@student_id AS NVARCHAR) + ' 會重試選課';
            END CATCH;

            SET @try_count = @try_count + 1;
        END

        SET @counter = @counter + 1;
    END

    FETCH NEXT FROM student_cursor INTO @student_id;
END

CLOSE student_cursor;
DEALLOCATE student_cursor;

PRINT '所有學生選課完成';
GO

--------------------------------------------------------------------------------
-- 3. 查看班級狀態（候補與正式）
PRINT '查看班級 enrollments 狀態';

DECLARE @semester_id INT = 1; -- 這裡再次宣告 semester_id

SELECT e.course_section_id, cs.section_code, c.name AS course_name,
       e.student_id, s.name AS student_name, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN course_sections cs ON e.course_section_id = cs.id
JOIN courses c ON cs.course_id = c.id
WHERE cs.semester_id = @semester_id
ORDER BY e.course_section_id, e.status;
GO

--------------------------------------------------------------------------------
-- 4. 模擬退選與候補升格
PRINT '模擬退選及候補升格';

DECLARE @semester_id INT = 1; -- 這裡再次宣告 semester_id
DECLARE @student_id INT;

DECLARE student_cursor2 CURSOR FOR
SELECT id FROM students WHERE status='active';

OPEN student_cursor2;
FETCH NEXT FROM student_cursor2 INTO @student_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @num_drop INT = 1 + (ABS(CHECKSUM(NEWID())) % 2); -- 1~2 門課
    DECLARE @d_counter INT = 0;
    DECLARE @drop_course INT;

    WHILE @d_counter < @num_drop
    BEGIN
        -- 隨機選擇一門已選課程進行退選
        SELECT TOP 1 @drop_course = course_section_id
        FROM enrollments
        WHERE student_id = @student_id
          AND status='enrolled'
          AND course_section_id IN (SELECT id FROM course_sections WHERE semester_id=@semester_id)
        ORDER BY NEWID();

        IF @drop_course IS NOT NULL
        BEGIN
            BEGIN TRY
                -- 執行退選存儲過程
                EXEC sp_DropCourse @student_id = @student_id, @course_section_id = @drop_course;
            END TRY
            BEGIN CATCH
                -- 忽略錯誤
            END CATCH;

            SET @d_counter = @d_counter + 1;
        END
        ELSE
            BREAK;
    END

    FETCH NEXT FROM student_cursor2 INTO @student_id;
END

CLOSE student_cursor2;
DEALLOCATE student_cursor2;
PRINT '退選及候補升格完成';
GO

--------------------------------------------------------------------------------
-- 5. 檢查學分上下限
PRINT '檢查學生最低學分警告';

DECLARE @semester_id INT = 1; -- 這裡再次宣告 semester_id
DECLARE @student_id INT;

DECLARE student_cursor3 CURSOR FOR
SELECT id FROM students WHERE status='active';

OPEN student_cursor3;
FETCH NEXT FROM student_cursor3 INTO @student_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        EXEC sp_CheckMinCredits @student_id = @student_id, @semester_id = @semester_id;
    END TRY
    BEGIN CATCH
        PRINT '學生 ' + CAST(@student_id AS NVARCHAR) + ' 學分低於最低限制: ' + ERROR_MESSAGE();
    END CATCH;

    FETCH NEXT FROM student_cursor3 INTO @student_id;
END

CLOSE student_cursor3;
DEALLOCATE student_cursor3;
GO

--------------------------------------------------------------------------------
-- 6. 候補列表與升格順序報表
PRINT '================== 候補列表與升格順序報表 ==================';

DECLARE @semester_id INT = 1; -- 這裡再次宣告 semester_id

SELECT 
    cs.id AS course_section_id,
    c.name AS course_name,
    cs.section_code,
    s.id AS student_id,
    s.name AS student_name,
    e.status,
    CASE 
        WHEN e.status = 'waiting' THEN ROW_NUMBER() OVER (PARTITION BY cs.id ORDER BY e.id)
        ELSE NULL
    END AS waiting_order
FROM course_sections cs
JOIN courses c ON cs.course_id = c.id
LEFT JOIN enrollments e ON cs.id = e.course_section_id
LEFT JOIN students s ON e.student_id = s.id
WHERE cs.semester_id = @semester_id
ORDER BY cs.id, 
         CASE e.status WHEN 'enrolled' THEN 0 ELSE 1 END, 
         waiting_order;
GO

PRINT '================== 50學生隨機選課測試結束 ==================';

--------------------------------------------------------------------------------
-- 7. 每位學生選課統計報表
PRINT '================== 每位學生選課統計報表 ==================';

DECLARE @semester_id INT = 1; -- 這裡再次宣告 semester_id

SELECT 
    s.id AS student_id,
    s.name AS student_name,
    COUNT(CASE WHEN e.status = 'enrolled' THEN 1 END) AS enrolled_count,
    COUNT(CASE WHEN e.status = 'waiting' THEN 1 END) AS waiting_count,
    COUNT(*) AS total_selected
FROM students s
LEFT JOIN enrollments e ON s.id = e.student_id
LEFT JOIN course_sections cs ON e.course_section_id = cs.id
WHERE s.status = 'active' 
  AND cs.semester_id = @semester_id
GROUP BY s.id, s.name
ORDER BY s.id;
GO