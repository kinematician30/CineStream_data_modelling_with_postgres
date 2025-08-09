### Data Description: Dimensional Model for CineStream DVD Rental Service

This section details the structure of the data warehouse, outlining the fields and relationships for each dimension and fact table within the `dvddw` schema. The model is based on a star schema design, optimized for analytical querying.

#### **Dimension Tables**

**1. `dvddw.dim_date`**
This dimension provides a comprehensive calendar for time-based analysis.
* **`date_key` (INT):** The unique primary key, formatted as YYYYMMDD.
* **`full_date` (DATE):** The full date value.
* **`day_of_week` (SMALLINT):** The day of the week (0=Sunday, 6=Saturday).
* **`day_name` (VARCHAR):** The name of the day (e.g., 'Monday').
* **`day_of_month` (SMALLINT):** The day number within the month.
* **`day_of_year` (SMALLINT):** The day number within the year.
* **`week_of_year` (SMALLINT):** The week number within the year.
* **`month` (SMALLINT):** The month number (1-12).
* **`month_name` (VARCHAR):** The name of the month (e.g., 'January').
* **`quarter` (SMALLINT):** The quarter number (1-4).
* **`quarter_name` (VARCHAR):** The name of the quarter (e.g., 'Q1').
* **`year` (SMALLINT):** The year value.
* **`is_weekend` (BOOLEAN):** A flag indicating if the day is a weekend.

**2. `dvddw.dim_customer`**
This table contains descriptive attributes for each customer.
* **`customer_key` (SERIAL):** The unique surrogate primary key for the dimension.
* **`customer_id` (INT):** The original primary key from the source `public.customer` table.
* **`first_name` (VARCHAR):** The customer's first name.
* **`last_name` (VARCHAR):** The customer's last name.
* **`email` (VARCHAR):** The customer's email address.
* **`address` (VARCHAR):** The customer's street address.
* **`city` (VARCHAR):** The city where the customer resides.
* **`country` (VARCHAR):** The country of the customer's residence.
* **`active_status` (VARCHAR):** The customer's active status ('active' or 'inactive').

**3. `dvddw.dim_film`**
This table describes the films available for rent, including their category.
* **`film_key` (SERIAL):** The unique surrogate primary key for the dimension.
* **`film_id` (INT):** The original primary key from the source `public.film` table.
* **`title` (VARCHAR):** The title of the film.
* **`description` (TEXT):** A brief description of the film.
* **`release_year` (SMALLINT):** The year the film was released.
* **`language` (VARCHAR):** The language of the film.
* **`rating` (VARCHAR):** The film's MPAA rating (e.g., 'G', 'PG-13').
* **`category_name` (VARCHAR):** The primary category or genre of the film.

**4. `dvddw.dim_store`**
This table provides details about each rental store location.
* **`store_key` (SERIAL):** The unique surrogate primary key for the dimension.
* **`store_id` (INT):** The original primary key from the source `public.store` table.
* **`address` (VARCHAR):** The store's street address.
* **`city` (VARCHAR):** The city where the store is located.
* **`country` (VARCHAR):** The country of the store's location.
* **`manager_first_name` (VARCHAR):** The first name of the store's manager.
* **`manager_last_name` (VARCHAR):** The last name of the store's manager.

**5. `dvddw.dim_staff`**
This table contains information on the staff members who process rentals.
* **`staff_key` (SERIAL):** The unique surrogate primary key for the dimension.
* **`staff_id` (INT):** The original primary key from the source `public.staff` table.
* **`first_name` (VARCHAR):** The staff member's first name.
* **`last_name` (VARCHAR):** The staff member's last name.
* **`email` (VARCHAR):** The staff member's email address.
* **`username` (VARCHAR):** The staff member's login username.
* **`store_location` (VARCHAR):** A denormalized field describing the staff member's store location.

#### **Fact Tables**

**1. `dvddw.fact_rental`**
This is the central transactional fact table, with each row representing a single rental event.
* **`rental_fact_id` (SERIAL):** A unique primary key for each fact record.
* **`rental_id` (INT):** A unique key corresponding to the original `public.rental` primary key.
* **`date_key` (INT):** Foreign key referencing `dvddw.dim_date`.
* **`customer_key` (INT):** Foreign key referencing `dvddw.dim_customer`.
* **`film_key` (INT):** Foreign key referencing `dvddw.dim_film`.
* **`store_key` (INT):** Foreign key referencing `dvddw.dim_store`.
* **`staff_key` (INT):** Foreign key referencing `dvddw.dim_staff`.
* **`rental_amount` (NUMERIC):** The total monetary value of the rental.
* **`rental_duration_days` (INT):** The duration of the rental in days.
* **`overdue_days` (INT):** The number of days the rental was returned late.

**2. `dvddw.fact_payment`**
This fact table records every payment event, allowing for detailed financial analysis.
* **`payment_fact_id` (SERIAL):** A unique primary key for each fact record.
* **`payment_id` (INT):** A unique key corresponding to the original `public.payment` primary key.
* **`date_key` (INT):** Foreign key referencing `dvddw.dim_date`.
* **`customer_key` (INT):** Foreign key referencing `dvddw.dim_customer`.
* **`staff_key` (INT):** Foreign key referencing `dvddw.dim_staff`.
* **`amount` (NUMERIC):** The monetary value of the payment.

**3. `dvddw.fact_daily_inventory_snapshot`**
This fact table is a snapshot of inventory levels at the end of each day, useful for tracking stock and turnover.
* **`inventory_snapshot_fact_id` (SERIAL):** A unique primary key for each fact record.
* **`date_key` (INT):** Foreign key referencing `dvddw.dim_date`.
* **`store_key` (INT):** Foreign key referencing `dvddw.dim_store`.
* **`film_key` (INT):** Foreign key referencing `dvddw.dim_film`.
* **`inventory_id` (INT):** The original ID of the inventory item.
* **`quantity_in_stock` (SMALLINT):** The number of units of a specific film in stock at a specific store.
* **`quantity_rented` (SMALLINT):** The number of units of a specific film rented out at a specific store.

**4. `dvddw.fact_daily_customer_activity`** This is a **periodic snapshot fact table** that captures aggregated customer activity and payments on a daily basis. Its purpose is to track customer engagement patterns and financial contributions over time, allowing for trend analysis and segmentation.

* **`customer_activity_fact_id` (SERIAL):** A unique primary key for each fact record.
* **`date_key` (INT):** Foreign key referencing `dvddw.dim_date`.
* **`customer_key` (INT):** Foreign key referencing `dvddw.dim_customer`.
* **`total_rentals_day` (INT):** A measure representing the number of rentals made by a specific customer on a specific day.
* **`total_payments_day` (NUMERIC):** A measure representing the total monetary value of payments made by a specific customer on a specific day.
