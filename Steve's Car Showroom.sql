create database steel_data;
use steel_data;
CREATE TABLE cars (
car_id INT PRIMARY KEY,
make VARCHAR(50),
type VARCHAR(50),
style VARCHAR(50),
cost_$ INT
);
INSERT INTO cars (car_id, make, type, style, cost_$)
VALUES (1, 'Honda', 'Civic', 'Sedan', 30000),
(2, 'Toyota', 'Corolla', 'Hatchback', 25000),
(3, 'Ford', 'Explorer', 'SUV', 40000),
(4, 'Chevrolet', 'Camaro', 'Coupe', 36000),
(5, 'BMW', 'X5', 'SUV', 55000),
(6, 'Audi', 'A4', 'Sedan', 48000),
(7, 'Mercedes', 'C-Class', 'Coupe', 60000),
(8, 'Nissan', 'Altima', 'Sedan', 26000);

CREATE TABLE salespersons (
salesman_id INT PRIMARY KEY,
name VARCHAR(50),
age INT,
city VARCHAR(50)
);

INSERT INTO salespersons (salesman_id, name, age, city)
VALUES (1, 'John Smith', 28, 'New York'),
(2, 'Emily Wong', 35, 'San Fran'),
(3, 'Tom Lee', 42, 'Seattle'),
(4, 'Lucy Chen', 31, 'LA');

CREATE TABLE sales (
sale_id INT PRIMARY KEY,
car_id INT,
salesman_id INT,
purchase_date DATE,
FOREIGN KEY (car_id) REFERENCES cars(car_id),
FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id)
);

INSERT INTO sales (sale_id, car_id, salesman_id, purchase_date)
VALUES (1, 1, 1, '2021-01-01'),
(2, 3, 3, '2021-02-03'),
(3, 2, 2, '2021-02-10'),
(4, 5, 4, '2021-03-01'),
(5, 8, 1, '2021-04-02'),
(6, 2, 1, '2021-05-05'),
(7, 4, 2, '2021-06-07'),
(8, 5, 3, '2021-07-09'),
(9, 2, 4, '2022-01-01'),
(10, 1, 3, '2022-02-03'),
(11, 8, 2, '2022-02-10'),
(12, 7, 2, '2022-03-01'),
(13, 5, 3, '2022-04-02'),
(14, 3, 1, '2022-05-05'),
(15, 5, 4, '2022-06-07'),
(16, 1, 2, '2022-07-09'),
(17, D, 3, '2023-01-01'),
(18, 6, 3, '2023-02-03'),
(19, 7, 1, '2023-02-10'),
(20, 4, 4, '2023-03-01');


#1. What are the details of all cars purchased in the year 2022?
select c.car_id,c.make,c.type,c.style,c.cost_$,s.sale_id,s.salesman_id,s.purchase_date
from cars c left join sales s on c.car_id=s.car_id
where year(s.purchase_date)=2022;

#2. What is the total number of cars sold by each salesperson?
select sp.*,count(c.car_id) as cars_sold from salespersons sp left join sales c
on sp.salesman_id=c.salesman_id
group by sp.salesman_id;

#3. What is the total revenue generated by each salesperson?
select s.salesman_id,sp.name,sp.age,sp.city,sum(c.cost_$) as total_revenue from salespersons sp
left join sales s on sp.salesman_id=s.salesman_id
left join cars c on s.car_id=c.car_id
group by sp.salesman_id;

#4. What are the details of the cars sold by each salesperson?
select sp.salesman_id, sp.name,c.*,s.purchase_date from salespersons sp
left join sales s on sp.salesman_id=s.salesman_id
left join cars c on s.car_id=c.car_id;

#5. What is the total revenue generated by each car type?
select type, sum(cost_$) as revenue from cars
group by type;

#6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?
select sp.salesman_id,sp.name,s.purchase_date,c.* from salespersons sp
inner join sales s on sp.salesman_id=s.salesman_id
inner join cars c on s.car_id=c.car_id
where year(s.purchase_date)=2021 and sp.name="Emily Wong";

select * from sales;
select * from cars;
#7. What is the total revenue generated by the sales of hatchback cars?
select s.car_id,c.style, sum(c.cost_$) as revenue from cars c
inner join sales s
on s.car_id=c.car_id
where c.style="Hatchback";

select s.car_id,c.style, c.cost_$ as revenue from cars c
inner join sales s
on s.car_id=c.car_id
where c.style="Hatchback";

#8. What is the total revenue generated by the sales of SUV cars in the year 2022?
select c.style,sum(c.cost_$) as revenue from cars c
inner join sales s on c.car_id=s.car_id
where c.style="SUV" and year(s.purchase_date)=2022;

#9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?
select sp.salesman_id, sp.name,sp.city,count(s.car_id) as count from salespersons sp
inner join sales s on sp.salesman_id=s.salesman_id
where year(s.purchase_date)=2023
group by sp.salesman_id
order by count desc
limit 1;

#10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?
select s.salesman_id,sp.name,sp.age,sum(c.cost_$) as revenue from salespersons sp
inner join sales s on sp.salesman_id=s.salesman_id
inner join cars c on s.car_id=c.car_id
where year(s.purchase_date)=2022
group by sp.salesman_id
order by revenue desc
limit 1;