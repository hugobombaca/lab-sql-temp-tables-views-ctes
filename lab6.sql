CREATE VIEW cust_rental_info AS
SELECT c.customer_id AS customer_id , CONCAT(c.first_name ," ",c.last_name) AS customer_name, c.email AS email_address, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id;

CREATE TEMPORARY TABLE temp_total_paid AS
SELECT cri.customer_id,cri.customer_name,cri.email_address,cri.rental_count,SUM(p.amount) AS total_paid
FROM cust_rental_info cri
LEFT JOIN payment p ON cri.customer_id = p.customer_id
GROUP BY cri.customer_id, cri.customer_name, cri.email_address, cri.rental_count;

WITH rental_payment AS (
	SELECT cri.customer_id,cri.email_address,cri.customer_name,cri.rental_count,ttp.total_paid
    FROM cust_rental_info cri
    JOIN temp_total_paid ttp ON cri.customer_id = ttp.customer_id 
)
SELECT customer_name,
    email_address,
    rental_count,
    total_paid,
    total_paid / rental_count AS average_payment_rental
FROM rental_payment;