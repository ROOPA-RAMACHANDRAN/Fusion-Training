Supplier/PO/AP :

--1.Build a query for Inactive supplier List
SELECT HP.STATUS,PSV.VENDOR_NAME AS SUPPLIER_NAME 
FROM  HZ_PARTIES HP,
POZ_SUPPLIERS_V PSV
WHERE
HP.PARTY_ID=PSV.PARTY_ID
AND
HP.STATUS='I'

--2.Build a query for Supplier List those who are Inactivated during last 2 months
SELECT INACTIVE_DATE
FROM  
POZ_SUPPLIER_SITES_ALL_M

--3.Get the Inactive Supplier Site List
SELECT HPS.STATUS,PSS.PARTY_SITE_NAME AS SITE_NAME 
FROM  HZ_PARTY_SITES HPS,
POZ_SUPPLIER_SITES_V PSS
WHERE
HPS.PARTY_SITE_ID=PSS.PARTY_SITE_ID
AND
HPS.STATUS='I'

--4.Build a Query for the Supplier Type other than ‘SUPPLIER’
SELECT PS.VENDOR_ID AS SUPPLIER_ID, PS.VENDOR_TYPE_LOOKUP_CODE AS SUPPLIER_TYPE,PSV.VENDOR_NAME AS SUPPLIER_NAME  
FROM POZ_SUPPLIERS PS
FULL JOIN
POZ_SUPPLIERS_V PSV
ON
PS.PARTY_ID=PSV.PARTY_ID
WHERE
PS.VENDOR_TYPE_LOOKUP_CODE NOT IN('SUPPLIER')

--5.Build a Query for Suppliers those are not having Supplier Site
SELECT VENDOR_NAME FROM POZ_SUPPLIERS_V
WHERE VENDOR_ID IN
(
SELECT VENDOR_ID FROM
POZ_SUPPLIERS_V
MINUS
SELECT VENDOR_ID FROM
POZ_SUPPLIER_SITES_V
)
--6.Build a Query for Supplier 
SELECT 
PSV.VENDOR_NAME,
PSSV.ADDRESS_LINE1,
PSSV.CITY,
PSSV.STATE,
PSSV.COUNTRY,
PSSV.ZIP
FROM POZ_SUPPLIERS_V PSV,
POZ_SUPPLIER_SITES_V PSSV
WHERE
PSV.VENDOR_ID(+)=PSSV.VENDOR_ID

--7.Write a Query for Supplier and its site List those are assigned to Vision Corporation Business Unit
SELECT HAOU.NAME,
PSV.VENDOR_NAME,
HPS.PARTY_SITE_NAME
FROM POZ_SUPPLIERS_V PSV,
HZ_PARTY_SITES HPS,
HR_ALL_ORGANIZATION_UNITS HAOU
WHERE
PSV.PARTY_ID=HPS.PARTY_ID
AND
HAOU.OBJECT_VERSION_NUMBER=PSV.OBJECT_VERSION_NUMBER
AND 
HAOU.NAME='Vision Corporation'

--8.Write a query for the supplier’s having Purchase order value more than 1000$

SELECT  PSV.VENDOR_NAME,SUM(UNIT_PRICE* QUANTITY)  AS AMOUNT
FROM PO_LINES_ALL PLA
FULL JOIN  PO_HEADERS_ALL PHA ON PLA.PO_HEADER_ID=PHA.PO_HEADER_ID
FULL JOIN POZ_SUPPLIERS_V PSV ON PSV.VENDOR_ID=PHA.VENDOR_ID
GROUP BY PSV.VENDOR_NAME
HAVING SUM(UNIT_PRICE* QUANTITY)>1000

--9.List Supplier and its open PO counts
SELECT DISTINCT VENDOR_NAME,COUNT(DOCUMENT_STATUS) AS OPEN_COUNT FROM POZ_SUPPLIERS_V PSV,
PO_HEADERS_ALL PHA
WHERE PSV.VENDOR_ID=PHA.VENDOR_ID
AND DOCUMENT_STATUS IN ('OPEN')
GROUP BY VENDOR_NAME

10.List of Partially Paid invoices with Supplier Name(Supplier, Business Unit , Invoice Number, Open Invoice Amount)

--11.List the invoices which is having PO details
SELECT DISTINCT INVOICE_NUM, 
PO_HEADER_ID 
FROM AP_INVOICES_ALL 
WHERE PO_HEADER_ID=PO_HEADER_ID

--12.Write the Cancelled AP Invoice List between 1-Jan-2021 to 30-Jun-2021

Customer/OM/AR :

1.       Build a query for Active Customer List

2.       List the Customer those are belongs to Country ‘US’

3.       Build a query for Customer those who are Inactivated during last 6 months

4.       Write a query for active customer Count based on the business Unit.

5.       Build a query for Order count based on its status

6.       Build a query to get the Customer and its AR Invoice count which is based on Sales Order

7.       Build a query to get AR Invoices Due date more than 50 days

8.       Build a query to get the AR Invoice details with the following bucket details

 

Customer Name, Inv Count(0-30days), Inv Count(31-60days), Inv Count(>60days)



9.       List the Incomplete state invoices

10.   List the Customer which is not having Bill to Site.



