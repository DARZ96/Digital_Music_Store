-- Who is the best customer?

SELECT c.FirstName || ' ' || c.LastName AS Customer , SUM(i.Total) AS Total_Spent
FROM Customer AS c
JOIN Invoice AS i
USING (CustomerId)
GROUP BY  1
ORDER BY 2 DESC;



-- all Rock Music listeners

SELECT c.email, c.FirstName || ' ' ||  c.LastName AS Full_Name, g.Name AS Genre
FROM Customer AS c
JOIN Invoice AS i
USING (CustomerId)
JOIN InvoiceLine AS il
USING (InvoiceId)
JOIN Track AS t
USING (TrackId)
JOIN Genre AS g
USING (GenreId)
WHERE Genre = 'Rock'
GROUP BY 1, 2
ORDER BY 1;


--- Who is writing the rock music?

SELECT  a.Name AS Artist, count(t.trackId) Number_of_Songs
FROM Artist AS a
JOIN Album AS alb
ON a.ArtistId = alb.ArtistId
JOIN Track AS t
ON alb.AlbumId = t.AlbumId
JOIN Genre AS g
ON t.GenreId = g.GenreId
WHERE g.name = 'Rock'
GROUP BY 1
ORDER BY 2 DESC;


--- First, find which artist has earned the most according to the InvoiceLines?

SELECT a.Name AS Artist, sum(il.Quantity*il.UnitPrice) AS Amount_Spent
FROM Artist AS a
JOIN Album AS alb
ON a.ArtistId = alb.ArtistId
JOIN Track AS t
ON alb.AlbumId = t.AlbumId
JOIN InvoiceLine AS il
ON t.TrackId = il.TrackId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- Which customer spent the most on this artist?

SELECT a.Name AS Artist, sum(il.Quantity*il.UnitPrice) AS Amount_Spent, c.FirstName || ' ' ||  c.LastName AS Full_Name
FROM Artist AS a
JOIN Album AS alb
ON a.ArtistId = alb.ArtistId
JOIN Track AS t
ON alb.AlbumId = t.AlbumId
JOIN InvoiceLine AS il
ON t.TrackId = il.TrackId
JOIN Invoice AS i
ON il.InvoiceId = i.InvoiceId
JOIN Customer AS c
ON i.CustomerId = c.CustomerId
WHERE Artist = (SELECT Artist
                FROM (
                      (SELECT a.Name AS Artist, sum(il.Quantity*il.UnitPrice) AS Amount_Spent
                      FROM Artist AS a
                      JOIN Album AS alb
                      ON a.ArtistId = alb.ArtistId
                      JOIN Track AS t
                      ON alb.AlbumId = t.AlbumId
                      JOIN InvoiceLine AS il
                      ON t.TrackId = il.TrackId
                      GROUP BY 1
                      ORDER BY 2 DESC
                      LIMIT 1)))
GROUP BY 1, 3
ORDER BY 2 DESC;
