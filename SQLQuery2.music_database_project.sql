select * from music_database_project..album

--Q1 : who is the senior most employee based on job title

select top 1 * from employee
order by levels desc

--Q2 : which countries have the most invoices

select count(*) as c,billing_country
from invoice
group by billing_country
order by c desc

--Q3 : what are top 3 values of total invoice

select  top 3 total
from invoice
order by total desc

/*Q4 : Which city has the best customers? We would like to throw a promotional Music Festival  
in the city we made the most money. Write a query that returns one city that has the highest 
sum of invoice totals.Return both the city name & sum of all invoice totals. */

select top 1 sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc

/*Q5: Who is the best customer? The customer who has spent the most money will be declared the
best customer. Write a query that returns the person who has spent the most money. */

select  top 1 customer.customer_id, customer.first_name,customer.last_name,sum(invoice.total) as total
from customer
join invoice on  customer.customer_id = invoice.customer_id
group by customer.customer_id, customer.first_name, customer.last_name
order by total desc


/* Q6  :Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A */

select distinct customer.first_name,customer.last_name,customer.email
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name = 'rock'
)
order by customer.email asc;

 /* Q7 :Let's invite the artists who have written the most rock music in our dataset.
 Write a query that returns the Artist name and total track count of the top 10 rock bands */

 select top 10 artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
 from track
 join album on album.album_id = track.album_id
 join artist on artist.artist_id = album.artist_id
 join genre on genre.genre_id = track.genre_id
 where genre.name = 'rock'
 group by artist.artist_id, artist.name
 order by number_of_songs desc


/*Q8:Return all the track names that have a song length longer than average song length.Return the
Name and milliseconds for each track. Order by the song length with the longest songs listed first.*/

select name , milliseconds
from track
where milliseconds > (
select avg(milliseconds) 
from track)
order by milliseconds desc ;

/*Q9 :Find how much amount spent by each customer on artists? Write a query to return customer name,
artist name and total spent*/

WITH best_selling_artist AS (
	SELECT top 1 artist.artist_id AS artist_id, artist.name AS artist_name, 
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY artist.artist_id,artist.name
	ORDER BY total_sales DESC
	)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC;






















 














