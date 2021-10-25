

SELECT 
LEDGER,
ACCOUNT_CODE,
PERIOD_NAME,
CASE WHEN ENTERED_DR IS NOT NULL THEN ENTERED_DR 
     WHEN ENTERED_CR IS NOT NULL THEN ENTERED_CR
	 END SGD,
CASE WHEN ACCOUNTED_DR IS NOT NULL THEN ACCOUNTED_DR
     WHEN ACCOUNTED_CR IS NOT NULL THEN ACCOUNTED_CR
	 END USD
FROM
(SELECT 
GL.NAME LEDGER,
GB.PERIOD_NAME,
GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6||'-'||
GCC.SEGMENT7||'-'||GCC.SEGMENT8 ACCOUNT_CODE,
(GJL.ENTERED_DR * -1) ENTERED_DR ,
GJL.ENTERED_CR,
(GJL.ACCOUNTED_DR * -1) ACCOUNTED_DR,
GJL.ACCOUNTED_CR

FROM
GL_LEDGERS GL,
GL_BALANCES GB,
GL_CODE_COMBINATIONS GCC,
GL_JE_LINES GJL,
GL_JE_HEADERS GJH,
GL_JE_CATEGORIES GJC
WHERE
1=1
AND GL.LEDGER_ID=GB.LEDGER_ID
AND GB.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
AND GCC.CODE_COMBINATION_ID=GJL.CODE_COMBINATION_ID
AND GJL.JE_HEADER_ID=GJH.JE_HEADER_ID
AND GJH.JE_CATEGORY=GJC.JE_CATEGORY_NAME
AND GJC.JE_CATEGORY_NAME='Accrual'
AND GB.ACTUAL_FLAG='A'
AND GB.CURRENCY_CODE IN ('SGD','USD')
--AND GB.PERIOD_NAME IN (SELECT PERIOD_NAME FROM GL_BALANCES WHERE SUBSTR(PERIOD_NAME,5,2) = SUBSTR(:PERIOD_NAME,5,2))
AND GB.PERIOD_NAME = :P_PERIOD_NAME
--AND SUBSTR(GB.PERIOD_NAME,5,2) SUBSTR(:P_PERIOD_NAME)
AND GL.NAME=:P_NAME
--AND GCC.SEGMENT2 IN('20851','20855','20854','20856','20855','20858')


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
GB.PERIOD_NAME,
GCC.SEGMENT2,
GJL.ENTERED_DR,
GJL.ENTERED_CR,
GJL.ACCOUNTED_DR,
GJL.ACCOUNTED_CR
)
WHERE
1=1
AND
ACCOUNT_CODE IN ('03-20854-00-00-00-000-0-000','03-20855-00-00-00-000-0-000','03-20856-00-00-00-000-0-000','03-20858-00-00-00-000-0-000',
'03-20851-00-00-54-000-0-000','03-20851-00-00-55-000-0-000','03-20851-00-00-56-000-0-000','03-20851-00-00-57-000-0-000','03-20851-00-00-58-000-0-000')

ORDER BY ACCOUNT_CODE
