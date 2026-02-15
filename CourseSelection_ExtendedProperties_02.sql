USE CourseSelectionSystem;
GO

/*==========================================================
  Extended Properties for Table and Column Descriptions
==========================================================*/

-- ======================== 1. departments ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'系所資料表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'departments';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，系所唯一識別碼，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'departments', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'系所代碼，不可重複', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'departments', @level2type=N'COLUMN', @level2name=N'code';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'系所名稱', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'departments', @level2type=N'COLUMN', @level2name=N'name';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'建立時間，預設為系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'departments', @level2type=N'COLUMN', @level2name=N'created_at';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'更新時間，預設為系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'departments', @level2type=N'COLUMN', @level2name=N'updated_at';
GO

-- ======================== 2. students ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學生資料表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，學生ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學號，唯一不可重複', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'student_no';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學生姓名', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'name';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'電子信箱，不可重複', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'email';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'聯絡電話', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'phone';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 departments.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'department_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'年級', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'grade';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學生狀態，active/leave/graduated', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'status';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'建立時間，預設為系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'created_at';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'更新時間，預設為系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'students', @level2type=N'COLUMN', @level2name=N'updated_at';
GO

-- ======================== 3. teachers ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'教師資料表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，教師ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'教師編號，不可重複', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers', @level2type=N'COLUMN', @level2name=N'teacher_no';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'教師姓名', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers', @level2type=N'COLUMN', @level2name=N'name';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'電子信箱，不可重複', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers', @level2type=N'COLUMN', @level2name=N'email';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 departments.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers', @level2type=N'COLUMN', @level2name=N'department_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'職稱', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers', @level2type=N'COLUMN', @level2name=N'title';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'建立時間，預設系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers', @level2type=N'COLUMN', @level2name=N'created_at';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'更新時間，預設系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'teachers', @level2type=N'COLUMN', @level2name=N'updated_at';
GO

-- ======================== 4. courses ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'課程模板資料表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'courses';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，課程ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'courses', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'課程代碼，不可重複', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'courses', @level2type=N'COLUMN', @level2name=N'course_code';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'課程名稱', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'courses', @level2type=N'COLUMN', @level2name=N'name';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學分數', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'courses', @level2type=N'COLUMN', @level2name=N'credits';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'開課系所，外鍵對應 departments.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'courses', @level2type=N'COLUMN', @level2name=N'department_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'課程說明', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'courses', @level2type=N'COLUMN', @level2name=N'description';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'必修或選修', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'courses', @level2type=N'COLUMN', @level2name=N'required_type';
GO

-- ======================== 5. semesters ========================  
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學期資料表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'semesters';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，學期ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'semesters', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學年度', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'semesters', @level2type=N'COLUMN', @level2name=N'academic_year';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學期 (1=上,2=下)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'semesters', @level2type=N'COLUMN', @level2name=N'term';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'開始日期', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'semesters', @level2type=N'COLUMN', @level2name=N'start_date';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'結束日期', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'semesters', @level2type=N'COLUMN', @level2name=N'end_date';
GO

-- ======================== 6. classrooms ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'教室資料表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'classrooms';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，教室ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'classrooms', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'大樓名稱', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'classrooms', @level2type=N'COLUMN', @level2name=N'building';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'教室編號', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'classrooms', @level2type=N'COLUMN', @level2name=N'room_number';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'容量', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'classrooms', @level2type=N'COLUMN', @level2name=N'capacity';
GO

-- ======================== 7. course_sections ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'開課資料表（實際開課）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，開課ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 courses.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'course_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 semesters.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'semester_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'班別代碼，同課程同學期唯一', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'section_code';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 teachers.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'teacher_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 classrooms.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'classroom_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'人數上限，必須大於0', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'max_students';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'開課狀態：open/closed/full', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'status';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'建立時間，預設系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'created_at';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'更新時間，預設系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_sections', @level2type=N'COLUMN', @level2name=N'updated_at';
GO

-- ======================== 8. course_schedules ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'課程時段表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_schedules';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，時段ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_schedules', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 course_sections.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_schedules', @level2type=N'COLUMN', @level2name=N'course_section_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'星期 (1=星期一, 7=星期日)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_schedules', @level2type=N'COLUMN', @level2name=N'weekday';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'開始節次', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_schedules', @level2type=N'COLUMN', @level2name=N'start_period';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'結束節次', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_schedules', @level2type=N'COLUMN', @level2name=N'end_period';
GO

-- ======================== 9. enrollments ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'選課表，學生與開課多對多關聯', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'enrollments';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，選課ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'enrollments', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 students.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'enrollments', @level2type=N'COLUMN', @level2name=N'student_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 course_sections.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'enrollments', @level2type=N'COLUMN', @level2name=N'course_section_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'選課狀態：enrolled/dropped/waitlisted', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'enrollments', @level2type=N'COLUMN', @level2name=N'status';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'選課時間，預設系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'enrollments', @level2type=N'COLUMN', @level2name=N'enrolled_at';
GO

-- ======================== 10. grades ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'成績表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'grades';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，成績ID，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'grades', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，對應 enrollments.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'grades', @level2type=N'COLUMN', @level2name=N'enrollment_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'成績類型，如期中/期末/作業', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'grades', @level2type=N'COLUMN', @level2name=N'grade_type';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'成績分數，0~100', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'grades', @level2type=N'COLUMN', @level2name=N'score';
GO

-- ======================== 11. course_prerequisites ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'先修課程表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_prerequisites';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'主鍵，自動遞增', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_prerequisites', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，主課程ID，對應 courses.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_prerequisites', @level2type=N'COLUMN', @level2name=N'course_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵，先修課程ID，對應 courses.id', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'course_prerequisites', @level2type=N'COLUMN', @level2name=N'prerequisite_course_id';
GO

-- ======================== 12. accounts ========================
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'學生登入帳號表', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'accounts';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'帳號ID（主鍵，自動遞增）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'accounts', @level2type=N'COLUMN', @level2name=N'id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'對應 students.id，一學生一帳號', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'accounts', @level2type=N'COLUMN', @level2name=N'student_id';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'登入帳號，不可重複', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'accounts', @level2type=N'COLUMN', @level2name=N'username';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'密碼雜湊（不可存明碼）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'accounts', @level2type=N'COLUMN', @level2name=N'password_hash';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'建立時間，預設系統時間', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'accounts', @level2type=N'COLUMN', @level2name=N'created_at';
EXEC sp_addextendedproperty @name=N'MS_Description', @value=N'更新時間，預設系統時間，自動更新', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'accounts', @level2type=N'COLUMN', @level2name=N'updated_at';
GO