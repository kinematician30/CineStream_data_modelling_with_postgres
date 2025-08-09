-- Create dvddw.fact_daily_customer_activity table
CREATE TABLE dvddw.fact_daily_customer_activity (
    customer_activity_fact_id SERIAL PRIMARY KEY,
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    total_rentals_day INT NOT NULL DEFAULT 0,
    total_payments_day NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    -- foreign key constraints
    FOREIGN KEY (date_key) REFERENCES dvddw.dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dvddw.dim_customer(customer_key),
    UNIQUE(date_key, customer_key)
    );

-- Populate dvddw.fact_daily_customer_activity
INSERT INTO dvddw.fact_daily_customer_activity (
    date_key, customer_key, total_rentals_day, total_payments_day
)
SELECT 
    *
FROM
    public.rental AS r
JOIN 
    dvddw.dim_customer AS dc ON r.customer_id = dc.customer_id
LEFT JOIN
    public.payment AS p ON r.rental_id = p.rental_id 
        AND TO_CHAR(p.payment_date, 'YYYYMMDD')::INT = TO_CHAR(r.rental_date, 'YYYYMMDD')::INT
GROUP BY
    date_key, dc.customer_key
ORDER BY 
    date_key, dc.customer_key;