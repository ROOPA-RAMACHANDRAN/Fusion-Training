select party_name,START_END_DATE,DESCRIPTION,acc_period,PERIOD_YEAR,PERIOD_NUM,Year,invoice_num,LINE_NUMBER,prv_cnt,USD_VALUE,
PREV_AMT,
case when prv_cnt =0 and  REM_BAL is null  then
USD_VALUE
else
REM_BAL end REM_BAL ,map_start_date,map_end_date,Acc_JAN,Acc_Feb,Acc_mar,Acc_Apr,Acc_May,Acc_Jun,Acc_Jul,Acc_Aug,Acc_Sep,Acc_Oct,Acc_Nov,
Acc_Dec,CURRENT_PERIOD,END_BAL from (
select party_name,
	START_END_DATE,
	 DESCRIPTION
	,acc_period
	,gp1.PERIOD_YEAR
	,gp1.PERIOD_NUM
	,substr(:P_PERIOD,5,2) Year
	,a.invoice_num,A.LINE_NUMBER,
	(select  count(*) cnt
	 From 
	AP_INVOICES_ALL aia ,
	ap_invoice_lines_all  aila,
	ap_invoice_distributions_all aida,
	xla_transaction_entities XLATE,
	XLA_EVENTS  XLAE,
	POZ_SUPPLIERS ps,
	hz_parties hzp,
	xla_distribution_links xdl, 
	xla_mpa_distributions xmd,
	XLA_AE_HEADERS XLAH,
	XLA_AE_LINES  XLAL
	where  1=1
	and aia.invoice_num =a.invoice_num
	and  aila.invoice_id=aia.invoice_id
	--and aila.LINE_TYPE_LOOKUP_CODE ='ITEM'
	and aida.invoice_id=aia.invoice_id
	--and aida.LINE_TYPE_LOOKUP_CODE  ='ITEM'
	and aida.INVOICE_LINE_NUMBER=aila.LINE_NUMBER
	and XLATE.source_id_int_1 =aia.invoice_id
	and XLATE.ENTITY_ID = XLAE.ENTITY_ID
	and ps.vendor_id=aia.vendor_id
	and hzp.party_id=ps.party_id
	--- and xdl.AE_HEADER_ID = xdl.AE_HEADER_ID
	and xdl.source_distribution_id_num_1=aida.invoice_distribution_id
	and xdl.source_distribution_type='AP_INV_DIST'
	and  xmd.SOURCE_DISTRIBUTION_ID_NUM_1 = aida.invoice_distribution_id
	and xdl.ae_header_id=XLAH.ae_header_id
	and XLAL.ae_header_id=xdl.ae_header_id
	and xlal.ae_line_num=xdl.ae_line_num
	-- and xlal.code_combination_id <> 300000008059116
    and xlal.ACCOUNTING_CLASS_CODE='ITEM EXPENSE'
	--and xlal.ACCOUNTING_CLASS_CODE 'ORA_AP_DEFER_ITEM_EXP'
	--and (XLAL.ACCOUNTED_DR >0 and XLAL.ACCOUNTED_DR is not null)
	 and XLAH.PERIOD_NAME in (select Period_name From  GL_PERIODS  where PERIOD_YEAR in(
	 SELECT PERIOD_YEAR   fROM GL_PERIODS WHERE 
	 PERIOD_NAME=a.acc_period)
     and  ADJUSTMENT_PERIOD_FLAG='N')) prv_cnt,
	b.LINE_TOT_AMT USD_VALUE,
	NVL(PREV_AMT,0) PREV_AMT,
	CASE WHEN NVL(PREV_AMT,0) <> 0 THEN
	(b.LINE_TOT_AMT - NVL(PREV_AMT,0))
	END REM_BAL,map_start_date,map_end_date,
	sum(Acc_JAN) Acc_JAN,
	sum(Acc_Feb) Acc_Feb,
	sum(Acc_mar) Acc_mar,
	sum(Acc_Apr) Acc_Apr,
    sum(Acc_May) Acc_May,
	sum(Acc_Jun) Acc_Jun,
	sum(Acc_Jul) Acc_Jul,
	sum(Acc_Aug) Acc_Aug,
	sum(Acc_Sep) Acc_Sep,
	sum(Acc_Oct) Acc_Oct,
	sum(Acc_Nov) Acc_Nov,
	sum(Acc_Dec) Acc_Dec,
		sum(nvl(Acc_JAN,0)) +
		sum(nvl(Acc_Feb,0))+
		sum(nvl(Acc_mar,0))+
		sum(nvl(Acc_Apr,0))+
		sum(nvl(Acc_May,0))+
		sum(nvl(Acc_Jun,0))+
		sum(nvl(Acc_Jul,0))+
		sum(nvl(Acc_Aug,0))+
		sum(nvl(Acc_Sep,0))+
		sum(nvl(Acc_Oct,0))+
		sum(nvl(Acc_Nov,0))+
		sum(nvl(Acc_Dec,0)) CURRENT_PERIOD,
		--case when INVOICE_TYPE_LOOKUP_CODE <>'CREDIT' then
		(b.LINE_TOT_AMT -NVL(PREV_AMT,0) + (sum(nvl(Acc_JAN,0)) +
		sum(nvl(Acc_Feb,0))+
		sum(nvl(Acc_mar,0))+
		sum(nvl(Acc_Apr,0))+
		sum(nvl(Acc_May,0))+
		sum(nvl(Acc_Jun,0))+
		sum(nvl(Acc_Jul,0))+
		sum(nvl(Acc_Aug,0))+
		sum(nvl(Acc_Sep,0))+
		sum(nvl(Acc_Oct,0))+
		sum(nvl(Acc_Nov,0))+
		sum(nvl(Acc_Dec,0))))
			END_BAL
		from (
	select DESCRIPTION,acc_period, START_END_DATE
	,party_name,invoice_num,LINE_NUMBER,
		case when PERIOD_NAME='Jan' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_JAN,
			case when PERIOD_NAME='Feb' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_feb,
			case when PERIOD_NAME='Mar' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_mar,
			case when PERIOD_NAME='Apr' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_Apr,
			case when PERIOD_NAME='May' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_May,
			case when PERIOD_NAME='Jun' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_Jun,
			case when PERIOD_NAME='Jul' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_Jul,
			case when PERIOD_NAME='Aug' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_Aug,
			case when PERIOD_NAME='Sep' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_Sep,
		case when PERIOD_NAME='Oct' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_OCT,
			case when PERIOD_NAME='Nov' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_Nov,
		case when PERIOD_NAME='Dec' || (select substr(:P_PERIOD,4,3) from dual) then
		sum(nvl(acc_dr,0))
		end  Acc_Dec,map_start_date,map_end_date,INVOICE_TYPE_LOOKUP_CODE
		from (
	select DESCRIPTION,acc_period,TO_CHAR(map_start_date,'MM/DD/YYYY') || '  TO  ' ||TO_CHAR(map_end_date ,'MM/DD/YYYY')  START_END_DATE
	,party_name,invoice_num,LINE_NUMBER,map_start_date,map_end_date,
		PERIOD_NAME,sum(nvl(UNROUNDED_ACCOUNTED_DR,0)) acc_dr,INVOICE_TYPE_LOOKUP_CODE
			from (
		select distinct hzp.party_name,
	 aia.invoice_num,
	  AILA.LINE_NUMBER,
	aila.DESCRIPTION,
	aila.period_name acc_period,
	aia.gl_date ,
	xmd.LAST_GL_DATE ,
	aila.def_acctg_start_date map_start_date,
	aila.def_acctg_end_date map_end_date,
	aida.invoice_distribution_id,
	INVOICE_TYPE_LOOKUP_CODE,
	-- XLAL.ACCOUNTED_dr UNROUNDED_ACCOUNTED_DR,
	case when INVOICE_TYPE_LOOKUP_CODE='CREDIT' then
     XLAL.ACCOUNTED_cr 
	else
    -XLAL.ACCOUNTED_DR
	end UNROUNDED_ACCOUNTED_DR,
	XLAH.PERIOD_NAME
	 From 
	AP_INVOICES_ALL aia ,
	ap_invoice_lines_all  aila,
	ap_invoice_distributions_all aida,
	xla_transaction_entities XLATE,
	XLA_EVENTS  XLAE,
	POZ_SUPPLIERS ps,
	hz_parties hzp,
	xla_distribution_links xdl, 
	xla_mpa_distributions xmd,
	XLA_AE_HEADERS XLAH,
	XLA_AE_LINES  XLAL
	where  1=1
	-- and aia.invoice_num in ('4190004507_Prepayment Adj','SGIN-434','00105686','00105298')
	AND AIA.ORG_ID IN (SELECT organization_id FROM HR_ORGANIZATION_UNITS_F_TL WHERE NAME LIKE :P_BUSINESS_UNIT)
	and aia.cancelled_date is null
	and  aila.invoice_id=aia.invoice_id
	and aila.LINE_TYPE_LOOKUP_CODE ='ITEM'
	and aida.invoice_id=aia.invoice_id
	and aida.LINE_TYPE_LOOKUP_CODE  ='ITEM'
	and aida.INVOICE_LINE_NUMBER=aila.LINE_NUMBER
	and XLATE.source_id_int_1 =aia.invoice_id
	and XLATE.ENTITY_ID = XLAE.ENTITY_ID
	and ps.vendor_id=aia.vendor_id
	and hzp.party_id=ps.party_id
	--- and xdl.AE_HEADER_ID = xdl.AE_HEADER_ID
	and xdl.source_distribution_id_num_1=aida.invoice_distribution_id
	and xdl.source_distribution_type='AP_INV_DIST'
	--- and (xdl.UNROUNDED_ACCOUNTED_DR >0 and xdl.UNROUNDED_ACCOUNTED_DR is not null)
	and  xmd.SOURCE_DISTRIBUTION_ID_NUM_1 = aida.invoice_distribution_id
	and xdl.ae_header_id=XLAH.ae_header_id
	and XLAL.ae_header_id=xdl.ae_header_id
	and xlal.ae_line_num=xdl.ae_line_num
	and xlal.code_combination_id <> 300000008059116
	and XLAH.PERIOD_NAME in (
	select Period_name From  GL_PERIODS  where to_char(YEAR_START_DATE,'DD-MON-YYYY') in(
	SELECT to_char(YEAR_START_DATE,'DD-MON-YYYY') a  fROM GL_PERIODS WHERE 
	PERIOD_NAME=:P_PERIOD)
	and  ADJUSTMENT_PERIOD_FLAG='N'
    and period_num <=( select PERIOD_NUM from GL_PERIODS where PERIOD_NAME=:P_PERIOD)
  )
	)
	group by DESCRIPTION,acc_period,TO_CHAR(gl_date,'MM/DD/YYYY') || '  TO  ' ||TO_CHAR(LAST_GL_DATE ,'MM/DD/YYYY') 
	,party_name,invoice_num,PERIOD_NAME,LINE_NUMBER,map_start_date,map_end_date,INVOICE_TYPE_LOOKUP_CODE)
		group by  DESCRIPTION,acc_period, START_END_DATE
	,party_name,invoice_num,PERIOD_NAME,LINE_NUMBER,map_start_date,map_end_date,INVOICE_TYPE_LOOKUP_CODE
	) a,
	(select invoice_num,code_combination_id,LINE_NUMBER,sum(line_total_amt) LINE_TOT_AMT 
from 
(
select
 aia.invoice_num, xlal.code_combination_id,aila.LINE_NUMBER,
case when INVOICE_TYPE_LOOKUP_CODE='CREDIT' then
    - XLAL.ACCOUNTED_cr 
	else
	XLAL.ACCOUNTED_DR
	end line_total_amt
  from AP_INVOICES_ALL aia ,
ap_invoice_lines_all  aila,
	ap_invoice_distributions_all aida,
xla_transaction_entities XLATE,
XLA_EVENTS  XLAE,POZ_SUPPLIERS ps,
	hz_parties hzp,
xla_distribution_links xdl,
xla_mpa_distributions xmd,
XLA_AE_HEADERS XLAH,
XLA_AE_LINES  XLAL
where   1=1
-- and aia.invoice_num in ('4190004507_Prepayment Adj','SGIN-434','00105686','00105298')
and aia.cancelled_date is null
and aila.invoice_id=aia.invoice_id
and aila.LINE_TYPE_LOOKUP_CODE ='ITEM'
and xlal.code_combination_id = 300000008059116
and xlal.ACCOUNTING_CLASS_CODE='ORA_AP_DEFER_ITEM_EXP'
and aida.invoice_id=aia.invoice_id
and aida.LINE_TYPE_LOOKUP_CODE  ='ITEM'
and aida.INVOICE_LINE_NUMBER=aila.LINE_NUMBER
and XLATE.source_id_int_1 =aia.invoice_id
and XLATE.ENTITY_ID = XLAE.ENTITY_ID	
and ps.vendor_id=aia.vendor_id
and xdl.source_distribution_id_num_1=aida.invoice_distribution_id
and XLAL.ae_header_id=xdl.ae_header_id
and xlal.ae_line_num=xdl.ae_line_num
and xdl.ae_header_id=XLAH.ae_header_id
and  xmd.SOURCE_DISTRIBUTION_ID_NUM_1 = aida.invoice_distribution_id
and xdl.source_distribution_type='AP_INV_DIST'
and hzp.party_id=ps.party_id)
group by invoice_num,code_combination_id,LINE_NUMBER) b,
	(select   aia.invoice_num, xlal.code_combination_id,aila.LINE_NUMBER,
	sum(XLAL.ACCOUNTED_DR) PREV_AMT From 
	AP_INVOICES_ALL aia ,
	ap_invoice_lines_all  aila,
	ap_invoice_distributions_all aida,
	xla_transaction_entities XLATE,
	XLA_EVENTS  XLAE,
	POZ_SUPPLIERS ps,
	hz_parties hzp,
	xla_distribution_links xdl, 
	xla_mpa_distributions xmd,
	XLA_AE_HEADERS XLAH,
	XLA_AE_LINES  XLAL
	where  1=1
	-- and aia.invoice_num in    ('SGIN-434','00105686','SentosaGolf_2021') ----('6885108511' ,'SGIN-434')
	and aia.cancelled_date is null
	and  aila.invoice_id=aia.invoice_id
	--and aila.LINE_TYPE_LOOKUP_CODE ='ITEM'
	and aida.invoice_id=aia.invoice_id
	--and aida.LINE_TYPE_LOOKUP_CODE  ='ITEM'
	and aida.INVOICE_LINE_NUMBER=aila.LINE_NUMBER
	and XLATE.source_id_int_1 =aia.invoice_id
	and XLATE.ENTITY_ID = XLAE.ENTITY_ID
	and ps.vendor_id=aia.vendor_id
	and hzp.party_id=ps.party_id
	--- and xdl.AE_HEADER_ID = xdl.AE_HEADER_ID
	and xdl.source_distribution_id_num_1=aida.invoice_distribution_id
	and xdl.source_distribution_type='AP_INV_DIST'
	and  xmd.SOURCE_DISTRIBUTION_ID_NUM_1 = aida.invoice_distribution_id
	and xdl.ae_header_id=XLAH.ae_header_id
	and XLAL.ae_header_id=xdl.ae_header_id
	and xlal.ae_line_num=xdl.ae_line_num
	-- and xlal.code_combination_id <> 300000008059116
	and xlal.ACCOUNTING_CLASS_CODE='ITEM EXPENSE'
	and (XLAL.ACCOUNTED_DR >0 and XLAL.ACCOUNTED_DR is not null)
	and XLAH.PERIOD_NAME not in (
select Period_name From  GL_PERIODS  where to_char(YEAR_START_DATE,'DD-MON-YYYY') in(
SELECT to_char(YEAR_START_DATE,'DD-MON-YYYY') a  fROM GL_PERIODS WHERE 
PERIOD_NAME=:P_PERIOD)
and  ADJUSTMENT_PERIOD_FLAG='N')
	group by  aia.invoice_num, xlal.code_combination_id,AILA.LINE_NUMBER) C
	, (select gp2.period_name,gp2.PERIOD_YEAR  ,gp2.PERIOD_NUM from GL_PERIODS gp2) gp1
	where a.invoice_num=b.invoice_num
	AND A.LINE_NUMBER=B.LINE_NUMBER
	AND a.invoice_num=C.invoice_num(+)
	AND A.LINE_NUMBER=C.LINE_NUMBER(+)
	and gp1.period_name =acc_period
	group by DESCRIPTION,acc_period, START_END_DATE
	,party_name,a.invoice_num,b.LINE_TOT_AMT,A.LINE_NUMBER,C.PREV_AMT,map_start_date,map_end_date
	,gp1.PERIOD_YEAR
	,gp1.PERIOD_NUM
	,INVOICE_TYPE_LOOKUP_CODE)
	order by 5,6,4,8