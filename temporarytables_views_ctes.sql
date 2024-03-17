use sakila;

-- 1.
CREATE VIEW rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

select * from rental_summary;

-- 2.
-- DROP TEMPORARY TABLE IF EXISTS customer_payments;

CREATE TEMPORARY TABLE customer_payments AS
SELECT
    rs.customer_name,
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary AS rs
JOIN payment AS p ON rs.customer_id = p.customer_id
GROUP BY
    rs.customer_id;
    
select * from customer_payments;


-- 3.
WITH customer_summary_cte AS (
    SELECT
        rs.customer_id,
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cp.total_paid,
        cp.total_paid / rs.rental_count AS average_payment_per_rental
    FROM rental_summary AS rs
    JOIN customer_payments AS cp ON rs.customer_id = cp.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM customer_summary_cte;



