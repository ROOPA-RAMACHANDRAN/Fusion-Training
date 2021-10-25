SELECT 
ASSET_NUMBER,
TO_CHAR (INVOICE_DATE,'DD-Mon-YYYY','NLS_DATE_LANGUAGE = AMERICAN')INVOICE_DATE,
INVOICE_NUM,
TRANSFERRED_IN,
TRANSFERRED_OUT,
--INVOICE_DATE_ADD,
-- nvl(COST,0)+nvl(ADJ_COST,0)+nvl(cost_retired,0) AS_ON_CURRENT_YEAR,
DESCRIPTION,
(NVL(TRANSFERRED_IN,0)-NVL(TRANSFERRED_OUT,0)) BALANCE,
INVOICE_AMOUNT COST,


CASE WHEN TO_CHAR (INVOICE_DATE,'YY','NLS_DATE_LANGUAGE = AMERICAN')=(select substr(:p_period_name,5,2) from dual) 
AND TO_CHAR (INVOICE_DATE_ADD,'YY','NLS_DATE_LANGUAGE = AMERICAN') IS NULL THEN TRANSFERRED_IN 
ELSE 0 END AS_ON_CURRENT_YEAR,
                                                                              
CASE WHEN TO_CHAR (INVOICE_DATE,'YY','NLS_DATE_LANGUAGE = AMERICAN') < (select substr(:p_period_name,5,2) from dual)
AND( TO_CHAR (INVOICE_DATE_ADD,'YY','NLS_DATE_LANGUAGE = AMERICAN') >= (select substr(:p_period_name,5,2) from dual) OR
TO_CHAR (INVOICE_DATE_ADD,'YY','NLS_DATE_LANGUAGE = AMERICAN') IS NULL)
THEN TRANSFERRED_IN
END AS_ON_PREVIOUS_YEAR,

CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Jan' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Jan' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END JAN_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Feb' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Feb' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END FEB_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Mar' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Mar' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END MAR_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Apr' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Apr' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END APR_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='May' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='May' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END MAY_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Jun' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Jun' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END JUN_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Jul' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Jul' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END JUL_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Aug' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Aug' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END AUG_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Sep' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Sep' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END SEP_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Oct' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Oct' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END OCT_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Nov' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Nov' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END NOV_21,
 CASE WHEN TO_CHAR (INVOICE_DATE,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Dec' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_IN 
 WHEN TO_CHAR (INVOICE_DATE_ADD,'Mon-YY','NLS_DATE_LANGUAGE = AMERICAN')='Dec' || (select substr(:p_period_name,4,3) from dual)
 then TRANSFERRED_OUT * -1
 END DEC_21
 
 
 

FROM
(SELECT 
DISTINCT FAB.ASSET_NUMBER,
--FDP.PERIOD_NAME,
(
SELECT DISTINCT AIA.INVOICE_NUM
From FA_ASSET_INVOICES FAI,
ap_invoices_all AIA,
ap_invoice_lines_all AILA
where 
FAI.asset_id=fab.asset_id
AND
AIA.INVOICE_ID=AILA.INVOICE_ID
AND
FAI.INVOICE_LINE_NUMBER=AILA.LINE_NUMBER
AND 
FAI.invoice_id=AIA.invoice_id
and AILA.amount<>0
AND AIA.INVOICE_CURRENCY_CODE='SGD'
AND
ROWNUM=1
) INVOICE_NUM,
(
SELECT SUM(AILA.AMOUNT)
From FA_ASSET_INVOICES FAI,
ap_invoices_all AIA,
ap_invoice_lines_all AILA
where 
FAI.asset_id=fab.asset_id
AND
AIA.INVOICE_ID=AILA.INVOICE_ID
AND
FAI.INVOICE_LINE_NUMBER=AILA.LINE_NUMBER
AND 
FAI.invoice_id=AIA.invoice_id
and AILA.amount<>0
AND AIA.INVOICE_CURRENCY_CODE='SGD'
) INVOICE_AMOUNT,

(SELECT 
TH.TRANSACTION_DATE_ENTERED
FROM
FA_TRANSACTION_HEADERS TH,
FA_BOOKS B
WHERE
TH.ASSET_ID=FAB.ASSET_ID
AND
B.TRANSACTION_HEADER_ID_IN=TH.TRANSACTION_HEADER_ID
AND 
TH.TRANSACTION_TYPE_CODE='CIP ADDITION' 
AND ROWNUM=1)INVOICE_DATE,

(SELECT 
TH.TRANSACTION_DATE_ENTERED
FROM
FA_TRANSACTION_HEADERS TH,
FA_BOOKS B
WHERE
TH.ASSET_ID=FAB.ASSET_ID
AND
B.TRANSACTION_HEADER_ID_IN=TH.TRANSACTION_HEADER_ID
AND 
TH.TRANSACTION_TYPE_CODE='ADDITION' 
AND ROWNUM=1)INVOICE_DATE_ADD,

(SELECT 
B.COST
FROM
FA_TRANSACTION_HEADERS TH,
FA_BOOKS B
WHERE
TH.ASSET_ID=FAB.ASSET_ID
AND
B.TRANSACTION_HEADER_ID_IN=TH.TRANSACTION_HEADER_ID
AND 
TH.TRANSACTION_TYPE_CODE='CIP ADDITION' 
)TRANSFERRED_IN,

(SELECT 
CASE WHEN H.TRANSACTION_TYPE_CODE = 'ADDITION' THEN A.COST END COST
FROM
FA_TRANSACTION_HEADERS H,
FA_BOOKS A
WHERE
H.ASSET_ID=FAB.ASSET_ID
AND
A.TRANSACTION_HEADER_ID_IN=H.TRANSACTION_HEADER_ID
AND 
H.TRANSACTION_TYPE_CODE IN ('ADDITION')
AND ROWNUM=1
)TRANSFERRED_OUT,
-- ADJ.ADJ_COST,
-- ret.cost_retired,
FATL.DESCRIPTION,
FB.COST
FROM
FA_ADDITIONS_B FAB,
FA_CATEGORIES_B FCB,
FA_ADDITIONS_TL FATL,
--FA_DEPRN_DETAIL FDD ,
--FA_DEPRN_PERIODS FDP,
--FA_TRANSACTION_HEADERS FTH,
FA_BOOKS FB
-- (select asset_number, a.ASSET_ID,
-- sum(decode(DEBIT_CREDIT_FLAG,'CR',-nvl(ADJUSTMENT_AMOUNT,0),nvl(ADJUSTMENT_AMOUNT,0))) ADJ_COST 
-- From FA_ADJUSTMENTS a,FA_ADDITIONS_B b
-- -- FA_DEPRN_PERIODS FDP
-- where a.asset_id=b.asset_id 
-- -- and b.asset_number in ('610','611') 
-- and a.ADJUSTMENT_TYPE='COST'
-- and SOURCE_TYPE_CODE in ('ADDITION')
-- and  PERIOD_COUNTER_ADJUSTED in (
-- select PERIOD_COUNTER from FA_DEPRN_PERIODS FDP1 where
-- FISCAL_YEAR =(
-- select FISCAL_YEAR from FA_DEPRN_PERIODS FDP 
-- where PERIOD_NAME =:p_period_name and book_type_code=:P_books)
-- and PERIOD_COUNTER <= ( select PERIOD_COUNTER from FA_DEPRN_PERIODS FDP 
-- where PERIOD_NAME =:p_period_name and book_type_code=:P_books)
-- and book_type_code=:P_books
-- )
-- group by asset_number, a.ASSET_ID) ADJ,
-- (select b.asset_number,cost_retired FRom fa_retirements a,FA_ADDITIONS_B b
-- where a.asset_id=b.asset_id 
-- -- and b.asset_number in ('612') 
-- and exists ( select 1 from FA_DEPRN_PERIODS D
 -- where a.date_retired between D.CALENDAR_PERIOD_OPEN_DATE and D.CALENDAR_PERIOD_CLOSE_DATE 
-- and d.BOOK_TYPE_CODE=:P_books
-- and period_name=:p_period_name)
-- )RET

WHERE
FCB.CATEGORY_ID=FAB.ASSET_CATEGORY_ID
AND
FATL.ASSET_ID=FAB.ASSET_ID
AND 
FB.ASSET_ID=FAB.ASSET_ID
and 
FB.book_type_code=:P_books
AND EXISTS ( SELECT 1 FROM(SELECT 
DISTINCT FB_1.ASSET_ID
FROM
FA_ADDITIONS_B FAB_1,
FA_BOOKS FB_1,
FA_TRANSACTION_HEADERS FTH_1
WHERE
FTH_1.ASSET_ID=FAB_1.ASSET_ID
AND
FB_1.ASSET_ID=FAB_1.ASSET_ID
AND
FB_1.BOOK_TYPE_CODE=FTH_1.BOOK_TYPE_CODE
AND
FB_1.book_type_code=:P_books
AND
FTH_1.TRANSACTION_TYPE_CODE = 'CIP ADDITION'
AND
FAB_1.ASSET_ID=FAB.ASSET_ID))
-- and 
-- FDD.ASSET_ID =FAB.asset_id
-- AND 
-- FDP.PERIOD_COUNTER=FDD.PERIOD_COUNTER
--AND 
--FDP.FISCAL_YEAR IN ( SELECT FISCAL_YEAR FROM FA_DEPRN_PERIODS WHERE PERIOD_NAME=:p_period_name )
-- and 
-- FDP.period_num =( select PERIOD_NUM from FA_DEPRN_PERIODS where PERIOD_NAME=:p_period_name)
-- and 
-- FDP.book_type_code like  :p_books   ---'CCHMS CORP BOOK'
-- and 
-- FDP.book_type_code=FDD.book_type_code

-- AND 
-- FAB.ASSET_NUMBER=ADJ.ASSET_NUMBER(+)
-- AND
-- FAB.ASSET_NUMBER=RET.ASSET_NUMBER(+)
-- AND
-- TRANSACTION_TYPE_CODE IN ('ADDITION','CIP ADDITION')
)MAIN
-- WHERE
--ASSET_NUMBER IN ('580','588','600','606','607','594')
-- AND 
-- INVOICE_DATE_ADD IS NULL
 GROUP BY ASSET_NUMBER,DESCRIPTION,INVOICE_NUM,INVOICE_AMOUNT,TRANSFERRED_IN,
TRANSFERRED_OUT,INVOICE_DATE,INVOICE_DATE_ADD