####CASE STUDY 1

use project3;
###Language Share
SELECT 
    DATE_FORMAT(ds, '%d-%M-%Y') AS Day,
    round(COUNT(distinct job_id) / sum(time_spent)*3600) AS No_of_Jobs_Reveiwed
FROM
    Job_data
WHERE
    ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY 1
ORDER BY 1;

select count(*) from Job_data;

SELECT 
    language,
    ROUND(100 * COUNT(language) / (SELECT COUNT(*) FROM job_data),2) AS percentage_share
FROM
    job_data
GROUP BY language;

###Duplicate rows 
SELECT * from (select*, ROW_NUMBER() OVER ( ORDER BY job_id DESC) AS No_of_rows
FROM Job_data) as A
where No_of_rows > 1 ;

##CASE STUDY 2
select * from users;
select * from events;

#A - weekly user engagement
SELECT 
    WEEK(occurred_at) AS Week_No,
    COUNT(DISTINCT user_id) AS Engaged_Users
FROM events
WHERE event_type = 'engagement'
GROUP BY Week_No
ORDER BY Week_No;

##User Growth Analysis:
#Objective: Analyze the growth of users over time for a product.
#Your Task: Write an SQL query to calculate the user growth for the product.
select * from users;
describe users;
describe events;

select year, A.week_no, A.no_of_active_users, sum(A.no_of_active_users) 
over (order by year, week_no rows between unbounded preceding and current row) 
as total_active_users from(
select extract(year from activated_at) as year, extract(week from activated_at) as week_no,
count(distinct user_id) as no_of_active_users 
from users   
group by year ,week_no 
order by year,week_no)as A;

#Weekly Retention Analysis:
#Objective: Analyze the retention of users on a weekly basis after signing up for a product.
#Your Task: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.

Select distinct user_id, 
sum(case when retention_week = 1 then 1 else 0 end) as per_week_retention_rate
from (select a.user_id,
a.signup_week, b.engagement_week,
b.engagement_week - a.signup_week as retention_week
from ((select distinct user_id, extract(week from occurred_at) as signup_week
from events
where event_type = 'signup_flow' and event_name = 'complete_signup') a
left join (select distinct user_id, extract(week from occurred_at) as engagement_week
from eventss
where event_type = 'engagement') b
on a.user_id = b.user_id)) d
group by user_id
order by user_id;

##Weekly Engagement Per Device:
#Objective: Measure the activeness of users on a weekly basis per device.
#Your Task: Write an SQL query to calculate the weekly engagement per device.

SELECT 
    extract(week from occurred_at) as week_no, device,
    COUNT(DISTINCT user_id) as no_of_users
FROM
    events 
where  event_type = 'engagement'
GROUP BY week_no, device
ORDER BY no_of_users;

#Email Engagement Analysis:
#Objective: Analyze how users are engaging with the email service.
#Your Task: Write an SQL query to calculate the email engagement metrics.

select count(action), action from email_events group by action;
SELECT 
    (SUM(CASE
        WHEN email_category = 'email_opened' THEN 1 ELSE 0 END) / SUM(CASE
        WHEN email_category = 'email_sent' THEN 1 ELSE 0 END)) * 100 AS email_open_rate,
    (SUM(CASE
        WHEN email_category = 'email_clicked' THEN 1 ELSE 0 END) / SUM(CASE
        WHEN email_category = 'email_sent' THEN 1 ELSE 0
    END)) * 100 AS email_clicked_rate
FROM
    (SELECT *,
            CASE
                WHEN action IN ('sent_weekly_digest' , 'sent_reengagement_email') THEN ('email_sent')
                WHEN action IN ('email_open') THEN ('email_opened')
                WHEN action IN ('email_clickthrough') THEN ('email_clicked')
            END AS email_category
    FROM
        email_events) AS a;
 ####### 7-day-rolling-avearge       
SELECT ds as date_of_review, extract(week from ds) as week_no, jobs_reviewed, AVG(jobs_reviewed)
OVER(ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS
throughput_7_rolling_average
FROM
(SELECT ds, COUNT( DISTINCT job_id) AS jobs_reviewed
FROM job_data
GROUP BY ds ORDER BY ds) a;

