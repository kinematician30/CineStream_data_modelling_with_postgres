-- Create dvddw.dim_store table
CREATE TABLE dvddw.dim_store (
    store_key SERIAL PRIMARY KEY,
    store_id INT NOT NULL UNIQUE, -- Original source ID
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(20) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10),
    phone VARCHAR(20) NOT NULL,
    manager_first_name VARCHAR(45) NOT NULL,
    manager_last_name VARCHAR(45) NOT NULL
);

-- Populate dvddw.dim_store
INSERT INTO dvddw.dim_store (
    store_id, address, address2, district, city, country, postal_code, phone,
    manager_first_name, manager_last_name
)
SELECT
    s.store_id,
    a.address,
    a.address2,
    a.district,
    ci.city,
    co.country,
    a.postal_code,
    a.phone,
    st.first_name AS manager_first_name,
    st.last_name AS manager_last_name
FROM
    public.store AS s
JOIN
    public.address AS a ON s.address_id = a.address_id
JOIN
    public.city AS ci ON a.city_id = ci.city_id
JOIN
    public.country AS co ON ci.country_id = co.country_id
JOIN
    public.staff AS st ON s.manager_staff_id = st.staff_id;