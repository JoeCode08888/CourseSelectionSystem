# 🎓 Course Selection System


## 專案介紹
Course Selection System 是一個模擬大學選課流程的資料庫專案，包含完整 SQL Server 資料庫設計、建表、測試資料、儲存過程與查詢範例。  
專案主要目標是練習資料庫設計、SQL 編寫與資料庫互動功能整合。

## 功能特色
- 系所管理（departments）
- 學生管理（students）
- 教師管理（teachers）
- 課程模板（courses）
- 學期管理（semesters）
- 教室管理（classrooms）
- 開課管理（course_sections）
- 課程時段管理（course_schedules）
- 選課紀錄（enrollments）
- 學生成績（grades）
- 課程先修關聯（course_prerequisites）
- 範例查詢與報表

## 專案結構
```
CourseSelectionSystem/
├─ SQL_server/
│ ├─ CourseSelection_DB_Create_01.sql
│ ├─ CourseSelection_SeedData_03.sql
│ ├─ CourseSelection_Engine_04.sql
│ ├─ CourseSelection_StoredProcedures_05.sql
│ ├─ CourseSelection_TestData_06.sql
│ ├─ CourseSelection_Query_07.sql
│ └─ CourseSelection_ExtendedProperties_02.sql
├─ DatabaseDocs/
│ ├─ CourseSelection_3NF_Design.txt
│ ├─ CourseSelection_ER_Diagram.txt
│ ├─ CourseSelection_ER_dbo.png
│ ├─ CourseSelection_SQL_Overview.txt
│ ├─ mermaid_ER.png
│ ├─ mermaid_ER.txt
│ └─ CourseSelection_ER_Detailed.txt
└─ README.md
```

## 技術堆疊
- SQL Server 2019
- T-SQL (表格、索引、儲存過程、觸發器)
- Mermaid / ER Diagram (資料庫設計圖)
- 文檔整理（.txt / .png）

## 安裝與使用
1. Clone 專案到本地：
```
git clone https://github.com/JoeCode08888/CourseSelectionSystem.git
```

2. 進入專案資料夾：
```
cd CourseSelectionSystem/SQL_server
```

3. 建立新資料庫，例如 CourseSelectionSystem

依序執行 SQL 檔案：
```
CourseSelection_DB_Create_01.sql           → 建立表格與欄位
CourseSelection_ExtendedProperties_02.sql  → 新增欄位註解
CourseSelection_SeedData_03.sql            → 匯入測試資料
CourseSelection_Engine_04.sql              → 設計觸發器與檢查約束
CourseSelection_StoredProcedures_05.sql    → 建立儲存過程
CourseSelection_TestData_06.sql            → 匯入進階測試資料
CourseSelection_Query_07.sql               → 範例查詢與報表
```

## 專案特色
清楚的模組化 SQL 結構

完整資料庫設計與 ER 文檔

易於擴充，可加入前端介面或後端 API

適合作為學習專案或作品集展示

## License
MIT License

## About
Course Selection System 資料庫專案由 JoeCode08888 開發，專注於資料庫設計、SQL 編寫與資料操作實務。
