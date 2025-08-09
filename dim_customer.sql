-- Create dvddw.dim_customer table
CREATE TABLE dvddw.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE, -- Original ID for lookup in customer table
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(20) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10),
    phone VARCHAR(20) NOT NULL,
    active_status VARCHAR(10) NOT NULL
);

-- Populate dvddw.dim_customer
INSERT INTO dvddw.dim_customer (
    customer_id, first_name, last_name, email, address, address2, district,
    city, country, postal_code, phone, active_status
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    a.address,
    a.address2,
    a.district,
    ci.city,
    co.country,
    a.postal_code,
    a.phone,
    CASE WHEN c.activebool THEN 'active' ELSE 'inactive' END AS active_status
FROM
    public.customer AS c
JOIN
    public.address AS a ON c.address_id = a.address_id
JOIN
    public.city AS ci ON a.city_id = ci.city_id
JOIN
    public.country AS co ON ci.country_id = co.country_id;