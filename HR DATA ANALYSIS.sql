create database hrdata;
use hrdata;

select * from employees;

-- Total employees
select count(*) as total_employees
from employees;

-- total old employees
select count(*) as total_old_employees
from employees
where dateoftermination!='';

-- total current employees
select count(*) as total_current_employees
from employees
where dateoftermination='';

-- average salary
select avg(salary) as avg_salary
from employees;

-- average age
select avg(timestampdiff(YEAR,STR_TO_DATE(DOB,'%d-%m-%T'),CURDATE())) as avg_age
FROM EMPLOYEES;

-- average years in company 
select AVG(timestampdiff(YEAR,STR_TO_DATE(DateofHire,'%d-%m-%Y'),CURDATE())) as avg_years_in_company 
from employees;

-- Adding new column for employee current status
alter table employees
add EmployeeCurrentStatus INT;

-- Updating values for new column
set sql_safe_updates=0;
update employees
set EmployeeCurrentStatus= CASE
when DateofTermination='' then 1
else 0
end;

-- Calculate attrition rate based on custom EmpStatusID values
select
(cast(count(case when EmployeeCurrentStatus=0 then 1 end) as float)/count(*) )* 100 as attrition_rate
from employees;

-- Get column names with data types
describe employees;
-- or
show columns from employees;

-- Print first five rows 
select * from employees
limit 5;

-- Print last 5 rows
select * from employees
order by EmpID desc
limit 5;

-- Changing data type of salary
alter table employees
modify column salary decimal(10,2);

-- Convert all date columns in proper dates
UPDATE employees
SET DOB = STR_TO_DATE(DOB, '%d-%m-%Y');
UPDATE employees
SET DateofHire = STR_TO_DATE(DateofHire, '%d-%m-%Y');
UPDATE employees
SET LastPerformanceReview_Date = STR_TO_DATE(LastPerformanceReview_Date, '%Y-%m-%d');


ALTER TABLE employees
MODIFY COLUMN DOB DATE,
MODIFY COLUMN DateofHire DATE,
MODIFY COLUMN LastPerformanceReview_Date DATE;

-- Read columns to check changes
select DOB,DateofHire,DateofTermination,LastPerformanceReview_date
from  employees;
describe employees;

-- Fill empty values in date of termination
set sql_safe_updates=0;
update employees
set dateoftermination='Currently Working';

-- count of each unique value in the maritaldesc
select maritaldesc,count(*) as count
from employees
group by maritaldesc
order by count desc;

-- count of each unique value in the department
select department,count(*) as count
from employees
group by department
order by count desc;

-- count of each unique value in the Positions
select position,count(*) as count
from employees
group by position
order by count desc;

-- count of each unique value in the Manager
select managername,count(*) as count
from employees
group by managername
order by count desc;

-- salary distribution by employees
select
case
when salary <30000 then '<30K'
when salary between 30000 and 49999 then '30K - 49K'
when salary between 50000 and 69999 then '50K - 69K'
when salary between 70000 and 89999 then '70K - 89K'
when salary >=90000 then '90K and above'
end as salary_range,
count(*) as frequency
from employees group by salary_range order by frequency desc;

-- performance score
select performancescore,count(*) as count
from employees
group by performancescore
order by  performancescore;

-- Average salary by department
select department,avg(salary) as averagesalary
from employees
group by department
order by averagesalary desc;

-- Count Termination by clause
select termreason,count(*) as count
from employees
where termreason is not null
group by termreason
order by count desc;

-- Employee Count Of state
select state,count(*) as count
from employees
group by state
order by count desc;

-- Gender distribution
select sex,count(*) as count
from employees
group by sex
order by count desc;

-- add a new column age
alter table employees
add column age int;

-- Convert all date columns in proper dates
UPDATE employees
SET DOB = STR_TO_DATE(DOB, '%d-%m-%Y');
UPDATE employees
SET DateofHire = STR_TO_DATE(DateofHire, '%d-%m-%Y');
UPDATE employees
SET LastPerformanceReview_Date = STR_TO_DATE(LastPerformanceReview_Date, '%Y-%m-%d');

ALTER TABLE employees
MODIFY COLUMN DOB DATE,
MODIFY COLUMN DateofHire DATE,
MODIFY COLUMN LastPerformanceReview_Date DATE;

-- update the age column with calculated age
update employees
set age=timestampdiff(YEAR,DOB,CURDATE());

-- AGE DISTRIBUTION
select
case
when age <20 then '<20'
when age between 20 and 29 then '20 - 29'
when age between 30 and 39 then '30-39'
when age between 40 and 49 then '40-49'
when age between 50 and 59 then '50-59'
when age >=60 then '60  and above'
end as age_range,
count(*) as count
from employees group by age_range;

-- Absences by department
select department,
sum(Absences) as TotalAbsences
from employees
group by department
order by totalabsences desc;

-- Salary distribution by gender
select sex,
sum(salary) as Totalsalary
from employees
group by sex
order by totalsalary desc;

-- Count of employees terminated as per marital status
select maritaldesc,
count(*) as terminatedcount
from employees
where termd=1
group by maritaldesc
order by terminatedcount desc;

-- Average absence by performance score
select performancescore,
avg(Absences) as AverageAbsences
from employees
group by performancescore
order by performancescore;

-- Employee count by recruitment score
select recruitmentsource,
count(*) as employeecount
from employees
group by recruitmentsource
order by employeecount desc;










