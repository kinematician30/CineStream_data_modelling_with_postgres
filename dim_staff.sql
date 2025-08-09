-- Create dvddw.dim_staff table
CREATE TABLE dvddw.dim_staff (
    staff_key SERIAL PRIMARY KEY,
    staff_id INT NOT NULL UNIQUE, -- Original source ID
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    username VARCHAR(16) NOT NULL,
    active BOOLEAN NOT NULL,
    store_location VARCHAR(100) 
	-- Denormalizing for the store info for staff
);

-- Populate dvddw.dim_staff
INSERT INTO dvddw.dim_staff (
    staff_id, first_name, last_name, email, username, active, store_location
)
SELECT
    st.staff_id,
    st.first_name,
    st.last_name,
    st.email,
    st.username,
    st.active,
    a.address || ', ' || ci.city || ', ' || co.country AS store_location
FROM
    public.staff AS st
JOIN
    public.store AS s ON st.store_id = s.store_id
JOIN
    public.address AS a ON s.address_id = a.address_id
JOIN
    public.city AS ci ON a.city_id = ci.city_id
JOIN
    public.country AS co ON ci.country_id = co.country_id;