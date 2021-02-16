# Lab | Aggregation Revisited - Sub queries

# Instructions
# Write the SQL queries to answer the following questions:

# Select the first name, last name, and email address of all the customers who have rented a movie.

select customer_id, first_name, last_name, email
from customer;


# What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

select c.customer_id, concat(c.first_name,' ',c.last_name) as CustomerName, round(avg(p.amount),2) as Average_payment
from customer as c
join payment as p
on c.customer_id = p.customer_id
group by c.customer_id;



# Select the name and email address of all the customers who have rented the "Action" movies.

# Write the query using sub queries with multiple WHERE clause and IN condition

select concat(first_name,' ',last_name) as CustomerName, email from customer
where customer_id in(
select customer_id from rental
where inventory_id in (
select inventory_id from inventory
where film_id in (
select film_id from film_category
where category_id in (
select category_id from category
where name = "Action"))));

# Write the query using multiple join statements

select distinct(customer_id), concat(cu.first_name,' ', cu.last_name) as CustomerName, cu.email from category as c
right join film_category as fc using (category_id)
right join inventory as i using (film_id)
right join rental as r using (inventory_id)
right join customer as cu using(customer_id)
where c.name = 'action';



# Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
# If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

select payment_id,amount,
 case 
 When amount <= 2  Then "low" 
 when amount >= 4 then "high"
 else "medium"
 End  classification

from (select  payment_id, amount from payment
  ) sub1
group by payment_id;

