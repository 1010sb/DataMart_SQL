# DataMart_SQL

#### Database for renting houses, apartments, and rooms
#### renting_db
The major aim of this project was to create a DataMart that would allow users to insert, delete manipulate and retrieve data. The functionality of this DataMart is evolved and applied in Relational Database Management System MySQL. One of the main features of using the MySQL database is that it is freely available and comes with the standard Workbench which make it easy to implement SQL commands, there is no need to install any other software. This makes it easy to add, retrieve and analyze data.
#### The renting_db is based on 3 fundamental roles:
![image](https://user-images.githubusercontent.com/96765388/203049322-a145c51c-381a-49d7-9e05-e0813f55d4d2.png)

1. The host offers their properties for rent.
2. The guest makes reservation and payment.
3. The market as a connection between the host and the guest, where all transections happen like property offering for rent, reservation, payments, cancellation, commission charges etc.
#### Following is the list of all tables:
country, city, property_commission, property_type, neighbourhood, host, property, facility,
room_type, room, amenities, guest_commission, guest, property_review, guest_review,
cancelation, reservation, payment_status, voucher, payment

#### Main challenges:
1. A guest can cancel his reservation without any charges. Problem can occur if there no checking mechanism to validate the condition. This issue is fixed by implementing MySQL CHECK constraint.
CHECK (reservation_date <= free_cancelation_date <= checkin_date < checkout_date)
2. The order of referenced tables is important. For instance, country table must be created before city table, because countryID is foreign key inside city table otherwise error will occur.
3. The data insertion sequence must be in the order of table creation, otherwise an error will occur.

#### Installation:
Download renting_db.sql file on local machine. Make sure MySQL is already installed on machine. From MySQL Workbench click File, Open SQL Scripts, choose “renting_db.sql” file, click “execute” icon to run the script and then click “refresh” button in SCHEMAS.
![image](https://user-images.githubusercontent.com/96765388/203050709-75eab04b-f12b-4784-8a21-7fd9333f17f6.png)
![image](https://user-images.githubusercontent.com/96765388/203050759-554ee00c-c891-4e48-b0d5-99a4aa0936f1.png)

#### Metadata:
Use following SQL command to get metadata information from a specific table.
##### SQL Command:
SELECT table_schema, table_name, column_name, ordinal_position, data_type,
column_key, extra, numeric_precision, column_type, column_default, is_nullable
FROM information_schema.columns
WHERE (table_schema='renting_db' and table_name = 'host')
ORDER BY ordinal_position;
![image](https://user-images.githubusercontent.com/96765388/203051147-76141e36-5dd6-4614-9b8e-479d717e3d23.png)

#### renting_db Functionality:
Data-driven decision-making empowers businesses to create real-time insights and forecasts to improve their performance. Through this, companies can test the success of various strategies and make informed business decisions for sustainable growth. Here are some use cases and functional aspects of renting_db.

##### To verify suspicious payments by the guests
![image](https://user-images.githubusercontent.com/96765388/203051709-68f3b5a4-1831-4d1f-9768-1af3af9a7025.png)

##### To ban a guest who received awful reviews from a host. In this example, guestID #16 received significant terrible reviews from the host. This type of guest should be completely banned from the market to save the image of the whole market.
![image](https://user-images.githubusercontent.com/96765388/203051994-46884d94-0461-44b4-8b0c-2164fd8daa98.png)

###### Filter inactive host where property rating is incredible. Give these types of property host a better commission offer to motivate them to be more active. In this example, propertyID #3 and propertyID #6 have a significantly excellent rating from the guests. This type of property host should be best candidate to get a better commission model to improve the quality of the whole market.
![image](https://user-images.githubusercontent.com/96765388/203051865-ad2694ec-908a-4084-aff2-b018af027258.png)
