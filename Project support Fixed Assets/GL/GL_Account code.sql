
SELECT 
LEDGER,
ACCOUNT_CODE,
PERIOD_NAME,
CASE WHEN ACCOUNT_CODE = '03-20851-00-00-54-000-0-000' THEN 'GST review fee '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
     WHEN ACCOUNT_CODE = '03-20851-00-00-55-000-0-000' THEN 'Corporate tax compliance fee '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20851-00-00-56-000-0-000' THEN 'Audit fee for '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20851-00-00-57-000-0-000' THEN 'Internal Audit fee for '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20851-00-00-58-000-0-000' THEN 'FIS BAU Operation and Support '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20851-00-00-59-000-0-000' THEN 'Accrual - CR25 EIR '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20851-00-00-60-000-0-000' THEN 'Accrual - Finance AGL phase 2 '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20854-00-00-00-000-0-000' THEN 'Accrual for Bonus '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20855-00-00-00-000-0-000' THEN 'Accrual for deferred bonus '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20856-00-00-00-000-0-000' THEN 'Accrual for CPF on bonus for '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 WHEN ACCOUNT_CODE = '03-20858-00-00-00-000-0-000' THEN 'Accrual for CPF on Salaries '||'FY20'||SUBSTR(:P_PERIOD_NAME,5,2)
	 
END DESCRIPTION,
CURRENCY_CONVERSION_RATE                                  CONVERSION_RATE,
CURRENCY_CONVERSION_DATE                                  CONVERSION_DATE,
CASE WHEN SGD IS NOT NULL THEN ROUND(SGD *  NVL(CURRENCY_CONVERSION_RATE,1),2)
	 END                                                                        SGD_CR,
SGD,
USD,
CASE WHEN SGD IS NULL AND USD IS NOT NULL THEN 0 END REVAL_USD
FROM
(SELECT 
GL.NAME LEDGER,
GP.PERIOD_NAME,
GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6||'-'||
GCC.SEGMENT7||'-'||GCC.SEGMENT8 ACCOUNT_CODE,
CASE WHEN GJL.ENTERED_DR IS NOT NULL AND GJH.CURRENCY_CODE='SGD' THEN ROUND((GJL.ENTERED_DR * -1) *  NVL(GJL.CURRENCY_CONVERSION_RATE,1),2)
     WHEN GJL.ENTERED_CR IS NOT NULL AND GJH.CURRENCY_CODE='SGD' THEN  ROUND(GJL.ENTERED_CR *  NVL(GJL.CURRENCY_CONVERSION_RATE,1),2)
	 WHEN GJL.ENTERED_DR IS NOT NULL AND GJH.CURRENCY_CODE='USD' THEN (GJL.ENTERED_DR * -1) 
	 WHEN GJL.ENTERED_CR IS NOT NULL AND GJH.CURRENCY_CODE='USD' THEN GJL.ENTERED_CR 
	 END USD,
	 
CASE WHEN GJL.ENTERED_DR IS NOT NULL AND GJH.CURRENCY_CODE='SGD' THEN (GJL.ENTERED_DR * -1) 
     WHEN GJL.ENTERED_CR IS NOT NULL AND GJH.CURRENCY_CODE='SGD' THEN  GJL.ENTERED_CR END SGD,
GJL.CURRENCY_CONVERSION_RATE,
GJL.CURRENCY_CONVERSION_DATE,
-- CASE WHEN GJl.DESCRIPTION IS NOT NULL THEN 'Accrual For '||
-- SUBSTR(GJl.DESCRIPTION,1,
-- CASE WHEN INSTR (GJl.DESCRIPTION,')',1)>1 THEN INSTR (GJl.DESCRIPTION,')',1) 
-- ELSE LENGTH(GJl.DESCRIPTION)END) 
-- ELSE GJl.DESCRIPTION
-- END DESCRIPTION,
--GJl.DESCRIPTION,
--SUBSTR(GJl.DESCRIPTION,1,LENGTH(GJl.DESCRIPTION)-8) DESCRIPTION,
GJB.NAME,
GJH.CURRENCY_CODE
FROM
GL_LEDGERS GL,
GL_PERIODS GP,
--GL_BALANCES GB,
GL_CODE_COMBINATIONS GCC,
GL_JE_LINES GJL,
GL_JE_HEADERS GJH,
GL_JE_BATCHES GJB,
GL_JE_CATEGORIES GJC
WHERE
1=1
AND GL.LEDGER_ID=GJH.LEDGER_ID
AND GJH.PERIOD_NAME=GP.PERIOD_NAME
AND GJL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
AND GJL.JE_HEADER_ID=GJH.JE_HEADER_ID
AND GJB.JE_BATCH_ID=GJH.JE_BATCH_ID
AND GJH.JE_CATEGORY=GJC.JE_CATEGORY_NAME
AND GJC.JE_CATEGORY_NAME='Accrual'
AND GJB.STATUS='P'
AND GP.PERIOD_NAME IN 
(SELECT PERIOD_NAME FROM GL_PERIODS WHERE SUBSTR(PERIOD_NAME,5,2) = SUBSTR(:P_PERIOD_NAME,5,2)
AND (DECODE ((SUBSTR(PERIOD_NAME,1,3)),'Jan',1,'Feb',2,
                                       'Mar',3,'Apr',4,
						               'May',5,'Jun',6,
						               'Jul',7,'Aug',8,
						               'Sep',9,'Oct',10,
						               'Nov',11,'Dec',12) <= (DECODE ((SUBSTR(:P_PERIOD_NAME,1,3)) ,'Jan',1,'Feb',2,
                                                                        'Mar',3,'Apr',4,
						                                                'May',5,'Jun',6,
						                                                'Jul',7,'Aug',8,
						                                                'Sep',9,'Oct',10,
						                                                'Nov',11,'Dec',12 ))))

AND GL.NAME=:P_NAME
--AND GJB.NAME = 'CCHMS - Accrual for Deferred Bonus Spreadsheet A 300000001149161 499996 N' --BATCH NAME
--AND GJH.NAME LIKE '%CCHMS - Accrual for Deferred Bonus Accrual%' --JOURNAL NAME
GROUP BY 
GCC.SEGMENT1,
GCC.SEGMENT2,
GCC.SEGMENT3,
GCC.SEGMENT4,
GCC.SEGMENT5,
GCC.SEGMENT6,
GCC.SEGMENT7,
GCC.SEGMENT8,
GL.NAME,
GP.PERIOD_NAME,
GCC.SEGMENT2,
GJL.ENTERED_DR,
GJL.ENTERED_CR,
GJL.ACCOUNTED_DR,
GJL.ACCOUNTED_CR,
GJL.CURRENCY_CONVERSION_RATE,
GJL.CURRENCY_CONVERSION_DATE,
GJl.DESCRIPTION,
GJB.NAME,
GJH.CURRENCY_CODE
)
WHERE
1=1
AND
--ACCOUNT_CODE ='03-20855-00-00-00-000-0-000'
ACCOUNT_CODE IN ('03-20854-00-00-00-000-0-000','03-20855-00-00-00-000-0-000','03-20856-00-00-00-000-0-000','03-20858-00-00-00-000-0-000',
'03-20851-00-00-54-000-0-000','03-20851-00-00-55-000-0-000','03-20851-00-00-56-000-0-000','03-20851-00-00-57-000-0-000','03-20851-00-00-58-000-0-000','03-20851-00-00-59-000-0-000','03-20851-00-00-60-000-0-000')

ORDER BY SUBSTR(PERIOD_NAME,5,2),(DECODE ((SUBSTR(PERIOD_NAME,1,3)),'Jan',1,'Feb',2,
                                       'Mar',3,'Apr',4,
						               'May',5,'Jun',6,
						               'Jul',7,'Aug',8,
						               'Sep',9,'Oct',10,
						               'Nov',11,'Dec',12))
