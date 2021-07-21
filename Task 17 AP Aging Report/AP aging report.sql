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

                          

SELECT 
HAOU.NAME AS "ORGANIZATION",
HP.PARTY_NAME AS "SUPPLIER",
PS.SEGMENT1 AS "SUPPLIER NUMBER",
HPS.PARTY_SITE_NAME AS "SITE",
HP.CITY||','||HP.STATE||','||HP.COUNTRY AS "SITE ADDRESS",
AIA.INVOICE_NUM AS "INVOICE NUMBER",
TO_CHAR(AIA.INVOICE_DATE, 'DD-MM-YYYY') AS "INVOICE DATE", 
AIA.INVOICE_TYPE_LOOKUP_CODE AS "INVOICE TYPE",
TO_CHAR(AIA.GL_DATE, 'DD-MM-YYYY') AS "LEDGER DATE",
TO_CHAR(APSA.DUE_DATE, 'DD-MM-YYYY') AS "DUE DATE",
AIA.INVOICE_AMOUNT AS "INVOICE AMOUNT",
(AIA.INVOICE_AMOUNT - APSA.AMOUNT_REMAINING) AS "AMOUNT PAID",
APSA.AMOUNT_REMAINING AS BALANCE_AMOUNT,
CEIL (SYSDATE - APSA.DUE_DATE) AS PAST_DUE_DAYS,
CASE WHEN CEIL (SYSDATE - APSA.DUE_DATE) >= -999 AND CEIL (SYSDATE - APSA.DUE_DATE) < 0
THEN APSA.AMOUNT_REMAINING ELSE 0
END "CURRENT BUCKET",
CASE WHEN CEIL (SYSDATE - APSA.DUE_DATE) >= 0 AND CEIL (SYSDATE - APSA.DUE_DATE) <= 30
THEN APSA.AMOUNT_REMAINING ELSE 0
END "0 TO 30 DAYS",
CASE WHEN CEIL (SYSDATE - APSA.DUE_DATE) >= 31 AND CEIL (SYSDATE - APSA.DUE_DATE) <= 60
THEN APSA.AMOUNT_REMAINING ELSE 0
END "31 TO 60 DAYS",
CASE WHEN CEIL (SYSDATE - APSA.DUE_DATE) >= 61 AND CEIL (SYSDATE - APSA.DUE_DATE) <= 90
THEN APSA.AMOUNT_REMAINING ELSE 0
END "61 TO 90 DAYS",
CASE WHEN CEIL (SYSDATE - APSA.DUE_DATE) >= 91 AND CEIL (SYSDATE - APSA.DUE_DATE) <= 120
THEN APSA.AMOUNT_REMAINING ELSE 0
END "91 TO 120 DAYS",
CASE WHEN CEIL (SYSDATE - APSA.DUE_DATE) >= 121 AND CEIL (SYSDATE - APSA.DUE_DATE) <= 999999
THEN APSA.AMOUNT_REMAINING ELSE 0
END "MORE THAN 120 DAYS"

FROM
HR_ALL_ORGANIZATION_UNITS HAOU,
HZ_PARTIES HP,
HZ_PARTY_SITES HPS,
POZ_SUPPLIERS PS,
AP_INVOICES_ALL AIA,
AP_PAYMENT_SCHEDULES_ALL APSA

WHERE 1=1
AND AIA.ORG_ID = HAOU.ORGANIZATION_ID(+)
AND AIA.PARTY_ID = HP.PARTY_ID(+)
AND AIA.PARTY_SITE_ID = HPS.PARTY_SITE_ID(+)
AND AIA.VENDOR_ID = PS.VENDOR_ID(+)
AND AIA.INVOICE_ID = APSA.INVOICE_ID(+)

AND APSA.AMOUNT_REMAINING != AIA.INVOICE_AMOUNT
AND APSA.AMOUNT_REMAINING > 0


	

                                        

                                     




                           
                           

                          

 

                            
                             

                                    

                              

                           
                           
                             

                 
 
 