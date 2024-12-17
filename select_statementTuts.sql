SELECT 
 first_name, birth_date, age,
 age-10

 FROM  employee_demographics;
 select first_name from employee_salary;
 SELECT MAX(salary) AS max_salary FROM employee_salary;

 SELECT DISTINCT gender
 FROM employeee_demographics;
 
 select * from employee_demographics
 WHERE first_name  like 'a%';
 -- subqueries
 -- a query in another query
  use parks_and_recreation;
 select * from employee_demographics
 Where employee_id IN( SELECT employee_id
 from employee_salary
 where dept_id =1);
 select first_name, salary, 
 (select AVG(salary)
 from employee_salary)
 from employee_salary;
 
  use parks_and_recreation;
 Select dem.first_name, dem.last_name,gender,salary,
 sum(salary) OVER(partition by gender order by dem.employee_id) as rolling_total
 from employee_demographics dem
 JOIN employee_salary as sal 
 ON dem.employee_id = sal.employee_id;
 
 -- CTEs
 -- Common Table Expressions
 WITH CTE_example as 
 (
 SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, min(salary) min_sal, count(salary) count_sal
 from employee_demographics as dem
 join employee_salary as sal
 ON dem.employee_id = sal.employee_id
 group by gender)
 select * from CTE_example;
 
 --  temporary tables
 CREATE temporary table temp_table
 (
 first_name varchar(50),
 last_name varchar(50),
 favorite_movie varchar (100)
 );
 
 INSERT into temp_table
 VALUES('Dennis', 'Agyekum', 'The Chi');
 
  select * from salary_over_50k;
 
 CREATE temporary table salary_over_50k
 select * from employee_salary
 where salary >= 50000;
 
 -- stored procedures
 delimiter $$
  CREATE procedure large_salaries2()
	BEGIN	
	 select * from employee_salary
	 where salary >= 50000;
     SELECT * FROM employee_salary
     where salary >= 10000;
 END $$
 delimiter ;
 
 CALL large_salaries2();
 
 -- triggers and events
 -- trigger
-- a block of code that executes automatically when an event takes place on a specific table

select * from employee_demographics;
select * from employee_salary;

delimiter $$
 CREATE TRIGGER employee_insert
	after INSERT ON employee_salary
    for each row 
    begin
    insert into employee_demographics(employee_id, first_name, last_name)
    values (NEW.employee_id, new.first_name, new.last_name );
    END $$
     delimiter ;
 INSERT into employee_salary 
 values(13,'Dennis', 'Agyekum', 'Managing HEAD', 700000, null);
 
 -- Events
 Select * from employee_demographics;
 Delimiter $$
 CREATE EVENT delete_retirees
 on schedule every 30 second
 DO
 Begin
	 delete  from employees_demographics
	 where age >= 60;
 End $$
 show variables like 'event%'
 delimiter ;
 
 