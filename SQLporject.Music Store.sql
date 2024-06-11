Q:1Who is the senior most employee based on job title?

Select * from employee
Order BY Levels desc
Limit 1
	
Q 2: Which countries have the most Invoice
 Select * from invoice
Select COUNT (*)  as c, Billing_country from invoice group by billing_country order
by c desc

Q:3 What are top 3 values of total invoice

Select total from invoice order by total desc limit 3

Select * from invoice;
select SUM(total) as invoice_total, billing_city from invoice group by billing_city
order by invoice_total desc;

Select * from customer;
Select * from customer cross join invoice;
Select customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) as total from customer
Join invoice ON customer.customer_id = invoice.customer_id 
Group BY customer.customer_id
Order BY total desc
limit 1;


SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre
FROM customer c
INNER JOIN invoice i ON c.customer_id = i.customer_id
INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
INNER JOIN track t ON il.track_id = t.track_id
INNER JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;

SELECT a.name AS artist_name, COUNT(t.track_id) AS track_count
FROM artist a
INNER JOIN album al ON a.artist_id = al.artist_id
INNER JOIN track t ON al.album_id = t.album_id
INNER JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.name
ORDER BY track_count DESC
LIMIT 10;


Select name,milliseconds from track
where milliseconds > ( 
	 select AVG(milliseconds) AS avg_track_length
	from track)
order by milliseconds desc;


Select * from customer name;
Select * from artist name;

SELECT c.first_name, c.last_name, a.name AS artist_name, SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
INNER JOIN invoice i ON c.customer_id = i.customer_id
INNER JOIN invoiceline il ON i.invoice_id = il.invoice_id
INNER JOIN track t ON il.track_id = t.track_id
INNER JOIN album al ON t.album_id = al.album_id
INNER JOIN artist a ON al.artist_id = a.artist_id
GROUP BY c.first_name, c.last_name, a.name
ORDER BY c.last_name, c.first_name, artist_name;

)

WITH best_selling_artist AS (
    SELECT 
        artist.artist_id AS artist_id, 
        artist.name AS artist_name,
        SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
    FROM 
        invoice_line
    JOIN 
        track ON track.track_id = invoice_line.track_id
    JOIN 
        album ON album.album_id = track.album_id
    JOIN 
        artist ON artist.artist_id = album.artist_id
    GROUP BY 
        artist.artist_id, artist.name
    ORDER BY 
        total_sales DESC
    LIMIT 10
)
SELECT *
FROM best_selling_artist;

WITH customer_spending AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country,
        SUM(il.unit_price * il.quantity) AS total_spent
    FROM 
        customer c
    INNER JOIN 
        invoice i ON c.customer_id = i.customer_id
    INNER JOIN 
        invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, c.country
),
ranked_spending AS (
    SELECT 
        cs.country,
        cs.customer_id,
        cs.first_name,
        cs.last_name,
        cs.total_spent,
        RANK() OVER (PARTITION BY cs.country ORDER BY cs.total_spent DESC) AS spending_rank
    FROM 
        customer_spending cs
)
SELECT 
    rs.country,
    rs.first_name,
    rs.last_name,
    rs.total_spent
FROM 
    ranked_spending rs
WHERE 
    rs.spending_rank = 1
ORDER BY 
    rs.country, rs.total_spent DESC;




