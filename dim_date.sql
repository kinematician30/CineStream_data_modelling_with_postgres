-- Create dvddw.dim_date table
-- This dimension is usually generated, not directly copied from source data, to provide a comprehensive calendar for analysis.
CREATE TABLE dvddw.dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day_of_week SMALLINT NOT NULL,
    day_name VARCHAR(9) NOT NULL,
    day_of_month SMALLINT NOT NULL,
    day_of_year SMALLINT NOT NULL,
    week_of_year SMALLINT NOT NULL,
    month SMALLINT NOT NULL,
    month_name VARCHAR(9) NOT NULL,
    quarter SMALLINT NOT NULL,
    quarter_name VARCHAR(6) NOT NULL,
    year SMALLINT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- Populate dvddw.dim_date
INSERT INTO dvddw.dim_date (
    date_key, full_date, day_of_week, day_name, day_of_month, day_of_year, week_of_year,
    month, month_name, quarter, quarter_name, year, is_weekend
)
SELECT
    TO_CHAR(day, 'YYYYMMDD')::INT AS date_key,
    day::DATE AS full_date,
    EXTRACT(DOW FROM day) AS day_of_week,
    TRIM(TO_CHAR(day, 'Day')) AS day_name,
    EXTRACT(DAY FROM day) AS day_of_month,
    EXTRACT(DOY FROM day) AS day_of_year,
    EXTRACT(WEEK FROM day) AS week_of_year,
    EXTRACT(MONTH FROM day) AS month,
    TRIM(TO_CHAR(day, 'Month')) AS month_name,
    EXTRACT(QUARTER FROM day) AS quarter,
    'Q' || EXTRACT(QUARTER FROM day) AS quarter_name,
    EXTRACT(YEAR FROM day) AS year,
    CASE WHEN EXTRACT(DOW FROM day) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
FROM
    GENERATE_SERIES('2005-01-01'::DATE, '2030-12-31'::DATE, '1 day'::INTERVAL) AS day;
