-- FA Report Summary


Select 

Distinct AA.BOOK_TYPE_CODE,
	AA.ASSET_ID,
	AA.Company_Code,
	AA.Company_Code Company_Code_Group,
	AA.FISCAL_YEAR,
	--A.Document_Number,
	--A.TRANSACTION_TYPE,
	--A.TRANSACTION_DATE,
	AA.Cost_Center,
	AA.Trading_partner,
	--A.Depreciation_Period,
	--TO_CHAR(A.Posting_Date , 'mm/dd/yyyy')  Posting_Date,
	AA.ASSET_NUMBER,
	AA.ASSET_KEY,
	AA.PRORATE_DATE,
	AA.MAJOR_CATEGORY||' - '||AA.APC_GL_Acc MAJOR_CATEGORY_GROUP,
	AA.MAJOR_CATEGORY,
	AA.MINOR_CATEGORY,
	--A.Capitalization_Date,
	AA.COUNTRY,
	AA.City,
	AA.PROPERTY,
	AA.AREA,
	AA.L_FLOOR,
	AA.VENDOR_NUMBER,
	AA.VENDOR_NAME,
	AA.MANUFACTURER_NAME,
	AA.Original_Asset_Number,
	AA.Quantity,
	SUM(AA.TRANSFER_UNITS) TRANSFER_UNITS,
	--A.EXPENSE_ACCOUNT_TRX,
	AA.Inventory_num,
	AA.DESCRIPTION,
	AA.Serial_Number,
	AA.DEPRN_START_DATE,
	AA.Useful_Life_Year,   
	AA.Useful_Life_Period,
	SUM(NVL(AA.Scrap_value,0)) Scrap_value,
	SUM(NVL(AA.Scrap_Value_Percent,0)) Scrap_Value_Percent,
	SUM(AA.YTD_Depn) YTD_Depn,
	SUM(AA.YTD_ORD_Depn) YTD_ORD_Depn,
	SUM(AA.YTD_ADJ_Depn) YTD_ADJ_Depn,
	SUM(AA.YTD_UNPLAN_Depn) YTD_UNPLAN_Depn,
	--NVL(A.Mnth_Depn,0) Mnth_Depn,
	--NVL(A.MNTH_ADJ_DEPN,0)-NVL(A.MNTH_UNPLAN_DEPN,0) MNTH_ADJ_DEPN,
	--NVL(A.MNTH_UNPLAN_DEPN,0) MNTH_UNPLAN_DEPN,
	--NVL(A.Mnth_Depn,0) + (NVL(A.MNTH_ADJ_DEPN,0)-NVL(A.MNTH_UNPLAN_DEPN,0)) + NVL(A.MNTH_UNPLAN_DEPN,0) MNTH_DEPN_TOT,
	SUM(AA.MNTH_DEPN_TOT) MNTH_DEPN_TOT,
	AA.APC_GL_Acc,
	AA.Acc_Depr_GL_Acc,
	AA.Depr_GL_Acc,
	AA.GR_Document_No,
	AA.GR_Date,
	AA.PO_Number,
	--A.Disposal_Date,
	--AA.DISPOSAL_FLAG,
	NVL((Select CASE WHEN (FRT.DATE_RETIRED IS NULL) THEN 'N' ELSE 'Y' END From FA_RETIREMENTS FRT , fa_transaction_headers fths Where 1=1 
	AND AA.book_type_code = FRT.book_type_code AND AA.asset_id = FRT.asset_id
	--AND NVL(FRT.STATUS,'NA') NOT IN ('DELETED')
	AND FRT.asset_id = FTHS.asset_id
	And FRT.TRANSACTION_HEADER_ID_IN = FTHs.TRANSACTION_HEADER_ID
	AND FTHs.TRANSACTION_TYPE_CODE = 'FULL RETIREMENT'
	AND ROWNUM = 1),'N') DISPOSAL_FLAG,
	SUM(NVL(AA.Sales_Proceed,0)) Sales_Proceed,
	SUM(NVL(AA.Gain_or_Loss_on_Disposal,0)) Gain_or_Loss_on_Disposal,
	SUM(NVL(AA.Cost_Disposal,0)) Cost_Disposal,
	SUM(NVL(AA.Acc_Depr_Disposal,0)) Acc_Depr_Disposal,
	--A.Transfer_Date,
	SUM(NVL(AA.Cost,0)) Cost,
	SUM(NVL(AA.Accum_Depn,0)) Accum_Depn,
	SUM(NVL(AA.Impairment_Expense,0)) Impairment_Expense,
	SUM(NVL(AA.Impairment_Reserve,0)) Impairment_Reserve,
	SUM(NVL(AA.CIP_Addition,0)) CIP_Addition,
	SUM(NVL(AA.Capitalization_from_CIP,0)) Capitalization_from_CIP,
	SUM(NVL(AA.Cost_Addition,0)) Cost_Addition,
	--A.AUC_No,
	SUM(NVL(AA.Cost_Reclass,0)) Cost_Reclass,
	SUM(NVL(AA.ACC_DEPN_RECLASS,0)) ACC_DEPN_RECLASS,
	--A.Reclass_No,
	AA.Remain_Useful_Life_Year,
	AA.Remain_Useful_Life_Period,
	AA.Prorate_Convention,
	AA.ASSET_TYPE,
	AA.Depreciation_Method,
	SUM(NVL(AA.Cost_PRE_YEAR,0)) Cost_PRE_YEAR,  -- Cost B/F
	SUM(NVL(AA.AccDep_PRE_YEAR,0)) AccDep_PRE_YEAR,  -- AccDep B/F
	SUM(NVL(AA.Recoverable_Cost,0)) Recoverable_Cost, --- Cost C/F
	SUM(NVL(AA.PRE_NET_BOOK_VALUE,0)) PRE_NET_BOOK_VALUE, --- NBV B/F
	SUM(NVL(AA.DEPRN_RESERVE,0)) DEPRN_RESERVE, --- AccDep C/F
	SUM(NVL(AA.NET_BOOK_VALUE,0)) NET_BOOK_VALUE,  --- NBV C/F
	SUM(AA.UNITS_RETIRED) UNITS_RETIRED,
	--A.Reclass_Category,
	--Adjustment Adjustment_Details,
	--SALVAGE_VALUE Adjustment_AMT,
	--A.ACC_STRING,
	AA.ATTRIBUTE1,
	AA.ATTRIBUTE2,
	AA.ATTRIBUTE3,
	AA.ATTRIBUTE4,
	AA.ATTRIBUTE5,
	AA.ATTRIBUTE6,
	AA.ATTRIBUTE7,
	AA.ATTRIBUTE8,
	AA.ATTRIBUTE9,
	AA.ATTRIBUTE10,
	AA.DEPRECIATE_FLAG

From (


	Select 

	Distinct A.BOOK_TYPE_CODE,
	A.ASSET_ID,
	A.Company_Code,
	A.FISCAL_YEAR,
	--A.Document_Number,
	--A.TRANSACTION_TYPE,
	--A.TRANSACTION_DATE,
	A.Cost_Center,
	A.Trading_partner,
	--A.Depreciation_Period,
	--TO_CHAR(A.Posting_Date , 'mm/dd/yyyy')  Posting_Date,
	A.ASSET_NUMBER,
	A.ASSET_KEY,
	A.PRORATE_DATE,
	A.MAJOR_CATEGORY,
	A.MINOR_CATEGORY,
	--A.Capitalization_Date,
	A.COUNTRY,
	A.City,
	A.PROPERTY,
	A.AREA,
	A.L_FLOOR,
	A.VENDOR_NUMBER,
	A.VENDOR_NAME,
	A.MANUFACTURER_NAME,
	A.Original_Asset_Number,
	A.Quantity,
	A.TRANSFER_UNITS,
	--A.EXPENSE_ACCOUNT_TRX,
	A.Inventory_num,
	A.DESCRIPTION,
	A.Serial_Number,
	A.DEPRN_START_DATE,
	A.Useful_Life_Year,   
	A.Useful_Life_Period,
	NVL(A.Scrap_value,0) Scrap_value,
	NVL(A.Scrap_Value_Percent,0) Scrap_Value_Percent,
	NVL(A.YTD_ORD_Depn,0)+(NVL(A.YTD_ADJ_Depn,0)-NVL(A.YTD_UNPLAN_Depn,0))+NVL(A.YTD_UNPLAN_Depn,0) YTD_Depn,
	NVL(A.YTD_ORD_Depn,0) YTD_ORD_Depn,
	CASE WHEN NVL(A.YTD_ADJ_Depn,0) != 0 THEN NVL(A.YTD_ADJ_Depn,0)-NVL(A.YTD_UNPLAN_Depn,0) ELSE 0 END YTD_ADJ_Depn,
	NVL(A.YTD_UNPLAN_Depn,0) YTD_UNPLAN_Depn,
	--NVL(A.Mnth_Depn,0) Mnth_Depn,
	--NVL(A.MNTH_ADJ_DEPN,0)-NVL(A.MNTH_UNPLAN_DEPN,0) MNTH_ADJ_DEPN,
	--NVL(A.MNTH_UNPLAN_DEPN,0) MNTH_UNPLAN_DEPN,
	NVL(A.Mnth_Depn,0) + (NVL(A.MNTH_ADJ_DEPN,0)-NVL(A.MNTH_UNPLAN_DEPN,0)) + NVL(A.MNTH_UNPLAN_DEPN,0) MNTH_DEPN_TOT,
	A.APC_GL_Acc,
	A.Acc_Depr_GL_Acc,
	A.Depr_GL_Acc,
	A.GR_Document_No,
	A.GR_Date,
	A.PO_Number,
	--A.Disposal_Date,
	A.DISPOSAL_FLAG,
	NVL(A.Sales_Proceed,0) Sales_Proceed,
	NVL(A.Gain_or_Loss_on_Disposal,0) Gain_or_Loss_on_Disposal,
	NVL(A.Cost_Disposal,0) Cost_Disposal,
	NVL(A.Acc_Depr_Disposal,0) Acc_Depr_Disposal,
	--A.Transfer_Date,
	NVL(A.Cost,0) Cost,
	NVL(A.Accum_Depn,0) Accum_Depn,
	NVL(A.Impairment_Expense,0) Impairment_Expense,
	NVL(A.Impairment_Reserve,0) Impairment_Reserve,
	NVL(A.CIP_Addition,0) CIP_Addition,
	NVL(A.Capitalization_from_CIP,0) Capitalization_from_CIP,
	NVL(A.Cost_Addition,0) Cost_Addition,
	--A.AUC_No,
	NVL(A.Cost_Reclass,0) Cost_Reclass,
	NVL(A.ACC_DEPN_RECLASS,0) ACC_DEPN_RECLASS,
	--A.Reclass_No,
	Case When A.Remain_Useful_Life_Year >= 0 then A.Remain_Useful_Life_Year Else 0 END Remain_Useful_Life_Year,
	Case When A.Remain_Useful_Life_Period  >= 0 then A.Remain_Useful_Life_Period ELSE 0 END Remain_Useful_Life_Period,
	A.Prorate_Convention,
	A.ASSET_TYPE,
	A.Depreciation_Method,
	NVL(A.Cost_PRE_YEAR,0) Cost_PRE_YEAR,
	NVL(A.AccDep_PRE_YEAR,0) AccDep_PRE_YEAR,
	NVL(A.Recoverable_Cost,0) Recoverable_Cost,
	--NVL(NVL(A.Cost_PRE_YEAR,0) - NVL(A.AccDep_PRE_YEAR,0),0) PRE_NET_BOOK_VALUE,
	CASE WHEN NVL(A.Cost_PRE_YEAR,0) >= NVL(A.AccDep_PRE_YEAR,0) THEN NVL(NVL(A.Cost_PRE_YEAR,0) - NVL(A.AccDep_PRE_YEAR,0),0) ELSE 0 END PRE_NET_BOOK_VALUE,
	NVL(A.DEPRN_RESERVE,0) DEPRN_RESERVE,
	--NVL(NVL(A.Recoverable_Cost,0) - NVL(A.DEPRN_RESERVE,0),0) NET_BOOK_VALUE,
	Case When NVL(A.Recoverable_Cost,0) >= NVL(A.DEPRN_RESERVE,0)   THEN NVL(NVL(A.Recoverable_Cost,0) - NVL(A.DEPRN_RESERVE,0),0) ELSE 0 END NET_BOOK_VALUE,
	A.UNITS_RETIRED,
	--A.Reclass_Category,
	--Adjustment Adjustment_Details,
	--SALVAGE_VALUE Adjustment_AMT,
	--A.ACC_STRING,
	A.ATTRIBUTE1,
	A.ATTRIBUTE2,
	A.ATTRIBUTE3,
	A.ATTRIBUTE4,
	A.ATTRIBUTE5,
	A.ATTRIBUTE6,
	A.ATTRIBUTE7,
	A.ATTRIBUTE8,
	A.ATTRIBUTE9,
	A.ATTRIBUTE10,
	A.DEPRECIATE_FLAG

	From

	(Select 
	FB.BOOK_TYPE_CODE,
	FA.ASSET_ID,
	GCC.Segment1 Company_Code,
	FDP.FISCAL_YEAR,
	FTH.TRANSACTION_HEADER_ID Document_Number,
	FTH.TRANSACTION_TYPE_CODE TRANSACTION_TYPE,
	TO_CHAR(FTH.TRANSACTION_DATE_ENTERED, 'mm/dd/yyyy') TRANSACTION_DATE,
	GCC.Segment4 Cost_Center,
	GCC.Segment5 Trading_partner,

	/* (Select Max(Period_Name)  
	--B.Period_Name
	From fa_deprn_Detail A, fa_deprn_periods B  Where A.Asset_Id = FB.Asset_Id
	 And A.period_counter = B.period_counter And A.BOOK_TYPE_CODE = b.BOOK_TYPE_CODE
	 And A.BOOK_TYPE_CODE = :P_BOOK_TYPE_CODE  And A.Deprn_Source_COde = 'D' -- And period_name <= :P_PERIOD_NAME
	 AND A.period_counter = FDP.PERIOD_COUNTER
	 AND Rownum = 1
	 ) as  Depreciation_Period, */

	 NULL Depreciation_Period, 
	 
			
	/*    (SELECT Distinct ACCOUNTING_DATE FROM xla_ae_headers WHERE (event_id = FTH.event_id) 
	OR ((NVL(FTH.TRANSACTION_TYPE_CODE,'NA') != 'TRANSFER IN' AND  	FTH.event_id is null) AND NVL(event_id, 'NA') IN (SELECT DISTINCT NVL(event_id, 'NA')
							FROM fa_deprn_summary
						   WHERE asset_id = FA.ASSET_ID
							 AND book_type_code = FB.book_type_code
							 AND PERIOD_COUNTER = FDP.PERIOD_COUNTER
							 AND ROWNUM =1 ))
	AND RowNum =1
	) Posting_Date,     */
	(Case when (NVL(FTH.TRANSACTION_TYPE_CODE,'NA') != 'TRANSFER IN' AND FTH.event_id is null) THEN 
				(SELECT Distinct ACCOUNTING_DATE FROM xla_ae_headers
				 WHERE NVL(event_id, -1) IN (SELECT DISTINCT NVL(event_id, -1)
							FROM fa_deprn_summary
						   WHERE asset_id = FA.ASSET_ID
							 AND book_type_code = FB.book_type_code
							 AND PERIOD_COUNTER = FDP.PERIOD_COUNTER
							 AND ROWNUM =1 )
				AND RowNum =1 )
		when (NVL(FTH.TRANSACTION_TYPE_CODE,'NA') != 'TRANSFER IN' AND FTH.event_id is NOT null) THEN 
			((SELECT Distinct ACCOUNTING_DATE FROM xla_ae_headers WHERE event_id = FTH.event_id AND RowNum =1))
				
	END) Posting_Date,

	FA.ASSET_NUMBER,
	FAK.SEGMENT1 ASSET_KEY,
	TO_CHAR(FB.PRORATE_DATE, 'mm/dd/yyyy') PRORATE_DATE,
	FCB.SEGMENT1 MAJOR_CATEGORY,
	FCB.SEGMENT2 MINOR_CATEGORY,

	CASE WHEN FTH.TRANSACTION_TYPE_CODE = 'ADDITION' Then TO_CHAR(FTH.DATE_EFFECTIVE, 'mm/dd/yyyy') END Capitalization_Date,

	FL.Segment1 as COUNTRY,
	FL.Segment2 as City,
	FL.Segment3 as PROPERTY,
	FL.Segment4 as AREA,
	FL.Segment5 as L_FLOOR,

	(Select VENDOR_NUMBER From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code = FB.book_type_code And Rownum=1 ) VENDOR_NUMBER,
	(Select vendor_Name From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code = FB.book_type_code And Rownum=1 ) VENDOR_NAME,
	FA.MANUFACTURER_NAME,
	FA.ATTRIBUTE3 Original_Asset_Number,
	FDH.UNITS_ASSIGNED Quantity,
	NVL(EXP_TRX.TRANSACTION_UNITS,0) Transfer_Units,
	EXP_TRX.EXP_TRX EXPENSE_ACCOUNT_TRX,
	FA.Attribute1 Inventory_num,

	FAT.DESCRIPTION,
	FA.Serial_Number,
	TO_CHAR(FB.DEPRN_START_DATE, 'mm/dd/yyyy') DEPRN_START_DATE,

	(CASE WHEN (METH.LIFE_IN_MONTHS > 11) then CAST(REGEXP_SUBSTR((METH.LIFE_IN_MONTHS/12),'[^(.)]+') AS INT) else 0 END) Useful_Life_Year,   

	(CASE WHEN (METH.LIFE_IN_MONTHS > 11) then (mod(METH.LIFE_IN_MONTHS, 12)) Else METH.LIFE_IN_MONTHS END) Useful_Life_Period,

	FB.SALVAGE_VALUE Scrap_value,
	FB.PERCENT_SALVAGE_VALUE Scrap_Value_Percent,

	0 YTD_ORD_Depn,
	0 YTD_ADJ_Depn,
	0 YTD_UNPLAN_Depn,

	0 Mnth_Depn,
	0 Mnth_ADJ_Depn,
	0 Mnth_UNPLAN_Depn,
	
	(SELECT Distinct gcc1.segment2 
	FROM fa_additions_b faab,
		 fa_categories_b fcbb,
		 fa_category_books fcbk,
		 gl_code_combinations gcc1
	 WHERE 1=1
	 AND faab.asset_category_id = fcbb.category_id
	 AND fcbb.category_id = fcbk.category_id
	 AND fcbk.ASSET_COST_ACCOUNT_CCID = gcc1.code_combination_id
	 AND faab.asset_id = FA.asset_id
	 AND fcbk.book_type_code = FB.book_type_code 
	 AND ROWNUM = 1) APC_GL_Acc,
	 
	(SELECT Distinct gcc1.segment2 
	FROM fa_additions_b faab,
		 fa_categories_b fcbb,
		 fa_category_books fcbk,
		 gl_code_combinations gcc1
	 WHERE 1=1
	 AND faab.asset_category_id = fcbb.category_id
	 AND fcbb.category_id = fcbk.category_id
	 AND fcbk.RESERVE_ACCOUNT_CCID = gcc1.code_combination_id
	 AND faab.asset_id = FA.asset_id
	 AND fcbk.book_type_code = FB.book_type_code
	 AND ROWNUM = 1
	 ) Acc_Depr_GL_Acc,

	(SELECT DISTINCT gcc1.segment2 
	FROM fa_additions_b faab,
		 fa_categories_b fcbb,
		 fa_category_books fcbk,
		 gl_code_combinations gcc1
	 WHERE 1=1
	 AND faab.asset_category_id = fcbb.category_id
	 AND fcbb.category_id = fcbk.category_id
	 AND fcbk.DEPRN_EXPENSE_ACCOUNT_CCID = gcc1.code_combination_id
	 AND faab.asset_id = FA.asset_id
	 AND fcbk.book_type_code = FB.book_type_code
	 AND ROWNUM = 1
	 ) Depr_GL_Acc,


	(select Distinct RSH.RECEIPT_NUM
		from 
			FA_ASSET_INVOICES FAI,
			AP_INVOICES_ALL AIA,
			RCV_SHIPMENT_HEADERS RSH,
			PO_LINES_ALL PLA,
			PO_HEADERS_ALL PHA,
			RCV_TRANSACTIONS RT
		where 1=1
			AND FAI.INVOICE_ID = AIA.INVOICE_ID
			AND AIA.PO_HEADER_ID = PHA.PO_HEADER_ID
			AND RT.PO_HEADER_ID= PHA.PO_HEADER_ID
			and RT.PO_LINE_ID = PLA.PO_LINE_ID
			and RSH.SHIPMENT_HEADER_ID = RT.TRANSACTION_ID
			AND FAI.Asset_id = FA.Asset_id  
			And FAI.book_type_code = FB.book_type_code 
			AND Rownum = 1
	) GR_Document_No,

	(select Distinct TO_CHAR(RT.CREATION_DATE, 'mm/dd/yyyy')
		from 
			FA_ASSET_INVOICES FAI,
			AP_INVOICES_ALL AIA,
			RCV_SHIPMENT_HEADERS RSH,
			PO_LINES_ALL PLA,
			PO_HEADERS_ALL PHA,
			RCV_TRANSACTIONS RT
		where 1=1
			AND FAI.INVOICE_ID = AIA.INVOICE_ID
			AND AIA.PO_HEADER_ID = PHA.PO_HEADER_ID
			AND RT.PO_HEADER_ID= PHA.PO_HEADER_ID
			and RT.PO_LINE_ID = PLA.PO_LINE_ID
			and RSH.SHIPMENT_HEADER_ID = RT.TRANSACTION_ID
			AND FAI.Asset_id = FA.Asset_id  
			And FAI.book_type_code = FB.book_type_code 
			AND Rownum = 1
	) GR_Date,

	(Select Distinct PO_NUMBER From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code = FB.book_type_code And Rownum=1 ) PO_Number,
	   
	TO_CHAR(FRT.DATE_RETIRED, 'mm/dd/yyyy') Disposal_Date,
	CASE WHEN (FRT.DATE_RETIRED IS NOT NULL) THEN 'Y' ELSE 'N' END Disposal_FLAG,
	FRT.PROCEEDS_OF_SALE Sales_Proceed,
	CASE WHEN FTH.TRANSACTION_TYPE_CODE = 'REINSTATEMENT' THEN NVL(FRT1.GAIN_LOSS_AMOUNT,0) * (-1) ELSE FRT.GAIN_LOSS_AMOUNT END Gain_or_Loss_on_Disposal,
	CASE WHEN FTH.TRANSACTION_TYPE_CODE = 'REINSTATEMENT' THEN NVL(FRT1.COST_RETIRED,0) * (-1) ELSE FRT.COST_RETIRED END Cost_Disposal,
	--FRT.STL_DEPRN_AMOUNT Acc_Depr_Disposal,
	--NVL(FRT.COST_RETIRED,0)-nvl(FRT.NBV_RETIRED,0) Acc_Depr_Disposal,
	CASE WHEN FTH.TRANSACTION_TYPE_CODE = 'REINSTATEMENT' THEN (NVL(FRT1.COST_RETIRED,0) * (-1)) + ABS(NVL(FRT1.GAIN_LOSS_AMOUNT,0) * (-1))
			ELSE nvl(FRT.COST_RETIRED,0)-ABS(NVL(FRT.GAIN_LOSS_AMOUNT,0)) END Acc_Depr_Disposal,

	CASE WHEN FTH.TRANSACTION_TYPE_CODE = 'TRANSFER' Then (Select TO_CHAR(FATV.TRANSACTION_DATE_ENTERED, 'mm/dd/yyyy') From FA_ASSET_TRANSFER_V FATV Where FATV.Asset_id = FA.Asset_id  
	   And FATV.book_type_code = FB.book_type_code And Rownum=1) END Transfer_Date,

	EXP_TRX.COST  as Cost,
	EXP_TRX.Accum_Depn as Accum_Depn,

	Nvl((Select 
			SUM(fi.ADJUSTMENT_AMOUNT) tot_cost
		FROM
			FA_ADJUSTMENTS fi , fa_transaction_headers fths1
		WHERE 1=1
			AND fi.asset_id = fths1.asset_id
			AND fi.book_type_code = fths1.book_type_code
			AND fths1.TRANSACTION_HEADER_ID = fi.TRANSACTION_HEADER_ID
			AND FI.SOURCE_TYPE_CODE = 'ADJUSTMENT'
			AND FI.ADJUSTMENT_TYPE = 'IMPAIR EXPENSE'
			AND FTHS1.TRANSACTION_HEADER_ID = FTH.TRANSACTION_HEADER_ID
			AND PERIOD_COUNTER_CREATED <= 
			(Select PERIOD_COUNTER from fa_deprn_periods fdp1 Where fdp1.period_name = :P_period_name and book_type_code = :P_book_type_code)
			AND fi.asset_id = FA.asset_id
			AND fi.book_type_code = FB.book_type_code
			AND NVL(FI.ADJUSTMENT_AMOUNT,0) != 0
		),0) Impairment_Expense,

	Nvl((Select 
			SUM(fi.ADJUSTMENT_AMOUNT) tot_cost
		FROM
			FA_ADJUSTMENTS fi , fa_transaction_headers fths1
		WHERE 1=1
			AND fi.asset_id = fths1.asset_id
			AND fi.book_type_code = fths1.book_type_code
			AND fths1.TRANSACTION_HEADER_ID = fi.TRANSACTION_HEADER_ID
			AND FI.SOURCE_TYPE_CODE = 'ADJUSTMENT'
			AND FI.ADJUSTMENT_TYPE = 'IMPAIR RESERVE'
			AND FTHS1.TRANSACTION_HEADER_ID = FTH.TRANSACTION_HEADER_ID
			AND PERIOD_COUNTER_CREATED <= 
			(Select PERIOD_COUNTER from fa_deprn_periods fdp1 Where fdp1.period_name = :P_period_name and book_type_code = :P_book_type_code)
			AND fi.asset_id = FA.asset_id
			AND fi.book_type_code = FB.book_type_code
			AND NVL(FI.ADJUSTMENT_AMOUNT,0) != 0
		),0) Impairment_Reserve,

	CASE WHEN FTH.TRANSACTION_TYPE_CODE = 'CIP ADDITION' Then FB.CIP_COST ELSE 0 END CIP_Addition,
	CASE WHEN (FTH.TRANSACTION_TYPE_CODE = 'ADDITION') Then FB.CIP_COST ELSE 0 END Capitalization_from_CIP,

	CASE WHEN FTH.TRANSACTION_TYPE_CODE = 'ADDITION' Then (NVL((SELECT SUM(FBKS1.COST) TOT_COST
	FROM fa_books fbks1,
	fa_transaction_headers fths1,
	fa_transactions_v ftv1
	WHERE fbks1.book_type_code = fths1.book_type_code
	AND fbks1.transaction_header_id_in = fths1.transaction_header_id
	AND UPPER(fths1.transaction_type_code) = 'ADDITION'
	And fths1.asset_id = ftv1.asset_id
	And fths1.book_type_code = ftv1.book_type_code
	And fths1.transaction_header_id = ftv1.transaction_header_id
	AND fths1.asset_id = fa.asset_id
	AND fths1.book_type_code = FB.book_type_code
	AND TO_CHAR(TO_Date(ftv1.period_name,'YYYY-MM'), 'YYYY') = TO_CHAR(TO_Date(:P_PERIOD_NAME,'YYYY-MM'), 'YYYY')
	AND TO_CHAR(TO_Date(ftv1.period_name,'YYYY-MM'), 'MM') Between 01 AND 12
	),0) ) END Cost_Addition,

	Case when FA.ASSET_TYPE = 'CIP' THEN FTH.TRANSACTION_HEADER_ID END AUC_No,
	Case When FTH.TRANSACTION_TYPE_CODE = 'RECLASS' Then RECLASS_TRX.COST_RECLASS  END Cost_Reclass,
	Case When FTH.TRANSACTION_TYPE_CODE = 'RECLASS' Then RECLASS_TRX.ACC_DEPN_RECLASS  END ACC_DEPN_RECLASS,
	Case When FTH.TRANSACTION_TYPE_CODE = 'RECLASS' Then FTH.TRANSACTION_HEADER_ID END Reclass_No,

	   
	(
	Select CASE WHEN (mon > 11) then CAST(REGEXP_SUBSTR((mon/12),'[^(.)]+') AS INT) else 0 END
	 FROM
	(
	SELECT
	decode(FB.conversion_date,
						NULL,
						( SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
	  WHERE 1=1  AND METH.METHOD_ID = FB.METHOD_ID
	  AND ROWNUM =1) -
						floor(months_between(fdp1.calendar_period_close_date,
											 FB.prorate_date)),
											 
					   (  SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
	  WHERE 1=1  AND METH.METHOD_ID = FB.METHOD_ID
	  AND ROWNUM =1)  -
						floor(months_between(fdp1.calendar_period_close_date,
											 FB.deprn_start_date))) MON
	FROM
	fa_deprn_periods fdp1
	  WHERE 1=1
			AND FB.book_type_code = fdp1.book_type_code 
			 AND FB.date_ineffective IS NULL
			 AND fdp1.period_counter = (SELECT MAX(dp.period_counter)
					FROM fa_deprn_periods dp
					WHERE dp.book_type_code = fdp1.book_type_code
					AND DP.period_name = :P_PERIOD_NAME)
	) ) Remain_Useful_Life_Year,

	(
	Select CASE WHEN (mon > 11) then (mod(mon, 12)) Else Mon END
	 FROM
	(
	SELECT
	decode(FB.conversion_date,
						NULL,
						( SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
	  WHERE 1=1  AND METH.METHOD_ID = FB.METHOD_ID
	  AND ROWNUM =1) -
						floor(months_between(fdp1.calendar_period_close_date,
											 FB.prorate_date)),
											 
					   (  SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
	  WHERE 1=1  AND METH.METHOD_ID = FB.METHOD_ID
	  AND ROWNUM =1)  -
						floor(months_between(fdp1.calendar_period_close_date,
											 FB.deprn_start_date))) MON
	FROM
	fa_deprn_periods fdp1
	  WHERE 1=1
			AND FB.book_type_code = fdp1.book_type_code 
			 AND FB.date_ineffective IS NULL
			 AND fdp1.period_counter = (SELECT MAX(dp.period_counter)
					FROM fa_deprn_periods dp
					WHERE dp.book_type_code = fdp1.book_type_code
					AND DP.period_name = :P_PERIOD_NAME)
	) ) Remain_Useful_Life_Period,

	(Select FM.Prorate_Convention_Code From fa_convention_types FM Where FM.Convention_Type_Id = FB.Convention_Type_Id and rownum=1) as Prorate_Convention,
	FA.ASSET_TYPE,
	METH.METHOD_CODE Depreciation_Method,

	0 Cost_PRE_YEAR,
	0 AccDep_PRE_YEAR,
	0 Recoverable_Cost,
	0 DEPRN_RESERVE,
			  
	NVL(FRT.UNITS,0) UNITS_RETIRED,
	Case when (NVL(FTH.TRANSACTION_TYPE_CODE,'NA') = 'RECLASS') THEN RECLASS_TRX.Reclass_Category END Reclass_Category,
	Adjustment.Adjustment,
	Adjustment.SALVAGE_VALUE,

	(Case when (NVL(FTH.TRANSACTION_TYPE_CODE,'NA') != 'TRANSFER IN' AND FTH.event_id is null) THEN 
				(Select LISTAGG(ACC_STRING, ', ') WITHIN GROUP (ORDER BY ACC_STRING) ACC_STRING
				  From
					(				
					SELECT CASE When GCC.segment1 is not null THEN 
					XAL.ACCOUNTING_CLASS_CODE||' - '||GCC.SEGMENT3||' - '||(SELECT Distinct ffvt.description
							FROM fnd_flex_values_tl ffvt,
								fnd_flex_values ffv,
								fnd_id_flex_segments fifs
							WHERE ffv.flex_value_id = ffvt.flex_value_id
								AND fifs.flex_value_set_id = ffv.flex_value_set_id
								AND fifs.segment_name in  ('Movement Type')
								AND fifs.id_flex_code = 'GL#'
								AND ffv.flex_value = GCC.SEGMENT3)
					END ACC_STRING
					FROM xla_ae_headers XAH,XLA_AE_LINES XAL, gl_code_combinations GCC
					WHERE 1=1
					AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
					AND XAL.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
					--AND XAL.ENTERED_DR is not NULL
					AND GCC.SEGMENT2 like '1%'
					AND NVL(XAH.event_id, -1) IN (SELECT DISTINCT NVL(event_id, -1)
							FROM fa_deprn_summary
						   WHERE asset_id = FA.ASSET_ID
							 AND book_type_code = FB.book_type_code
							 AND PERIOD_COUNTER = FDP.PERIOD_COUNTER
							 --AND ROWNUM =1 
							 )
				--AND RowNum =1 
				))
		when (NVL(FTH.TRANSACTION_TYPE_CODE,'NA') != 'TRANSFER IN' AND FTH.event_id is NOT null) THEN 
			((Select LISTAGG(ACC_STRING, ', ') WITHIN GROUP (ORDER BY ACC_STRING) ACC_STRING
					From
					(
					SELECT CASE When GCC.segment1 is not null THEN 
					XAL.ACCOUNTING_CLASS_CODE||' - '||GCC.SEGMENT3||' - '||(SELECT Distinct ffvt.description
							FROM fnd_flex_values_tl ffvt,
								fnd_flex_values ffv,
								fnd_id_flex_segments fifs
							WHERE ffv.flex_value_id = ffvt.flex_value_id
								AND fifs.flex_value_set_id = ffv.flex_value_set_id
								AND fifs.segment_name in  ('Movement Type')
								AND fifs.id_flex_code = 'GL#'
								AND ffv.flex_value = GCC.SEGMENT3)
					END ACC_STRING
					FROM xla_ae_headers XAH,XLA_AE_LINES XAL, gl_code_combinations GCC
					WHERE 1=1
					AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
					AND XAL.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
					--AND XAL.ENTERED_DR is not NULL
					AND GCC.SEGMENT2 like '1%'
					AND XAH.event_id = FTH.event_id
					--AND RowNum =1
					)))
				
	END) ACC_STRING,

	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE1 END ATTRIBUTE1,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE2 END ATTRIBUTE2,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE3 END ATTRIBUTE3,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE4 END ATTRIBUTE4,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE5 END ATTRIBUTE5,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE6 END ATTRIBUTE6,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE7 END ATTRIBUTE7,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE8 END ATTRIBUTE8,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE9 END ATTRIBUTE9,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE_NUMBER1 END ATTRIBUTE10,
	FB.DEPRECIATE_FLAG



	FROM
	FA_ADDITIONS_B FA,
	FA_ADDITIONS_TL FAT,
	FA_ASSET_KEYWORDS FAK,
	(Select FTH.ASSET_ID , FTH.BOOK_TYPE_CODE, FTH.TRANSACTION_HEADER_ID , FTH.TRANSACTION_TYPE_CODE,
	FTH.TRANSACTION_DATE_ENTERED, FTH.DATE_EFFECTIVE, FTH.event_id, FTRV.PERIOD_COUNTER From FA_TRANSACTION_HEADERS FTH,FA_TRANSACTIONS_V FTRV 
	WHERE 1=1 And FTH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	AND fth.book_type_code = :P_BOOK_TYPE_CODE
	--AND FTRV.period_name <= :P_PERIOD_NAME
	AND FTRV.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	AND FTRV.period_name <= :P_PERIOD_NAME
	--AND ((:P_SUPRESS = 'N' AND FTRV.PERIOD_NAME = :P_PERIOD_NAME ) OR (:P_SUPRESS = 'Y' AND FTRV.PERIOD_NAME <= :P_PERIOD_NAME ) )
	) FTH,

	FA_BOOKS FB,
	--FA_DEPRN_PERIODS FDP,
	(SELECT PERIOD_COUNTER, period_name, FISCAL_YEAR , BOOK_TYPE_CODE , period_num FROM FA_DEPRN_PERIODS WHERE 1=1 
	AND BOOK_TYPE_CODE =  :P_BOOK_TYPE_CODE 
	--AND period_name <= :P_PERIOD_NAME
	AND period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	AND period_name <= :P_PERIOD_NAME
	--AND ((:P_SUPRESS = 'N' AND PERIOD_NAME = :P_PERIOD_NAME ) OR (:P_SUPRESS = 'Y' AND PERIOD_NAME <= :P_PERIOD_NAME ) )
	 ) FDP,
	FA_CATEGORIES_B FCB,
	FA_CATEGORY_BOOKS FCATB,
	--FA_DISTRIBUTION_HISTORY FDH,
	( Select FDH1.*
	from FA_DISTRIBUTION_HISTORY FDH1, FA_ADDITIONS_B FA1
	Where 1=1
	AND FA1.ASSET_ID = FDH1.ASSET_ID
	AND FDH1.DATE_INEFFECTIVE IS NULL
	AND FDH1.LOCATION_ID in (Select Max(FMA.LOCATION_ID) From  FA_DISTRIBUTION_HISTORY FMA
							Where 1=1 And FMA.Asset_Id = FDH1.Asset_Id And FMA.BOOK_TYPE_CODE = FDH1.BOOK_TYPE_CODE
							AND FMA.DATE_INEFFECTIVE IS NULL) ) FDH,
	Gl_Code_Combinations GCC,
	FA_LOCATIONS FL,
	--( Select Asset_id, BOOK_TYPE_CODE , VENDOR_NUMBER, VENDOR_NAME, PO_NUMBER From FA_ASSET_INVOICES Where INVOICE_LINE_TYPE = 'ITEM') FAI
	FA_METHODS METH,
	FA_RETIREMENTS FRT,
	FA_RETIREMENTS FRT1,
	(SELECT BOOK_TYPE_CODE , ASSET_ID , TRANSACTION_HEADER_ID, TRANSACTION_HEADER_ID_IN, TRANSACTION_HEADER_ID_OUT,
	(METHOD_CODE||LIFE_IN_MONTHS||DATE_PLACED_IN_SERVICE||PRORATE_CONVENTION||PRORATE_DATE||BASIC_RATE||Sus_Depreciation||SALVAGE_VALUE||
	--Unplan_Deprec||RECOVERABLE_COST
	(CASE WHEN (Unplan_Deprec1 IS not null AND RECOVERABLE_COST1 is NOT NULL) THEN
	RECOVERABLE_COST ELSE Unplan_Deprec END)
	||CURRENT_COST||Amortized) AS Adjustment ,
	--(SALVAGE_VALUE||ADJUSTED_COST||RECOVERABLE_COST||CURRENT_COST) As SALVAGE_VALUE
	--(RECOVERABLE_COST1||CURRENT_COST1||Unplan_Deprec1) As SALVAGE_VALUE
	--(RECOVERABLE_COST1) As SALVAGE_VALUE
	CASE WHEN (RECOVERABLE_COST1 IS not null AND Unplan_Deprec1 is NOT NULL ) THEN
	RECOVERABLE_COST1 ELSE Unplan_Deprec1 END As SALVAGE_VALUE
	FROM
	(
	Select 
	A.BOOK_TYPE_CODE , A.ASSET_ID , A.TRANSACTION_HEADER_ID, A.TRANSACTION_HEADER_ID_IN, A.TRANSACTION_HEADER_ID_OUT, 
	Decode(A.B_DATE_PLACED_IN_SERVICE, A.A_DATE_PLACED_IN_SERVICE, NULL, 'In Service Date'||'; ') DATE_PLACED_IN_SERVICE,
	Decode(A.B_SALVAGE_VALUE, A.A_SALVAGE_VALUE, NULL , 'Salvage Value'||'; ') SALVAGE_VALUE,
	Decode(A.B_PRORATE_DATE, A.A_PRORATE_DATE, NULL , 'Prorate Date'||'; ') PRORATE_DATE, 
	Decode(A.B_METHOD_CODE, A.A_METHOD_CODE , NULL , 'Depreciation Method'||'; ') METHOD_CODE,
	Decode(A.B_LIFE_IN_MONTHS, A.A_LIFE_IN_MONTHS, NULL , 'Life in Months'||'; ') LIFE_IN_MONTHS,
	Decode(A.B_BASIC_RATE, A.A_BASIC_RATE, NULL, 'Basic Rate'||'; ') BASIC_RATE,
	Decode(A.B_PRORATE_CONVENTION, A.A_PRORATE_CONVENTION, NULL, 'Prorate Convention'||'; ') PRORATE_CONVENTION,
	Decode(A.B_RECOVERABLE_COST, A.A_RECOVERABLE_COST, NULL, 'Recoverable Cost'||'; ') RECOVERABLE_COST,
	Decode(A.B_RECOVERABLE_COST, A.A_RECOVERABLE_COST, NULL, (A.A_RECOVERABLE_COST-A.B_RECOVERABLE_COST)) RECOVERABLE_COST1,
	Decode(A.B_COST, A.A_COST, NULL, 'Cost'||'; ') CURRENT_COST,
	Decode(A.B_COST, A.A_COST, NULL, (A.A_COST-A.B_COST)) CURRENT_COST1,
	Decode(A.B_DEPRECIATE_FLAG, A.A_DEPRECIATE_FLAG, NULL, 'Suspend Depreciation'||'; ') Sus_Depreciation,
	'Amortized'||' - '||A.Amortized||'; ' Amortized,
	DECODE(A.UNPLANNED_DEPRN_AMOUNT, '', NULL, 'Unplanned Depreciation'||'; ') Unplan_Deprec,
	DECODE(A.UNPLANNED_DEPRN_AMOUNT, '', NULL, A.UNPLANNED_DEPRN_AMOUNT) Unplan_Deprec1

	 
	FROM  
	(
	Select 
	 FB.BOOK_TYPE_CODE , FB.ASSET_ID , FTH.TRANSACTION_HEADER_ID,
	 FB.DATE_PLACED_IN_SERVICE B_DATE_PLACED_IN_SERVICE, FB1.DATE_PLACED_IN_SERVICE A_DATE_PLACED_IN_SERVICE,
	 FB.SALVAGE_VALUE B_SALVAGE_VALUE, FB1.SALVAGE_VALUE A_SALVAGE_VALUE, 
	 FB.PRORATE_DATE B_PRORATE_DATE , FB1.PRORATE_DATE A_PRORATE_DATE ,
	 FB.TRANSACTION_HEADER_ID_IN , FB.TRANSACTION_HEADER_ID_OUT,  
	 METH.METHOD_CODE B_METHOD_CODE ,  METH1.METHOD_CODE A_METHOD_CODE ,
	 METH.LIFE_IN_MONTHS B_LIFE_IN_MONTHS,  METH1.LIFE_IN_MONTHS A_LIFE_IN_MONTHS,
	 NVL(FFR.BASIC_RATE,0) * 100 B_BASIC_RATE, NVL(FFR1.BASIC_RATE,0) *100 A_BASIC_RATE, 
	 FCT.PRORATE_CONVENTION_CODE B_PRORATE_CONVENTION, FCT1.PRORATE_CONVENTION_CODE A_PRORATE_CONVENTION,
	 --FB.ADJUSTED_COST B_ADJUSTED_COST, FB1.ADJUSTED_COST A_ADJUSTED_COST,
	 FB.RECOVERABLE_COST B_RECOVERABLE_COST, FB1.RECOVERABLE_COST A_RECOVERABLE_COST,
	 FB.COST B_COST, FB1.COST A_COST ,
	 (CASE WHEN FTH.AMORTIZATION_START_DATE is null THEN 'NO' WHEN FTH.AMORTIZATION_START_DATE is NOT null THEN 'YES' END)  Amortized,
	 FB.DEPRECIATE_FLAG B_DEPRECIATE_FLAG, FB1.DEPRECIATE_FLAG A_DEPRECIATE_FLAG,
	 NVL(ADJ.UNPLANNED_DEPRN_AMOUNT,ADJ1.UNPLANNED_DEPRN_AMOUNT) UNPLANNED_DEPRN_AMOUNT
	 
	FROM FA_BOOKS FB , FA_BOOKS FB1 , FA_METHODS METH, FA_METHODS METH1 , FA_FLAT_RATES FFR, FA_FLAT_RATES FFR1 , FA_TRANSACTION_HEADERS FTH,
	fa_convention_types FCT, fa_convention_types FCT1,
		(Select FA.TRANSACTION_HEADER_ID , FA.CODE_COMBINATION_ID, FAT.UNPLANNED_DEPRN_AMOUNT from FA_ADJUSTMENTS FA , FA_ADJUSTMENTS_T FAT
			Where 1=1
				AND FA.ASSET_ID = FAT.ASSET_ID
				AND FA.BOOK_TYPE_CODE = FAT.BOOK_TYPE_CODE
				AND FAT.TRANSACTION_TYPE_CODE = 'UNPLANNED'
				AND FA.CODE_COMBINATION_ID = FAT.CODE_COMBINATION_ID
		) ADJ,
		
		(Select FA.TRANSACTION_HEADER_ID , FA.CODE_COMBINATION_ID, FA.ADJUSTMENT_AMOUNT UNPLANNED_DEPRN_AMOUNT from FA_ADJUSTMENTS FA
			Where 1=1
				AND FA.SOURCE_TYPE_CODE = 'DEPRECIATION'
				AND FA.ADJUSTMENT_TYPE = 'EXPENSE'
		) ADJ1
	WHERE 1=1
	AND FB.METHOD_ID = METH.METHOD_ID(+)
	AND FB1.METHOD_ID = METH1.METHOD_ID(+)
	AND METH.METHOD_ID = FFR.METHOD_ID(+)
	AND FB.FLAT_RATE_ID = FFR.FLAT_RATE_ID(+)
	AND METH1.METHOD_ID = FFR1.METHOD_ID(+)
	AND FB1.FLAT_RATE_ID = FFR1.FLAT_RATE_ID(+)
	AND FB.asset_id = FB1.asset_id
	AND FB.CONVENTION_TYPE_ID = FCT.CONVENTION_TYPE_ID(+)
	AND FB.CONVENTION_TYPE_ID = FCT1.CONVENTION_TYPE_ID(+)
	AND FTH.TRANSACTION_TYPE_CODE in ('ADJUSTMENT', 'CIP ADJUSTMENT', 'GROUP ADJUSTMENT')
	AND FTH.TRANSACTION_HEADER_ID = FB.TRANSACTION_HEADER_ID_OUT
	AND FTH.TRANSACTION_HEADER_ID = FB1.TRANSACTION_HEADER_ID_IN
	AND FTH.TRANSACTION_HEADER_ID = ADJ.TRANSACTION_HEADER_ID(+)
	AND FTH.TRANSACTION_HEADER_ID = ADJ1.TRANSACTION_HEADER_ID(+)
	--AND FTH.asset_id IN (Select asset_id from FA_ADDITIONS_B  WHERE asset_number = '10019558')
	AND FB.BOOK_TYPE_CODE = :P_BOOK_TYPE_CODE
	AND FB1.BOOK_TYPE_CODE = :P_BOOK_TYPE_CODE
	Order by FB.TRANSACTION_HEADER_ID_IN
	) A
	)
	Where
	METHOD_CODE is not null OR LIFE_IN_MONTHS is not null OR DATE_PLACED_IN_SERVICE is not null OR PRORATE_CONVENTION is not null OR 
	PRORATE_DATE is not null OR BASIC_RATE is not null OR SALVAGE_VALUE is not null --OR ADJUSTED_COST is not null 
	OR CURRENT_COST is not null OR CURRENT_COST1 is not null or Amortized is not null or Sus_Depreciation is not null or RECOVERABLE_COST is not null or RECOVERABLE_COST1 is not null or Unplan_Deprec is not null
	 or Unplan_Deprec1 is not null) ADJUSTMENT,
	 
	 (Select FDH1.DISTRIBUTION_ID , FDH1.BOOK_TYPE_CODE, FDH1.ASSET_ID, FDH1.UNITS_ASSIGNED, ABS(NVL(FDH1.TRANSACTION_UNITS,FDH1.UNITS_ASSIGNED)) TRANSACTION_UNITS, FDH1.CODE_COMBINATION_ID,
			FDH1.TRANSACTION_HEADER_ID_IN, FTRV.PERIOD_COUNTER, 
			CASE WHEN GCC.SEGMENT1 is not NULL THEN GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6||'-'||GCC.SEGMENT7||'-'||GCC.SEGMENT8||'-'||GCC.SEGMENT9 END EXP_TRX,
			(Nvl((SELECT Sum(fdd1.Cost)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1,
		   fa_deprn_Detail fdd1,
		   FA_ASSET_TRANSFER_V FATV
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fdp1.period_counter = fdd1.period_counter
	   AND fds1.period_counter = fdd1.period_counter
	   AND fdp1.book_type_code = fdd1.book_type_code
	   AND fdd1.asset_id = fds1.asset_id
	   AND fa1.asset_id = FTH.Asset_id
	   AND fa1.asset_id = FATV.asset_id
	   AND fdp1.book_type_code = FATV.book_type_code
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   --AND FDD1.DISTRIBUTION_ID = FDH.DISTRIBUTION_ID
	   --AND FDD1.DISTRIBUTION_ID = EXP_TRX.DISTRIBUTION_ID
	   AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'YYYY') = TO_CHAR(TO_Date(:P_PERIOD_NAME,'YYYY-MM'), 'YYYY')
		AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'MM') Between 01 AND 12
	),0))   as Cost,
	(Nvl((SELECT SUM(fdd1.deprn_reserve)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1,
		   fa_deprn_Detail fdd1,
		   FA_ASSET_TRANSFER_V FATV
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fdp1.period_counter = fdd1.period_counter
	   AND fds1.period_counter = fdd1.period_counter
	   AND fdp1.book_type_code = fdd1.book_type_code
	   AND fdd1.asset_id = fds1.asset_id
	   AND fa1.asset_id = FATV.asset_id
	   AND fdp1.book_type_code = FATV.book_type_code
	   AND fa1.asset_id = FTH.Asset_id
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   --AND FDD1.DISTRIBUTION_ID = FDH.DISTRIBUTION_ID
	   --AND FDD1.DISTRIBUTION_ID = EXP_TRX.DISTRIBUTION_ID
	   AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'YYYY') = TO_CHAR(TO_Date(:P_PERIOD_NAME,'YYYY-MM'), 'YYYY')
		AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'MM') Between 01 AND 12
	),0)) as Accum_Depn
	from FA_DISTRIBUTION_HISTORY FDH1,  FA_TRANSACTION_HEADERS FTH, FA_TRANSACTIONS_V FTRV ,Gl_Code_Combinations GCC
	WHERE 1=1
	And FTH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	AND FTH.TRANSACTION_TYPE_CODE IN ('TRANSFER', 'TRANSFER OUT')
	AND FDH1.TRANSACTION_HEADER_ID_IN = FTH.TRANSACTION_HEADER_ID
	And FDH1.Code_Combination_Id = GCC.Code_Combination_Id(+)
	--AND FDH1.asset_id = 46019
	/* Union ALL
	Select FDH1.DISTRIBUTION_ID , FDH1.BOOK_TYPE_CODE, FDH1.ASSET_ID, FDH1.UNITS_ASSIGNED, FDH1.TRANSACTION_UNITS, FDH1.CODE_COMBINATION_ID,
			FDH1.TRANSACTION_HEADER_ID_OUT TRANSACTION_HEADER_ID_IN, FTRV.PERIOD_COUNTER, 
			CASE WHEN GCC.SEGMENT1 is not NULL THEN GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6||'-'||GCC.SEGMENT7||'-'||GCC.SEGMENT8||'-'||GCC.SEGMENT9 END EXP_TRX,
			(Nvl((SELECT Sum(fdd1.Cost)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1,
		   fa_deprn_Detail fdd1,
		   FA_ASSET_TRANSFER_V FATV
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fdp1.period_counter = fdd1.period_counter
	   AND fds1.period_counter = fdd1.period_counter
	   AND fdp1.book_type_code = fdd1.book_type_code
	   AND fdd1.asset_id = fds1.asset_id
	   AND fa1.asset_id = FTH.Asset_id
	   AND fa1.asset_id = FATV.asset_id
	   AND fdp1.book_type_code = FATV.book_type_code
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   --AND FDD1.DISTRIBUTION_ID = FDH.DISTRIBUTION_ID
	   --AND FDD1.DISTRIBUTION_ID = EXP_TRX.DISTRIBUTION_ID
	   AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'YYYY') = TO_CHAR(TO_Date(:P_PERIOD_NAME,'YYYY-MM'), 'YYYY')
		AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'MM') Between 01 AND 12
	),0)) *-1   as Cost,
	(Nvl((SELECT SUM(fdd1.deprn_reserve) 
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1,
		   fa_deprn_Detail fdd1,
		   FA_ASSET_TRANSFER_V FATV
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fdp1.period_counter = fdd1.period_counter
	   AND fds1.period_counter = fdd1.period_counter
	   AND fdp1.book_type_code = fdd1.book_type_code
	   AND fdd1.asset_id = fds1.asset_id
	   AND fa1.asset_id = FATV.asset_id
	   AND fdp1.book_type_code = FATV.book_type_code
	   AND fa1.asset_id = FTH.Asset_id
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   --AND FDD1.DISTRIBUTION_ID = FDH.DISTRIBUTION_ID
	   --AND FDD1.DISTRIBUTION_ID = EXP_TRX.DISTRIBUTION_ID
	   AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'YYYY') = TO_CHAR(TO_Date(:P_PERIOD_NAME,'YYYY-MM'), 'YYYY')
		AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'MM') Between 01 AND 12
	),0)) *-1 as Accum_Depn
	
	from FA_DISTRIBUTION_HISTORY FDH1,  FA_TRANSACTION_HEADERS FTH, FA_TRANSACTIONS_V FTRV ,Gl_Code_Combinations GCC 
	WHERE 1=1
	And FTH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	AND FTH.TRANSACTION_TYPE_CODE IN ('TRANSFER', 'TRANSFER OUT')
	AND FDH1.TRANSACTION_HEADER_ID_OUT = FTH.TRANSACTION_HEADER_ID
	And FDH1.Code_Combination_Id = GCC.Code_Combination_Id(+)
	--AND FDH1.asset_id = 46019
	 */) EXP_TRX,
	
	(Select FAH.BOOK_TYPE_CODE, FAH.ASSET_ID, FAH.CATEGORY_ID, FAH.TRANSACTION_HEADER_ID_IN, FTRV.PERIOD_COUNTER, (FCB1.SEGMENT1||'-'||FCB1.SEGMENT2) Reclass_Category,
	(Nvl((SELECT Sum(fdd1.Cost)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1,
		   fa_deprn_Detail fdd1,
		   FA_TRANSACTION_HEADERS FTH1
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fdp1.period_counter = fdd1.period_counter
	   AND fds1.period_counter = fdd1.period_counter
	   AND fdp1.book_type_code = fdd1.book_type_code
	   AND fdd1.asset_id = fds1.asset_id
	   AND fa1.asset_id = FTH.Asset_id
	   AND fa1.asset_id = FTH1.Asset_id
	   AND fdp1.book_type_code = FTH1.book_type_code
	   AND FTH1.TRANSACTION_TYPE_CODE = 'RECLASS'
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   AND fdp1.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	   AND fdp1.period_name <= :P_PERIOD_NAME
	   And fds1.period_counter = FTRV.PERIOD_COUNTER
	   And fdd1.Cost <> 0
	   ),0)) AS Cost_Reclass,
	   (Nvl((SELECT Sum(fdd1.deprn_reserve)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1,
		   fa_deprn_Detail fdd1,
		   FA_TRANSACTION_HEADERS FTH1
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fdp1.period_counter = fdd1.period_counter
	   AND fds1.period_counter = fdd1.period_counter
	   AND fdp1.book_type_code = fdd1.book_type_code
	   AND fdd1.asset_id = fds1.asset_id
	   AND fa1.asset_id = FTH.Asset_id
	   AND fa1.asset_id = FTH1.Asset_id
	   AND fdp1.book_type_code = FTH1.book_type_code
	   AND FTH1.TRANSACTION_TYPE_CODE = 'RECLASS'
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   AND fdp1.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	   AND fdp1.period_name <= :P_PERIOD_NAME
	   And fds1.period_counter = FTRV.PERIOD_COUNTER
	   And fdd1.deprn_reserve <> 0
	   ),0)) AS ACC_DEPN_RECLASS
	from FA_ASSET_HISTORY FAH,  FA_TRANSACTION_HEADERS FTH, FA_TRANSACTIONS_V FTRV, FA_CATEGORIES_B FCB1
	WHERE 1=1
	And FTH.asset_id = FTRV.asset_id
	And FAH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	AND FTH.TRANSACTION_TYPE_CODE IN ('RECLASS')
	AND FAH.TRANSACTION_HEADER_ID_IN = FTH.TRANSACTION_HEADER_ID
	AND FAH.CATEGORY_ID = FCB1.CATEGORY_ID 
	--AND FAH.asset_id = 42001
	/* Union ALL
	Select FAH.BOOK_TYPE_CODE, FAH.ASSET_ID, FAH.CATEGORY_ID, FAH.TRANSACTION_HEADER_ID_OUT TRANSACTION_HEADER_ID_IN, FTRV.PERIOD_COUNTER, (FCB1.SEGMENT1||'-'||FCB1.SEGMENT2) Reclass_Category,
	(Nvl((SELECT Sum(fdd1.Cost)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1,
		   fa_deprn_Detail fdd1,
		   FA_TRANSACTION_HEADERS FTH1
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fdp1.period_counter = fdd1.period_counter
	   AND fds1.period_counter = fdd1.period_counter
	   AND fdp1.book_type_code = fdd1.book_type_code
	   AND fdd1.asset_id = fds1.asset_id
	   AND fa1.asset_id = FTH.Asset_id
	   AND fa1.asset_id = FTH1.Asset_id
	   AND fdp1.book_type_code = FTH1.book_type_code
	   AND FTH1.TRANSACTION_TYPE_CODE = 'RECLASS'
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   AND fdp1.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	   AND fdp1.period_name <= :P_PERIOD_NAME
	   And fds1.period_counter = FTRV.PERIOD_COUNTER
	   And fdd1.Cost <> 0
	   ),0)) *-1 AS Cost_Reclass,
	   (Nvl((SELECT Sum(fdd1.deprn_reserve)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1,
		   fa_deprn_Detail fdd1,
		   FA_TRANSACTION_HEADERS FTH1
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fdp1.period_counter = fdd1.period_counter
	   AND fds1.period_counter = fdd1.period_counter
	   AND fdp1.book_type_code = fdd1.book_type_code
	   AND fdd1.asset_id = fds1.asset_id
	   AND fa1.asset_id = FTH.Asset_id
	   AND fa1.asset_id = FTH1.Asset_id
	   AND fdp1.book_type_code = FTH1.book_type_code
	   AND FTH1.TRANSACTION_TYPE_CODE = 'RECLASS'
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   AND fdp1.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	   AND fdp1.period_name <= :P_PERIOD_NAME
	   And fds1.period_counter = FTRV.PERIOD_COUNTER
	   And fdd1.deprn_reserve <> 0
	   ),0))* -1 AS ACC_DEPN_RECLASS
	from FA_ASSET_HISTORY FAH,  FA_TRANSACTION_HEADERS FTH, FA_TRANSACTIONS_V FTRV, FA_CATEGORIES_B FCB1
	WHERE 1=1
	And FTH.asset_id = FTRV.asset_id
	And FAH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	AND FTH.TRANSACTION_TYPE_CODE IN ('RECLASS')
	AND FAH.TRANSACTION_HEADER_ID_OUT = FTH.TRANSACTION_HEADER_ID
	AND FAH.CATEGORY_ID = FCB1.CATEGORY_ID 
	--AND FAH.asset_id = 42001
	 */) RECLASS_TRX	

	Where 1=1
	And FA.Asset_Number In (SELECT Distinct fa.asset_number
								FROM FA_ADDITIONS_B fa,
									 fa_deprn_periods fdp,
									 fa_deprn_summary fds
							WHERE fa.asset_id = fds.asset_id(+)
								AND fdp.period_counter = fds.period_counter(+)
								AND fdp.book_type_code = fds.book_type_code (+)
								And fdp.book_type_code= :P_BOOK_TYPE_CODE
								--And fdp.period_name <= :P_PERIOD_NAME
								AND fdp.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
								AND fdp.period_name <= :P_PERIOD_NAME
								--AND FDS.DEPRN_SOURCE_CODE = 'DEPRN'
								--AND ((:P_SUPRESS = 'N' AND FDP.PERIOD_NAME = :P_PERIOD_NAME ) OR (:P_SUPRESS = 'Y' AND FDP.PERIOD_NAME <= :P_PERIOD_NAME ) )
							)
	AND FA.ASSET_ID = FAT.ASSET_ID
	AND FAT.language = userenv('LANG')
	AND FA.ASSET_KEY_CCID = FAK.CODE_COMBINATION_ID(+)
	AND FA.ASSET_ID = FTH.ASSET_ID(+)
	And FB.BOOK_TYPE_CODE=FTH.BOOK_TYPE_CODE(+)


	AND FTH.PERIOD_COUNTER = FDP.PERIOD_COUNTER(+)

	AND FA.ASSET_ID = FB.ASSET_ID 
	AND FB.DATE_INEFFECTIVE IS NULL

	AND FB.BOOK_TYPE_CODE = FDP.BOOK_TYPE_CODE(+)

	AND FA.ASSET_CATEGORY_ID = FCB.CATEGORY_ID
	AND FCB.CATEGORY_ID = FCATB.CATEGORY_ID
	AND FB.BOOK_TYPE_CODE = FCATB.BOOK_TYPE_CODE

	AND FA.ASSET_ID = FDH.ASSET_ID(+)
	And FB.Book_TYpe_Code = FDH.Book_TYpe_Code(+)
	AND FDH.DATE_INEFFECTIVE IS NULL
	--AND FTH.TRANSACTION_HEADER_ID = FDH.TRANSACTION_HEADER_ID_IN(+)
	And FDH.Code_Combination_Id = GCC.Code_Combination_Id(+)

	And FDH.Location_id = FL.Location_Id(+)
	AND FB.METHOD_ID = METH.METHOD_ID(+)

	--AND FB.retirement_id = FRT.retirement_id(+)
	AND FB.book_type_code = FRT.book_type_code(+)
	AND FTH.asset_id = FRT.asset_id(+)
	And FTH.TRANSACTION_HEADER_ID = FRT.TRANSACTION_HEADER_ID_IN(+)

	--AND FB.retirement_id = FRT.retirement_id(+)
	AND FB.book_type_code = FRT1.book_type_code(+)
	AND FTH.asset_id = FRT1.asset_id(+)
	And FTH.TRANSACTION_HEADER_ID = FRT1.TRANSACTION_HEADER_ID_OUT(+)


	AND FTH.BOOK_TYPE_CODE = ADJUSTMENT.BOOK_TYPE_CODE(+)
	AND FTH.asset_id = ADJUSTMENT.ASSET_ID(+)
	AND FTH.TRANSACTION_HEADER_ID = ADJUSTMENT.TRANSACTION_HEADER_ID(+)

	And FB.Book_TYpe_Code = EXP_TRX.BOOK_TYPE_CODE(+)
	AND FA.ASSET_ID = EXP_TRX.ASSET_ID(+)
	AND FTH.PERIOD_COUNTER = EXP_TRX.PERIOD_COUNTER(+)
	And FTH.TRANSACTION_HEADER_ID = EXP_TRX.TRANSACTION_HEADER_ID_IN(+)
	
	And FB.Book_TYpe_Code = RECLASS_TRX.BOOK_TYPE_CODE(+)
	AND FA.ASSET_ID = RECLASS_TRX.ASSET_ID(+)
	AND FTH.PERIOD_COUNTER = RECLASS_TRX.PERIOD_COUNTER(+)
	And FTH.TRANSACTION_HEADER_ID = RECLASS_TRX.TRANSACTION_HEADER_ID_IN(+)

	--Parameter
	--AND FA.ASSET_NUMBER in ('10000067', '10000702','10000001', '10000028', '10000091' , '10000618' , '10000004')
	AND FB.BOOK_TYPE_CODE = :P_BOOK_TYPE_CODE  -- 'AU3051 COBK', ' AU3053 COBK' ,  'GB3299 COBK' , 'ID2352 COBK'
	--AND FDP.PERIOD_NAME <= :P_PERIOD_NAME
	AND FDP.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	AND FDP.period_name <= :P_PERIOD_NAME
	--AND ((:P_SUPRESS = 'N' AND FDP.PERIOD_NAME = :P_PERIOD_NAME ) OR (:P_SUPRESS = 'Y' AND FDP.PERIOD_NAME <= :P_PERIOD_NAME ) )
	AND NVL(GCC.Segment1,-1) = NVL(:P_COMPANY,NVL(GCC.Segment1,-1))
	AND NVL(FAK.SEGMENT1,-1) = NVL(:P_ASSET_KEY,NVL(FAK.SEGMENT1,-1))
	AND NVL(FCB.SEGMENT1,-1) = NVL(:P_MAJOR_CATEGORY,NVL(FCB.SEGMENT1,-1))
	AND NVL(FCB.SEGMENT2,-1) = NVL(:P_MINOR_CATEGORY,NVL(FCB.SEGMENT2,-1))
	AND FA.ASSET_NUMBER Between NVL(:P_ASSET_NO_FROM, FA.ASSET_NUMBER) AND NVL(:P_ASSET_NO_TO, FA.ASSET_NUMBER)
	--AND NVL(FTH.TRANSACTION_DATE_ENTERED,sysdate+1) Between NVL(:P_TRANS_FROM, NVL(FTH.TRANSACTION_DATE_ENTERED,sysdate-1)) AND NVL(:P_TRANS_TO, NVL(FTH.TRANSACTION_DATE_ENTERED,sysdate+2))
	--AND NVL(FTH.TRANSACTION_TYPE_CODE,-1) = NVL(:P_TRANS_TYPE ,NVL(FTH.TRANSACTION_TYPE_CODE,-1))
	AND 'Summary' = :P_REPORT_REVIEW

	Union ALL
	----For DEPRECIATION

	Select 
	FB.BOOK_TYPE_CODE,
	FA.ASSET_ID,
	GCC.Segment1 Company_Code,
	FDP.FISCAL_YEAR,
	NULL Document_Number,
	'DEPRECIATION' TRANSACTION_TYPE,
	NULL TRANSACTION_DATE,
	GCC.Segment4 Cost_Center,
	GCC.Segment5 Trading_partner,

	(Select Max(Period_Name)  
	--B.Period_Name
	From fa_deprn_Detail A, fa_deprn_periods B  Where A.Asset_Id = FB.Asset_Id
	 And A.period_counter = B.period_counter And A.BOOK_TYPE_CODE = b.BOOK_TYPE_CODE
	 And A.BOOK_TYPE_CODE = :P_BOOK_TYPE_CODE  And A.Deprn_Source_COde = 'D' -- And period_name <= :P_PERIOD_NAME
	 AND A.period_counter = FDP.PERIOD_COUNTER
	 AND Rownum = 1
	 ) as  Depreciation_Period,
			
	(SELECT Distinct ACCOUNTING_DATE FROM xla_ae_headers WHERE (event_id = FDS.event_id)) Posting_Date, 

	FA.ASSET_NUMBER,
	FAK.SEGMENT1 ASSET_KEY,
	TO_CHAR(FB.PRORATE_DATE, 'mm/dd/yyyy') PRORATE_DATE,
	FCB.SEGMENT1 MAJOR_CATEGORY,
	FCB.SEGMENT2 MINOR_CATEGORY,

	NULL Capitalization_Date,

	FL.Segment1 as COUNTRY,
	FL.Segment2 as City,
	FL.Segment3 as PROPERTY,
	FL.Segment4 as AREA,
	FL.Segment5 as L_FLOOR,

	(Select VENDOR_NUMBER From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code = FB.book_type_code And Rownum=1 ) VENDOR_NUMBER,
	(Select vendor_Name From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code = FB.book_type_code And Rownum=1 ) VENDOR_NAME,
	FA.MANUFACTURER_NAME,
	FA.ATTRIBUTE3 Original_Asset_Number,
	FDH.UNITS_ASSIGNED Quantity,
	0 Transfer_Units,
	NULL EXPENSE_ACCOUNT_TRX,
	FA.Attribute1 Inventory_num,

	FAT.DESCRIPTION,
	FA.Serial_Number,
	TO_CHAR(FB.DEPRN_START_DATE, 'mm/dd/yyyy') DEPRN_START_DATE,

	(CASE WHEN (METH.LIFE_IN_MONTHS > 11) then CAST(REGEXP_SUBSTR((METH.LIFE_IN_MONTHS/12),'[^(.)]+') AS INT) else 0 END) Useful_Life_Year,   

	(CASE WHEN (METH.LIFE_IN_MONTHS > 11) then (mod(METH.LIFE_IN_MONTHS, 12)) Else METH.LIFE_IN_MONTHS END) Useful_Life_Period,

	FB.SALVAGE_VALUE Scrap_value,
	FB.PERCENT_SALVAGE_VALUE Scrap_Value_Percent,

	Nvl((SELECT SUM(fds1.SYSTEM_DEPRN_AMOUNT)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fa1.asset_id = FB.Asset_id
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   --And fdp.period_name= :P_PERIOD_NAME
	   --AND fds1.period_counter = fdp.period_counter
	   AND fdp1.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	   AND fdp1.period_name <= FDP.period_name
	),0) as YTD_ORD_Depn,
	
	Nvl((SELECT SUM(fds1.DEPRN_ADJUSTMENT_AMOUNT)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fa1.asset_id = FB.Asset_id
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   --And fdp1.period_name= :P_PERIOD_NAME
	   --AND fds1.period_counter = fdp.period_counter
	   AND fdp1.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	   AND fdp1.period_name <= FDP.period_name
	),0) as YTD_ADJ_Depn,

	Nvl((Select SUM(FA1.ADJUSTMENT_AMOUNT) from FA_ADJUSTMENTS FA1,FA_DEPRN_PERIODS FDPP
			Where 1=1 AND Fa1.BOOK_TYPE_CODE = FDPP.BOOK_TYPE_CODE(+)
				AND Fa1.PERIOD_COUNTER_CREATED = FDPP.PERIOD_COUNTER(+)
				AND FA1.SOURCE_TYPE_CODE = 'DEPRECIATION'
				AND FA1.ADJUSTMENT_TYPE = 'EXPENSE'
				AND fa1.asset_id = FB.Asset_id
				And fa1.book_type_code= :P_BOOK_TYPE_CODE
				AND fdpp.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
				AND fdpp.period_name <= FDP.period_name
				AND FA1.ADJUSTMENT_LINE_ID = (SELECT MIN(ADJUSTMENT_LINE_ID) From FA_ADJUSTMENTS FA2 Where 1=1
													AND FA2.SOURCE_TYPE_CODE = 'DEPRECIATION'
													AND FA2.ADJUSTMENT_TYPE = 'EXPENSE'
													AND fa2.asset_id = fa1.asset_id
													And fa2.book_type_code = fa1.book_type_code
													AND Fa2.PERIOD_COUNTER_CREATED = FA1.PERIOD_COUNTER_CREATED
													)
	),0) as YTD_UNPLAN_Depn,

	Nvl((SELECT SUM(fds1.SYSTEM_DEPRN_AMOUNT)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fa1.asset_id = FB.Asset_id
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   --And fdp.period_name= :P_PERIOD_NAME
	   AND fds1.period_counter = fdp.period_counter
	),0) as Mnth_Depn,

	Nvl((SELECT SUM(fds1.DEPRN_ADJUSTMENT_AMOUNT)
	  FROM FA_ADDITIONS_B        fa1,
		   fa_deprn_periods    fdp1,
		   fa_deprn_summary fds1
	 WHERE fa1.asset_id = fds1.asset_id
	   AND fdp1.period_counter = fds1.period_counter
	   AND fdp1.book_type_code = fds1.book_type_code
	   AND fa1.asset_id = FB.Asset_id
	   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
	   --And fdp1.period_name= :P_PERIOD_NAME
	   AND fds1.period_counter = fdp.period_counter
	),0) Mnth_ADJ_Depn,

	Nvl((Select SUM(FA1.ADJUSTMENT_AMOUNT) from FA_ADJUSTMENTS FA1,FA_DEPRN_PERIODS FDPP
			Where 1=1 AND Fa1.BOOK_TYPE_CODE = FDPP.BOOK_TYPE_CODE(+)
				AND Fa1.PERIOD_COUNTER_CREATED = FDPP.PERIOD_COUNTER(+)
				AND FA1.SOURCE_TYPE_CODE = 'DEPRECIATION'
				AND FA1.ADJUSTMENT_TYPE = 'EXPENSE'
				AND fa1.asset_id = FB.Asset_id
				And fa1.book_type_code= :P_BOOK_TYPE_CODE
				AND fdpp.period_counter = fdp.period_counter
				AND FA1.ADJUSTMENT_LINE_ID = (SELECT MIN(ADJUSTMENT_LINE_ID) From FA_ADJUSTMENTS FA2 Where 1=1
													AND FA2.SOURCE_TYPE_CODE = 'DEPRECIATION'
													AND FA2.ADJUSTMENT_TYPE = 'EXPENSE'
													AND fa2.asset_id = fa1.asset_id
													And fa2.book_type_code = fa1.book_type_code
													AND Fa2.PERIOD_COUNTER_CREATED = FA1.PERIOD_COUNTER_CREATED
													)
	),0) Mnth_UNPLAN_Depn,

	(SELECT Distinct gcc1.segment2 
	FROM fa_additions_b faab,
		 fa_categories_b fcbb,
		 fa_category_books fcbk,
		 gl_code_combinations gcc1
	 WHERE 1=1
	 AND faab.asset_category_id = fcbb.category_id
	 AND fcbb.category_id = fcbk.category_id
	 AND fcbk.ASSET_COST_ACCOUNT_CCID = gcc1.code_combination_id
	 AND faab.asset_id = FA.asset_id
	 AND fcbk.book_type_code = FB.book_type_code 
	 AND ROWNUM = 1) APC_GL_Acc,
	 
	(SELECT Distinct gcc1.segment2 
	FROM fa_additions_b faab,
		 fa_categories_b fcbb,
		 fa_category_books fcbk,
		 gl_code_combinations gcc1
	 WHERE 1=1
	 AND faab.asset_category_id = fcbb.category_id
	 AND fcbb.category_id = fcbk.category_id
	 AND fcbk.RESERVE_ACCOUNT_CCID = gcc1.code_combination_id
	 AND faab.asset_id = FA.asset_id
	 AND fcbk.book_type_code = FB.book_type_code
	 AND ROWNUM = 1
	 ) Acc_Depr_GL_Acc,

	(SELECT DISTINCT gcc1.segment2 
	FROM fa_additions_b faab,
		 fa_categories_b fcbb,
		 fa_category_books fcbk,
		 gl_code_combinations gcc1
	 WHERE 1=1
	 AND faab.asset_category_id = fcbb.category_id
	 AND fcbb.category_id = fcbk.category_id
	 AND fcbk.DEPRN_EXPENSE_ACCOUNT_CCID = gcc1.code_combination_id
	 AND faab.asset_id = FA.asset_id
	 AND fcbk.book_type_code = FB.book_type_code
	 AND ROWNUM = 1
	 ) Depr_GL_Acc,


	(select Distinct RSH.RECEIPT_NUM
		from 
			FA_ASSET_INVOICES FAI,
			AP_INVOICES_ALL AIA,
			RCV_SHIPMENT_HEADERS RSH,
			PO_LINES_ALL PLA,
			PO_HEADERS_ALL PHA,
			RCV_TRANSACTIONS RT
		where 1=1
			AND FAI.INVOICE_ID = AIA.INVOICE_ID
			AND AIA.PO_HEADER_ID = PHA.PO_HEADER_ID
			AND RT.PO_HEADER_ID= PHA.PO_HEADER_ID
			and RT.PO_LINE_ID = PLA.PO_LINE_ID
			and RSH.SHIPMENT_HEADER_ID = RT.TRANSACTION_ID
			AND FAI.Asset_id = FA.Asset_id  
			And FAI.book_type_code = FB.book_type_code 
			AND Rownum = 1
	) GR_Document_No,

	(select Distinct TO_CHAR(RT.CREATION_DATE, 'mm/dd/yyyy')
		from 
			FA_ASSET_INVOICES FAI,
			AP_INVOICES_ALL AIA,
			RCV_SHIPMENT_HEADERS RSH,
			PO_LINES_ALL PLA,
			PO_HEADERS_ALL PHA,
			RCV_TRANSACTIONS RT
		where 1=1
			AND FAI.INVOICE_ID = AIA.INVOICE_ID
			AND AIA.PO_HEADER_ID = PHA.PO_HEADER_ID
			AND RT.PO_HEADER_ID= PHA.PO_HEADER_ID
			and RT.PO_LINE_ID = PLA.PO_LINE_ID
			and RSH.SHIPMENT_HEADER_ID = RT.TRANSACTION_ID
			AND FAI.Asset_id = FA.Asset_id  
			And FAI.book_type_code = FB.book_type_code 
			AND Rownum = 1
	) GR_Date,

	(Select Distinct PO_NUMBER From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code = FB.book_type_code And Rownum=1 ) PO_Number,
	   
	NULL Disposal_Date,
	(Select CASE WHEN (FRT.DATE_RETIRED IS NULL) THEN 'N' ELSE 'Y' END From FA_RETIREMENTS FRT Where 1=1 
	AND FB.book_type_code = FRT.book_type_code AND FA.asset_id = FRT.asset_id
	AND ROWNUM = 1) Disposal_FLAG,
	NULL Sales_Proceed,
	NULL Gain_or_Loss_on_Disposal,
	NULL Cost_Disposal,
	NULL Acc_Depr_Disposal,

	NULL Transfer_Date,
	NULL Cost,
	   
	NULL Accum_Depn,

	0 Impairment_Expense,
	0 Impairment_Reserve,

	NULL CIP_Addition,
	NULL Capitalization_from_CIP,

	NULL Cost_Addition,

	NULL AUC_No,
	NULL Cost_Reclass,
	NULL ACC_DEPN_RECLASS,
	NULL Reclass_No,

	   
	(
	Select CASE WHEN (mon > 11) then CAST(REGEXP_SUBSTR((mon/12),'[^(.)]+') AS INT) else 0 END
	 FROM
	(
	SELECT
	decode(FB.conversion_date,
						NULL,
						( SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
	  WHERE 1=1  AND METH.METHOD_ID = FB.METHOD_ID
	  AND ROWNUM =1) -
						floor(months_between(fdp1.calendar_period_close_date,
											 FB.prorate_date)),
											 
					   (  SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
	  WHERE 1=1  AND METH.METHOD_ID = FB.METHOD_ID
	  AND ROWNUM =1)  -
						floor(months_between(fdp1.calendar_period_close_date,
											 FB.deprn_start_date))) MON
	FROM
	fa_deprn_periods fdp1
	  WHERE 1=1
			AND FB.book_type_code = fdp1.book_type_code 
			 AND FB.date_ineffective IS NULL
			 AND fdp1.period_counter = (SELECT MAX(dp.period_counter)
					FROM fa_deprn_periods dp
					WHERE dp.book_type_code = fdp1.book_type_code
					AND DP.period_name = :P_PERIOD_NAME)
	) ) Remain_Useful_Life_Year,

	(
	Select CASE WHEN (mon > 11) then (mod(mon, 12)) Else Mon END
	 FROM
	(
	SELECT
	decode(FB.conversion_date,
						NULL,
						( SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
	  WHERE 1=1  AND METH.METHOD_ID = FB.METHOD_ID
	  AND ROWNUM =1) -
						floor(months_between(fdp1.calendar_period_close_date,
											 FB.prorate_date)),
											 
					   (  SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
	  WHERE 1=1  AND METH.METHOD_ID = FB.METHOD_ID
	  AND ROWNUM =1)  -
						floor(months_between(fdp1.calendar_period_close_date,
											 FB.deprn_start_date))) MON
	FROM
	fa_deprn_periods fdp1
	  WHERE 1=1
			AND FB.book_type_code = fdp1.book_type_code 
			 AND FB.date_ineffective IS NULL
			 AND fdp1.period_counter = (SELECT MAX(dp.period_counter)
					FROM fa_deprn_periods dp
					WHERE dp.book_type_code = fdp1.book_type_code
					AND DP.period_name = :P_PERIOD_NAME)
	) ) Remain_Useful_Life_Period,

	(Select FM.Prorate_Convention_Code From fa_convention_types FM Where FM.Convention_Type_Id = FB.Convention_Type_Id and rownum=1) as Prorate_Convention,
	FA.ASSET_TYPE,
	METH.METHOD_CODE Depreciation_Method,

	
	 (select SUM(fb1.RECOVERABLE_COST) from FA_BOOKS fb1, FA_DEPRN_PERIODS FDPP, FA_TRANSACTIONS_V FTRV
where 1=1
						AND FB1.BOOK_TYPE_CODE = FDPP.BOOK_TYPE_CODE(+)
						AND fb1.BOOK_TYPE_CODE = FB.book_type_code 
						AND fb1.ASSET_ID= FB.ASSET_ID
						AND fb1.RECOVERABLE_COST <> 0 
						and FB1.DATE_INEFFECTIVE IS NULL 
						AND FB1.TRANSACTION_HEADER_ID_IN = FTRV.TRANSACTION_HEADER_ID
						--AND FDPP.PERIOD_COUNTER = FTRV.PERIOD_COUNTER
						AND FTRV.PERIOD_COUNTER <= (Select Distinct PERIOD_COUNTER From FA_DEPRN_PERIODS FD Where 1=1 AND FD.BOOK_TYPE_CODE = fb1.BOOK_TYPE_CODE
										AND TO_CHAR(TO_Date(fd.period_name,'YYYY-MM'), 'YYYY') = TO_CHAR(TO_Date(:P_PERIOD_NAME,'YYYY-MM'), 'YYYY')-1
										AND TO_CHAR(TO_Date(fd.period_name,'YYYY-MM'), 'MM') = 12)
						AND TO_CHAR(TO_Date(fdpp.period_name,'YYYY-MM'), 'YYYY') = TO_CHAR(TO_Date(:P_PERIOD_NAME,'YYYY-MM'), 'YYYY')-1
						AND TO_CHAR(TO_Date(fdpp.period_name,'YYYY-MM'), 'MM') = 12
						)  Cost_PRE_YEAR,


	(Nvl((SELECT Sum(FDS1.DEPRN_RESERVE)
			  FROM FA_ADDITIONS_B        fa1,
				   fa_deprn_periods    fdp1,
				   fa_deprn_summary fds1
			 WHERE fa1.asset_id = fds1.asset_id
			   AND fdp1.period_counter = fds1.period_counter
			   AND fdp1.book_type_code = fds1.book_type_code
			   AND fa1.asset_id = FB.Asset_id
			   And fdp1.book_type_code= :P_BOOK_TYPE_CODE
			   AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'YYYY') = TO_CHAR(TO_Date(:P_PERIOD_NAME,'YYYY-MM'), 'YYYY')-1
			AND TO_CHAR(TO_Date(fdp1.period_name,'YYYY-MM'), 'MM') = 12
			),0) )  AccDep_PRE_YEAR,

	(CASE
		WHEN FB.ANNUAL_DEPRN_ROUNDING_FLAG = 'RET' and FB.PERIOD_COUNTER_FULLY_RETIRED > FDP.period_counter
			THEN  (select SUM(fb1.RECOVERABLE_COST) from FA_BOOKS fb1 where 1=1
				AND fb1.BOOK_TYPE_CODE = FB.book_type_code 
				AND FB.ASSET_ID = fb1.ASSET_ID AND fb1.cost <> 0 
				and FB1.DATE_INEFFECTIVE IS NOT NULL 
				AND FB1.ANNUAL_DEPRN_ROUNDING_FLAG ='RET' )
		WHEN FB.ANNUAL_DEPRN_ROUNDING_FLAG <> 'RET' 
			THEN FB.COST
		ELSE
			FB.COST
		END
	)  Recoverable_Cost,

	((SELECT SUM(FDS1.DEPRN_RESERVE) FROM FA_DEPRN_SUMMARY FDS1
				WHERE 1=1 AND FDS1.ASSET_ID = FA.ASSET_ID  
				AND FDS1.BOOK_TYPE_CODE = FB.BOOK_TYPE_CODE 
				AND FDS1.period_counter = (SELECT  PERIOD_COUNTER FROM FA_DEPRN_PERIODS WHERE BOOK_TYPE_CODE = FDS1.BOOK_TYPE_CODE
											AND period_name = :P_PERIOD_NAME)
			  ))  DEPRN_RESERVE,
	0 UNITS_RETIRED,
	NULL Reclass_Category,
	NULL Adjustment,
	NULL SALVAGE_VALUE,
	 (Select LISTAGG(ACC_STRING, ', ') WITHIN GROUP (ORDER BY ACC_STRING) ACC_STRING
	From
	(
	SELECT CASE When GCC.segment1 is not null THEN 
					XAL.ACCOUNTING_CLASS_CODE||' - '||GCC.SEGMENT3||' - '||(SELECT Distinct ffvt.description
							FROM fnd_flex_values_tl ffvt,
								fnd_flex_values ffv,
								fnd_id_flex_segments fifs
							WHERE ffv.flex_value_id = ffvt.flex_value_id
								AND fifs.flex_value_set_id = ffv.flex_value_set_id
								AND fifs.segment_name in  ('Movement Type')
								AND fifs.id_flex_code = 'GL#'
								AND ffv.flex_value = GCC.SEGMENT3)
					END ACC_STRING
		FROM xla_ae_headers XAH,XLA_AE_LINES XAL, gl_code_combinations GCC
		WHERE 1=1
					AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
					AND XAL.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
					--AND XAL.ENTERED_DR is not NULL
					AND GCC.SEGMENT2 like '1%'
					AND XAH.event_id = FDS.event_id
					--AND RowNum =1
					)) ACC_STRING, 
					
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE1 END ATTRIBUTE1,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE2 END ATTRIBUTE2,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE3 END ATTRIBUTE3,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE4 END ATTRIBUTE4,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE5 END ATTRIBUTE5,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE6 END ATTRIBUTE6,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE7 END ATTRIBUTE7,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE8 END ATTRIBUTE8,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE9 END ATTRIBUTE9,
	CASE WHEN :P_DFF = 'Y' THEN FA.ATTRIBUTE_NUMBER1 END ATTRIBUTE10,
	FB.DEPRECIATE_FLAG


	FROM
	FA_ADDITIONS_B FA,
	FA_ADDITIONS_TL FAT,
	FA_ASSET_KEYWORDS FAK,
	FA_BOOKS FB,
	(SELECT PERIOD_COUNTER, period_name, FISCAL_YEAR , BOOK_TYPE_CODE , period_num FROM FA_DEPRN_PERIODS WHERE 1=1 
	AND BOOK_TYPE_CODE =  :P_BOOK_TYPE_CODE 
	-- AND period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
	-- AND period_name <= :P_PERIOD_NAME
	AND period_name = :P_PERIOD_NAME
	) FDP,
	FA_CATEGORIES_B FCB,
	FA_CATEGORY_BOOKS FCATB,
	--FA_DISTRIBUTION_HISTORY FDH,
	( Select FDH1.*
	from FA_DISTRIBUTION_HISTORY FDH1, FA_ADDITIONS_B FA1
	Where 1=1
	AND FA1.ASSET_ID = FDH1.ASSET_ID
	AND FDH1.DATE_INEFFECTIVE IS NULL
	AND FDH1.LOCATION_ID in (Select Max(FMA.LOCATION_ID) From  FA_DISTRIBUTION_HISTORY FMA
							Where 1=1 And FMA.Asset_Id = FDH1.Asset_Id And FMA.BOOK_TYPE_CODE = FDH1.BOOK_TYPE_CODE
							AND FMA.DATE_INEFFECTIVE IS NULL) ) FDH,
	Gl_Code_Combinations GCC,
	FA_LOCATIONS FL,
	FA_METHODS METH,
	(Select * From FA_DEPRN_SUMMARY Where DEPRN_SOURCE_CODE = 'DEPRN' ) FDS

	Where 1=1
	And FA.Asset_Number In (SELECT Distinct fa.asset_number
								FROM FA_ADDITIONS_B fa,
									 fa_deprn_periods fdp,
									 fa_deprn_summary fds
							WHERE fa.asset_id = fds.asset_id(+)
								AND fdp.period_counter = fds.period_counter(+)
								AND fdp.book_type_code = fds.book_type_code(+) 
								And fdp.book_type_code= :P_BOOK_TYPE_CODE
								--And fdp.period_name <= :P_PERIOD_NAME
								--AND ((:P_SUPRESS = 'Y' AND FDP.PERIOD_NAME = :P_PERIOD_NAME  ) OR (:P_SUPRESS = 'N' AND FDP.PERIOD_NAME <= :P_PERIOD_NAME ) )
								AND ((:P_SUPRESS = 'Y' AND FDP.PERIOD_NAME = :P_PERIOD_NAME  ) OR (:P_SUPRESS = 'N' AND (FDP.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
								AND FDP.period_name <= :P_PERIOD_NAME) ) )
								AND FDS.DEPRN_SOURCE_CODE(+) = 'DEPRN'
								)
	AND FA.ASSET_ID = FAT.ASSET_ID
	AND FAT.language = userenv('LANG')
	AND FA.ASSET_KEY_CCID = FAK.CODE_COMBINATION_ID(+)


	AND FA.ASSET_ID = FB.ASSET_ID 
	AND FB.DATE_INEFFECTIVE IS NULL

	AND FB.BOOK_TYPE_CODE = FDP.BOOK_TYPE_CODE(+)

	AND FA.ASSET_CATEGORY_ID = FCB.CATEGORY_ID
	AND FCB.CATEGORY_ID = FCATB.CATEGORY_ID
	AND FB.BOOK_TYPE_CODE = FCATB.BOOK_TYPE_CODE

	AND FA.ASSET_ID = FDH.ASSET_ID(+)
	And FB.Book_TYpe_Code = FDH.Book_TYpe_Code(+)
	AND FDH.DATE_INEFFECTIVE IS NULL
	And FDH.Code_Combination_Id = GCC.Code_Combination_Id(+)

	And FDH.Location_id = FL.Location_Id(+)
	AND FB.METHOD_ID = METH.METHOD_ID(+)

	AND fa.asset_id = fds.asset_id(+)
	AND fdp.period_counter = fds.period_counter
	AND fdp.book_type_code = fds.book_type_code

	--Parameter
	--AND FA.ASSET_NUMBER in ('10008941')
	AND FB.BOOK_TYPE_CODE = :P_BOOK_TYPE_CODE  -- 'AU3051 COBK', ' AU3053 COBK' ,  'GB3299 COBK' , 'ID2352 COBK'
	AND FDP.PERIOD_NAME = :P_PERIOD_NAME
	--AND ((:P_SUPRESS = 'Y' AND FDP.PERIOD_NAME = :P_PERIOD_NAME  ) OR (:P_SUPRESS = 'N' AND FDP.PERIOD_NAME <= :P_PERIOD_NAME ) )
	/* AND ((:P_SUPRESS = 'Y' AND FDP.PERIOD_NAME = :P_PERIOD_NAME  ) OR (:P_SUPRESS = 'N' AND (FDP.period_name >= (SUBSTR(:P_PERIOD_NAME,1,5)||'01')
					AND FDP.period_name <= :P_PERIOD_NAME) ) ) */
	AND NVL(GCC.Segment1,-1) = NVL(:P_COMPANY,NVL(GCC.Segment1,-1))
	AND NVL(FAK.SEGMENT1,-1) = NVL(:P_ASSET_KEY,NVL(FAK.SEGMENT1,-1))
	AND NVL(FCB.SEGMENT1,-1) = NVL(:P_MAJOR_CATEGORY,NVL(FCB.SEGMENT1,-1))
	AND NVL(FCB.SEGMENT2,-1) = NVL(:P_MINOR_CATEGORY,NVL(FCB.SEGMENT2,-1))
	AND FA.ASSET_NUMBER Between NVL(:P_ASSET_NO_FROM, FA.ASSET_NUMBER) AND NVL(:P_ASSET_NO_TO, FA.ASSET_NUMBER)
	--AND ((:P_TRANS_FROM is null AND :P_TRANS_TO is null AND 1=1)  OR (:P_TRANS_FROM is not null AND :P_TRANS_TO is not null AND 1=2))
	--AND 'DEPRECIATION' = NVL(:P_TRANS_TYPE , 'DEPRECIATION')
	AND 'Summary' = :P_REPORT_REVIEW

	) A

	Where 1=1 
	---Parameter
	  --AND NVL(A.Posting_Date , sysdate+1) Between NVL(:P_POSTING_FROM,NVL(A.Posting_Date , sysdate-1)) AND NVL(:P_POSTING_TO,NVL( A.Posting_Date , sysdate+2))
	
	) AA
	Group by 
	AA.BOOK_TYPE_CODE,
	AA.ASSET_ID,
	AA.Company_Code,
	AA.FISCAL_YEAR,
	AA.Cost_Center,
	AA.Trading_partner,
	AA.ASSET_NUMBER,
	AA.ASSET_KEY,
	AA.PRORATE_DATE,
	AA.MAJOR_CATEGORY,
	AA.MINOR_CATEGORY,
	AA.COUNTRY,
	AA.City,
	AA.PROPERTY,
	AA.AREA,
	AA.L_FLOOR,
	AA.VENDOR_NUMBER,
	AA.VENDOR_NAME,
	AA.MANUFACTURER_NAME,
	AA.Original_Asset_Number,
	AA.Quantity,
	--AA.TRANSFER_UNITS,
	AA.Inventory_num,
	AA.DESCRIPTION,
	AA.Serial_Number,
	AA.DEPRN_START_DATE,
	AA.Useful_Life_Year,   
	AA.Useful_Life_Period,
	AA.APC_GL_Acc,
	AA.Acc_Depr_GL_Acc,
	AA.Depr_GL_Acc,
	AA.GR_Document_No,
	AA.GR_Date,
	AA.PO_Number,
	--AA.DISPOSAL_FLAG,
	AA.Remain_Useful_Life_Year,
	AA.Remain_Useful_Life_Period,
	AA.Prorate_Convention,
	AA.ASSET_TYPE,
	AA.Depreciation_Method,
	AA.ATTRIBUTE1,
	AA.ATTRIBUTE2,
	AA.ATTRIBUTE3,
	AA.ATTRIBUTE4,
	AA.ATTRIBUTE5,
	AA.ATTRIBUTE6,
	AA.ATTRIBUTE7,
	AA.ATTRIBUTE8,
	AA.ATTRIBUTE9,
	AA.ATTRIBUTE10,
	AA.DEPRECIATE_FLAG
	
	Order by AA.MAJOR_CATEGORY, AA.Company_Code , AA.ASSET_NUMBER ASC 
	-- , A.Document_Number , DEPRECIATION_PERIOD , A.TRANSACTION_DATE DESC