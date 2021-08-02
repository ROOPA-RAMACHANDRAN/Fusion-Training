

                          
SELECT 
HAOU.NAME AS "Business Unit",
HP.PARTY_NAME AS "Supplier",
PS.SEGMENT1 AS "Supplier Number",
HPS.PARTY_SITE_NAME AS "Site",
HP.CITY||','||HP.STATE||','||HP.COUNTRY AS "Site Address",
AIA.INVOICE_NUM AS "Invoice Number",
TO_CHAR(AIA.INVOICE_DATE, 'DD-MM-YYYY') AS "Invoice Date", 
AIA.INVOICE_TYPE_LOOKUP_CODE AS "Invoice Type",
TO_CHAR(AIA.GL_DATE, 'DD-MM-YYYY') AS "Ledger Date",
TO_CHAR(APSA.DUE_DATE, 'DD-MM-YYYY') AS "Due Date",
AIA.INVOICE_AMOUNT AS "Invoice Amount",
(AIA.INVOICE_AMOUNT - APSA.AMOUNT_REMAINING) AS "Amount Paid",
APSA.AMOUNT_REMAINING AS Balance_amount,
TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') ) AS Past_due_days,
CASE WHEN TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )>= -999 AND
TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )<0
THEN APSA.AMOUNT_REMAINING ELSE 0 END "Current Bucket",
CASE WHEN TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') ) >= 0 AND
TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )<= 30
THEN APSA.AMOUNT_REMAINING ELSE 0 END "0 to 30 Days",
CASE WHEN TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )>= 31 AND
TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )<= 60
THEN APSA.AMOUNT_REMAINING ELSE 0
END "31 to 60 Days",
CASE WHEN TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )>= 61 AND
TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )<= 90
THEN APSA.AMOUNT_REMAINING ELSE 0
END "61 to 90 Days",
CASE WHEN TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )>= 91 AND
TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )<= 120
THEN APSA.AMOUNT_REMAINING ELSE 0
END "91 to 120 Days",
CASE WHEN TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )>= 121 AND
TO_DATE(TO_CHAR(:AS_OF_DATE,'YYYY-MM-DD')) -   TO_DATE(TO_CHAR(APSA.DUE_DATE,'YYYY-MM-DD') )<= 999999
THEN APSA.AMOUNT_REMAINING ELSE 0
END "More than 120 Days"

--tables
FROM
HR_ALL_ORGANIZATION_UNITS HAOU,
HZ_PARTIES HP,
HZ_PARTY_SITES HPS,
POZ_SUPPLIERS PS,
AP_INVOICES_ALL AIA,
AP_PAYMENT_SCHEDULES_ALL APSA

--joins
WHERE 1=1
AND AIA.ORG_ID = HAOU.ORGANIZATION_ID(+)
AND AIA.PARTY_ID = HP.PARTY_ID(+)
AND AIA.PARTY_SITE_ID = HPS.PARTY_SITE_ID(+)
AND AIA.VENDOR_ID = PS.VENDOR_ID(+)
AND AIA.INVOICE_ID = APSA.INVOICE_ID(+)
AND HAOU.NAME = NVL(:BUSINESS_UNIT,HAOU.NAME)
AND AIA.GL_DATE <= :AS_OF_DATE
AND AIA.INVOICE_TYPE_LOOKUP_CODE = NVL(:INVOICE_TYPE,AIA.INVOICE_TYPE_LOOKUP_CODE)
AND AIA.INVOICE_AMOUNT > :MINIMUM_AMOUNT
AND AIA.INVOICE_AMOUNT < :MAXIMUM_AMOUNT

--conditions
AND APSA.AMOUNT_REMAINING != AIA.INVOICE_AMOUNT
AND APSA.AMOUNT_REMAINING > 0



Invoice date
=============
04-03-2020
15-07-2018
01-06-2018
15-02-2018
15-04-2018
29-01-2016
13-08-2018
	

AP_PAYMENT_SCHEDULES_ALL
DUE_DATE
AMOUNT_REMAINING  (ORG_ID,INVOICE_ID)
PAYMENT_CROSS_DATE

AP_INVOICES_ALL 
GL_DATE,
INVOICE_NUM,
INVOICE_DATE,
INVOICE_TYPE_LOOKUP_CODE AS INVOICE_TYPE,
EXCHANGE_RATE
PARTY_ID,
PARTY_SITE_ID

--AP_SUPPLIER_SITES_aLL
--AP_SUPPLIERS 

HZ_PARTIES
PARTY_ID,
PARTY_NAME,
PARTY_NUMBER,
PARTY_SITE_NUMBER,
CITY
STATE

HZ_PARTY_SITES
PARTY_SITE_ID
PARTY_SITE_NUMBER

HR_OPERATING_UNITS
NAME

SELECT 
HAOU.NAME AS "Business Unit"














 
(CEIL (SYSDATE - ps.due_date)) past_due_days,



    

SELECT   org_name,

              vendor_name,

              vendor_number,

              vendor_site_details,

              invoice_number,

              invoice_date,

              gl_Date,

              invoice_type,

              due_date,

              past_due_days,

              amount_remaining,

              CASE

                 WHEN past_due_days >= -999 AND past_due_days < 0

                 THEN

                  amount_remaining

                 ELSE

                    0

              END

                 CURRENT_BUCKET,

              CASE

                 WHEN past_due_days >= 0 AND past_due_days <= 30

                 THEN

                  amount_remaining

                 ELSE

                    0

              END

                 "0 to 30",

              CASE

                 WHEN past_due_days > 30 AND past_due_days <= 60

                 THEN

                  amount_remaining

                 ELSE

                    0

              END

                  "31 to 60",

              CASE

                 WHEN past_due_days > 60 AND past_due_days <= 90

                 THEN

                amount_remaining

                 ELSE

                    0

              END

                  "61 to 90",

              CASE

                 WHEN past_due_days > 90 AND past_due_days <= 120

                 THEN

                 amount_remaining

                 ELSE

                    0

              END

                   "61 to 120",

              CASE

                 WHEN past_due_days > 120 AND past_due_days <= 999999

                 THEN

                 amount_remaining

                 ELSE

                    0

              END

                   " More than 120 Days"

       FROM   (SELECT   hou.name org_name,

                        pv.vendor_name vendor_name,

                        pv.segment1 vendor_number,

                        pvs.vendor_site_code || ' ' || pvs.city || ' ' || state

                           vendor_site_details,

                        i.invoice_num invoice_number,

                        i.payment_status_flag,

                        i.invoice_type_lookup_code invoice_type,

                        i.invoice_date Invoice_Date,

                        i.gl_date Gl_Date,

                        ps.due_date Due_Date,

                        ps.amount_remaining,

                        (CEIL (SYSDATE - ps.due_date)) past_due_days, -- DAYS_DUE,
DECODE (i.invoice_currency_code,'USD', DECODE (0, 0,ROUND (( (NVL (ps.amount_remaining, 0)/ (NVL (i.payment_cross_rate, 1)))* NVL (i.exchange_rate, 1)),2 ), 
ROUND( ( (NVL (ps.amount_remaining, 0)/ (NVL (i.payment_cross_rate, 1))) * NVL (i.exchange_rate, 1))/ 0)* 0),
DECODE ( i.exchange_rate,NULL,0, DECODE (0,0,ROUND (( (NVL (ps.amount_remaining, 0) / (NVL (ps.payment_cross_rate, 1))) * NVL (i.exchange_rate, 1)),2 ),
ROUND( ( (NVL (ps.amount_remaining, 0)/ (NVL (i.payment_cross_rate, 1)))* NVL (i.exchange_rate, 1))/ 0)* 0))) amt_due_remaining

FROM   ap_payment_schedules_all ps,

                        ap_invoices_all i,

                        ap_suppliers pv,

                        ap_supplier_sites_all pvs,

                        hr_operating_units hou

                WHERE       i.invoice_id = ps.invoice_id

                        AND i.vendor_id = pv.vendor_id

                        AND i.vendor_site_id = pvs.vendor_site_id

                        AND i.org_id = hou.organization_id

                        AND i.cancelled_date IS NULL

                        AND (NVL (ps.amount_remaining, 0)

                             * NVL (i.exchange_rate, 1)) != 0

                        AND i.payment_status_flag IN ('N', 'P')

                           and i.org_id =:p_org_id)

   ORDER BY   vendor_number,Invoice_number
                                        

                                 



                           
                           

                          

 

                            
                             

                                    

                              

                           
                           
                             

                 
 
 