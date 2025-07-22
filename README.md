
# 🧠 HR Data Analytics with SQL

This project demonstrates a comprehensive SQL-based data analysis on an HR dataset. It includes database creation, data transformation, cleaning, and analytical queries to derive key business insights like attrition rates, salary distributions, age groups, departmental statistics, and more.

---

## 📁 Project Overview

The goal of this project is to:

- Create and manage an HR database
- Perform data cleaning and formatting (especially on date fields)
- Add derived metrics such as employee status and age
- Analyze HR metrics such as attrition, salary, absence, demographics, and performance

---
## 🏗️ Database Setup

- A new database `hrdata` is created and selected for use.
- Data is assumed to be available in a table named `employees`.

```sql
CREATE DATABASE hrdata;
USE hrdata;
SELECT * FROM employees;
````

---

## 📊 Basic Metrics

* **Total number of employees**
* **Count of current vs. terminated employees**
* **Average salary and age**
* **Average tenure (years in company)**

```sql
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM employees WHERE DateofTermination != '';
SELECT COUNT(*) FROM employees WHERE DateofTermination = '';
SELECT AVG(Salary) FROM employees;
SELECT AVG(TIMESTAMPDIFF(YEAR, DOB, CURDATE())) FROM employees;
```

---

## 🔁 Employee Status & Attrition

* A new column `EmployeeCurrentStatus` is added to classify employees as current (1) or former (0).
* Attrition rate is calculated as the percentage of terminated employees.

```sql
ALTER TABLE employees ADD EmployeeCurrentStatus INT;
UPDATE employees
SET EmployeeCurrentStatus = CASE
  WHEN DateofTermination = '' THEN 1
  ELSE 0
END;

SELECT (CAST(COUNT(CASE WHEN EmployeeCurrentStatus = 0 THEN 1 END) AS FLOAT) / COUNT(*)) * 100 AS attrition_rate
FROM employees;
```

---

## 🛠️ Data Cleaning & Transformation

* Ensures all `DATE` columns are properly converted.
* Alters the data type of `Salary` to `DECIMAL`.
* Adds a new `age` column and calculates age based on DOB.

```sql
-- Date formatting
UPDATE employees SET DOB = STR_TO_DATE(DOB, '%d-%m-%Y');
UPDATE employees SET DateofHire = STR_TO_DATE(DateofHire, '%d-%m-%Y');
UPDATE employees SET LastPerformanceReview_Date = STR_TO_DATE(LastPerformanceReview_Date, '%Y-%m-%d');

ALTER TABLE employees
MODIFY DOB DATE,
MODIFY DateofHire DATE,
MODIFY LastPerformanceReview_Date DATE;

-- Salary data type
ALTER TABLE employees MODIFY COLUMN Salary DECIMAL(10, 2);

-- Add and calculate age
ALTER TABLE employees ADD COLUMN Age INT;
UPDATE employees SET Age = TIMESTAMPDIFF(YEAR, DOB, CURDATE());
```

---

## 📈 Employee Demographics & Distributions

### 🔹 Marital Status, Department, Position, and Manager Breakdown

```sql
SELECT MaritalDesc, COUNT(*) FROM employees GROUP BY MaritalDesc;
SELECT Department, COUNT(*) FROM employees GROUP BY Department;
SELECT Position, COUNT(*) FROM employees GROUP BY Position;
SELECT ManagerName, COUNT(*) FROM employees GROUP BY ManagerName;
```

### 🔹 Salary Range Distribution

```sql
SELECT 
  CASE
    WHEN Salary < 30000 THEN '<30K'
    WHEN Salary BETWEEN 30000 AND 49999 THEN '30K - 49K'
    WHEN Salary BETWEEN 50000 AND 69999 THEN '50K - 69K'
    WHEN Salary BETWEEN 70000 AND 89999 THEN '70K - 89K'
    ELSE '90K and above'
  END AS Salary_Range,
  COUNT(*) AS Frequency
FROM employees
GROUP BY Salary_Range;
```

### 🔹 Performance Score Count

```sql
SELECT PerformanceScore, COUNT(*) FROM employees GROUP BY PerformanceScore;
```

### 🔹 Age Distribution

```sql
SELECT 
  CASE
    WHEN Age < 20 THEN '<20'
    WHEN Age BETWEEN 20 AND 29 THEN '20 - 29'
    WHEN Age BETWEEN 30 AND 39 THEN '30 - 39'
    WHEN Age BETWEEN 40 AND 49 THEN '40 - 49'
    WHEN Age BETWEEN 50 AND 59 THEN '50 - 59'
    ELSE '60 and above'
  END AS Age_Range,
  COUNT(*) AS Count
FROM employees
GROUP BY Age_Range;
```

---

## 💼 Department-Level Analysis

* **Average Salary by Department**
* **Absences by Department**

```sql
SELECT Department, AVG(Salary) AS AverageSalary FROM employees GROUP BY Department;
SELECT Department, SUM(Absences) AS TotalAbsences FROM employees GROUP BY Department;
```

---

## 📌 Termination & Performance Insights

* **Termination reasons and counts**
* **Terminated employees by marital status**
* **Average absences by performance score**

```sql
SELECT TermReason, COUNT(*) FROM employees WHERE TermReason IS NOT NULL GROUP BY TermReason;
SELECT MaritalDesc, COUNT(*) AS TerminatedCount FROM employees WHERE Termd = 1 GROUP BY MaritalDesc;
SELECT PerformanceScore, AVG(Absences) AS AverageAbsences FROM employees GROUP BY PerformanceScore;
```

---

## 📍 Geographic & Demographic Breakdown

* **Employee count by state**
* **Salary distribution by gender**
* **Gender breakdown**

```sql
SELECT State, COUNT(*) FROM employees GROUP BY State;
SELECT Sex, SUM(Salary) FROM employees GROUP BY Sex;
SELECT Sex, COUNT(*) FROM employees GROUP BY Sex;
```

---

## 🚀 Recruitment Analytics

* **Employee count by recruitment source**

```sql
SELECT RecruitmentSource, COUNT(*) FROM employees GROUP BY RecruitmentSource;
```

---

## 📑 Sample Data Queries

* **First and last 5 records**

```sql
SELECT * FROM employees LIMIT 5;
SELECT * FROM employees ORDER BY EmpID DESC LIMIT 5;
