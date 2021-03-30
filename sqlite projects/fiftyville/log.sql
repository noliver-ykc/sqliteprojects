-- Keep a log of any SQL queries you execute as you solve the mystery.
-- THE CASE OF THE DUCK OF FIFTYVILLE -- 

-- ( 1 Diving into Details ) -- 
SELECT description 
FROM crime_scene_reports
WHERE month = 7 AND day = 28
AND street = "Chamberlin Street";

/* Like with any great investigation, we must first first inquire into 
the details of the case. 

NEW INFO : we learned the CS50 duck was ab(duck)ted at exactly 10:15 at the 
Chamberlin Street courthouse. There are 3 witnesses and interviews with them.
TO DO: Check interviews */

-- ( 2 "Or So You Say.")

SELECT * FROM interviews 
WHERE month = 7 AND day = 28;

/* Going over the interviews we learm there are 3 witnesses Ruth, Eugene and Raymond. 

NEW INFO: 
Ruth ] according to Ruth the theif escaped into a car in the CH parking lot and escape, hinting
at possible security footage. 

Eugene ] Eugene recognizes the theif and saw them withdrawing money from the ATM on fifer street.
If possible I should check if there are any cameras in the area. 

Raymond ] Raymond heard the a brief phonecall between the theif and an accomplice. Theif requested acc
purchase the earliest flight ticket out of town 2mm (7/29). Check flight logs. 

+ We can gather that the perp before arriving at the crime scene withdrew money. then later
left the crime scene, called a friend to buy the tickets
 
TO DO: 1) Check parking lot cameras. 2)Check out the ATM. 3) Check flights leaving 2mm morning. 
*/

-- ( 3 "The Daring escape")

SELECT *  
FROM courthouse_security_logs
WHERE month = 7 AND day = 28 AND hour = 9 OR month = 7 AND day = 28 AND minute <= 30 AND hour = 10;

/* Checking parking lot activity between 9 and 10:30 (supposing the criminal arrived anywhere b/t an 
hour before the crime and left before 15mins past.) 

NEW INFO: The following cars arrived and left in the above time period
id | year | month | day | hour | minute | activity | license_plate
254 | 2020 | 7 | 28 | 9 | 14 | entrance | 4328GD8
263 | 2020 | 7 | 28 | 10 | 19 | exit | 4328GD8

255 | 2020 | 7 | 28 | 9 | 15 | entrance | 5P2BI95
260 | 2020 | 7 | 28 | 10 | 16 | exit | 5P2BI95

256 | 2020 | 7 | 28 | 9 | 20 | entrance | 6P58WS2
262 | 2020 | 7 | 28 | 10 | 18 | exit | 6P58WS2

257 | 2020 | 7 | 28 | 9 | 28 | entrance | G412CB7
264 | 2020 | 7 | 28 | 10 | 20 | exit | G412CB7

TO DO: check the people with those lisence plates. Then cross check that list to see
if any of them stopped at the ATM metioned by Eugene. 

*/

--( 4 "The Suspects")

SELECT *
FROM people
WHERE license_plate = "G412CB7";
-- repeated with all license plates
/* Here we have checked for the name, passport no. and phone no. of all possible
suspects (those who were in the courthouse during our chosen time frame). Passport 
and phone numbers will be used to determine who the sidekick to this crime was
when we chk other records. 

NEW INFO: 
id | name | phone_number | passport_number | license_plate
467400 | Danielle | (389) 555-5198 | 8496433585 | 4328GD8
221103 | Patrick | (725) 555-4692 | 2963008352 | 5P2BI95
243696 | Amber | (301) 555-4174 | 7526138472 | 6P58WS2
398010 | Roger | (130) 555-0289 | 1695452385 | G412CB7

TO DO: 
1) Chk phone records for these four to see if they called anyone for less than
a minute between 10:15-10:20. 
2) Check out the ATM transactions. 
3) Check flights leaving 2mm morning. */

--( 5 "Who you gonna call?")--
SELECT *
FROM phone_calls
WHERE year = 2020 AND day = 28 AND month = 7 
AND duration < 60;

/* Accodring to witness statements the perp called their assistant to get them to 
book a flight ticket and the call was less than 1 minute so we check for the date 
and duration. 

There were about <10 calls that meet those qualifications. But only one
that matched our sus list. 

NEW INFO: Suspect Roger Nolastname called the number (996) 555-8899 for 51 seconds
during the suspecious time period. 

TO DO: 
1) Chk who Roger called
2) Chk AtM transactions
3) Chk flights leaving early 7/29 
*/
--( 6 "Captain Jack the Accomplice (probably)")
SELECT *
FROM people
WHERE phone_number = "(996) 555-8899";

/*
NEW INFO: Running the # Roger called into the system we get Jack. But we cant be sure yet
too much circumstancial evidence. We need to dig deeper. If Roger made a money transfer that went to Jack right
befor Eugene arrived at the bank then its him.

TO DO: 
1) Chk ATM transactions. 
2) Chk flight ticket purchases by Jack with Rogers passport number. 

*/

--( 7 "a dead end")
SELECT atm_transactions.transaction_type,people.id
FROM atm_transactions
JOIN bank_accounts
ON bank_accounts.account_number = atm_transactions.account_number
JOIN people
ON people.id = bank_accounts.person_id
WHERE people.id = 398010;

/*Following the cookie trail we check to see if someone with Roger's ID withdrew 
money from the ATM on the day of the crime as per witness accounts. Close-- but no
cigar. It seems he doesnt even have a bank account. Now we are back to square one--
or are we? */

--( 8 RESTART)
--If it wasn"t Roger and Jack, then who in the heck-?
SELECT *  
FROM courthouse_security_logs
WHERE month = 7 AND day = 28 AND hour = 10 AND minute >= 15 AND minute <= 25; 



/* I most likely messed up by narrowing down the arrival time of the perp. 
Now examining footage for people who left within 10 mins only. This time we leave 
Roger out of the search as he is clear*/

--( 9 "Listing the sus")
SELECT *
FROM people
WHERE license_plate = "5P2BI95" OR license_plate = "94KL13X" OR license_plate = "6P58WS2"
OR license_plate = "4328GD8" OR license_plate = "L93JTIZ" OR license_plate = "322W7JE" OR license_plate = "0NTHK55"
;

/* Listing out once more the people who we got back from trial 8. */

--( 10 "One more call")
SELECT *
FROM phone_calls
WHERE year = 2020 AND day = 28 AND month = 7 
AND duration < 60;

/* Rechecking call-list using phone numbers from trial 9 to see if any of them made
a sus call. Russell, Evelyn and Ernest are our new suspects. */

--
-- (11 "Money money money")
SELECT atm_transactions.transaction_type, people.name
FROM atm_transactions
JOIN bank_accounts
ON bank_accounts.account_number = atm_transactions.account_number
JOIN people
ON people.id = bank_accounts.person_id
WHERE day = 28 AND month = 7 AND atm_location = "Fifer Street" AND people.id = 514354 
OR day = 28 AND month = 7 AND atm_location = "Fifer Street" AND people.id = 560886 
OR day = 28 AND month = 7 AND atm_location = "Fifer Street" AND people.id = 686048
;

/* Using their IDs we check to see if anyone made a withdraw like in the witness 
statement we can narrow it down to 
withdraw | Russell
withdraw | Ernest
TO DO: We need to narrow it down further. How about following the flight lead. */

-- (12 "Run Devil Run")
SELECT hour, minute, flights.id, destination_airport_id
FROM flights
JOIN airports 
ON airports.id = origin_airport_id
WHERE airports.city = "Fiftyville" AND flights.month = 7 AND flights.day = 29
;

/* Here we checked to see what the earliest flight out of 50ville is. 
That would be flight.id 36 departing AT 8:20am for airport Id 4. 

TO DO: 
1) See who got a ticket for this flight
2) see who that person called
3) Check out where airport 4 is
*/

--(13 "Who dunnit")
SELECT people.name, people.id
FROM passengers
JOIN people 
ON passengers.passport_number = people.passport_number
WHERE passengers.flight_id = 36 AND people.passport_number = "3592750733" 
OR passengers.flight_id = 36 AND people.passport_number = "5773159633" 
;

/* Check out of the suspects who is supposed to board flight 36 and get

NEW INFO: MAIN SUSPECT IS ERNEST, I REPEAT MAIN SUSPECT IS ERNEST. 
TO DO : See who Earnest called and where his flight is headed */

--(14 "And who helped?")

SELECT name, id
FROM people
WHERE phone_number = "(375) 555-8161";

/* find who ernest called--- his accomplice berthold 

NEW INFO:
Accomplice found-
name | id
Berthold | 864400

TO DO: 
Name of airport fled to */

--(15 "Off to Scotland Yard with ya' lot")
SELECT * 
FROM airports
WHERE id = 4

/*
NEW INFO 
id | abbreviation | full_name | city
4 | LHR | Heathrow Airport | London

He fled to Heathrow Airport in London. We'll have to contact our friends over at
Scotland yard and ask them to do the honors in arresting this fiend. Maybe they can
tell him stealing ducks isnt how you earn an Ernest living, not in the UK or US. 

:) */



