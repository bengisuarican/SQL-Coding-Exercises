--Coding Exercise 1:

--Your company has been acquired by Udemy, and all email addresses
--need to be converted to a new format. The new format should be 'lastname.firstname@udemy.com'
--(e.g., smith.john@udemy.com). The IT department has asked you
--to prepare a list showing both the current and new email addresses.
--For employees with double first or last names, any spaces should be removed
--(e.g., 'Lex De Haan' should become dehaan.lex@udemy.com)

select  concat(first_name,' ',last_name) as full_name,
        email as old_email,
        concat(concat(lower(replace(last_name,' ','')), '.'),
               lower(replace(first_name,' ', '')), '@udemy.com') as new_email
from hr.employees;

--Coding Exercise 2:

--You are working as the company's Financial Analyst.
--Management wants to examine the salary distribution in each department and
--identify high-budget departments.
--Only departments with more than 3 employees should be included in the report.

select
    department_id,
    count(*) as employee_count,
    sum(salary) as total_salary,
    min(salary) as min_salary,
    max(salary) as max_salary,
    round(avg(salary)) as avg_salary
from hr.employees
where nullif(salary, 0) is not null
group by department_id
having count(*) >3
order by total_salary desc;

--Coding Exercise 3:

--You are working as the company's HR Analyst.
--The year-end performance review is approaching,
--and the board of directors has asked you to prepare an employee profile report.

select
   concat (upper(first_name),' ', upper(last_name)) as full_name,
    email,
case
    when hire_date < '1997-01-01' then 'Kıdemli' else 'Yeni'
end as experience_level,

case
    when nullif(salary,0) >= 15000 then 'Üst Düzey'
    when nullif(salary,0) >= 10000 then 'Yüksek'
    when nullif(salary,0) >= 5000 then 'Orta'
    when nullif(salary,0) < 5000 then 'Başlangıç'
    else 'Güncellenmeli'
end as salary_level ,
coalesce(phone_number,email) as contact_info,
case
    when nullif(salary,0) is null then 'Güncellenmeli'
    else cast(salary as varchar)
end as salary_status

from hr.employees
order by salary desc;

-- Coding Exercise 4:

-- For each employee, return their information along
-- with the average salary of their respective department.

with avg_salary as (select department_id,
                           avg(salary) as d_avg_salary
                    from hr.employees
                    group by 1)
select e.first_name,
       e.department_id,
       d.department_name,
       e.salary,
       d_avg_salary
from hr.employees as e
left join avg_salary as a_s on e.department_id = a_s.department_id
left join departments as d on e.department_id = d.department_id;

-- Coding Exercise 5:

--List the orders of each customer ordered by order date.

select contactid,
       bookingdate,
       to_char(bookingdate, 'yyyy-mm-dd') as booking_date,
       row_number() over (partition by contactid order by to_char(bookingdate, 'yyyy-mm-dd') ) as row_n
from travels.bookings
limit 100;