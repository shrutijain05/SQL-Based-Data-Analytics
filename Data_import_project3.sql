create database Project3;
show databases;

use Project3;
#Table 1 users


create table users (
user_id int,
created_at varchar(100),
company_id int,
language varchar(50),
activated_at varchar (100),
state varchar(50));

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from users;
alter table users add column temp_created_at datetime;

UPDATE users SET temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');

ALTER TABLE users DROP column created_at;

ALTER TABLE users CHANGE COLUMN temp_created_at created_at datetime;

alter table users add column temp datetime;
update users set temp=str_to_date(activated_at,'%d-%m-%Y %H:%i');
alter table users drop column activated_at;
alter table users change column temp activated_at datetime;

#TABLE 2 events

create table events (
user_id	INT,
occurred_at	VARCHAR(100),
event_type	VARCHAR(50),
event_name	VARCHAR(100),
location VARCHAR(50),
device	VARCHAR(50),
user_type INT 
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
INTO TABLE events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from events;

###description of table events
desc events; 
alter table events add column temp_occurred_at datetime;

UPDATE events SET temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');

ALTER TABLE events DROP column occurred_at;

ALTER TABLE events CHANGE COLUMN temp_occurred_at occurred_at datetime;


#TABLE 3 email_events

create table email_events (
user_id	INT,
occurred_at	varchar(100),
action	varchar(100),
user_type INT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
INTO TABLE email_events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from email_events;

alter table email_events add column temp_occurred_at datetime;

UPDATE email_events SET temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');

ALTER TABLE email_events DROP column occurred_at;

ALTER TABLE email_events CHANGE COLUMN temp_occurred_at occurred_at datetime;

# CASE STUDY Job_data

create table Job_data (
ds	varchar(100),
job_id	INT,
actor_id INT,
event varchar(100),
language varchar(100),	
time_spent	INT,
org varchar(50)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_data.csv"
INTO TABLE Job_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from Job_data;

alter table Job_data add column dates date;
update Job_data set dates=STR_TO_DATE(ds,'%m/%d/%Y');
alter table Job_data drop column ds;
alter table Job_data change column dates ds date;

select * from job_data;


