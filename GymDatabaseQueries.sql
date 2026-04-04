# GYM MEMBERSHIP MANAGEMENT SYSTEM 

## DATABASE CREATION
create database gymdatabase;
use gymdatabase;

## CREATING OF TABLES
# MEMBERS TABLE
create table members
(member_id int primary key auto_increment,
name varchar(50),
contact varchar(20),
gender enum('Male', 'Female'),
join_date date);

# SUBSCRIPTION TABLE
create table subscriptions
(subscription_id int primary key auto_increment,
member_id int,
subscription_start date,
subscription_end date,
amount_paid decimal(10,2),
duration varchar(50),
status enum('Active', 'Inactive', 'Expired'),
payment_method enum('Bank Transfer', 'Cash', 'Card'),
foreign key (member_id) references members(member_id)
);

## QUERIES FOR INSERING OF VALUES INTO THE TABLES
insert into members (name, contact, gender, join_date)
values
();

insert into subscriptions (member_id, subscription_start, subscription_end, amount_paid, duration, status, payment_method)
values
();

select*
from members;

select*
from subscriptions;

# QUERY FOR SUBSCRIPTIONS THAT IS YET TO BE ACTIVE
select sb.subscription_id, mb.member_id, name, subscription_start, subscription_end, contact, duration, status, amount_paid
from members mb
join subscriptions sb
using(member_id)
where status = 'Inactive';

# ACTIVE SUBSCRIPTIONS 
select sb.subscription_id, mb.member_id, name, subscription_start, subscription_end, contact, duration, status, amount_paid
from members mb
join subscriptions sb
using(member_id)
where status = 'Active';

# QUERY FOR EXPIRED SUBSCRIPTIONS (AT-RISK MEMBERS)
select sb.subscription_id, mb.member_id, name, subscription_start, subscription_end, contact, duration, status, amount_paid
from members mb
join subscriptions sb
using(member_id)
where status = 'Expired';

## CREATED A VIEW TO TRACK EXPIRED SUBSCRIPTIONS AND UPCOMING EXPIRATIONS 
# UPCOMING EXPIRATIONS (NEXT 3 DAYS)
create view expiring_sub_3days as
select mb.member_id, name, contact,subscription_start, subscription_end, duration, status
from members mb
join subscriptions sb
on mb.member_id = sb.member_id
where subscription_end = curdate() + interval 3 day;

select*
from expiring_sub_3days;

# UPCOMING EXPIRATIONS (NEXT DAY)
create view expiring_sub as
select mb.member_id, name, contact,subscription_start, subscription_end, duration, status
from members mb
join subscriptions sb
on mb.member_id = sb.member_id
where subscription_end = curdate() + interval 1 day;

select*
from expiring_sub;

# THE DAY OF EXPIRATION
create view expired_sub as
select mb.member_id, name, contact, subscription_start, subscription_end, duration, status
from members mb
join subscriptions sb
on mb.member_id = sb.member_id
where subscription_end = curdate();

select*
from expired_sub;  

# QUERY FOR UPDATING SUBSCRIPTION STATUS TO EXPIRED ON DAY OF EXPIRATION OR SUBSCRIPTIONS THAT HAS EXPIRED DAYS BEFORE
update subscriptions
set status = 'Expired'
where subscription_end <= curdate();

# TOTAL REVENUE
select sum(amount_paid) total_revenue
from subscriptions;

# TOP PAYING MEMBERS
select name, sum(amount_paid) total_paid
from members m
join subscriptions s
using(member_id)
group by name
order by total_paid desc
limit 5;

# TOP 10 MOST POPULAR SUBSCRIPTION PLAN
select duration, count(*) total_subscriptions
from subscriptions
group by duration
order by total_subscriptions desc
limit 10;

# MONTHLY REVENUE TREND
select date_format(subscription_start, '%Y-%m') month,
sum(amount_paid) revenue
from subscriptions
group by month
order by month;
