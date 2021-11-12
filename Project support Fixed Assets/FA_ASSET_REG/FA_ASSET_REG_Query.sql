--NET BOOK VALUE ORGINAL VALUE-DEPRECIATION

select asset_number,TO_CHAR (DEPRN_START_DATE,'DD-Mon-YYYY','NLS_DATE_LANGUAGE = AMERICAN') DEPRN_START_DATE,ORIGINAL_COST,year,run_year,FISCAL_YEAR,
CASE WHEN INVOICE_NUM IS NOT NULL THEN TO_CHAR (INVOICE_DATE,'DD-Mon-YYYY','NLS_DATE_LANGUAGE = AMERICAN') 
     END INVOICE_DATE,invoice_num,invoice_amount SGD,Supplier_Name,description,ATTRIBUTE_CATEGORY_CODE,CATEGORY,
account_code,COST,ADJ_COST,cost_retired,nvl(COST,0)+nvl(ADJ_COST,0)+nvl(cost_retired,0) as_on,YTD_DEPRN,dp_amt_jan,
dp_amt_Feb,dp_amt_Mar,dp_amt_Apr,dp_amt_May,dp_amt_Jun,dp_amt_Jul,dp_amt_Aug,dp_amt_Sep,dp_amt_Oct,dp_amt_Nov,dp_amt_Dec,
Acc_desp,nbv,dp_amt_current from
(
select  MAIN.asset_number, 
MAIN.DEPRN_START_DATE,
MAIN.ORIGINAL_COST,
substr(:p_period_name,5,2) year,
(select fdp5.FISCAL_YEAR from FA_DEPRN_PERIODS fdp5 where fdp5.period_name=:p_period_name) run_year,
asset_year.FISCAL_YEAR,
invoice_date,
invoice_num ,
invoice_amount ,
Supplier_Name,
description,
ATTRIBUTE_CATEGORY_CODE,
CATEGORY,
account_code,
case when (select fdp5.FISCAL_YEAR from FA_DEPRN_PERIODS fdp5 where fdp5.period_name=:p_period_name) = asset_year.FISCAL_YEAR then
null
else 
COST end COST,
ADJ.ADJ_COST ADJ_COST,
-ret.cost_retired cost_retired,
--- nvl(COST,0)+nvl(ADJ.ADJ_COST,0)- nvl(ret.cost_retired,0) as_on,
desp_open.YTD_DEPRN YTD_DEPRN,
sum(dp_amt_jan) dp_amt_jan ,
sum(dp_amt_Feb) dp_amt_Feb,
sum(dp_amt_Mar) dp_amt_Mar,
sum(dp_amt_Apr) dp_amt_Apr,
sum(dp_amt_May) dp_amt_May,
sum(dp_amt_Jun) dp_amt_Jun,
sum(dp_amt_Jul) dp_amt_Jul,
sum(dp_amt_Aug) dp_amt_Aug,
sum(dp_amt_Sep) dp_amt_Sep,
sum(dp_amt_Oct) dp_amt_Oct,
sum(dp_amt_Nov) dp_amt_Nov,
sum(dp_amt_Dec) dp_amt_Dec,
Acc_desp,

(cost - Acc_desp) nbv,
sum(dp_amt_current) dp_amt_current
-- ,fiscal_year
 from 
(
select  asset_number,description,ass_id,
invoice_date,
ATTRIBUTE_CATEGORY_CODE,
CATEGORY,
DEPRN_START_DATE,
ORIGINAL_COST,
account_code,
invoice_num ,
INVOICE_AMOUNT,
Supplier_Name,
COST,
case when PERIOD_NAME='Jan' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_jan,
	case when PERIOD_NAME='Feb' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_feb,
	case when PERIOD_NAME='Mar' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_Mar,
	case when PERIOD_NAME='Apr' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_apr,
	case when PERIOD_NAME='May' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_May,
	case when PERIOD_NAME='Jun' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_jun,
	case when PERIOD_NAME='Jul' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_jul,
	case when PERIOD_NAME='Aug' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_aug,
	case when PERIOD_NAME='Sep' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_Sep,
	case when PERIOD_NAME='Oct' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_oct,
	case when PERIOD_NAME='Nov' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_Nov,
	case when PERIOD_NAME='Dec' || (select substr(:p_period_name,4,3) from dual) then
	sum(nvl(dp_amt,0))
	end  dp_amt_Dec,
	dp_res Acc_desp,
	case when PERIOD_NAME=:p_period_name then
	sum(nvl(dp_amt,0))
	end  dp_amt_current,
	fiscal_year
from (  
select distinct asset_number,description,ass_id ,
invoice_date,
ATTRIBUTE_CATEGORY_CODE,
CATEGORY,
DEPRN_START_DATE,
ORIGINAL_COST,
account_code,invoice_num ,
INVOICE_AMOUNT,
Supplier_Name,
COST,
PERIOD_NAME,
sum(nvl(DEPRN_AMOUNT,0)) dp_amt,
(SELECT SUM (FDD1.deprn_reserve)
                  FROM fa_deprn_detail FDD1, fa_distribution_history fdhi
                 WHERE     fdd1.asset_id = ass_id
                       AND PERIOD_COUNTER =
                              (SELECT MAX (PERIOD_COUNTER)
                                 FROM fa_deprn_detail fddi
                                WHERE     fddi.ASSET_ID = FDD1.ASSET_ID
                                      AND fddi.distribution_id =
                                             fdd1.distribution_id
                                      AND fddi.distribution_id =
                                             fdhi.distribution_id)
                       AND FDD1.DISTRIBUTION_ID = FDHI.DISTRIBUTION_ID )dp_res,
					   fiscal_year
from (

select  fab.asset_number,fatl.description,fab.asset_id ass_id,
TRANSACTION_DATE_ENTERED invoice_date,
fab.ATTRIBUTE_CATEGORY_CODE,
FCB.SEGMENT1 CATEGORY,
 FB.COST,FDD.DEPRN_AMOUNT,FDP.PERIOD_NAME,
 FB.DEPRN_START_DATE,
 FB.ORIGINAL_COST,
 TRANSACTION_TYPE_CODE,
 (select gcc.segment2 from 
xla_ae_headers xah,
xla_ae_lines xal,
gl_code_combinations gcc
where 
xah.event_id=fth.event_id
and xah.AE_HEADER_ID=xal.AE_HEADER_ID
and  ACCOUNTING_CLASS_CODE='COST'
and gcc.code_combination_id=xal.code_combination_id) account_code,
(select  distinct  c.INVOICE_NUM From fa_asset_invoices a,
ap_invoices_all c,
ap_invoice_lines_all d
where a.asset_id=fab.asset_id
and a.invoice_id=c.invoice_id
and a.invoice_id=d.invoice_id
and d.amount<>0) invoice_num,
(select  distinct  c.INVOICE_AMOUNT From fa_asset_invoices a,
ap_invoices_all c,
ap_invoice_lines_all d
where a.asset_id=fab.asset_id
and a.invoice_id=c.invoice_id
and a.invoice_id=d.invoice_id
and d.amount<>0
and c.INVOICE_CURRENCY_CODE='SGD')INVOICE_AMOUNT,
(select  distinct b.party_name
From 
fa_asset_invoices a,
ap_invoices_all c,
ap_invoice_lines_all d,
hz_parties b
where 
a.asset_id=fab.asset_id
and a.invoice_id=c.invoice_id
and a.invoice_id=d.invoice_id
and b.party_id = c.party_id
and d.amount<>0
--and c.INVOICE_CURRENCY_CODE='SGD'
)Supplier_Name,
fab.asset_category_id,
FDP.fiscal_year 
From fa_additions_tl fatl,FA_ADDITIONS_B fab,
fa_transaction_headers fth,fa_categories_b FCB,FA_BOOKS FB,
FA_DEPRN_DETAIL FDD ,FA_DEPRN_PERIODS FDP
where fatl.asset_id=fab.asset_id
--and fab.asset_number in('364','363','362','370','373')
-- and fab.asset_number in('612')
and  fth.asset_id=fab.asset_id
--and TRANSACTION_TYPE_CODE='ADDITION'
AND EXISTS ( SELECT 1 FROM(SELECT 
DISTINCT FB_1.ASSET_ID
FROM
FA_ADDITIONS_B FAB_1,
FA_BOOKS FB_1,
FA_TRANSACTION_HEADERS FTH_1,
FA_TRANSACTIONS_V FTRV
WHERE
FTH_1.ASSET_ID=FAB_1.ASSET_ID
AND
FB_1.ASSET_ID=FAB_1.ASSET_ID
AND
FTH_1.asset_id = FTRV.asset_id
And fth_1.book_type_code = ftrv.book_type_code
AND FTH_1.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
AND FB_1.BOOK_TYPE_CODE=FTH_1.BOOK_TYPE_CODE
AND FTH_1.TRANSACTION_TYPE_CODE = 'ADDITION'
AND FAB_1.ASSET_ID=FAB.ASSET_ID))

AND NOT EXISTS ( SELECT 1 FROM(SELECT 
DISTINCT FB_1.ASSET_ID
FROM
FA_ADDITIONS_B FAB_1,
FA_BOOKS FB_1,
FA_TRANSACTION_HEADERS FTH_1,
FA_TRANSACTIONS_V FTRV
WHERE
FTH_1.ASSET_ID=FAB_1.ASSET_ID
AND
FB_1.ASSET_ID=FAB_1.ASSET_ID
AND
FTH_1.asset_id = FTRV.asset_id
And fth_1.book_type_code = ftrv.book_type_code
AND FTH_1.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
AND FB_1.BOOK_TYPE_CODE=FTH_1.BOOK_TYPE_CODE
AND FTH_1.TRANSACTION_TYPE_CODE = 'FULL RETIREMENT'
AND FAB_1.ASSET_ID=FAB.ASSET_ID))
--AND TRANSACTION_TYPE_CODE NOT IN ('FULL RETIREMENT')
AND FCB.CATEGORY_ID=fab.asset_category_id
AND FB.ASSET_ID=FAB.ASSET_ID
AND FB.TRANSACTION_HEADER_ID_IN=FTH.TRANSACTION_HEADER_ID
And FAB.ASSET_TYPE='CAPITALIZED'
and fdd.ASSET_ID =fab.asset_id
AND FDP.PERIOD_COUNTER=FDD.PERIOD_COUNTER
--AND FISCAL_YEAR IN ( SELECT FISCAL_YEAR FROM FA_DEPRN_PERIODS WHERE PERIOD_NAME=:p_period_name )
and FDP.period_num <=( select PERIOD_NUM from FA_DEPRN_PERIODS where PERIOD_NAME=:p_period_name)
and FDP.book_type_code like  :p_books   ---'CCHMS CORP BOOK'
and FDP.book_type_code=FDD.book_type_code
--AND fab.ASSET_NUMBER in ('364','363','362','370','373')
--AND fab.ASSET_NUMBER in ('354','355','356')
--AND TO_CHAR(:P_SYSDATE,'DD-Mon-YYYY','NLS_DATE_LANGUAGE = AMERICAN')
ORDER BY FISCAL_YEAR,PERIOD_NUM
)
group by asset_number,description,ass_id,
invoice_date,
ATTRIBUTE_CATEGORY_CODE,
CATEGORY,
DEPRN_START_DATE,
ORIGINAL_COST,
account_code,invoice_num ,
INVOICE_AMOUNT,
Supplier_Name,
COST,
PERIOD_NAME,fiscal_year)
group by  asset_number,description,ass_id,
invoice_date,
ATTRIBUTE_CATEGORY_CODE,
CATEGORY,
DEPRN_START_DATE,
ORIGINAL_COST,
account_code,invoice_num ,
INVOICE_AMOUNT,
Supplier_Name,
COST,period_name,dp_res ,fiscal_year) MAIN,
(select asset_number, a.ASSET_ID,
sum(decode(DEBIT_CREDIT_FLAG,'CR',-nvl(ADJUSTMENT_AMOUNT,0),nvl(ADJUSTMENT_AMOUNT,0))) ADJ_COST 
From FA_ADJUSTMENTS a,FA_ADDITIONS_B b
-- FA_DEPRN_PERIODS FDP
where a.asset_id=b.asset_id 
-- and b.asset_number in ('610','611') 
and a.ADJUSTMENT_TYPE='COST'
and SOURCE_TYPE_CODE in ('ADJUSTMENT','ADDITION')
and  PERIOD_COUNTER_ADJUSTED in (
select PERIOD_COUNTER from FA_DEPRN_PERIODS FDP1 where
FISCAL_YEAR =(
select FISCAL_YEAR from FA_DEPRN_PERIODS FDP 
where PERIOD_NAME =:p_period_name and book_type_code=:P_books)
and PERIOD_COUNTER <= ( select PERIOD_COUNTER from FA_DEPRN_PERIODS FDP 
where PERIOD_NAME =:p_period_name and book_type_code=:P_books)
and book_type_code=:P_books
)
group by asset_number, a.ASSET_ID) ADJ,
(select b.asset_number,cost_retired FRom fa_retirements a,FA_ADDITIONS_B b
where a.asset_id=b.asset_id 
-- and b.asset_number in ('612') 
and exists ( select 1 from FA_DEPRN_PERIODS D
 where a.date_retired between D.CALENDAR_PERIOD_OPEN_DATE and D.CALENDAR_PERIOD_CLOSE_DATE 
and d.BOOK_TYPE_CODE=:P_books
and period_name=:p_period_name)
)ret,
 (select a.asset_id,asset_number,YTD_DEPRN From fa_deprn_summary a,FA_ADDITIONS_B b
 where a.asset_id =b.asset_id
-- and asset_number='410'
and PERIOD_COUNTER in ( select PERIOD_COUNTER from FA_DEPRN_PERIODS where FISCAL_YEAR in
(select FISCAL_YEAR-1 From FA_DEPRN_PERIODS where PERIOD_NAME =:p_period_name
and book_type_code=:P_books )
and period_num=12
and book_type_code=:P_books) ) desp_open
,(select asset_number,a.asset_id,PERIOD_COUNTER_ADJUSTED,fdp.PERIOD_NAME, a.SOURCE_TYPE_CODE ,fdp.FISCAL_YEAR
From FA_ADJUSTMENTS a,FA_ADDITIONS_B b,
FA_DEPRN_PERIODS FDP
where a.asset_id=b.asset_id 
 -- and b.asset_number in ('610','421') 
and a.ADJUSTMENT_TYPE='COST'
and SOURCE_TYPE_CODE in ('ADDITION')
and  PERIOD_COUNTER_ADJUSTED=PERIOD_COUNTER
and fdp.book_type_code=:P_books) asset_year
WHERE MAIN.ASSET_NUMBER=ADJ.ASSET_NUMBER(+)
and MAIN.ASSET_NUMBER=ret.ASSET_NUMBER(+)
and MAIN.ASSET_NUMBER=desp_open.ASSET_NUMBER(+)
and MAIN.ASSET_NUMBER=asset_year.ASSET_NUMBER(+)
--AND MAIN.ASSET_NUMBER='580'
group by MAIN.asset_number,description,ass_id,
invoice_date,
ATTRIBUTE_CATEGORY_CODE,
CATEGORY,
DEPRN_START_DATE,
ORIGINAL_COST,
account_code,invoice_num ,
INVOICE_AMOUNT,
Supplier_Name,
COST,
Acc_desp,
ADJ_COST,
ret.cost_retired,
desp_open.YTD_DEPRN
--,fiscal_year
,asset_year.FISCAL_YEAR
)
order by 1