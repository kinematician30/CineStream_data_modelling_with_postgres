-- Create dvddw.fact_rental table
CREATE TABLE dvddw.fact_rental (
    rental_fact_id SERIAL PRIMARY KEY,
    rental_id INT NOT NULL, -- Original source rental ID for traceability
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    film_key INT NOT NULL,
    store_key INT NOT NULL,
    staff_key INT NOT NULL,
    rental_amount NUMERIC(5,2) NOT NULL,
    rental_duration_days INT,
    overdue_days INT,
    -- Foreign key constraints
    FOREIGN KEY (date_key) REFERENCES dvddw.dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dvddw.dim_customer(customer_key),
    FOREIGN KEY (film_key) REFERENCES dvddw.dim_film(film_key),
    FOREIGN KEY (store_key) REFERENCES dvddw.dim_store(store_key),
    FOREIGN KEY (staff_key) REFERENCES dvddw.dim_staff(staff_key)
);

-- Populate dvddw.fact_rental
INSERT INTO dvddw.fact_rental (
    rental_id, date_key, customer_key, film_key, store_key, staff_key,
    rental_amount, rental_duration_days, overdue_days
)
SELECT
    r.rental_id,
    TO_CHAR(r.rental_date, 'YYYYMMDD')::INT AS date_key,
    dc.customer_key,
    df.film_key,
    ds.store_key,
    dst.staff_key,
    p.amount AS rental_amount,
    EXTRACT(DAY FROM (r.return_date - r.rental_date)) AS rental_duration_days,
    CASE
        WHEN r.return_date IS NOT NULL AND (r.return_date - r.rental_date) > (f.rental_duration * INTERVAL '1 day')
        THEN EXTRACT(DAY FROM (r.return_date - r.rental_date) - (f.rental_duration * INTERVAL '1 day'))
        ELSE 0
    END AS overdue_days
FROM
    public.rental AS r
JOIN
    public.payment AS p ON r.rental_id = p.rental_id
JOIN
    public.inventory AS i ON r.inventory_id = i.inventory_id
JOIN
    public.film AS f ON i.film_id = f.film_id
JOIN
    dvddw.dim_customer AS dc ON r.customer_id = dc.customer_id
JOIN
    dvddw.dim_film AS df ON f.film_id = df.film_id
JOIN
    dvddw.dim_store AS ds ON i.store_id = ds.store_id
JOIN
    dvddw.dim_staff AS dst ON r.staff_id = dst.staff_id;