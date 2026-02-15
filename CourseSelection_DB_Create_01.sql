/*==========================================================
  建立資料庫
  說明：建立選課系統資料庫
==========================================================*/
CREATE DATABASE CourseSelectionSystem;
GO

USE CourseSelectionSystem;
GO


/*==========================================================
  1. 系所表 departments
  說明：儲存所有系所基本資料
  關係：一個系所對多個學生 / 教師 / 課程 (1:N)
==========================================================*/
CREATE TABLE departments (
    id INT PRIMARY KEY IDENTITY(1,1),           -- 主鍵，系所唯一識別碼，自動遞增
    code NVARCHAR(20) NOT NULL UNIQUE,          -- 系所代碼，不可重複
    name NVARCHAR(100) NOT NULL,                -- 系所名稱
    created_at DATETIME DEFAULT GETDATE(),      -- 建立時間，預設為系統時間
    updated_at DATETIME DEFAULT GETDATE()       -- 更新時間
);
GO


/*==========================================================
  2. 學生表 students
  說明：儲存學生基本資料
  關係：多個學生屬於一個系所 (N:1)
==========================================================*/
CREATE TABLE students (
    id INT PRIMARY KEY IDENTITY(1,1),                             -- 主鍵，學生ID
    student_no NVARCHAR(20) NOT NULL UNIQUE,                      -- 學號，唯一不可重複
    name NVARCHAR(100) NOT NULL,                                  -- 學生姓名
    email NVARCHAR(100) UNIQUE,                                   -- 電子信箱，不可重複
    phone NVARCHAR(20),                                           -- 聯絡電話
    department_id INT NOT NULL,                                   -- 外鍵，對應 departments.id
    grade INT,                                                    -- 年級
    status NVARCHAR(20) DEFAULT 'active',                         -- 學生狀態
    created_at DATETIME DEFAULT GETDATE(),                        -- 建立時間
    updated_at DATETIME DEFAULT GETDATE(),                        -- 更新時間
    CONSTRAINT chk_student_status 
        CHECK (status IN ('active','leave','graduated')),         -- 限制學生狀態只能為指定值
    CONSTRAINT fk_students_department
        FOREIGN KEY (department_id) REFERENCES departments(id)    -- 外鍵：學生所屬系所
);
GO


/*==========================================================
  3. 教師表 teachers
  說明：儲存教師資料
  關係：多個教師屬於一個系所 (N:1)
==========================================================*/
CREATE TABLE teachers (
    id INT PRIMARY KEY IDENTITY(1,1),                             -- 主鍵，教師ID
    teacher_no NVARCHAR(20) NOT NULL UNIQUE,                      -- 教師編號，不可重複
    name NVARCHAR(100) NOT NULL,                                  -- 教師姓名
    email NVARCHAR(100) UNIQUE,                                   -- 電子信箱
    department_id INT NOT NULL,                                   -- 外鍵，所屬系所
    title NVARCHAR(50),                                           -- 職稱
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_teachers_department
        FOREIGN KEY (department_id) REFERENCES departments(id)    -- 外鍵：約束教師必須屬於某系所
);
GO


/*==========================================================
  4. 課程主檔 courses
  說明：課程模板資料（非實際開課）
  關係：一個課程可在不同學期開多次 (1:N)
==========================================================*/
CREATE TABLE courses (
    id INT PRIMARY KEY IDENTITY(1,1),                             -- 主鍵，課程ID
    course_code NVARCHAR(20) NOT NULL UNIQUE,                     -- 課程代碼，不可重複
    name NVARCHAR(100) NOT NULL,                                  -- 課程名稱
    credits INT NOT NULL,                                         -- 學分數
    department_id INT NOT NULL,                                   -- 開課系所
    description NVARCHAR(MAX),                                    -- 課程說明
    required_type NVARCHAR(20),                                   -- 必修或選修
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT chk_credits 
        CHECK (credits > 0),                                      -- 學分必須大於0
    CONSTRAINT chk_required_type 
        CHECK (required_type IN ('required','elective')),         -- 限制必修或選修
    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id) REFERENCES departments(id)    -- 外鍵：課程所屬系所
);
GO


/*==========================================================
  5. 學期表 semesters
==========================================================*/
CREATE TABLE semesters (
    id INT PRIMARY KEY IDENTITY(1,1),                       -- 主鍵，學期ID
    academic_year INT NOT NULL,                             -- 學年度
    term INT NOT NULL,                                      -- 學期 (1=上, 2=下)
    start_date DATE,                                        -- 開始日期
    end_date DATE,                                          -- 結束日期
    CONSTRAINT chk_term CHECK (term IN (1,2)),              -- 學期只能是1或2
    CONSTRAINT uq_year_term UNIQUE (academic_year, term)    -- 同一年同學期不可重複
);
GO


/*==========================================================
  6. 教室表 classrooms
==========================================================*/
CREATE TABLE classrooms (
    id INT PRIMARY KEY IDENTITY(1,1),                            -- 主鍵，教室ID
    building NVARCHAR(50) NOT NULL,                              -- 大樓名稱
    room_number NVARCHAR(20) NOT NULL,                           -- 教室編號
    capacity INT NOT NULL,                                       -- 容量
    CONSTRAINT chk_capacity CHECK (capacity > 0),                -- 容量必須大於0
    CONSTRAINT uq_building_room UNIQUE (building, room_number)   -- 同一棟大樓教室編號不可重複
);
GO


/*==========================================================
  7. 開課表 course_sections (核心表)
  說明：實際開課資料
==========================================================*/
CREATE TABLE course_sections (
    id INT PRIMARY KEY IDENTITY(1,1),                        -- 主鍵，開課ID
    course_id INT NOT NULL,                                  -- 外鍵，課程ID
    semester_id INT NOT NULL,                                -- 外鍵，學期ID
    section_code NVARCHAR(10) NOT NULL,                      -- 班別代碼
    teacher_id INT NOT NULL,                                 -- 外鍵，教師ID
    classroom_id INT NOT NULL,                               -- 外鍵，教室ID
    max_students INT NOT NULL,                               -- 人數上限
    status NVARCHAR(20) DEFAULT 'open',                      -- 開課狀態
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT chk_max_students CHECK (max_students > 0),    -- 人數上限必須大於0
    CONSTRAINT chk_section_status 
        CHECK (status IN ('open','closed','full')),          -- 限制狀態
    CONSTRAINT uq_course_semester_section 
        UNIQUE (course_id, semester_id, section_code),       -- 同課程同學期班別不可重複
    FOREIGN KEY (course_id) REFERENCES courses(id),          -- 外鍵：對應課程
    FOREIGN KEY (semester_id) REFERENCES semesters(id),      -- 外鍵：對應學期
    FOREIGN KEY (teacher_id) REFERENCES teachers(id),        -- 外鍵：對應教師
    FOREIGN KEY (classroom_id) REFERENCES classrooms(id)     -- 外鍵：對應教室
);
GO


/*==========================================================
  8. 課程時段表 course_schedules
==========================================================*/
CREATE TABLE course_schedules (
    id INT PRIMARY KEY IDENTITY(1,1),                                 -- 主鍵，時段ID
    course_section_id INT NOT NULL,                                   -- 外鍵，開課ID
    weekday INT NOT NULL,                                             -- 星期 (1~7)
    start_period INT NOT NULL,                                        -- 開始節次
    end_period INT NOT NULL,                                          -- 結束節次
    CONSTRAINT chk_weekday CHECK (weekday BETWEEN 1 AND 7),           -- 限制星期範圍
    CONSTRAINT chk_period CHECK (start_period <= end_period),         -- 開始節次不可大於結束節次
    FOREIGN KEY (course_section_id) REFERENCES course_sections(id)    -- 外鍵：對應開課
);
GO


/*==========================================================
  9. 選課表 enrollments
  說明：學生與開課的多對多拆解表
==========================================================*/
CREATE TABLE enrollments (
    id INT PRIMARY KEY IDENTITY(1,1),                                 -- 主鍵，選課ID
    student_id INT NOT NULL,                                          -- 外鍵，學生ID
    course_section_id INT NOT NULL,                                   -- 外鍵，開課ID
    status NVARCHAR(20) DEFAULT 'enrolled',                           -- 選課狀態
    enrolled_at DATETIME DEFAULT GETDATE(),                           -- 選課時間
    CONSTRAINT chk_enroll_status 
        CHECK (status IN ('enrolled','dropped','waitlisted')),        -- 限制選課狀態
    CONSTRAINT uq_student_section 
        UNIQUE (student_id, course_section_id),                       -- 同一學生不可重複選同一門課
    FOREIGN KEY (student_id) REFERENCES students(id),                 -- 外鍵：對應學生
    FOREIGN KEY (course_section_id) REFERENCES course_sections(id)    -- 外鍵：對應開課
);
GO


/*==========================================================
  10. 成績表 grades
==========================================================*/
CREATE TABLE grades (
    id INT PRIMARY KEY IDENTITY(1,1),                         -- 主鍵，成績ID
    enrollment_id INT NOT NULL,                               -- 外鍵，選課ID
    grade_type NVARCHAR(20) NOT NULL,                         -- 成績類型
    score DECIMAL(5,2),                                       -- 成績分數
    CONSTRAINT chk_score CHECK (score BETWEEN 0 AND 100),     -- 成績限制0~100
    CONSTRAINT uq_enrollment_grade 
        UNIQUE (enrollment_id, grade_type),                   -- 同一選課同類型成績不可重複
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(id)    -- 外鍵：對應選課紀錄
);
GO


/*==========================================================
  11. 先修課表 course_prerequisites
==========================================================*/
CREATE TABLE course_prerequisites (
    id INT PRIMARY KEY IDENTITY(1,1),                              -- 主鍵
    course_id INT NOT NULL,                                        -- 課程ID
    prerequisite_course_id INT NOT NULL,                           -- 先修課程ID
    CONSTRAINT uq_course_prereq 
        UNIQUE (course_id, prerequisite_course_id),                -- 同一先修設定不可重複
    FOREIGN KEY (course_id) REFERENCES courses(id),                -- 外鍵：主課程
    FOREIGN KEY (prerequisite_course_id) REFERENCES courses(id)    -- 外鍵：先修課程
);
GO

/*==========================================================
  12. 帳號表 accounts
  說明：儲存學生登入系統用的帳號資料
  關係：一個學生對一個帳號 (1:1)
==========================================================*/
CREATE TABLE accounts (
    id INT PRIMARY KEY IDENTITY(1,1),               -- 帳號ID（主鍵）
    student_id INT NOT NULL UNIQUE,                 -- 對應 students.id（一學生一帳號）
    username NVARCHAR(50) NOT NULL UNIQUE,          -- 登入帳號（不可重複）
    password_hash NVARCHAR(255) NOT NULL,           -- 密碼雜湊（不可存明碼）
    created_at DATETIME2 DEFAULT SYSDATETIME(),     -- 建立時間
    updated_at DATETIME2 DEFAULT SYSDATETIME(),     -- 更新時間
    CONSTRAINT fk_accounts_students
        FOREIGN KEY (student_id)
        REFERENCES students(id)
        ON DELETE CASCADE                           -- 若學生刪除，帳號一併刪除
);
GO


/*==========================================================
  建議：自動更新 updated_at 觸發器
==========================================================*/
CREATE TRIGGER trg_accounts_updated
ON accounts
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE a
    SET updated_at = SYSDATETIME()
    FROM accounts a
    INNER JOIN inserted i ON a.id = i.id;
END;
GO


/*==========================================================
  建議：加強查詢效能索引
==========================================================*/
CREATE INDEX ix_accounts_student_id
ON accounts(student_id);
GO