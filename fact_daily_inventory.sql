-- Create dvddw.fact_daily_inventory_snapshot table
CREATE TABLE dvddw.fact_daily_inventory_snapshot (
    inventory_snapshot_fact_id SERIAL PRIMARY KEY,
    date_key INT NOT NULL,
    store_key INT NOT NULL,
    film_key INT NOT NULL,
    inventory_id INT NOT NULL, -- Original inventory item ID
    quantity_in_stock SMALLINT NOT NULL,
    quantity_rented SMALLINT NOT NULL,
    -- Foreign key constraints
    FOREIGN KEY (date_key) REFERENCES dvddw.dim_date(date_key),
    FOREIGN KEY (store_key) REFERENCES dvddw.dim_store(store_key),
    FOREIGN KEY (film_key) REFERENCES dvddw.dim_film(film_key)
);

-- Populate dvddw.fact_daily_inventory_snapshot
-- This is a more complex ETL, as it requires aggregating daily data.
-- For simplicity for beginners, we'll take a snapshot of the *current* state
-- as if it were an end-of-day snapshot. In a real DW, this would be run daily.
INSERT INTO dvddw.fact_daily_inventory_snapshot (
    date_key, store_key, film_key, inventory_id, quantity_in_stock, quantity_rented
)
SELECT
    TO_CHAR(CURRENT_DATE, 'YYYYMMDD')::INT AS date_key, -- Use current date for snapshot
    ds.store_key,
    df.film_key,
    inv.inventory_id,
    CASE
        WHEN public.inventory_in_stock(inv.inventory_id) THEN 1
        ELSE 0
    END AS quantity_in_stock,
    CASE
        WHEN NOT public.inventory_in_stock(inv.inventory_id) THEN 1
        ELSE 0
    END AS quantity_rented
FROM
    public.inventory AS inv
JOIN
    public.film AS f ON inv.film_id = f.film_id
JOIN
    dvddw.dim_store AS ds ON inv.store_id = ds.store_id
JOIN
    dvddw.dim_film AS df ON inv.film_id = df.film_id;

-- Note: For a true daily snapshot, you'd need to run this query daily and insert data for that specific date or by calculating in-stock/rented status for each inventory item on that day.