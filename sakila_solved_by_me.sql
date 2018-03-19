use sakila;

# 1a. Display the first and last names (fields) of all actors (records) from the table actor.
select first_name,last_name from actor;

# 1b. Display the first and last name (fields) of each actor (record) in a single column in upper case letters. 
# Name the column Actor Name.
# "upper" is the function that capitalizes, "concat" the one that concatenates.
select upper(concat(first_name," ",last_name)) as 'Actor Name' from actor;

# 2a. You need to find the ID number, first name, and last name (fields) of an actor (table), of whom you know 
# only the first name, "Joe." What is one query would you use to obtain this information?
select first_name,last_name,actor_id from actor where first_name = 'Joe';

# 2b. Find all actors (records) whose last name (field) contain the letters GEN:
select first_name,last_name,actor_id from actor where last_name like '%GEN%';

# 2c. Find all actors (records) whose last names (field) contain the letters LI. This time, order the rows by 
# last name and first name (fields), in that order:
select first_name,last_name,actor_id from actor where last_name like '%LI%' order by last_name,first_name;

# 2d. Using IN (a function), display the country_id and country columns (fields) of the following countries: 
# Afghanistan, Bangladesh, and China (records).
# Below, the frst "country" is a field in the table "country", the second is the table, the third one again the field.
select country_id,country from country where country in ('Afghanistan','Bangladesh','China');

# 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
# Hint: you will need to specify the data type.
# Note that if have already run this partocular code, when you execute it the system will flag the following error:
# "Duplicate column name 'middle_name'.  To be beyond that, you need to temporarily insert the line below to remove this
# field, so that you can go ahead and add it back again:
# alter table actor drop column middle_name;
alter table actor add column middle_name varchar(50) after first_name;

# 3b. You realize that some of these actors have tremendously long last names. 
# Change the data type of the middle_name column to blobs.
alter table actor modify column middle_name blob;

# 3c. Now delete the middle_name column.
alter table actor drop column middle_name;

# 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as 'Last Name Count' from actor group by last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by 
# at least two actors
select last_name, count(last_name) as 'Last Name Count' from actor group by last_name having 'Last Name Count' >=2;

# 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of 
# Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor set first_name = 'HARPO' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all!
# In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
# Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error.
# BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER!
# (Hint: update the record using a unique identifier.)

update actor set first_name=case when first_name='HARPO' then 'GROUCHO' else 'MUCHO GROUCHO' end where actor_id=172;

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
# Use the tables staff and address.
# Aliases are created for the tables "staff" (s) and "address" (a).
# Then, select the fields "first_name", "last_name", and "address" in the table "staff" and make an innder joint (the
# default join) with the table "address" using the common field "address_id".  
select s.first_name, s.last_name, s.address_id from staff s join address a on s.address_id=a.address_id;

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
# Select from the table "staff" the fields "first_name" and "last_name" and from the table "payment" the sum of the records
# in the field "amount".
# Then, make an inner joint with the table "payment" using the common field "staff_id", limiting howwever the records to
# those that, in the "payment table" field "payment_date", start with "2005-08".
select s.first_name, s.last_name, sum(p.amount) from staff as s join payment as p on p.staff_id = s.staff_id
where p.payment_date='2005-08%' group by s.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
# Use inner join.
select f.title, count(fa.actor_id) from film_actor fa join film f on f.film_id = fa.film_id group by f.title;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
# Count the occurrences of this title within the "inventory_id" field of the "inventory" table, reporting the result by the
# title name, contained in the field "title" of the "film" table.
select f.title, count(i.inventory_id) from film f join inventory i on f.film_id = i.film_id 
where f.title = 'Hunchback Impossible' group by f.title;

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
# List the customers alphabetically by last name:
# Using here the alternative way to join tables.
select first_name, last_name, sum(amount) from payment join customer using(customer_id) group by customer_id 
order by last_name;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films 
# starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting
# with the letters K and Q whose language is English.
select title from film where title like 'Q%' or title like 'K%' and 
language_id in (select language_id from language where name='English');

# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
# For each record of the field "actor_id" (the connector between the tables "actor" and "film_actor"), display the records
# in the "actor" table's fields "first_name" and "last_name" for which the field "title" in the table "film" is "Alone Trip",
# with "film_id" being the connector between the tables "film_actor" and "film".
select first_name, last_name from actor 
where actor_id in (select actor_id from film_actor where film_id in (select film_id from film where title='Alone Trip'));
 
# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all 
# Canadian customers. Use joins to retrieve this information.
# Display the fields "first_name", "last_name", and "email" of the table "customer".
# The field "address_id" connects this table to the "address" table.
# The field "city_id" connects the "address" table to the "city" table. 
# The field "country_id" connects the "city" table to the "country" table, where finally the field "country" can be set to 
# "Canada". 
select first_name, last_name, email, country from customer cu
join address a on (cu.address_id = a.address_id)
join city ci on (a.city_id = ci.city_id)
join country co on (ci.country_id = co.country_id)
where co.country='Canada';

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as famiy films.
# Join the "film" and "film_category" tables, with "film_id" as the connecting field.
# Join the "film_id" and "category" tables, with "category_id" as the connecting field.
# Select records in this latter table for which the field "name" equals "Family".
select title, ca.name from film f join film_category fc on (f.film_id = fc.film_id)
join category ca on (ca.category_id = fc.category_id) where name = 'Family';

# 7e. Display the most frequently rented movies in descending order.
# The feld "rentals" is created so that the titles can be ordered by that field. 
select title, count(title) as rentals from film f join inventory i on (f.film_id = i.film_id)
join rental r on (i.inventory_id = r.inventory_id)
group by title order by rentals desc;

# 7f. Write a query to display how much business, in dollars, each store brought in.
select sto.store_id, sum(p.amount) from payment p 
join rental r on (p.rental_id = r.rental_id)
join inventory i on (i.inventory_id = r.inventory_id)
join store sto on (sto.store_id = i.store_id)
group by sto.store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
select sto.store_id, ci.city, co.country from store sto join address a on (sto.address_id = a.address_id)
join city ci on (a.city_id = ci.city_id)
join country co on (ci.country_id = co.country_id);

# 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category,
# film_category, inventory, payment, and rental.)
 select sum(p.amount), c.name from payment p 
 join rental r on (p.rental_id = r.rental_id)
 join inventory i on (r.inventory_id = i.inventory_id)
 join film_category fc on (i.film_id = fc.film_id)
 join category c on (fc.category_id = c.category_id)
 group by c.name order by sum(amount) desc;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
# Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to 
# create a view.
create view top5genres as select c.name, sum(p.amount) from category c, rental r, payment p, film_category fc, inventory i
where r.rental_id = p.rental_id and r.inventory_id = i.inventory_id and i.film_id=fc.film_id and fc.category_id=c.category_id
group by c.name order by sum(p.amount) desc limit 5;

# 8b. How would you display the view that you created in 8a?
select * from top5genres;

# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top5genres