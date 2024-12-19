--- string functions
use parks_and_recreation;	
select  first_name, last_name,  
concat(first_name,  ' ', last_name) as full_name
from employee_demographics;

-- Case Statements
-- Pay Increase and Bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- finance = 10% bonus

Select first_name, last_name, salary,
case
when salary<=50000 then salary + (salary * 0.05)
when salary > 50000 then salary + (salary* 0.07)
when dept_id = 6 then salary + (salary *0.1)
end as 'SALARY INCREMENT'


 FROM employee_salary


