USE CourseSelectionSystem;
GO

PRINT '================== 1. 系所資料 ==================';
SELECT * FROM departments;
GO

PRINT '================== 2. 學生資料 ==================';
SELECT s.id, s.student_no, s.name, s.email, s.phone, d.name AS department_name, s.grade, s.status
FROM students s
JOIN departments d ON s.department_id = d.id;
GO

PRINT '================== 3. 教師資料 ==================';
SELECT t.id, t.teacher_no, t.name, t.email, d.name AS department_name, t.title
FROM teachers t
JOIN departments d ON t.department_id = d.id;
GO

PRINT '================== 4. 課程資料 ==================';
SELECT c.id, c.course_code, c.name, c.credits, d.name AS department_name, c.description, c.required_type
FROM courses c
JOIN departments d ON c.department_id = d.id;
GO

PRINT '================== 5. 學期資料 ==================';
SELECT * FROM semesters;
GO

PRINT '================== 6. 教室資料 ==================';
SELECT * FROM classrooms;
GO

PRINT '================== 7. 開課班別及授課資料 ==================';
SELECT cs.id, c.name AS course_name, cs.section_code, t.name AS teacher_name, cl.building, cl.room_number,
       s.academic_year, s.term, cs.max_students, cs.status
FROM course_sections cs
JOIN courses c ON cs.course_id = c.id
JOIN teachers t ON cs.teacher_id = t.id
JOIN classrooms cl ON cs.classroom_id = cl.id
JOIN semesters s ON cs.semester_id = s.id;
GO

PRINT '================== 8. 課程時段資料 ==================';
SELECT cs.id AS course_section_id, c.name AS course_name, cs.section_code, sch.weekday, sch.start_period, sch.end_period
FROM course_schedules sch
JOIN course_sections cs ON sch.course_section_id = cs.id
JOIN courses c ON cs.course_id = c.id;
GO

PRINT '================== 9. 學生選課狀態 ==================';
SELECT e.id AS enrollment_id, s.name AS student_name, c.name AS course_name, cs.section_code, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN course_sections cs ON e.course_section_id = cs.id
JOIN courses c ON cs.course_id = c.id;
GO

PRINT '================== 10. 成績資料 ==================';
SELECT g.id AS grade_id, s.name AS student_name, c.name AS course_name, cs.section_code, g.grade_type, g.score
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.id
JOIN students s ON e.student_id = s.id
JOIN course_sections cs ON e.course_section_id = cs.id
JOIN courses c ON cs.course_id = c.id;
GO

PRINT '================== 11. 先修課程 ==================';
SELECT c.name AS course_name, pc.name AS prerequisite_name
FROM course_prerequisites cp
JOIN courses c ON cp.course_id = c.id
JOIN courses pc ON cp.prerequisite_course_id = pc.id;
GO

PRINT '================== 12. 帳號資料 ==================';
SELECT a.id, s.name AS student_name, a.username, a.created_at, a.updated_at
FROM accounts a
JOIN students s ON a.student_id = s.id;
GO

PRINT '================== 13. 每班選課統計（已選/候補人數） ==================';
SELECT cs.id AS course_section_id, cs.section_code, c.name AS course_name,
       COUNT(CASE WHEN e.status='enrolled' THEN 1 END) AS enrolled_count,
       COUNT(CASE WHEN e.status='waitlisted' THEN 1 END) AS waitlisted_count,
       cs.max_students
FROM course_sections cs
JOIN courses c ON cs.course_id = c.id
LEFT JOIN enrollments e ON cs.id = e.course_section_id
GROUP BY cs.id, cs.section_code, c.name, cs.max_students
ORDER BY cs.id;
GO

PRINT '================== 14. 候補學生順序 ==================';
SELECT cs.id AS course_section_id, cs.section_code, c.name AS course_name,
       s.id AS student_id, s.name AS student_name, e.status,
       ROW_NUMBER() OVER (PARTITION BY cs.id ORDER BY e.id) AS waiting_order
FROM course_sections cs
JOIN courses c ON cs.course_id = c.id
LEFT JOIN enrollments e ON cs.id = e.course_section_id AND e.status='waitlisted'
LEFT JOIN students s ON e.student_id = s.id
ORDER BY cs.id, waiting_order;
GO

PRINT '================== 15. 每位學生選課統計 ==================';
SELECT 
    s.id AS student_id,
    s.name AS student_name,
    COUNT(CASE WHEN e.status='enrolled' THEN 1 END) AS enrolled_count,
    COUNT(CASE WHEN e.status='waitlisted' THEN 1 END) AS waiting_count,
    COUNT(*) AS total_selected
FROM students s
LEFT JOIN enrollments e ON s.id = e.student_id
LEFT JOIN course_sections cs ON e.course_section_id = cs.id
WHERE s.status = 'active'
GROUP BY s.id, s.name
ORDER BY s.id;
GO