# Lab | SQL Iterations
# In this lab, we will continue working on the Sakila database of movie rentals.


# Instructions
# Write queries to answer the following questions:

 -- Call the stored procedure and print the results.


# 1. Write a query to find what is the total business done by each store.

select c.store_id, sum(p.amount) as AmountPerStore
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.store_id;


# 2. Convert the previous query into a stored procedure.

drop procedure if exists balance_per_store;

delimiter //
create procedure balance_per_store ()
begin
	select c.store_id, sum(p.amount)
	from customer c
	join payment p
	on c.customer_id = p.customer_id
	group by c.store_id;
end;
// delimiter ;

call balance_per_store();



# 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists total_business_choose_store;

delimiter //
create procedure total_business_choose_store (in param1 int)
begin
  select c.store_id, sum(amount) as total_business from customer c
	join payment
	using (customer_id)
    where c.store_id = param1;
end;
//
delimiter ;

call total_business_choose_store(1);


# 4. Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 

drop procedure if exists total_business_choose_store;

delimiter //
create procedure total_business_choose_store (in param1 int)
begin
  declare total_sales_value float default 0.0; -- Declaring variables
  select sum(amount) into total_sales_value 
	from customer c
	join payment
	using (customer_id)
    where c.store_id = param1;
select total_sales_value;
end;
//
delimiter ;

call total_business_choose_store(1);


# 5. In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.


drop procedure if exists total_business_choose_store;

delimiter //
create procedure total_business_choose_store (in param1 int, out param2 varchar(20), out param3 float)
begin
  declare total_sales_value float default 0.0; -- Declaring variables
  declare flag varchar(20) default "";
  select sum(amount) into param3
	from customer c
	join payment
	using (customer_id)
    where c.store_id = param1;
select total_sales_value = param3;
if total_sales_value > 30000 then
    set flag = 'Green Zone';
  else
    set flag = 'Red Zone';
  end if;
  select flag into param2;
end;
//
delimiter ;

call total_business_choose_store(1, @x, @y);
select @x as type_of_flag, round(@y,2) as total_sales_value;