-- cat test.sql | sqlite3 fiftyville.db

SELECT hour, minute, flights.id, destination_airport_id
FROM flights
JOIN airports 
ON airports.id = origin_airport_id
WHERE airports.city = "Fiftyville" AND flights.month = 7 AND flights.day = 29
;

SELECT  
FROM airports
WHERE id = 4