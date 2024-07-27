# Introduction 
This project delves into the data job market with a focus on the data analyst role, exploring top-paying positions, in-demand skills, and areas where high demand aligns with high salaries in data analytics.

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to identify top-paying and in-demand skills, leveraging others' work to find the optimal skill set.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are the most in-demand for data analysts?
4. Which skills are associated with higher salaries?
5. what are the most optimal skills to learn?

# Tools I Used

For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights, ideal for handling job posting data.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# Analysis
Each query for this project was designed to investigate specific aspects of the data analyst job market. Here is how I approached each question:

### 1. Top Paying Data Analyst jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high-paying opportunities in the field.
~~~sql
SELECT 
       job_posted_date
       job_id, 
       job_title,
	   job_location,
	   salary_year_avg,
       job_schedule_type,
	   name as company_name
FROM  
      sql_course.dbo.job_posting as post
Left Join  sql_course.dbo.company_dim as dim 
ON post.company_id = dim.company_id
Where 
      job_title = 'Data Analyst'AND
      job_location = 'Anywhere' AND
	  salary_year_avg IS NOT NULL

ORDER BY  
        salary_year_avg DESC
 ~~~       

### 2. Skills Required For Top Paying Jobs
To better understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insight into what employers value for high-compensation roles.

~~~sql
WITH Top_paying_jobs as (
  SELECT 
        top 10 job_id, 
       job_title,
	   salary_year_avg,
	   name as company_name	
FROM  
      sql_course.dbo.job_posting as post
Left Join  sql_course.dbo.company_dim as dim 
ON post.company_id = dim.company_id
Where 
      job_title = 'Data Analyst'AND
      job_location = 'Anywhere' AND
	  salary_year_avg IS NOT NULL
)
  
SELECT 
      Top_paying_jobs.* , skills
FROM  
      top_paying_jobs
INNER JOIN sql_course.dbo.skills_job_dim 
 ON  
     skills_job_dim .job_id = Top_paying_jobs.job_id
INNER JOIN sql_course.dbo.skills
 ON 
     skills.skill_id = skills_job_dim.skill_id
ORDER BY 
     salary_year_avg

~~~

Here is a breakdown of the most in-demand job skills for the top 10 highest-paying data analyst positions:

Based on the provided data, here are the top 10 data analyst job skills:

**SQL -** Mentioned 9 times.

**Python -** Mentioned 5 times.

**R -** Mentioned 4 times.

### 3. In-Demand Skills for Data Analyst 
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
~~~sql
SELECT 
       Top 5 skills,
	   COUNT(skills_job_dim.job_id) Demand_count
FROM  
      sql_course.dbo.job_posting
INNER JOIN sql_course.dbo.skills_job_dim 
ON  
       skills_job_dim .job_id = job_posting.job_id
INNER JOIN sql_course.dbo.skills
ON   
       skills.skill_id = skills_job_dim.skill_id
WHERE 
       job_title_short = 'Data Analyst'
GROUP BY skills, 
       job_title_short 
ORDER BY Demand_count DESC
~~~


Here is the breakdown of the most demanded skills for data analysts:

- **SQL and Excel remain fundamental**, emphasizing the need for strong foundational skills in data processing.
- **Programming and visualization tools like Python, Tableau, and Power BI** are essential, pointing to the increasing importance of technical skills in data storytelling and decision support.

| **Skills** | **Demand Count** |
|------------|------------------|
| SQL        | 47,641           |
| Python     | 29,333           |
| R          | 15,407           |
| SAS        | 14,386           |
| Go         | 4,013            |

### 4. Skills Based On Salary 
Exploring the average salaries assocaited with different skills revealed which skills are highest paying 
~~~sql
SELECT  
        TOP 20 skills ,
        AVG(cast (salary_year_avg as float)) as avg_salary
FROM 
        sql_course.dbo.job_posting
INNER JOIN sql_course.dbo.skills_job_dim
ON   
       job_posting.job_id = skills_job_dim.job_id
INNER JOIN sql_course.dbo.skills
ON 
        skills.skill_id = skills_job_dim.skill_id
WHERE salary_year_avg IS NOT NULL 
            AND job_work_from_home = 'False'
			AND job_title_short = 'Data Analyst'
GROUP BY 
         skills, salary_year_avg 
ORDER BY 
        avg_salary DESC
~~~
Here's a breakdown of the result for top paying skills for Data Analyst:

| **Skills** | **Avg Salary** |
|------------|-----------------|
| Python     | 375,000         |
| R          | 375,000         |
| VBA        | 375,000         |
| Python     | 350,000         |
| SQL        | 350,000         |
| SQL        | 235,000         |
| NoSQL      | 234,000         |
| Python     | 234,000         |
| R          | 234,000         |
| SAS        | 234,000         |
| Scala      | 234,000         |
| SQL        | 234,000         |
| Python     | 225,000         |
| SQL        | 225,000         |
| Python     | 222,500         |
| R          | 222,500         |
| SQL        | 222,500         |
| Go         | 220,000         |
| Go         | 218,500         |
| MATLAB     | 218,500         |

### 5. Most Optimal skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and offer a high average salary, providing a strategic focus for skills development.
~~~sql
SELECT 
        skills.skill_id,
        skills,
        count(job_posting.job_id) as Demand_count,  
		ROUND(AVG(cast (salary_year_avg as float)), 1) as avg_salary
FROM 
      sql_course.dbo.job_posting
INNER JOIN sql_course.dbo.skills_job_dim
ON    job_posting.job_id = skills_job_dim.job_id
INNER JOIN sql_course.dbo.skills
ON     skills.skill_id = skills_job_dim.skill_id
WHERE salary_year_avg IS NOT NULL 
      AND job_title_short = 'Data Analyst' 
	  AND job_work_from_home = 'False'
GROUP BY 
	   skills,
	   skills.skill_id
HAVING 
    COUNT(job_posting.job_id) > 10
ORDER BY 
	Demand_count DESC,
	avg_salary DESC

~~~

| **Skill ID** | **Skills**      | **Demand Count** | **Avg Salary** |
|--------------|-----------------|------------------|----------------|
| 0            | SQL             | 1,362            | 95,235.20      |
| 1            | Python          | 803              | 101,566        |
| 5            | R               | 470              | 98,131.20      |
| 7            | SAS             | 227              | 91,501.70      |
| 186          | SAS             | 227              | 91,501.70      |
| 8            | Go              | 130              | 95,692.20      |
| 22           | VBA             | 75               | 92,773         |
| 9            | JavaScript      | 75               | 89,554.70      |
| 4            | Java            | 66               | 92,409.40      |
| 2            | NoSQL           | 44               | 109,421.10     |
| 26           | C               | 44               | 102,313.70     |
| 23           | Crystal         | 44               | 82,477.80      |
| 15           | MATLAB          | 39               | 98,820.20      |
| 13           | C++             | 34               | 97,297.80      |
| 3            | Scala           | 32               | 109,680.70     |
| 16           | T-SQL           | 29               | 90,797.40      |
| 14           | C#              | 28               | 101,085.50     |
| 10           | HTML            | 24               | 82,509.60      |
| 6            | Shell           | 19               | 98,498.90      |
| 21           | Visual Basic    | 18               | 94,421.40      |
| 11           | CSS             | 16               | 85,532         |
| 25           | PHP             | 12               | 113,139.70     |
| 62           | MongoDB         | 12               | 109,915.20     |
| 18           | MongoDB         | 12               | 109,915.20     |

Here is a breakdown of the most optimal skills for data analysts:

**High-Demand Programming Languages:** SQL, Python, and R stand out for their high demand, with demand counts of 1,362, 803, and 470 respectively. Despite their high demand, their average salaries are around $95,235.20 for SQL, $101,566 for Python, and $98,131.20 for R, indicating that proficiency in these languages is highly valued but also widely available.

### What I Learned

# What I Learned
Throughout this adventure, I’ve supercharged my SQL toolkit with some powerful enhancements:

**Complex Query Crafting:** Mastered advanced SQL techniques, expertly merging tables with precision.

**Data Aggregation:** Became proficient with GROUP BY and utilized aggregate functions like COUNT() and AVG() to effectively summarize data.

**Analytical Wizardry:** Enhanced my problem-solving skills, transforming complex questions into actionable, insightful SQL queries.

# Conclusions
### Insights
**1.Top Paying Data Analyst Jobs:** The highest-paying data analyst jobs that allow remote work offer a wide range of average salaries, with the highest at $98,750!

**2.Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skill for earning a top salary.

**3.Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, making it essential for job seekers.

**4.Skills with Higher Salaries:** Specialized skills, such as Python and R, are associated with the highest average salaries, indicating a premium on niche expertise.

**5.Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.
