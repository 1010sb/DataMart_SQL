DROP DATABASE IF EXISTS renting_db;
CREATE DATABASE IF NOT EXISTS renting_db;
USE renting_db;

DROP TABLE IF EXISTS	
country, city, property_commission, property_type, neighbourhood, host, property, facility, 
room_type, room, amenities, guest_commission, guest, property_review, guest_review, 
cancelation, reservation, payment_status, voucher, payment;

CREATE TABLE voucher 
(
voucherID INTEGER PRIMARY KEY AUTO_INCREMENT,
voucher VARCHAR(20), 
discount DECIMAL(4,2), 
updated_at DATETIME DEFAULT now()  
); 

CREATE TABLE payment_status 
(
payment_statusID INTEGER PRIMARY KEY AUTO_INCREMENT,
payment_status VARCHAR(50),
updated_at DATETIME DEFAULT now()  
);

CREATE TABLE cancelation 
(
cancelationID INTEGER PRIMARY KEY AUTO_INCREMENT,
cancel_charge DECIMAL(5,2), 
updated_at DATETIME DEFAULT now() 
);

CREATE TABLE country 
(
countryID INTEGER PRIMARY KEY AUTO_INCREMENT,
country_name VARCHAR(70) NOT NULL,
updated_at DATETIME DEFAULT now()
);

CREATE TABLE city 
(
cityID INTEGER PRIMARY KEY AUTO_INCREMENT,
countryID INTEGER,
city_name VARCHAR(70) NOT NULL,
FOREIGN KEY (countryID) REFERENCES country (countryID),
updated_at DATETIME DEFAULT now()
);

CREATE TABLE property_commission 
(
property_commissionID INTEGER PRIMARY KEY AUTO_INCREMENT,
property_commission DECIMAL(4,2) NOT NULL,
updated_at DATETIME DEFAULT now()
);

CREATE TABLE property_type 
(
property_typeID INTEGER PRIMARY KEY AUTO_INCREMENT,
property_type VARCHAR(30),
updated_at DATETIME DEFAULT now()
);

CREATE TABLE neighbourhood 
(
neighbourhoodID INTEGER PRIMARY KEY AUTO_INCREMENT,
cityID INTEGER,
neighbourhood_name VARCHAR(30),
FOREIGN KEY (cityID) REFERENCES city (cityID),
updated_at DATETIME DEFAULT now()
);

CREATE TABLE host 
(
hostID INTEGER PRIMARY KEY AUTO_INCREMENT,
firstname VARCHAR(30),
lastname VARCHAR(30),
address VARCHAR(100),
email VARCHAR(30),
phone VARCHAR(20),
password CHAR(8),
member_since DATETIME,
active BOOLEAN,
updated_at DATETIME DEFAULT now() 
);

CREATE TABLE property 
(
propertyID INTEGER PRIMARY KEY AUTO_INCREMENT,
hostID INTEGER,
property_typeID INTEGER,
neighbourhoodID INTEGER,
property_commissionID INTEGER,
property_name VARCHAR(50),
property_address VARCHAR(100),
property_size DECIMAL(8,2),
property_rating INTEGER,
qty_room INTEGER,
FOREIGN KEY (property_commissionID) REFERENCES property_commission (property_commissionID),
FOREIGN KEY (hostID) REFERENCES host (hostID),
FOREIGN KEY (property_typeID) REFERENCES property_type (property_typeID),
FOREIGN KEY (neighbourhoodID) REFERENCES neighbourhood (neighbourhoodID),
updated_at DATETIME DEFAULT now()
);


CREATE TABLE facility 
(
facilityID INTEGER PRIMARY KEY AUTO_INCREMENT,
propertyID INTEGER,
parking BOOLEAN,
pool BOOLEAN,
FOREIGN KEY (propertyID) REFERENCES property (propertyID),
updated_at DATETIME DEFAULT now() 
);

CREATE TABLE room_type 
(
room_typeID INTEGER PRIMARY KEY AUTO_INCREMENT,
room_type INTEGER,
updated_at DATETIME DEFAULT now() 
);

CREATE TABLE room 
(
roomID INTEGER PRIMARY KEY AUTO_INCREMENT,
propertyID INTEGER,
room_typeID INTEGER,
room_name VARCHAR(30),
room_number INTEGER,
room_size INTEGER,
room_rate DECIMAL(6,2),
room_availability BOOLEAN,
FOREIGN KEY (room_typeID) REFERENCES room_type (room_typeID),
FOREIGN KEY (propertyID) REFERENCES property (propertyID),
updated_at DATETIME DEFAULT now() 
);

CREATE TABLE amenities 
(
amenitiesID INTEGER PRIMARY KEY AUTO_INCREMENT,
roomID INTEGER,
WiFi BOOLEAN,
heating BOOLEAN,
TV BOOLEAN,
towel BOOLEAN,
shampoo BOOLEAN,
FOREIGN KEY (roomID) REFERENCES room (roomID),
updated_at DATETIME DEFAULT now() 
);

CREATE TABLE guest_commission(
guest_commissionID INTEGER PRIMARY KEY AUTO_INCREMENT,
guest_commission DECIMAL(4,2),  
updated_at DATETIME DEFAULT now() 
); 

CREATE TABLE guest 
(
guestID INTEGER PRIMARY KEY AUTO_INCREMENT,
guest_commissionID INTEGER,
firstname VARCHAR(30),
lastname VARCHAR(30),
address VARCHAR(100),
email VARCHAR(30),
phone VARCHAR(20),  
password CHAR(8),
member_since DATETIME,
guest_level INTEGER, 
active BOOLEAN, 
guest_rating INTEGER,
FOREIGN KEY (guest_commissionID) REFERENCES guest_commission(guest_commissionID), 
updated_at DATETIME DEFAULT now()
);

CREATE TABLE property_review 
(
property_reviewID INTEGER PRIMARY KEY AUTO_INCREMENT,
propertyID INTEGER,
guestID INTEGER,
service INTEGER,
amenities INTEGER,
location INTEGER,
FOREIGN KEY (guestID) REFERENCES guest (guestID),
FOREIGN KEY (propertyID) REFERENCES property (propertyID),
updated_at DATETIME DEFAULT now()
);

CREATE TABLE guest_review 
(
guest_reviewID INTEGER PRIMARY KEY AUTO_INCREMENT,
hostID INTEGER,
guestID INTEGER,
guest_rate INTEGER,
guest_review TEXT,
FOREIGN KEY (hostID) REFERENCES host (hostID),
FOREIGN KEY (guestID) REFERENCES guest (guestID),
updated_at DATETIME DEFAULT now()
);



CREATE TABLE reservation 
(
reservationID INTEGER PRIMARY KEY AUTO_INCREMENT,
roomID INTEGER, 
guestID INTEGER,
hostID INTEGER,
cancelationID INTEGER, 
reservation_date DATETIME,
checkin_date DATE,
checkout_date DATE,
free_cancelation_date DATE,
FOREIGN KEY (roomID) REFERENCES room (roomID),
FOREIGN KEY (guestID) REFERENCES guest (guestID),
FOREIGN KEY (hostID) REFERENCES host (hostID),
FOREIGN KEY (cancelationID) REFERENCES cancelation (cancelationID),
CHECK (reservation_date <= free_cancelation_date <= checkin_date < checkout_date),
updated_at DATETIME DEFAULT now() 
); 


CREATE TABLE payment 
(
paymentID INTEGER PRIMARY KEY AUTO_INCREMENT,
payment_statusID INTEGER,
reservationID INTEGER, 
voucherID INTEGER,
amount DECIMAL(8,2),
payment_date DATETIME, 
FOREIGN KEY (payment_statusID) REFERENCES payment_status (payment_statusID),
FOREIGN KEY (reservationID) REFERENCES reservation (reservationID),
FOREIGN KEY (voucherID) REFERENCES voucher (voucherID),
updated_at DATETIME DEFAULT now()  
); 

#1: inserting 20 voucher data into voucher table
# Minimum discount is 5 % and maximum can be 40%
INSERT INTO voucher (voucher, discount) 
VALUES
('M_JAN', 0.05), ('M_FEB', 0.07),('M_MAR', 0.1),('M_APR', 0.12),('M_MAI', 0.13),('M_JUN', 0.14),
('M_JUL2', 0.15),('M_AUG', 0.17),('M_SEP', 0.18),('M_OCT', 0.19),('M_NOV', 0.20), ('M_DEC', 0.21),
('WINT', 0.22),('SPRNG', 0.23),('AUTM', 0.24),('SUMM', 0.25), ('SPEC1', 0.30),('SPEC2', 0.32),
('VIP1', 0.35),('VIP2', 0.40); 

#2: inserting 20 different payment status into payment_status table
INSERT INTO payment_status (payment_status)
VALUES
('In Process'),('Problem in Payment Processing'),('Payment on Hold'),('Card Issue'),('Further Processing Required'),
('Transectional Issue'),('Paid'),('Host Side On Hold'),('Send to Host'),('Processing Problem with Host'),
('Paid to Host'),('Sucessfull'),('Transaction Completed'),('Doughtfull'),('Authority Issue'),
('Fraud'),('Received complaint from Host'),('False Payment '),('Extra Payment'),('Return to Guest');

#3: inserting 20 countries name into countray table
INSERT INTO country(country_name) VALUES ('Germany'), ('Hong Kong'),('Switzerland'),('United Kingdom'),('Thailand'),
('Singapore'),('France'), ('United Arab Emirates'),('United States'),('Malaysia'),('Turkey'),('India'),
('China'),('Italy'),('Japan'),('Netherlands'),('Spain'),('Austria'),('Canada'),('South Africa');
 
 #4: inserting 20 differernt cities with country ids into city table
 INSERT INTO city(countryID, city_name) VALUES (1,'Berlin'),(3,'Geneva'), (4,'Manchester'),
(4,'London'),(5,'Bangkok'),(5,'Chiang Mai'),(7,'Paris'),(8,'Dubai'),(9,'New York'),(9,'Washington DC'),(10, 'Kuala Lumpur'),
(11,'Istanbul'),(11,'Antalya'),(12,'Mumbai'),(13,'Beijing'),(14,'Rom'),(15,'Tokyo'),(16,'Amsterdam'),(19,'Toronto'),
(20,'Cap Town');

#5: inserting 20 different commision rate into property_commission table
# Minimum property commision is 5 % and maximum can be 24%
INSERT INTO property_commission(property_commission) VALUES (0.05),(0.06),(0.07),
(0.08),(0.09),(0.1),(0.11),(0.12),(0.13),(0.14),(0.15),(0.16),(0.17),(0.18),(0.19),(0.2),(0.21),(0.22),(0.23),(0.24);

#6: inserting 20 different type of properties into property_type table, types are obtained from internet search
INSERT INTO property_type(property_type) VALUES ('Apartment'),('Serviced Apartment'), ('Hause'), ('Guest House') , ('Town House'),
('Bed and Breakfast'), ('Bungalow'),('Guest Suite'), ('Hostel Accommodation'), ('Chalet'), ('Loft'), ('Villa'), ('Hotel'), 
('Boutique Hotel'), ('Resort'), ('Cabin'),('Cottage'), ('Motel'), ('Camper'), ('Boat');

#7: inserting neighbourhood name according to cities in city table
INSERT INTO neighbourhood (cityID, neighbourhood_name) VALUES (1,'Reuterkiez'),(2,'Eaux-Vives'),(3,'Old Trafford'),(4,'Hampstead'),
(5,'Ekamai'),(6,'Night Bazaar'),(7,'Le Marais'),(8,'Deira'),(9,'Manhattan'),(10,'Brookland'),(11,'Ampang'),(12,'Galata'),
(13,'Kaleici'),(14,'Bandra'),(15,'Sanlitun'),(6,'Monti'),(17,'Asakusa'),(18,'Westerpark'),(19,'Alexandra Park'),(20,'Clifton');

#8: inserting 21 dummy host data into host table
# Dummy data were generated with python Faker packege
INSERT INTO host (
firstname, lastname, address, email, phone, password, member_since, active) 
VALUES 
('Cameron', 'Morgan' , '20453 Ellis Courts Apt. 579 Port Erintown, FM 51464' , 'suebennett@example.org' , '164-495559129', '*******' , '2014-09-25', TRUE),
('Kelly', 'Day' , '81795 Braun Keys Wangtown, SC 89066' , 'scott97@example.net' , '+1-90895285', '*******' , '2011-07-06', FALSE),
('Tammy' ,'Buckley' , '773 Castaneda Vill eLake Ashley, TX 47646' , 'john78@example.com' , '+1-974201134' ,'*******' , '2016-11-12', FALSE),
('Ricky' ,'Turner' , '37208 Derrick Plaza Suite 111 Waynefort, KS 05056' , 'stewartnathaniel@example.org' , '001-356277998' ,'*******' , '2017-06-04', TRUE),
('Christopher' ,'Rice' , '221 Curtis Spurs West Brian, CA 67503' , 'vpetersen@example.net' , '+1-9402728' ,'******' , '2012-05-17', TRUE),
('Adam' , 'Bond' , '573 Larry Lakes Whitestad, MO 32213' , 'alejandra21@example.com' , '3719136212' ,'******' , '2015-05-16', FALSE),
('Dawn', 'Fox' , '8313 Robert Inlet Hardyfort, WA 64017' , 'josephwaters@example.com' , '+1-9350-5493' ,'******' , '2017-03-21', TRUE),
('Vincent', 'Brown' , '30383 Lopez Drives Suite 758 South Tiffanyburgh, SC 35461' , 'david94@example.net' , '1739625074' ,'******' , '2015-06-07', TRUE),
('Christine' , 'Simmons' , 'Unit 1277 Box 0354 DPO AP 76175' , 'morrisjeffrey@example.net' , '622848663' ,'******' , '2012-10-23' , TRUE ),
('Deborah' , 'Olsen' , '35513 Villanueva Bypass New Christopherville, ND 71465' , 'oscarjackson@example.com' , '+1-808-9335' , '******' , '2011-08-07', TRUE),
('Christopher' , 'Sanders' , '3711 Erin Expressway Jasonville, MO 72795' , 'angela53@example.net' , '001-3920652590' , '******' , '2018-05-21', TRUE),
('Kenneth' , 'Martin' , '099 John Fort Apt. 618 East Evelyn, FL 43571' , 'kevin81@example.net' , '+1-740092214' , '******' , '2020-12-02' , TRUE),
('James' , 'Ramirez' , '48560 Andrew Square Suite 347 Dawsonville, WV 83857' , 'mary69@example.com' , '049-274-9741' , '******' , '2019-05-20' , TRUE),
('Crystal' , 'Reid' , '94097 Peters Mill Suite 962 Gambletown, ID 71366' , 'knightsteven@example.org' , '670 034280' , '******' , '2017-05-11', TRUE),
('Chelsea' , 'Thornton' , '533 Jasmine Highway Port Manuelstad, KY 83666' , 'adrian02@example.net' , '533-2981080' , '******' , '2015-12-28', TRUE),
('Garrett' , 'Harper' , '69146 Bowman Isle Suite 318 Masonstad, MO 00896' , 'andrew86@example.net' , '7799569614' , '******' , '2012-07-21', FALSE),
('Andrew' , 'Sanchez' , '1573 Oneal Terrace Apt. 828 West David, VA 58564' , 'tyler67@example.org' , '001-6-8069679' , '******' , '2019-01-02' , TRUE),
('Maria' , 'Fernandez' , '26691 Jonathan Terrace Suite 680 South Daryl, LA 49043' , 'sanderslori@example.org' , '+1-84807247' , '******' , '2013-03-29', TRUE),
('Katelyn' , 'Johnson' , '2452 Griffin Stravenue North Haroldland, WY 73487' , 'rachel73@example.com' , '001-594-072-77277202' , '******' , '2013-08-07' , TRUE),
('Cory' , 'Cross' , '1474 Martin Unions North Bradleyport, TX 02504' , 'timothybrown@example.org' , '7855273321' , '******' , '2018-08-04' , TRUE),
('David' , 'Santiago' , '30593 Kevin Mountain Lake Tamaraview, NE 03515' , 'casemadeline@example.org' , '159-822-08332817' , '******' , '2021-07-21' , TRUE);

#9: defining cancelation charges and inster into cancelation table
# if guest cancel the reservation with free_cancelation_date period there is no chareges or 0 charges
# 1 mean guest will be charged full amount because there is no cancelation possible any more.
INSERT INTO cancelation (cancel_charge) 
VALUES 
(0),(0.05),(0.1),(0.15),(0.20),(0.25),(0.30),(0.4),(0.45),(0.5),
(0.55),(0.6),(0.65),(0.7),(0.75),(0.8),(0.85),(0.9),(0.95),(1); 

#10: introducing guest commision rate which market will charge to guest
# minumum will be 5% and maximum can be 24%
INSERT INTO guest_commission(guest_commission) VALUES 
(0.05),(0.06),(0.07),(0.08),(0.09),(0.1),(0.11),(0.12),(0.13),(0.14),
(0.15),(0.16),(0.17),(0.18),(0.19),(0.2), (0.21),(0.22),(0.23),(0.24);

#11: inserting data into property table
# property name are taken from internet search https://bnbfacts.com/the-most-overused-adjectives-in-airbnb-listing-names/
# property addresses are dummy and according to neighbourhood
INSERT INTO property 
(hostID, property_typeID, neighbourhoodID, property_commissionID, property_name, property_address, property_size, property_rating, qty_room) 
VALUES 
(1,11,20,8,'Black Lake Cabin','Main Road Clifton',100,5,3),
(2,7,18,11,'Radcliff Refuge','Street Westerpark',150,4,10),
(3,16,16,4,'Rockaway beach Villa','Side Road Monti',200,5,15),
(4,9,14,8,'The Red Bungalow of Deerfield','Bandra Road',500,4,20),
(5,10,12,11,'The Retreat On Lansdale','Galata Tower',250,4,15),
(6,20,10,8,'The Inn at Shorewood Township','Down Town Brookland',350,5,25),
(7,15,8,8,'Chez Christopher’s','Souk Deira',600,4,50),
(8,2,6,8,'Danielle’s Boutique Inn','Mian Street Night Bazaar',400,2,15),
(9,11,4,4,'The Easy in Brooklyn','High Street Hampstead',500,2,35),
(10,17,2,11,'The Tired Traveler Inn','North Street Eaux-Vives',200,1,40),
(11,18,20,11,'The Darling North Sanctuary', 'South Road Clifton',150,4,10),
(12,13,18,4,'The Brooklyn Penthouse','Main Street Westerpark',400,2,50),
(13,8,16,8,'East Shore Hideaway','West area Road Monti',150,3,7),
(14,9,14,8,'Chinatown Artist Loft','Chau Chupati Bandra',70,2,3),
(15,12,12,8,'The Sunset','Taksim Square Galata',270,3,15),
(16,4,10,11,'The Iconic Allen Street Clubhouse','West Block Brookland',1500,2,110),
(17,16,8,11,'The Little Diamond','Old Bazar Deira',700,4,30),
(18,20,6,11,'Williamsburg Abode','Town Night Bazaar',1000,4,50),
(19,10,4,11,'The Home Away from Home','Noth Street Hampstead',500,5,20),
(20,1,2,8,'Maui Beach Retreat','Upper Mall Eaux-Vives',600,4,20);

#12: insterting facility availibity data according to the property
INSERT INTO facility (propertyID, parking, pool) 
VALUES 
(1,FALSE, TRUE),(2,TRUE, TRUE),(3,FALSE, FALSE),(4,FALSE, FALSE),(5,TRUE, FALSE),
(6,FALSE, TRUE),(7,TRUE, FALSE),(8,FALSE, FALSE),(9,TRUE, FALSE),(10,FALSE, FALSE),
(11,FALSE, FALSE),(12,TRUE, TRUE),(13,TRUE, TRUE),(14,FALSE, TRUE),(15,FALSE, FALSE),
(16,TRUE, TRUE),(17,FALSE, FALSE),(18,FALSE, TRUE),(19,FALSE, FALSE),(20,FALSE, TRUE);

#13: insterting room type 
INSERT INTO room_type(room_type) 
VALUES 
(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),
(18),(19),(20),(21),(22),(23),(24),(25),(26),(27);


#14: inserting 21 dummy guest data into host table
# Dummy data were generated with python Faker packege
INSERT INTO guest 
(guest_commissionID, firstname, lastname, address, email, phone, password, member_since, guest_level, active, guest_rating) 
VALUES 
(1,'Philip', 'Russell' , '5236 Jackson Tunnel Suite 931 Castrochester, UT 19864' , 'carlosbutler@example.net' , '679907-1515' , '******' , '2018-01-31',2, TRUE, 2),
(1, 'Rebecca', 'White' , '20239 Sean Trace Mayoshire, MI 48319' , 'thopkins@example.org' , '594-665365321' , '******' , '2012-04-12', 1 , TRUE , 5),
(2, 'Ryan' , 'Bernard' , '3192 Waters Drive Michaelmouth, WY 32710' , 'yowens@example.net' , '419-705-6170' , '******' , '2020-05-10' , 3 , FALSE , 3),
(3, 'Jennifer' , 'Gillespie' , '60005 Medina Trail Suite 971 Saraton, VA 28199' , 'james14@example.org' , '235-0253977' , '******' , '2018-01-08' , 1 , TRUE , 4),
(4, 'Jennifer' , 'Gillespie' , '60005 Medina Trail Suite 971 Saraton, VA 28199' , 'james14@example.org' , '235-0253977' , '******' , '2018-01-08' , 3 , FALSE , 5),
(1, 'Colleen' , 'Davidson' , '5224 Williams View Port Mark, CA 12587' , 'emilydelacruz@example.net' , '8430177804' , '******' , '2016-03-24' , 1 , TRUE , 5),
(2, 'Michael' , 'Smith' , '4831 Thompson Park Apt. 505 Mirandaton, VT 31718' , 'beverlylewis@example.net' , '001-791016146' , '******' , '2015-07-17' , 1 , FALSE , 4),
(2, 'Tyler' , 'Stephens' , '5867 Emily Isle Apt. 740 Davilaland, NH 32600' , 'curryryan@example.org' , '+1-5483584' , '******' , '2012-10-25' , 2 , TRUE , 5),
(3, 'Scott' , 'Freeman' , '6103 Davis Terrace Suite 508 Perezton, WV 75387' , 'fjordan@example.org' , '907-9296595' , '******' , '2021-03-23' , 2 , TRUE , 4),
(3, 'Kathleen' , 'Delgado' , '180 Sean Mountains Nathanhaven, NE 61764' , 'jasongordon@example.org' , '1-563653135' , '******' , '2018-04-12' , 2 , FALSE , 5),
(2, 'Joseph' , 'Merritt' , '946 Stephanie Groves Suite 092 West Kim, MP 46174' , 'thomas52@example.org' , '9628768660' , '******' , '2016-06-06' , 2 , TRUE , 4),
(1, 'Annette' , 'Hayes' , 'USCGC Griffin FPO AP 38020' , 'cole40@example.org' , '004-27802824' , '******' , '2019-07-01' , 2 , TRUE , 4),
(3, 'Candice' , 'Le' , '298 Steven Spurs Apt. 264 Taylorstad, OR 71596' , 'brendajones@example.org' , '1521941219' , '******' , '2018-02-27' , 2 , TRUE , 5),
(3, 'Kenneth' , 'Luna' , 'PSC 1570, Box 3323 APO AE 97715' , 'camachogina@example.net' , '32314303586' , '******' , '2017-04-07' , 1 , FALSE , 4),
(2, 'Yolanda' , 'Burgess' , '82956 Welch Ports Crystalport, MS 65221' , 'brandonwarner@example.com' , '671091-2515' , '******' , '2021-11-22' , 1 , TRUE , 4),
(1, 'Jimmy' , 'Chapman' , '370 Anderson Forges East Kimberly, CA 07003' , 'psantana@example.net' , '323-8771999' , '******' , '2017-08-04' , 2 , TRUE , 5),
(3, 'Timothy' , 'Munoz' , '99632 Roberson Turnpike Apt. 923 Adamhaven, VT 70573' , 'ugolden@example.org' , '004-4020919' , '******' , '2019-12-11' , 1 , TRUE , 2),
(2, 'Vickie' , 'Williams' , '42763 Li Ferry Marymouth, NV 79547' , 'juliecox@example.org' , '284-138-5703' , '******' , '2010-08-29' , 1 , TRUE , 5),
(2, 'Catherine' , 'Rodriguez' , '3259 Silva Rapids Jaredburgh, DE 35978' , 'tgibson@example.org' , '001-21773339' , '******' , '2019-07-12' , 2 , FALSE , 5),
(2, 'Debbie' , 'Mcknight' , '4155 Bailey Fords Suite 769 Cherylchester, MP 92080' , 'kperez@example.com' , '208-9156278' , '******' , '2018-01-14' , 2 , TRUE , 5),
(2, 'Vanessa' , 'Williams' , '197 Timothy Villages Suite 698 Port Derrick, DC 74226' , 'williamsteresa@example.com' , '001-284615460' , '******' , '2012-06-30' , 1 , FALSE , 4);

#15: inserting property review with their propertyID and guestID
INSERT INTO property_review 
(propertyID, guestID, service, amenities, location) 
VALUES 
(1,2,5,5,5), (2,4,5,4,4), (3,6,3,5,3), (4,6,5,5,5), (5,8,4,4,4), (6,10,5,5,4), (7,10,4,4,5), (8,12,3,4,5),(9,10,4,4,5), (10,12,4,5,4), 
(11,14,4,5,4), (12,16,5,5,5), (13,18,4,4,3), (14,18,4,3,5), (15,20,5,4,3), (16,1,4,4,3), (17,3,5,4,3), (18,5,4,2,2),(19,7,2,4,4), (20,9,2,3,5); 

#16: inserting some reviews form host about their hosting experience 
# dummy reviews data were collected from https://www.hostaway.com/airbnb-review-templates/
INSERT INTO guest_review 
(hostID, guestID, guest_rate, guest_review) 
VALUES 
(1,1,5,'It was a pleasure hosting you. You were so thoughtful about everything.'), 
(2,2,5,'Five stars for the 5-star guest. Respectful, clean and organized'), 
(3,3,5,'Excellent guest. Very considerate of our belongings and property.'), 
(4,4,5,'You were very communicative. Straightforward and  polite'),
(5,5,4,'A really nice guest. Left the place neat and tidy'), 
(6,6,4,'Super-friendly and respected the space.'), 
(7,7,5,'It was great to have you back! An exemplary guest as always.'),
(8,8,5,'Fantastic guests. Easy to be around. Respected all the rules.'),
(9,9,5,'I have nothing negative to say about this guest. They left our flat clean and tidy.'),
(10,10,5,'We really enjoyed hosting you. It was such a breeze to deal with you. Highly recommended!'),
(11,11,3,'The guest arrived 3 hours after the check-in time and then complained about there not being anyone to check them in at the time.'), 
(12,12,2,'Didn’t follow the house rules.'),
(13,13,2,'We are very clear about our no smoking policy with even signs displayed prominently in the apartment. The guests chose not to follow this!'),
(14,14,2,'The party included two more people than specified and then complained because we had not made bedding arrangements for the extra guests.'), 
(15,15,2,'Not recommended! We almost lost our vacation rental permit because of all the chaos they caused in the neighborhood.'), 
(16,16,1,'They damaged several belongings and furniture including a burned kettle and a broken chair.'),
(17,17,2,'We had a disappointing experience with this guest party. Empty beer cans left lying everywhere'), 
(18,18,3,'We would have appreciated it if the guest responded in a timely fashion.'),
(19,19,2,'The guest had no respect for others in the shared space. They played music loudly.'),
(20,20,3,'An ok experience');

#17: inserting room name with their propertyID, room_typeID and some further details into room table 
# Room name data was gathered from https://bnbfacts.com/the-most-overused-adjectives-in-airbnb-listing-names/
INSERT INTO 
room (propertyID, room_typeID, room_name, room_number, room_size, room_rate, room_availability) 
VALUES 
(1,1,'Family',10,50,80,TRUE), (2,2,'Single',20,25,40,TRUE),
(3,3,'Double',30,40,55,TRUE), (4,4,'Spacious Large',40,100,150,TRUE),
(5,5,'Big Master Bed',50,70,120,TRUE), (6,6,'Cozy Private Room',60,50,45,TRUE),
(7,7,'Beautiful Loft',70,30,45,TRUE), (8,8,'Private Room',80,20,35,TRUE),
(9,9,'Bright Brooklyn',90,35,65,TRUE), (10,10,'Sunny Room',100,40,65,TRUE),
(11,11,'Bedroom with Massive Balcony',110,50,75,TRUE),(12,12,'Private Basement Studio',120,60,120,FALSE), 
(13,13,'Luxurious Bedroom',130,60,100,TRUE), (14,14,'Amazing Bedroom',140,20,45,TRUE), 
(15,15,'Comfy',150,35,45,TRUE),(16,16,'Adorable',160,50,75,TRUE), 
(17,17,'Modern',170,40,75,TRUE), (18,18,'Historic',180,30,80,TRUE), 
(19,19,'Quiet',190,35,60,FALSE), (20,20,'Bright',200,50,100,FALSE);

#18: inserting reservation data into reservation table
INSERT INTO reservation
(roomID, guestID, hostID, cancelationID, reservation_date, checkin_date, 
checkout_date, free_cancelation_date) 
VALUES 
(1,1,1,5,'2022-09-12', '2022-09-15', '2022-09-19', '2022-09-15'),
(2,3,4,1,'2022-09-13', '2022-10-10', '2022-10-20', '2022-10-08'),
(3,3,5,1,'2022-09-10', '2022-10-11', '2022-10-18', '2022-10-05'),
(4,4,10,2,'2022-09-05', '2022-10-05', '2022-10-20', '2022-10-01'),
(5,5,17,5,'2022-10-05', '2022-10-08', '2022-10-18', '2022-10-03'),
(6,6,11,2,'2022-10-10', '2022-10-21', '2022-10-30', '2022-10-18'),
(7,7,6,1,'2022-09-10', '2022-10-10', '2022-10-30', '2022-10-15'),
(8,8,3,3,'2022-09-25', '2022-10-03', '2022-10-20', '2022-10-01'),
(9,9,7,2,'2022-09-20', '2022-10-20', '2022-10-30', '2022-10-10'),
(10,10,12,1,'2022-09-10', '2022-10-10', '2022-10-30', '2022-10-05'),
(11,11,9,2,'2022-09-20', '2022-10-05', '2022-10-20', '2022-10-01'),
(12,12,10,3,'2022-09-25', '2022-10-05', '2022-10-10', '2022-10-01'),
(13,13,9,2,'2022-09-25', '2022-10-10', '2022-10-25', '2022-10-05'),
(14,14,7,1,'2022-09-20', '2022-10-20', '2022-10-30', '2022-10-10'),
(15,15,19,2,'2022-09-25', '2022-10-20', '2022-10-25', '2022-10-05'),
(16,16,4,1,'2022-09-20', '2022-10-20', '2022-10-30', '2022-10-10'),
(17,17,8,2,'2022-09-25', '2022-10-10', '2022-10-30', '2022-10-05'),
(18,18,7,1,'2022-09-10', '2022-10-10', '2022-10-30', '2022-10-01'),
(19,19,3,1,'2022-09-20', '2022-10-15', '2022-10-25', '2022-10-05'),
(20,20,14,2,'2022-09-25', '2022-10-15', '2022-10-25', '2022-10-05');

#19: adding amenities date into amenities table according to their roomID
INSERT INTO amenities 
(roomID, WiFi, heating, TV, towel, shampoo) 
VALUES 
(1,FALSE, TRUE, TRUE, TRUE, TRUE), (2,FALSE, TRUE, FALSE, TRUE, TRUE),(3,TRUE, FALSE, FALSE, TRUE, TRUE), (4,FALSE, TRUE, TRUE, TRUE, TRUE),
(5,FALSE, TRUE, FALSE, TRUE, TRUE), (6,TRUE, TRUE, TRUE, TRUE, TRUE),(7,TRUE, TRUE, TRUE, TRUE, TRUE), (8,TRUE, TRUE, TRUE, TRUE, FALSE),
(9,TRUE, TRUE, FALSE, FALSE, TRUE), (10,TRUE, TRUE, TRUE, TRUE, TRUE),(11,TRUE, TRUE, TRUE, TRUE, TRUE), (12,TRUE, TRUE, TRUE, TRUE, TRUE),
(13,TRUE, TRUE, TRUE, TRUE, FALSE), (14,TRUE, TRUE, TRUE, TRUE, TRUE),(15,TRUE, FALSE, TRUE, TRUE, TRUE), (16,TRUE, TRUE, TRUE, TRUE, TRUE),
(17,TRUE, TRUE, TRUE, TRUE, FALSE), (18,TRUE, FALSE, TRUE, TRUE, TRUE),(19,TRUE, TRUE, TRUE, TRUE, TRUE), (20,TRUE, TRUE, TRUE, TRUE, TRUE);

#20: inserting payment details according to payment_statusID and reservationID
INSERT INTO payment 
(payment_statusID, reservationID, voucherID, amount, payment_date)
VALUES
(11,1,2,210,'2022-10-20'),(11,2,1,275,'2022-10-15'),(1,3,2,450,'2022-09-15'),(3,4,1,150,'2022-09-25'),
(11,5,2,75,'2022-09-20'), (1,6,2,175,'2022-09-15'),(1,7,2,250,'2022-09-30'),(2,8,2,180,'2022-09-20'),
(1,9,2,210,'2022-10-20'),(2,10,3,45,'2022-10-19'),(4,11,3,80,'2022-10-24'),(11,12,11,40,'2022-10-13'),
(11,13,3,350,'2022-09-12'), (3,14,2,150,'2022-10-12'),(11,15,1,180,'2022-09-17'),(1,16,2,250,'2022-10-20'),
(1,17,2,163,'2022-09-20'), (16,18,1,750,'2022-09-17'),(1,19,3,250,'2022-10-14'),(5,20,1,340,'2022-10-20'); 