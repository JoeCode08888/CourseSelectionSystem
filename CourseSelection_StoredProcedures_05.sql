USE CourseSelectionSystem;
GO

/*==========================================================
  SP: sp_DescribeCourseSelectionSystem
  說明：生成 CourseSelectionSystem 資料庫所有表格與欄位註解
  輸出欄位：
    - table_name      表格名稱
    - column_name     欄位名稱
    - data_type       資料型別
    - is_primary_key  是否為主鍵 (Y/N)
    - is_foreign_key  是否為外鍵 (Y/N)
    - description     註解說明
==========================================================*/
CREATE OR ALTER PROCEDURE sp_DescribeCourseSelectionSystem
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM (
        -- departments
        SELECT 'departments' AS table_name, 'id' AS column_name, 'INT' AS data_type, 'Y' AS is_primary_key, 'N' AS is_foreign_key, '主鍵，系所唯一識別碼，自動遞增' AS description
        UNION ALL
            SELECT 'departments', 'code', 'NVARCHAR(20)', 'N', 'N', '系所代碼，不可重複'
        UNION ALL
            SELECT 'departments', 'name', 'NVARCHAR(100)', 'N', 'N', '系所名稱'
        UNION ALL
            SELECT 'departments', 'created_at', 'DATETIME', 'N', 'N', '建立時間，預設系統時間'
        UNION ALL
            SELECT 'departments', 'updated_at', 'DATETIME', 'N', 'N', '更新時間，預設系統時間'

        -- students
        UNION ALL
            SELECT 'students', 'id', 'INT', 'Y', 'N', '主鍵，學生ID，自動遞增'
        UNION ALL
            SELECT 'students', 'student_no', 'NVARCHAR(20)', 'N', 'N', '學生學號，唯一不可重複'
        UNION ALL
            SELECT 'students', 'name', 'NVARCHAR(100)', 'N', 'N', '學生姓名'
        UNION ALL
            SELECT 'students', 'email', 'NVARCHAR(100)', 'N', 'N', '電子信箱，唯一不可重複'
        UNION ALL
            SELECT 'students', 'phone', 'NVARCHAR(20)', 'N', 'N', '聯絡電話'
        UNION ALL
            SELECT 'students', 'department_id', 'INT', 'N', 'Y', '外鍵，對應 departments.id'
        UNION ALL
            SELECT 'students', 'grade', 'INT', 'N', 'N', '年級'
        UNION ALL
            SELECT 'students', 'status', 'NVARCHAR(20)', 'N', 'N', '學生狀態 (active, leave, graduated)'
        UNION ALL
            SELECT 'students', 'created_at', 'DATETIME', 'N', 'N', '建立時間'
        UNION ALL
            SELECT 'students', 'updated_at', 'DATETIME', 'N', 'N', '更新時間'

        -- teachers
        UNION ALL
            SELECT 'teachers', 'id', 'INT', 'Y', 'N', '主鍵，教師ID，自動遞增'
        UNION ALL
            SELECT 'teachers', 'teacher_no', 'NVARCHAR(20)', 'N', 'N', '教師編號，不可重複'
        UNION ALL
            SELECT 'teachers', 'name', 'NVARCHAR(100)', 'N', 'N', '教師姓名'
        UNION ALL
            SELECT 'teachers', 'email', 'NVARCHAR(100)', 'N', 'N', '電子信箱，唯一不可重複'
        UNION ALL
            SELECT 'teachers', 'department_id', 'INT', 'N', 'Y', '外鍵，對應 departments.id'
        UNION ALL
            SELECT 'teachers', 'title', 'NVARCHAR(50)', 'N', 'N', '職稱'
        UNION ALL
            SELECT 'teachers', 'created_at', 'DATETIME', 'N', 'N', '建立時間'
        UNION ALL
            SELECT 'teachers', 'updated_at', 'DATETIME', 'N', 'N', '更新時間'

        -- courses
        UNION ALL
            SELECT 'courses', 'id', 'INT', 'Y', 'N', '主鍵，課程ID，自動遞增'
        UNION ALL
            SELECT 'courses', 'course_code', 'NVARCHAR(20)', 'N', 'N', '課程代碼，不可重複'
        UNION ALL
            SELECT 'courses', 'name', 'NVARCHAR(100)', 'N', 'N', '課程名稱'
        UNION ALL
            SELECT 'courses', 'credits', 'INT', 'N', 'N', '學分數，必須大於0'
        UNION ALL
            SELECT 'courses', 'department_id', 'INT', 'N', 'Y', '外鍵，對應 departments.id'
        UNION ALL
            SELECT 'courses', 'description', 'NVARCHAR(MAX)', 'N', 'N', '課程說明'
        UNION ALL
            SELECT 'courses', 'required_type', 'NVARCHAR(20)', 'N', 'N', '必修或選修 (required, elective)'
        UNION ALL
            SELECT 'courses', 'created_at', 'DATETIME', 'N', 'N', '建立時間'
        UNION ALL
            SELECT 'courses', 'updated_at', 'DATETIME', 'N', 'N', '更新時間'

        -- semesters
        UNION ALL
            SELECT 'semesters', 'id', 'INT', 'Y', 'N', '主鍵，學期ID，自動遞增'
        UNION ALL
            SELECT 'semesters', 'academic_year', 'INT', 'N', 'N', '學年度'
        UNION ALL
            SELECT 'semesters', 'term', 'INT', 'N', 'N', '學期 (1=上, 2=下)'
        UNION ALL
            SELECT 'semesters', 'start_date', 'DATE', 'N', 'N', '開始日期'
        UNION ALL
            SELECT 'semesters', 'end_date', 'DATE', 'N', 'N', '結束日期'

        -- classrooms
        UNION ALL
            SELECT 'classrooms', 'id', 'INT', 'Y', 'N', '主鍵，教室ID，自動遞增'
        UNION ALL
            SELECT 'classrooms', 'building', 'NVARCHAR(50)', 'N', 'N', '大樓名稱'
        UNION ALL
            SELECT 'classrooms', 'room_number', 'NVARCHAR(20)', 'N', 'N', '教室編號'
        UNION ALL
            SELECT 'classrooms', 'capacity', 'INT', 'N', 'N', '容量'

        -- course_sections
        UNION ALL
            SELECT 'course_sections', 'id', 'INT', 'Y', 'N', '主鍵，開課ID，自動遞增'
        UNION ALL
            SELECT 'course_sections', 'course_id', 'INT', 'N', 'Y', '外鍵，對應 courses.id'
        UNION ALL
            SELECT 'course_sections', 'semester_id', 'INT', 'N', 'Y', '外鍵，對應 semesters.id'
        UNION ALL
            SELECT 'course_sections', 'section_code', 'NVARCHAR(10)', 'N', 'N', '班別代碼'
        UNION ALL
            SELECT 'course_sections', 'teacher_id', 'INT', 'N', 'Y', '外鍵，對應 teachers.id'
        UNION ALL
            SELECT 'course_sections', 'classroom_id', 'INT', 'N', 'Y', '外鍵，對應 classrooms.id'
        UNION ALL
            SELECT 'course_sections', 'max_students', 'INT', 'N', 'N', '人數上限'
        UNION ALL
            SELECT 'course_sections', 'status', 'NVARCHAR(20)', 'N', 'N', '開課狀態 (open, closed, full)'
        UNION ALL
            SELECT 'course_sections', 'created_at', 'DATETIME', 'N', 'N', '建立時間'
        UNION ALL
            SELECT 'course_sections', 'updated_at', 'DATETIME', 'N', 'N', '更新時間'

        -- course_schedules
        UNION ALL
            SELECT 'course_schedules', 'id', 'INT', 'Y', 'N', '主鍵，時段ID，自動遞增'
        UNION ALL
            SELECT 'course_schedules', 'course_section_id', 'INT', 'N', 'Y', '外鍵，對應 course_sections.id'
        UNION ALL
            SELECT 'course_schedules', 'weekday', 'INT', 'N', 'N', '星期 (1~7)'
        UNION ALL
            SELECT 'course_schedules', 'start_period', 'INT', 'N', 'N', '開始節次'
        UNION ALL
            SELECT 'course_schedules', 'end_period', 'INT', 'N', 'N', '結束節次'

        -- enrollments
        UNION ALL
            SELECT 'enrollments', 'id', 'INT', 'Y', 'N', '主鍵，選課ID，自動遞增'
        UNION ALL
            SELECT 'enrollments', 'student_id', 'INT', 'N', 'Y', '外鍵，對應 students.id'
        UNION ALL
            SELECT 'enrollments', 'course_section_id', 'INT', 'N', 'Y', '外鍵，對應 course_sections.id'
        UNION ALL
            SELECT 'enrollments', 'status', 'NVARCHAR(20)', 'N', 'N', '選課狀態 (enrolled, dropped, waitlisted)'
        UNION ALL
            SELECT 'enrollments', 'enrolled_at', 'DATETIME', 'N', 'N', '選課時間'

        -- grades
        UNION ALL
            SELECT 'grades', 'id', 'INT', 'Y', 'N', '主鍵，成績ID，自動遞增'
        UNION ALL
            SELECT 'grades', 'enrollment_id', 'INT', 'N', 'Y', '外鍵，對應 enrollments.id'
        UNION ALL
            SELECT 'grades', 'grade_type', 'NVARCHAR(20)', 'N', 'N', '成績類型'
        UNION ALL
            SELECT 'grades', 'score', 'DECIMAL(5,2)', 'N', 'N', '成績分數，0~100'

        -- course_prerequisites
        UNION ALL
            SELECT 'course_prerequisites', 'id', 'INT', 'Y', 'N', '主鍵，自動遞增'
        UNION ALL
            SELECT 'course_prerequisites', 'course_id', 'INT', 'N', 'Y', '外鍵，對應 courses.id (主課程)'
        UNION ALL
            SELECT 'course_prerequisites', 'prerequisite_course_id', 'INT', 'N', 'Y', '外鍵，對應 courses.id (先修課程)'

        -- accounts
        UNION ALL
            SELECT 'accounts', 'id', 'INT', 'Y', 'N', '主鍵，帳號ID，自動遞增'
        UNION ALL
            SELECT 'accounts', 'student_id', 'INT', 'N', 'Y', '外鍵，對應 students.id，一個學生對應一個帳號'
        UNION ALL
            SELECT 'accounts', 'username', 'NVARCHAR(50)', 'N', 'N', '登入帳號名稱，唯一'
        UNION ALL
            SELECT 'accounts', 'password_hash', 'NVARCHAR(255)', 'N', 'N', '密碼雜湊值'
        UNION ALL
            SELECT 'accounts', 'created_at', 'DATETIME2', 'N', 'N', '建立時間'
        UNION ALL
            SELECT 'accounts', 'updated_at', 'DATETIME2', 'N', 'N', '更新時間'
    ) AS er_description
    ORDER BY table_name, column_name;
END;
GO

-- 執行 SP 生成 ER 註解清單
EXEC sp_DescribeCourseSelectionSystem;