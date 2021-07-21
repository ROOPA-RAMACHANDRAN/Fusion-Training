

DOO_HEADERS_ALL
=====================
- ORDER_NUMBER
- ORDERED_DATE
- CUSTOMER_PO_NUMBER
- TRANSACTIONAL_CURRENCY_CODE
- SHIPPING_INSTRUCTIONS


DOO_LINES_ALL
=====================

- LINE_NUMBER
- ORDERED_QTY
- ORDERED_UOM
- UNIT_LIST_PRICE
- UNIT_SELLING_PRICE
- SCHEDULE_SHIP_DATE

INV_ORG_PARAMETERS
===================
ORGANIZATION_CODE

HZ_CUST_ACCOUNTS
====================
- ACCOUNT_NUMBER

HZ_PARTIES
=================
- PARTY_NAME

RA_TERMS_TL
==================
- NAME

HZ_CUST_SITE_USES_ALL
=====================
- LOCATION
QP_PRICE_LISTS_TL
====================
- NAME


DOO_FULFILL_LINES_ALL
=======================
- HEADER_ID
- LINE_ID
- INVENTORY_ITEM_ID
- BILL_TO_CUSTOMER_ID
- PRODUCT_TYPE
- ORG_ID       ---------------------------DOO_FULFILL_LINES_ALL	doo_lines_all	LINE_ID

DOO_ORDER_PRICING_DETAILS_V
===========================
- HEADER_ID
- LEGAL_ENTITY_ID
- ORDER_NUMBER
- ORG_ID
- LINE_ID
- LINE_NUMBER

QP_PRICE_LIST_ITEMS
==========================
- QP_PRICE_LIST_ITEMS	      qp_price_lists_all_b	PRICE_LIST_ID
- qp_price_list_covered_items	 qp_price_list_items	PRICE_LIST_ITEM_ID


WSH_DELIVERY_DETAILS
==========================
- ORGANIZATION_ID
- ORG_ID
- UNIT_PRICE      ----------------WSH_DELIVERY_DETAILS	      hz_parties	SHIP_TO_PARTY_ID
		        ----------------WSH_DELIVERY_DETAILS	      hz_parties	SOLD_TO_PARTY_ID
WSH_DELIVERY_ASSIGNMENTS
===========================
- DELIVERY_ID     ----------------wsh_delivery_assignments	   wsh_delivery_details	DELIVERY_DETAIL_ID,DELIVERY_ID
                ----------------wsh_delivery_assignments	    wsh_delivery_details	PARENT_DELIVERY_DETAIL_ID

WSH_NEW_DELIVERIES
======================			
- DELIVERY_ID
- DELIVERY_NAME
- BILL_FREIGHT_TO
- CONFIRM_DATE  ----------------WSH_NEW_DELIVERIES	hz_parties	SHIP_TO_PARTY_ID
              ----------------wsh_delivery_assignments	wsh_new_deliveries	DELIVERY_ID
              ---------------- wsh_delivery_assignments	wsh_new_deliveries	PARENT_DELIVERY_ID
			  
WSH_CARRIERS
===================
- CARRIER_ID
- JOB_DEFINITION_NAME
- REQUEST_ID-----------WSH_CARRIERS	hz_parties	CARRIER_ID			  
							  WSH_NEW_DELIVERIES	hz_parties	SOLD_TO_PARTY_ID
							  
							  
							  
HZ_PARTIES
==================
- PARTY_ID
- PARTY_NUMBER
- PARTY_NAME
- PARTY_TYPE
- REQUEST_ID
- COUNTRY
- ADDRESS1
- CITY
- POSTAL_CODE	
- EMAIL_ADDRESS
				  

SELECT 
IOP.ORGANIZATION_CODE "Organization Code",
DHA.ORDER_NUMBER "Order Number",
HCA.ACCOUNT_NUMBER "Customer Number",
HP.PARTY_NAME "Order Sold To",
DHA.CUSTOMER_PO_NUMBER "Customer PO Number",
DHA.ORDERED_DATE "Ordered Date",
QPLT.NAME "Price List Name",
DHA.TRANSACTIONAL_CURRENCY_CODE "Transactional Curr Code",
RTT.NAME "Payment Terms",
DLA.LINE_NUMBER "Line Number",
DLA.ORDERED_QTY "Ordered Quantity",
DLA.ORDERED_UOM "Order Quantity UOM",
DLA.UNIT_SELLING_PRICE "Unit Selling Price",
DLA.UNIT_LIST_PRICE "Unit List Price",
HCSA.LOCATION "Ship To",
HCSA.LOCATION "Bill To",
DLA.SCHEDULE_SHIP_DATE "Schedule Ship Date",
DHA.SHIPPING_INSTRUCTIONS "Shipping Instructions"

FROM
DOO_HEADERS_ALL DHA,
DOO_LINES_ALL DLA,
HZ_CUST_ACCOUNTS HCA,
INV_ORG_PARAMETERS IOP,
HZ_PARTIES HP,
HZ_CUST_SITE_USES_ALL HCSA,
RA_TERMS_TL RTT,
QP_PRICE_LISTS_TL QPLT

WHERE
DHA.HEADER_ID=DLA.HEADER_ID
AND
DHA.SOLD_TO_CUSTOMER_ID=HCA.CUST_ACCOUNT_ID
AND
DHA.SOLD_TO_PARTY_ID=HP.PARTY_ID
AND
DHA.SOLD_TO_PARTY_ID=HCA.PARTY_ID
AND
DHA.ORG_ID=IOP.ORGANIZATION_ID
AND



