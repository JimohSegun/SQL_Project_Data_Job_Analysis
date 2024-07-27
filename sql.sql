--What are the top paying analyst job ?
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


  
--What skills are required for these top-paying jobs?
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



--What skills are the most in demand for data analysts?
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



--Which skills are associated with higher salaries?
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



--What are the most optimal skills to learn?
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
     Demand_count DESC


