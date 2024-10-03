/*
A. Show all data in each of the tables.
*/

select * from item;
select * from shipment;
select * from shipment_item;

/*
B. List the ShipmentID, ShipperName, and ShipperInvoiceNumber of all shipments.
*/

select ShipmentID, ShipperName, ShipperInvoiceNumber from shipment;

/*
C. List the ShipmentID, ShipperName, and ShipperInvoiceNumber for all shipments that 
have an insured value greater than $10,000.00.
*/

select ShipmentID, ShipperName, ShipperInvoiceNumber from shipment where InsuredValue > 10000;

/*
D. List the ShipmentID, ShipperName, and ShipperInvoiceNumber of all shippers
whose name starts with “AB”.
*/

select ShipmentID, ShipperName, ShipperInvoiceNumber from shipment where ShipperName like "AB%";

/*
E. Assume DepartureDate and ArrivalDate are in the format MM/DD/YY. List the
ShipmentID, ShipperName, ShipperInvoiceNumber, and ArrivalDate of all shipments
that departed in December.
*/

select ShipmentID, ShipperName, ShipperInvoiceNumber, ArrivalDate from shipment where month(DepartureDate) = 12;

/*
F. Assume DepartureDate and ArrivalDate are in the format MM/DD/YY. List the
ShipmentID, ShipperName, ShipperInvoiceNumber, and ArrivalDate of all shipments
that departed on the tenth day of any month.
*/

select ShipmentID, ShipperName, ShipperInvoiceNumber, ArrivalDate from shipment where day(DepartureDate) = 10;

/*
G. Determine the maximum and minimum InsuredValue.
*/

select max(InsuredValue) as maximum, min(InsuredValue) as minimum from shipment;

/*
H. Determine the average InsuredValue.
*/

select avg(InsuredValue) as average from shipment;

/*
I. Count the number of shipments.
*/

select count(*) from shipment;

/*
J. Show ItemID, Description, Store, and a calculated column named
USCurrencyAmount that is equal to LocalCurrencyAmount times the ExchangeRate
for all rows of ITEM.
*/

select ItemID, Description, Store, 
	LocalCurrencyAmount * ExchangeRate as USCurrencyAmount from item;
    
/*
K. Group item purchases by City and Store.
*/

select 
	City, 
	Store, 
	count(*) as NumberOfPurchases, 
	sum(Quantity) as TotalQuantity, 
    sum(LocalCurrencyAmount) as TotalLocalCurrencyAmount 
from item
group by City, Store;

/*
L. Count the number of purchases having each combination of City and Store.
*/

SELECT City, Store, COUNT(*) AS NumberOfPurchases
FROM ITEM
GROUP BY City, Store;

/*
M. Show the ShipperName, ShipmentID and DepartureDate of all shipments that have
an item with a value of $1,000.00 or more. Use a subquery. Present results sorted
by ShipperName in ascending order and then DepartureDate in descending order.
*/

select ShipperName, ShipmentID, DepartureDate from shipment where ShipmentID in (
	select ShipmentID from shipment_item where Value >= 1000
) 
order by ShipperName asc, 
	DepartureDate desc;

/*
N. Show the ShipperName, ShipmentID, and DepartureDate of all shipments that have
an item with a value of $1000.00 or more. Use a join. Present results sorted by
ShipperName in ascending order and then DepartureDate in descending order.
*/

select s.ShipperName, s.ShipmentID, s.DepartureDate from shipment s
	join shipment_item si on s.ShipmentID = si.ShipmentID
where si.Value > 1000
order by s.ShipperName asc, 
	s.DepartureDate desc;

/*
O. Show the ShipperName, ShipmentID, and DepartureDate of the shipments for items
that were purchased in Singapore. Use a subquery. Present results sorted by
ShipperName in ascending order and then DepartureDate in descending order
*/

select s.ShipperName, s.ShipmentID, s.DepartureDate from shipment s
where s.ShipmentID in (
	select ShipmentID from shipment_item where ItemID in (
		select ItemID from item where City = 'Singapore'
	)
)
order by s.ShipperName asc, s.DepartureDate desc;

/*
P. Show the ShipperName, ShipmentID, and DepartureDate of all shipments that have
an item that was purchased in Singapore. Use a join, but do not use JOIN ON
syntax. Present results sorted by ShipperName in ascending order and then
DepartureDate in descending order.
*/

select distinct s.ShipperName, s.ShipmentID, s.DepartureDate 
from shipment_item si, item i, shipment s
	where si.ItemID = i.ItemID
		and s.ShipmentID = si.ShipmentID
		and i.City = 'Singapore'
order by s.ShipperName asc, s.DepartureDate desc;
    
/*
Q. Show the ShipperName, ShipmentID, and DepartureDate of all shipments that have
an item that was purchased in Singapore. Use a join using JOIN ON syntax.
Present results sorted by ShipperName in ascending order and then DepartureDate
in descending order.
*/

select s.ShipperName, s.ShipmentID, s.DepartureDate from shipment_item si
	join item i on si.ItemID = i.ItemID
    join shipment s on s.ShipmentID = si.ShipmentID
where i.City = 'Singapore'
order by s.ShipperName asc, s.DepartureDate desc;

/*
R. Show the ShipperName, ShipmentID, the DepartureDate of the shipment, and Value
for items that were purchased in Singapore. Use a combination of a join and a
subquery. Present results sorted by ShipperName in ascending order and then
DepartureDate in descending order.
*/

select distinct s.ShipperName, s.ShipmentID, s.DepartureDate from shipment_item si
    join shipment s on s.ShipmentID = si.ShipmentID
where si.ItemID in (
	select ItemID from item where City = 'Singapore'
    )
order by s.ShipperName asc, s.DepartureDate desc;

/*
S. Show the ShipperName, ShipmentID, the DepartureDate of the shipment, and Value
for items that were purchased in Singapore. Also show the ShipperName,
ShipmentID, and DepartureDate for all other shipments. Present results sorted by
Value in ascending order, then ShipperName in ascending order, and then
DepartureDate in descending order.
*/

select s.ShipperName, s.ShipmentID, s.DepartureDate, si.Value 
from shipment s
    left join shipment_item si on s.ShipmentID = si.ShipmentID
	left join item i on si.ItemID = i.ItemID and i.City = 'Singapore'
order by si.Value asc, s.ShipperName asc, s.DepartureDate desc;
