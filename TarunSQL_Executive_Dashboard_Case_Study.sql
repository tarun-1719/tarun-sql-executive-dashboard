/* =========================================================
   PROJECT: tarunSQL Corp – Executive Analytics Dashboard
/* =========================================================================================
   PROJECT NAME    : tarunSQL Corp – Executive Analytics Dashboard
   PROJECT TYPE    : End-to-End SQL Analytics Project
   TARGET ROLE     : Data Analyst / Business Intelligence Analyst
   DATABASE        : MySQL 8.0+
   AUTHOR          : Tarun singh
   

   PROJECT OVERVIEW:
   This project demonstrates the design and implementation of a SQL-based analytics layer
   to support executive decision-making across geographic expansion, compensation equity,
   UI preference analysis, referral network visibility, and query performance optimization.
   ========================================================================================= */

/* =========================================================================================
   SECTION 1: DATABASE INITIALIZATION
   PURPOSE : Create and activate the project database environment
   ========================================================================================= */
 
 CREATE DATABASE IF NOT EXISTS tarunsql_dashboard;
USE tarunsql_dashboard;


/* =========================================================================================
   SECTION 2: CORE DATA MODEL DEFINITIONS
   PURPOSE : Define normalized tables required for analytical reporting
   NOTES   : 
   - users     → Master entity for employee/user information
   - addresses → Dimension table supporting geographic analysis
   ========================================================================================= */

/* -----------------------------
   TABLE: users
   DESCRIPTION: Stores user demographics, compensation, referral lineage,
                and UI configuration data in JSON format
------------------------------*/

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    gender ENUM('Male','Female','Other'),
    salary DECIMAL(10,2),
    referred_by INT,
    ui_preferences JSON
);

/* -----------------------------
   TABLE: addresses
   DESCRIPTION: Stores geographic attributes associated with users
------------------------------*/
CREATE TABLE addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    city VARCHAR(100),
    state VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


/* =========================================================================================
   SECTION 3: DATA POPULATION
   PURPOSE : Insert realistic sample data to simulate enterprise usage patterns
   NOTE    : Dataset intentionally supports all downstream analytical use cases
   ========================================================================================= */

/* -----------------------------
   INSERT: users
------------------------------*/
INSERT INTO users (name, gender, salary, referred_by, ui_preferences) VALUES
('Amit Sharma','Male',95000,NULL,'{"theme":"dark"}'),
('Neha Verma','Female',87000,1,'{"theme":"light"}'),
('Ravi Patel','Male',105000,1,'{"theme":"dark"}'),
('Sneha Iyer','Female',92000,2,'{"theme":"dark"}'),
('Kunal Mehta','Male',88000,3,'{"theme":"light"}'),
('Ananya Roy','Female',98000,3,'{"theme":"dark"}');

/* -----------------------------
   INSERT: addresses
------------------------------*/
INSERT INTO addresses (user_id, city, state) VALUES
(1,'Bengaluru','Karnataka'),
(2,'Mumbai','Maharashtra'),
(3,'Bengaluru','Karnataka'),
(4,'Delhi','Delhi'),
(5,'Mumbai','Maharashtra'),
(6,'Bengaluru','Karnataka');


/* =========================================================================================
   SECTION 4: GEOGRAPHIC EXPANSION ANALYSIS
   BUSINESS QUESTION:
   Which cities have the highest concentration of users to support
   infrastructure and office expansion decisions?

   OUTPUT COLUMNS:
   - city
   - state
   - total_users
   ========================================================================================= */

SELECT 
    a.city,
    a.state,
    COUNT(u.user_id) AS total_users
FROM users u
JOIN addresses a 
    ON u.user_id = a.user_id
GROUP BY a.city, a.state
ORDER BY total_users DESC
LIMIT 3;


/* =========================================================================================
   SECTION 5: COMPENSATION & EQUITY AUDIT
   BUSINESS QUESTION:
   Who is the second-highest earner within each gender group to evaluate
   internal pay distribution and benchmarking?

   TECHNIQUE:
   - Window Function (DENSE_RANK)
   ========================================================================================= */

SELECT 
    name,
    gender,
    salary,
    salary_rank
FROM (
    SELECT 
        name,
        gender,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY gender 
            ORDER BY salary DESC
        ) AS salary_rank
    FROM users
) ranked_compensation
WHERE salary_rank = 2;


/* =========================================================================================
   SECTION 6: USER INTERFACE PREFERENCE ANALYSIS
   BUSINESS QUESTION:
   Which users have explicitly enabled Dark Mode to guide UI/UX strategy?

   TECHNIQUE:
   - JSON value extraction
   ========================================================================================= */

SELECT 
    user_id,
    name,
    ui_preferences->>'$.theme' AS theme
FROM users
WHERE ui_preferences->>'$.theme' = 'dark';


/* =========================================================================================
   SECTION 7: INTERNAL REFERRAL NETWORK MAPPING
   BUSINESS QUESTION:
   How are employees connected through referral-based hiring?

   TECHNIQUE:
   - Self-Join on users table
   ========================================================================================= */

SELECT 
    e.name AS employee_name,
    r.name AS referred_by
FROM users e
JOIN users r 
    ON e.referred_by = r.user_id;


/* =========================================================================================
   SECTION 8: QUERY PERFORMANCE & OPTIMIZATION REVIEW
   BUSINESS QUESTION:
   Is the geographic expansion query efficiently using indexes
   or performing unnecessary full table scans?

   TECHNIQUE:
   - EXPLAIN ANALYZE
   ========================================================================================= */

EXPLAIN ANALYZE
SELECT 
    a.city,
    a.state,
    COUNT(u.user_id) AS total_users
FROM users u
JOIN addresses a 
    ON u.user_id = a.user_id
GROUP BY a.city, a.state



/* =========================================================
   END OF SCRIPT
   ========================================================= */
