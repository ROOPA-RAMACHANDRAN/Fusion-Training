Select Distinct B.* from (

Select Distinct A.*, MAJOR_CATEGORY||' - '||COST_ACCOUNT MAJOR_CATEGORY_GROUP , COMPANY_PROPERTY COMPANY_PROPERTY_GROUOP  From (

	Select  
	BOOK,	:P_period_name  as PERIOD,	COMPANY_PROPERTY,	DEPT,	EXPENSE_ACCOUNT,	COST_ACCOUNT,	RESERVE_ACCOUNT,	MAJOR_CATEGORY,	MINOR_CATEGORY,	MAJOR_MINOR_CATEGORY,	ASSET_NO,	SERIAL_NUMBER,	TAG_NUMBER,	COUNTRY,	CITY,	PROPERTY,	AREA,	FLOOR,	DATE_PLACE_IN_SERVICE,	FIRST_ADDITION_DATE,	METHOD,	LIFE_IN_MONTHS,	PRORATE_CONVENTION,	DEPRECIATION_START_DATE,	CURRENT_UNITS
	,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		SALVAGE_VALUE Else 0 End) as SALVAGE_VALUE
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		COST Else 0 End) as COST */
	,   NVL(COST,0) COST
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		DEPN_MNTH Else 0 End)	as DEPN_MNTH */
	,NVL(DEPN_MNTH,0)	as DEPN_MNTH
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		YTD_DEPN Else 0 End)	as YTD_DEPN */
	,   NVL(YTD_DEPN,0)	as YTD_DEPN
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		ACCUM_DEPN Else 0 End)	as ACCUM_DEPN */
	,   NVL(ACCUM_DEPN,0)	as ACCUM_DEPN
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		NBV Else 0 End)as  NBV */
	,   NVL(NBV,0) as  NBV
	,	ASSET_DESC,	OLD_ASSET_NO,	PO_NUMBER,	INVOICE_NO,	INVOICE_DATE,	SUPPLIER_NAME,	RFID_NO,	ADDITIONAL_NOTE,	ASSET_TYPE,	RETIREMENT_ID,	FUNDED_BY,	DATE_IN_PERIOD,	DEP_PERIOD_START,	ASSET_KEY,
	Case When Balance_Useful_Life >= 0 then Balance_Useful_Life Else 0 END Balance_Useful_Life,
	Impairment_Reserve, DEPRECIATE_FLAG,
	Mnth_UNPLAN_Depn,
	CASE WHEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) >= 0 THEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) ELSE 0 END Mnth_ADJ_Depn,
	--Total_Depn,
	/* (((Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		DEPN_MNTH Else 0 End)) + Mnth_UNPLAN_Depn +  CASE WHEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) >= 0 THEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) ELSE 0 END) Total_Depn, */
		
	((NVL(DEPN_MNTH,0)) + Mnth_UNPLAN_Depn +  CASE WHEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) >= 0 THEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) ELSE 0 END) Total_Depn,
	
	Additional_Note_2, Additional_Note_3, Additional_Note_4, Additional_Note_5, Additional_Note_6, Amortization_Flag, TO_CHAR(Amortization_Date, 'mm/dd/yyyy') Amortization_Date



	  From (
	  
	Select Distinct FAB.Book_TYpe_Code as Book
	,(Select Max(Period_Name) as  From fa_deprn_Detail A, fa_deprn_periods B  Where A.Asset_Id=FAB.Asset_Id
	 And A.period_counter=B.period_counter And A.BOOK_TYPE_CODE=b.BOOK_TYPE_CODE
	And  A.BOOK_TYPE_CODE= :P_book_type_code  And A.Deprn_Source_COde='D' And period_name <= :P_period_name) as  Period
	,(Select GCC.Segment1 From FA_DISTRIBUTION_HISTORY FD ,Gl_Code_Combinations GCC
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FD.Code_Combination_Id=GCC.Code_Combination_Id
	AND FD.DATE_INEFFECTIVE IS NULL And Rownum=1 )as Company_Property
	,(Select GCC.Segment4 From FA_DISTRIBUTION_HISTORY FD ,Gl_Code_Combinations GCC
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FD.Code_Combination_Id=GCC.Code_Combination_Id
	AND FD.DATE_INEFFECTIVE IS NULL And Rownum=1 )as Dept
	/* ,(Select GCC.Segment2 From FA_CATEGORY_BOOKS FAC ,Gl_Code_Combinations GCC
	Where   FAC.Book_TYpe_Code=FAB.Book_TYpe_Code And FAC.Deprn_Expense_Account_CCId=GCC.Code_Combination_Id
	And FAC.Category_id=FA.Asset_category_Id And Rownum=1 )as Expense_Account */
	,( Select Distinct GCC.SEGMENT2
	from FA_DISTRIBUTION_HISTORY FDH1, FA_ADDITIONS_B FA1, Gl_Code_Combinations GCC
	Where 1=1
	AND FA1.ASSET_ID = FDH1.ASSET_ID
	AND FDH1.DATE_INEFFECTIVE IS NULL
	AND FDH1.LOCATION_ID in (Select Max(FMA.LOCATION_ID) From  FA_DISTRIBUTION_HISTORY FMA
							Where 1=1 And FMA.Asset_Id = FDH1.Asset_Id And FMA.BOOK_TYPE_CODE = FDH1.BOOK_TYPE_CODE
							AND FMA.DATE_INEFFECTIVE IS NULL
							AND FMA.DISTRIBUTION_ID = FDH1.DISTRIBUTION_ID)
	And FDH1.CODE_COMBINATION_ID = GCC.Code_Combination_Id
	AND FDH1.Book_TYpe_Code = FAB.Book_TYpe_Code
	AND FDH1.Asset_Id = FA.Asset_id
	AND FDH1.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	AND ROWnum=1
	) as Expense_Account
	,(Select GCC.Segment2 From FA_CATEGORY_BOOKS FAC ,Gl_Code_Combinations GCC
	Where   FAC.Book_TYpe_Code=FAB.Book_TYpe_Code And FAC.Asset_Cost_Account_CCId=GCC.Code_Combination_Id
	And FAC.Category_id=FA.Asset_category_Id And Rownum=1 )as Cost_Account
	,(Select GCC.Segment2 From FA_CATEGORY_BOOKS FAC ,Gl_Code_Combinations GCC
	Where   FAC.Book_TYpe_Code=FAB.Book_TYpe_Code And FAC.Reserve_Account_CCId=GCC.Code_Combination_Id
	And FAC.Category_id=FA.Asset_category_Id And Rownum=1 )as Reserve_Account

	/*,(Select Segment1 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ) as Major_Category
	,(Select Segment2 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ) as Minor_Category
	,(Select Segment1||' - '||Segment2 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ) as Major_Minor_Category*/

	,Nvl((Select Segment1 From FA_CATEGORIES_B FC,Fa_Asset_History ahc 
	Where FC.Category_id=ahc.Category_id And ahc.Asset_Id=FAB.Asset_id
	And ahc.Book_TYpe_Code=FAB.Book_TYpe_Code And ahc.BOOK_TYPE_CODE= :P_book_type_code
	And (Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name
	And ahc.Transaction_Header_Id_In=(Select Max(AC.Transaction_Header_Id_In)From Fa_Asset_History AC 
	Where 1=1
	And  ahc.Asset_Id=AC.Asset_id And ahc.Book_TYpe_Code=AC.Book_TYpe_Code
	And (Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name)) 
	,(Select Segment1 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ))
	as Major_Category

	,Nvl((Select Segment2 From FA_CATEGORIES_B FC,Fa_Asset_History ahc 
	Where FC.Category_id=ahc.Category_id And ahc.Asset_Id=FAB.Asset_id
	And ahc.Book_TYpe_Code=FAB.Book_TYpe_Code And ahc.BOOK_TYPE_CODE= :P_book_type_code
	And (Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name
	And ahc.Transaction_Header_Id_In=(Select Max(AC.Transaction_Header_Id_In)From Fa_Asset_History AC 
	Where 1=1
	And  ahc.Asset_Id=AC.Asset_id And ahc.Book_TYpe_Code=AC.Book_TYpe_Code
	And (Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name) )
	,(Select Segment2 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ))
	 as Minor_Category

	,Nvl((Select Segment1||' - '||Segment2 From FA_CATEGORIES_B FC,Fa_Asset_History ahc 
	Where FC.Category_id=ahc.Category_id And ahc.Asset_Id=FAB.Asset_id
	And ahc.Book_TYpe_Code=FAB.Book_TYpe_Code And ahc.BOOK_TYPE_CODE= :P_book_type_code
	And (Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name
	And ahc.Transaction_Header_Id_In=(Select Max(AC.Transaction_Header_Id_In)From Fa_Asset_History AC 
	Where 1=1
	And  ahc.Asset_Id=AC.Asset_id And ahc.Book_TYpe_Code=AC.Book_TYpe_Code
	And (Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name) )
	,(Select Segment1||' - '||Segment2 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ))
	 as Major_Minor_Category

	,FA.Asset_Number as Asset_No
	, FA.Serial_Number
	,  FA.Tag_Number
	/*,(Select FL.Segment1 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as COUNTRY
	,(Select FL.Segment2 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as City
	,(Select FL.Segment3 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as PROPERTY
	,(Select FL.Segment4 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as AREA
	,(Select FL.Segment5 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as FLOOR*/

	,FL.Segment1 as COUNTRY
	,FL.Segment2 as City
	,FL.Segment3 as PROPERTY
	,FL.Segment4 as AREA
	,FL.Segment5 as FLOOR


	,TO_CHAR(FAB.Date_Placed_In_Service, 'mm/dd/yyyy') as Date_Place_In_Service
	,TO_CHAR(FAB.Date_effective, 'mm/dd/yyyy') as First_Addition_Date
	,(Select FM.Name From Fa_Methods FM Where FM.Method_id=FAB.Method_id and rownum=1) as Method
	,FAM.Life_In_Months as life_in_months
	,(Select FM.Prorate_Convention_Code From fa_convention_types FM Where FM.Convention_Type_Id=FAB.Convention_Type_Id and rownum=1) as Prorate_Convention
	, TO_CHAR(FAB.Prorate_Date, 'mm/dd/yyyy') as Depreciation_Start_Date
	, Current_Units
	, FAB.salvage_value

	, (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	 Nvl((SELECT SUM(fdd.Cost)
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) And fdd.Cost <> 0
	   
	   --AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   --And Rownum=1
	   ),FAB.Cost)
	   END)
	   as Cost
	   
	, (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	Nvl((SELECT --fds.deprn_amount
			FDS.SYSTEM_DEPRN_AMOUNT
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name= :P_period_name),0)
	   END )
	   as Depn_Mnth
	   
	, --(Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	/* Nvl((SELECT fds.Ytd_Deprn
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) And fds.Ytd_Deprn <>0
	   And Rownum=1
	   ),0) as YTD_Depn */
	   
	   (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	   Nvl((SELECT fds.Ytd_Deprn
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter = (Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name )
	   And fds.Ytd_Deprn <>0
	   And Rownum=1
	   AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),0)
	END)
	   as YTD_Depn
	  
	, (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	Nvl((SELECT fds.deprn_reserve
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) And fds.deprn_reserve <>0
	   And Rownum=1
	   AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),0) 
	   END)
	   as Accum_Depn
	   
	, (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	Nvl((SELECT SUM(fdd.Cost)
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) ANd fdd.Cost <>0
	   --And Rownum=1
	   --AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),FAB.Cost)
	   END)
	  - 
	  Nvl((SELECT fds.deprn_reserve
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) And fds.deprn_reserve <>0
	   And Rownum=1
	   AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),0) 
		-
	   Nvl((SELECT SUM(FDS.IMPAIRMENT_RESERVE)
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_Detail fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fa.asset_id = FAB.Asset_id
	   And fdp.book_type_code= :P_book_type_code
	   --And fdp.period_name= :P_period_name
	   And fdp.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 Where 1=1 
	   AND fdp1.period_counter = fds1.period_counter AND fds1.asset_id=fds.asset_id And fds1.book_type_code = fds.book_type_code
	   And fdp1.period_name <= :P_period_name )
	   --AND FDS.DEPRN_SOURCE_CODE = 'D'
	   ),0)
		
	   as NBV
	   
	, (Select Description From FA_ADDITIONS_TL FD1 Where FD1.Asset_Id=FAB.Asset_id And Rownum=1) as Asset_Desc   
	, FA.Attribute3 as Old_Asset_No
	, (Select Po_Number From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code= :P_book_type_code And Rownum=1 ) as PO_Number
	   , (Select Invoice_Number From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code= :P_book_type_code And Rownum=1 ) as Invoice_No
	   , (Select TO_CHAR(Invoice_Date, 'mm/dd/yyyy') From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code= :P_book_type_code And Rownum=1 ) as Invoice_Date
	   , (Select vendor_Name From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code= :P_book_type_code  And Rownum=1 ) as Supplier_Name
	, FA.Attribute2 as RFID_No 
	,FA.Attribute1  as Additional_Note  
	, FA.Asset_Type
	/*, (Case When (Select Retirement_Id From FA_BOOKS B Where B.Retirement_Id Is Not Null 
	And B.Asset_Id=FA.Asset_Id And  FAB.Asset_Id=FA.Asset_Id ANd B.BOOK_TYPE_CODE=FAB.BOOK_TYPE_CODE And Rownum=1 ) Is not Null 
	Then 'Yes' Else 'No' ENd)*/
	, Nvl((Select (Case When Transaction_Type_Code !='FULL RETIREMENT' then 'No' Else 'Yes' End) From(
	Select Distinct Transaction_Type_Code,TRANSACTION_HEADER_ID From FA_TRANSACTION_HEADERS th,FA_Books bks
	Where 1=1
	And th.Asset_id=th.Asset_id
	And th.book_type_code=bks.book_type_code
	And TO_CHAR(th.Transaction_Date_Entered, 'YYYY-MM')<= :P_period_name
	AND th.TRANSACTION_HEADER_ID=(SELECT MAX(TRANSACTION_HEADER_ID) 
	FROM FA_TRANSACTION_HEADERS FB1 WHERE FB1.ASSET_ID=th.Asset_Id AND FB1.BOOK_TYPE_CODE=th.BOOK_TYPE_CODE 
	And TO_CHAR(Transaction_Date_Entered, 'YYYY-MM') <= :P_period_name)
	And th.Asset_Id =FAB.Asset_id
	And th.book_type_code= :P_book_type_code)),'No')
	  as Retirement_Id
	, FA.Attribute4 as  Funded_By,Substr(TO_CHAR(Date_Placed_In_Service, 'YYYY-MM'),1,5)||Substr(TO_CHAR(Date_Placed_In_Service, 'YYYY-MM'),7,1) as Date_In_Period
	, (Select Min(Period_Name) as  From fa_deprn_Detail A, fa_deprn_periods B  Where A.Asset_Id=FAB.Asset_Id
	 And A.period_counter=B.period_counter And A.BOOK_TYPE_CODE=b.BOOK_TYPE_CODE
	And  A.BOOK_TYPE_CODE= :P_book_type_code  And A.Deprn_Source_COde='D')as Dep_Period_Start
	, (Select Segment1  From FA_ASSET_KEYWORDS AK Where AK.Code_Combination_Id=FA.Asset_Key_CCID) As Asset_Key,

	(SELECT
		decode(FAB.conversion_date,
							NULL,
							( SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
		  WHERE 1=1  AND METH.METHOD_ID = FAB.METHOD_ID
		  AND ROWNUM =1) -
							floor(months_between(fdp1.calendar_period_close_date,
												 FAB.prorate_date)),
												 
						   (  SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
		  WHERE 1=1  AND METH.METHOD_ID = FAB.METHOD_ID
		  AND ROWNUM =1)  -
							floor(months_between(fdp1.calendar_period_close_date,
												 FAB.deprn_start_date))) MON
		FROM
		fa_deprn_periods fdp1
		  WHERE 1=1
				AND FAB.book_type_code = fdp1.book_type_code 
				 AND FAB.date_ineffective IS NULL
				 AND fdp1.period_counter = (SELECT MAX(dp.period_counter)
						FROM fa_deprn_periods dp
						WHERE dp.book_type_code = fdp1.book_type_code
						AND DP.period_name = :P_period_name)
		) Balance_Useful_Life,
		
		Nvl((SELECT SUM(FDS.IMPAIRMENT_RESERVE)
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_Detail fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fa.asset_id = FAB.Asset_id
	   And fdp.book_type_code= :P_book_type_code
	   --And fdp.period_name= :P_period_name
	   And fdp.period_counter = (Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 Where 1=1 
	   AND fdp1.period_counter = fds1.period_counter AND fds1.asset_id=fds.asset_id And fds1.book_type_code = fds.book_type_code
	   And fdp1.period_name <= :P_period_name )
	   --AND FDS.DEPRN_SOURCE_CODE = 'D'
	   ),0) Impairment_Reserve,
		
		FAB.DEPRECIATE_FLAG,
		
		Nvl((Select SUM((FA1.ADJUSTMENT_AMOUNT)*-1) from FA_ADJUSTMENTS FA1,FA_DEPRN_PERIODS FDPP
				Where 1=1 AND Fa1.BOOK_TYPE_CODE = FDPP.BOOK_TYPE_CODE(+)
					AND Fa1.PERIOD_COUNTER_CREATED = FDPP.PERIOD_COUNTER(+)
					AND FA1.SOURCE_TYPE_CODE = 'DEPRECIATION'
					AND FA1.ADJUSTMENT_TYPE = 'EXPENSE'
					AND FA1.DEBIT_CREDIT_FLAG = 'CR'
					AND fa1.asset_id = FAB.Asset_id
					And fa1.book_type_code= :P_book_type_code
					--AND fdpp.period_counter = fdp.period_counter
					And fdpp.period_name= :P_period_name
					/* AND FA1.ADJUSTMENT_LINE_ID = (SELECT MIN(ADJUSTMENT_LINE_ID) From FA_ADJUSTMENTS FA2 Where 1=1
														AND FA2.SOURCE_TYPE_CODE = 'DEPRECIATION'
														AND FA2.ADJUSTMENT_TYPE = 'EXPENSE'
														AND fa2.asset_id = fa1.asset_id
														And fa2.book_type_code = fa1.book_type_code
														AND Fa2.PERIOD_COUNTER_CREATED = FA1.PERIOD_COUNTER_CREATED
														) */
		),0) Mnth_UNPLAN_Depn,
		
		Nvl((SELECT SUM(fds1.DEPRN_ADJUSTMENT_AMOUNT)
		  FROM FA_ADDITIONS_B        fa1,
			   fa_deprn_periods    fdp1,
			   fa_deprn_summary fds1
		 WHERE fa1.asset_id = fds1.asset_id
		   AND fdp1.period_counter = fds1.period_counter
		   AND fdp1.book_type_code = fds1.book_type_code
		   AND fa1.asset_id = FAB.Asset_id
		   And fdp1.book_type_code= :P_book_type_code
		   And fdp1.period_name= :P_period_name
			),0) Mnth_ADJ_Depn,
			
			Nvl((SELECT fds.deprn_amount
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name= :P_period_name),0)  Total_Depn,
			
		FA.ATTRIBUTE5 Additional_Note_2,
		FA.ATTRIBUTE6 Additional_Note_3,
		FA.ATTRIBUTE7 Additional_Note_4,
		FA.ATTRIBUTE8 Additional_Note_5,
		FA.ATTRIBUTE9 Additional_Note_6,
		
		(Select (CASE WHEN FTH.AMORTIZATION_START_DATE is null THEN 'NO' WHEN FTH.AMORTIZATION_START_DATE is NOT null THEN 'YES' END)  Amortized
	from FA_TRANSACTION_HEADERS FTH, FA_TRANSACTIONS_V FTRV 
	Where 1=1
	And FTH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	--AND FTH.TRANSACTION_TYPE_CODE in ('ADJUSTMENT')
	--AND FTH.TRANSACTION_HEADER_ID = FAB.TRANSACTION_HEADER_ID_OUT
	AND FTH.BOOK_TYPE_CODE = :P_book_type_code
	AND FTRV.PERIOD_NAME <= :P_period_name  
	And FTH.asset_id = FA.asset_id
	AND FTH.AMORTIZATION_START_DATE = (Select MIN(FTH1.AMORTIZATION_START_DATE) from FA_TRANSACTION_HEADERS FTH1 Where 1=1 and FTH1.asset_id = FTH.asset_id
	And fth1.book_type_code = FTH.book_type_code)
	AND rownum = 1
	) Amortization_Flag,

	(Select (CASE WHEN FTH.AMORTIZATION_START_DATE is not null THEN FTH.AMORTIZATION_START_DATE  END)  Amortized_DATE
	from FA_TRANSACTION_HEADERS FTH, FA_TRANSACTIONS_V FTRV 
	Where 1=1
	And FTH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	--AND FTH.TRANSACTION_TYPE_CODE in ('ADJUSTMENT')
	--AND FTH.TRANSACTION_HEADER_ID = FAB.TRANSACTION_HEADER_ID_OUT
	AND FTH.BOOK_TYPE_CODE = :P_book_type_code
	AND FTRV.PERIOD_NAME <= :P_period_name  
	And FTH.asset_id = FA.asset_id
	AND FTH.AMORTIZATION_START_DATE = (Select MIN(FTH1.AMORTIZATION_START_DATE) from FA_TRANSACTION_HEADERS FTH1 Where 1=1 and FTH1.asset_id = FTH.asset_id
	And fth1.book_type_code = FTH.book_type_code)
	AND rownum = 1
	) Amortization_Date


	From FA_BOOKS FAB,FA_ADDITIONS_B FA,FA_METHODS FAM,FA_DISTRIBUTION_HISTORY FDA,Fa_Locations FL
	Where FAB.Asset_Id=FA.Asset_Id 
	AND FAB.TRANSACTION_HEADER_ID_IN=(SELECT MAX(TRANSACTION_HEADER_ID_IN) 
	FROM FA_BOOKS FB1 WHERE FB1.ASSET_ID=FAB.ASSET_ID AND FB1.BOOK_TYPE_CODE=FAB.BOOK_TYPE_CODE)
	--And FA.Asset_Number IN('10000125','10000024','10000088')
	And FAB.BOOK_TYPE_CODE= :P_book_type_code
	--And FA.Asset_Key_CCID In(Select Code_Combination_Id  From FA_ASSET_KEYWORDS Where Segment1 =Nvl(:P_Asset_Key,Segment1))
	And FAB.METHOD_ID=FAM.METHOD_ID
	And  FA.Asset_Number In(SELECT fa.asset_number
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   --AND fa.asset_id = 19010 
	   And fdp.book_type_code= :P_book_type_code--:P_book_type_code
	   And fdp.period_name <= :P_period_name --'2020-7'
	   )
	   --And TO_CHAR(FAB.Date_Placed_In_Service, 'YYYY-MM')<= :P_period_name --:P_period_name
	   
	   And FAB.Asset_Id=FDA.Asset_Id 
	   And FDA.BOOK_TYPE_CODE=FAB.BOOK_TYPE_CODE
	   And FL.Location_Id=FDA.Location_id
	   
	   ----Restrict Historical for transfer and adjustment start---
	   And FDA.Transaction_Header_Id_In In(Select Max(FMA.Transaction_Header_Id_In) From  FA_DISTRIBUTION_HISTORY FMA
	   Where 1=1    And FMA.Asset_Id=FDA.Asset_Id    And FMA.BOOK_TYPE_CODE=FAB.BOOK_TYPE_CODE)
	   ----Restrict Historical for transfer and adjustment End---   
	   
	)Where 1=1
	And  Company_Property Between  Nvl(:P_From_Company,Company_Property) And  Nvl(:P_TO_Company,Company_Property)
	And Major_Category = Nvl(:P_Major_Category,Major_Category)
	And Minor_Category = Nvl(:P_Minor_Category,Minor_Category)
	And Asset_No Between  Nvl(:P_From_Asset,Asset_No) And Nvl(:P_To_Asset,Asset_No)
	--And Date_In_Period <=   :P_period_name
	And Dep_Period_Start <= :P_period_name

	Or Dep_Period_Start Is Null

	And Asset_Key=Nvl(:P_Asset_Key,Asset_Key)


	-------------------THis is for asset key null record  Start---------------------

	Union All

	Select 
	BOOK,	:P_period_name as PERIOD,	COMPANY_PROPERTY,	DEPT,	EXPENSE_ACCOUNT,	COST_ACCOUNT,	RESERVE_ACCOUNT,	MAJOR_CATEGORY,	MINOR_CATEGORY,	MAJOR_MINOR_CATEGORY,	ASSET_NO,	SERIAL_NUMBER,	TAG_NUMBER,	COUNTRY,	CITY,	PROPERTY,	AREA,	FLOOR,	DATE_PLACE_IN_SERVICE,	FIRST_ADDITION_DATE,	METHOD,	LIFE_IN_MONTHS,	PRORATE_CONVENTION,	DEPRECIATION_START_DATE,	CURRENT_UNITS
	,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		SALVAGE_VALUE Else 0 End) as SALVAGE_VALUE
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		COST Else 0 End) as COST */
	,   NVL(COST,0) COST
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		DEPN_MNTH Else 0 End)	as DEPN_MNTH */
	,   NVL(DEPN_MNTH,0) as DEPN_MNTH
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		YTD_DEPN Else 0 End)	as YTD_DEPN */
	,   NVL(YTD_DEPN,0)	as YTD_DEPN
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		ACCUM_DEPN Else 0 End)	as ACCUM_DEPN */
	,   NVL(ACCUM_DEPN,0)	as ACCUM_DEPN
	/* ,   (Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		NBV Else 0 End)as  NBV */
	,   NVL(NBV,0) as  NBV
	,	ASSET_DESC,	OLD_ASSET_NO,	PO_NUMBER,	INVOICE_NO,	INVOICE_DATE,	SUPPLIER_NAME,	RFID_NO,	ADDITIONAL_NOTE,	ASSET_TYPE,	RETIREMENT_ID,	FUNDED_BY,	DATE_IN_PERIOD,	DEP_PERIOD_START,	ASSET_KEY, 
	Case When Balance_Useful_Life >= 0 then Balance_Useful_Life Else 0 END Balance_Useful_Life,
	Impairment_Reserve, DEPRECIATE_FLAG ,
	Mnth_UNPLAN_Depn,
	CASE WHEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) >= 0 THEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) ELSE 0 END Mnth_ADJ_Depn ,
	--Total_Depn,
	/* (((Case When  row_number() over(partition by Book,Asset_no order by Book,Asset_no)=1 Then 
		DEPN_MNTH Else 0 End)) + Mnth_UNPLAN_Depn +  CASE WHEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) >= 0 THEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) ELSE 0 END) Total_Depn, */
		
		((NVL(DEPN_MNTH,0)) + Mnth_UNPLAN_Depn +  CASE WHEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) >= 0 THEN (NVL(Mnth_ADJ_Depn,0)-NVL(Mnth_UNPLAN_Depn,0)) ELSE 0 END) Total_Depn,
	Additional_Note_2, Additional_Note_3, Additional_Note_4, Additional_Note_5, Additional_Note_6, Amortization_Flag, TO_CHAR(Amortization_Date, 'mm/dd/yyyy') Amortization_Date

	  From (
	  
	Select Distinct FAB.Book_TYpe_Code as Book
	,(Select Max(Period_Name) as  From fa_deprn_Detail A, fa_deprn_periods B  Where A.Asset_Id=FAB.Asset_Id
	 And A.period_counter=B.period_counter And A.BOOK_TYPE_CODE=b.BOOK_TYPE_CODE
	And  A.BOOK_TYPE_CODE= :P_book_type_code  And A.Deprn_Source_COde='D' And period_name <= :P_period_name) as  Period
	,(Select GCC.Segment1 From FA_DISTRIBUTION_HISTORY FD ,Gl_Code_Combinations GCC
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FD.Code_Combination_Id=GCC.Code_Combination_Id
	AND FD.DATE_INEFFECTIVE IS NULL And Rownum=1 )as Company_Property
	,(Select GCC.Segment4 From FA_DISTRIBUTION_HISTORY FD ,Gl_Code_Combinations GCC
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FD.Code_Combination_Id=GCC.Code_Combination_Id
	AND FD.DATE_INEFFECTIVE IS NULL And Rownum=1 )as Dept
	/* ,(Select GCC.Segment2 From FA_CATEGORY_BOOKS FAC ,Gl_Code_Combinations GCC
	Where   FAC.Book_TYpe_Code=FAB.Book_TYpe_Code And FAC.Deprn_Expense_Account_CCId=GCC.Code_Combination_Id
	And FAC.Category_id=FA.Asset_category_Id And Rownum=1 )as Expense_Account */
	,( Select Distinct GCC.SEGMENT2
	from FA_DISTRIBUTION_HISTORY FDH1, FA_ADDITIONS_B FA1, Gl_Code_Combinations GCC
	Where 1=1
	AND FA1.ASSET_ID = FDH1.ASSET_ID
	AND FDH1.DATE_INEFFECTIVE IS NULL
	AND FDH1.LOCATION_ID in (Select Max(FMA.LOCATION_ID) From  FA_DISTRIBUTION_HISTORY FMA
							Where 1=1 And FMA.Asset_Id = FDH1.Asset_Id And FMA.BOOK_TYPE_CODE = FDH1.BOOK_TYPE_CODE
							AND FMA.DISTRIBUTION_ID = FDH1.DISTRIBUTION_ID)
	And FDH1.CODE_COMBINATION_ID = GCC.Code_Combination_Id
	AND FDH1.Book_TYpe_Code = FAB.Book_TYpe_Code
	AND FDH1.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	AND FDH1.Asset_Id = FA.Asset_id AND ROWnum=1) as Expense_Account
	,(Select GCC.Segment2 From FA_CATEGORY_BOOKS FAC ,Gl_Code_Combinations GCC
	Where   FAC.Book_TYpe_Code=FAB.Book_TYpe_Code And FAC.Asset_Cost_Account_CCId=GCC.Code_Combination_Id
	And FAC.Category_id=FA.Asset_category_Id And Rownum=1 )as Cost_Account
	,(Select GCC.Segment2 From FA_CATEGORY_BOOKS FAC ,Gl_Code_Combinations GCC
	Where   FAC.Book_TYpe_Code=FAB.Book_TYpe_Code And FAC.Reserve_Account_CCId=GCC.Code_Combination_Id
	And FAC.Category_id=FA.Asset_category_Id And Rownum=1 )as Reserve_Account

	/*,(Select Segment1 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ) as Major_Category
	,(Select Segment2 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ) as Minor_Category
	,(Select Segment1||' - '||Segment2 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ) as Major_Minor_Category*/

	,Nvl((Select Segment1 From FA_CATEGORIES_B FC,Fa_Asset_History ahc 
	Where FC.Category_id=ahc.Category_id And ahc.Asset_Id=FAB.Asset_id
	And ahc.Book_TYpe_Code=FAB.Book_TYpe_Code And ahc.BOOK_TYPE_CODE= :P_book_type_code
	And (Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name
	And ahc.Transaction_Header_Id_In=(Select Max(AC.Transaction_Header_Id_In)From Fa_Asset_History AC 
	Where 1=1
	And  ahc.Asset_Id=AC.Asset_id And ahc.Book_TYpe_Code=AC.Book_TYpe_Code
	And (Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name)) 
	,(Select Segment1 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ))
	as Major_Category

	,Nvl((Select Segment2 From FA_CATEGORIES_B FC,Fa_Asset_History ahc 
	Where FC.Category_id=ahc.Category_id And ahc.Asset_Id=FAB.Asset_id
	And ahc.Book_TYpe_Code=FAB.Book_TYpe_Code And ahc.BOOK_TYPE_CODE= :P_book_type_code
	And (Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name
	And ahc.Transaction_Header_Id_In=(Select Max(AC.Transaction_Header_Id_In)From Fa_Asset_History AC 
	Where 1=1
	And  ahc.Asset_Id=AC.Asset_id And ahc.Book_TYpe_Code=AC.Book_TYpe_Code
	And (Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name) )
	,(Select Segment2 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ))
	 as Minor_Category

	,Nvl((Select Segment1||' - '||Segment2 From FA_CATEGORIES_B FC,Fa_Asset_History ahc 
	Where FC.Category_id=ahc.Category_id And ahc.Asset_Id=FAB.Asset_id
	And ahc.Book_TYpe_Code=FAB.Book_TYpe_Code And ahc.BOOK_TYPE_CODE= :P_book_type_code
	And (Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(ahc.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name
	And ahc.Transaction_Header_Id_In=(Select Max(AC.Transaction_Header_Id_In)From Fa_Asset_History AC 
	Where 1=1
	And  ahc.Asset_Id=AC.Asset_id And ahc.Book_TYpe_Code=AC.Book_TYpe_Code
	And (Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),1,5)||Substr(TO_CHAR(AC.Date_Effective, 'YYYY-MM'),7,1)) <= :P_period_name) )
	,(Select Segment1||' - '||Segment2 From FA_CATEGORIES_B FC Where FC.Category_id=FA.Asset_category_Id And Rownum=1 ))
	 as Major_Minor_Category

	,FA.Asset_Number as Asset_No
	, FA.Serial_Number
	,  FA.Tag_Number
	/*,(Select FL.Segment1 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as COUNTRY
	,(Select FL.Segment2 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as City
	,(Select FL.Segment3 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as PROPERTY
	,(Select FL.Segment4 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as AREA
	,(Select FL.Segment5 From FA_DISTRIBUTION_HISTORY FD ,Fa_Locations FL
	Where  FA.ASSET_ID=FD.ASSET_ID And FD.Book_TYpe_Code=FAB.Book_TYpe_Code And FL.Location_Id=FD.Location_id and Rownum=1) as FLOOR*/

	,FL.Segment1 as COUNTRY
	,FL.Segment2 as City
	,FL.Segment3 as PROPERTY
	,FL.Segment4 as AREA
	,FL.Segment5 as FLOOR


	,TO_CHAR(FAB.Date_Placed_In_Service, 'mm/dd/yyyy') as Date_Place_In_Service
	,TO_CHAR(FAB.Date_effective, 'mm/dd/yyyy') as First_Addition_Date
	,(Select FM.Name From Fa_Methods FM Where FM.Method_id=FAB.Method_id and rownum=1) as Method
	,FAM.Life_In_Months as life_in_months
	,(Select FM.Prorate_Convention_Code From fa_convention_types FM Where FM.Convention_Type_Id=FAB.Convention_Type_Id and rownum=1) as Prorate_Convention
	, TO_CHAR(FAB.Prorate_Date, 'mm/dd/yyyy') as Depreciation_Start_Date
	, Current_Units
	, FAB.salvage_value

	,  (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	 Nvl((SELECT SUM(fdd.Cost)
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) And fdd.Cost <> 0
	  --And Rownum=1
	  --AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),FAB.Cost) 
	   END)
	   as Cost
	   
	, (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	Nvl((SELECT --fds.deprn_amount
	fds.SYSTEM_DEPRN_AMOUNT
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name= :P_period_name),0)
	   END)
	   as Depn_Mnth
	   
	, --(Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	/* Nvl((SELECT fds.Ytd_Deprn
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) And fds.Ytd_Deprn <>0
	   And Rownum=1
	   ),0) as YTD_Depn */
	   
	   (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	   Nvl((SELECT fds.Ytd_Deprn
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name )
	   And fds.Ytd_Deprn <>0
	   And Rownum=1
	   AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),0) 
	   END)
	   as YTD_Depn
	   
	, (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	Nvl((SELECT fds.deprn_reserve
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) And fds.deprn_reserve <>0
	   And Rownum=1
	   AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),0) 
	   END )
	   as Accum_Depn
	   
	, (Case When  row_number() over(partition by FAB.book_type_code,FAB.Asset_id order by FAB.book_type_code,FAB.Asset_id)=1 Then
	Nvl((SELECT SUM(fdd.Cost)
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) ANd fdd.Cost <>0
	   --And Rownum=1
	   --AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),FAB.Cost)
	   END )
	  - 
	  Nvl((SELECT fds.deprn_reserve
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds,
		   fa_deprn_Detail fdd
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fdp.period_counter = fdd.period_counter
	   AND fds.period_counter = fdd.period_counter
	   AND fdp.book_type_code = fdd.book_type_code
	   AND fdd.asset_id = fds.asset_id
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name <= :P_period_name
	   And fds.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 
	   Where 1=1 
	   AND fds1.asset_id=fdd.asset_id And fds1.asset_id=FA.Asset_Id And fdd.book_type_code=fds1.book_type_code 
	   AND  fdp1.period_counter = fds1.period_counter And fdp1.period_name <= :P_period_name ) And fds.deprn_reserve <>0
	   And Rownum=1
	   AND FDD.DISTRIBUTION_ID = FDA.DISTRIBUTION_ID
	   ),0) 
		-
		Nvl((SELECT SUM(FDS.IMPAIRMENT_RESERVE)
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_Detail fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fa.asset_id = FAB.Asset_id
	   And fdp.book_type_code= :P_book_type_code
	   --And fdp.period_name= :P_period_name
	   And fdp.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 Where 1=1 
	   AND fdp1.period_counter = fds1.period_counter AND fds1.asset_id=fds.asset_id And fds1.book_type_code = fds.book_type_code
	   And fdp1.period_name <= :P_period_name )
	   --AND FDS.DEPRN_SOURCE_CODE = 'D'
	   ),0)
		
		as NBV
	   
	, (Select Description From FA_ADDITIONS_TL FD1 Where FD1.Asset_Id=FAB.Asset_id And Rownum=1) as Asset_Desc   
	, FA.Attribute3 as Old_Asset_No
	, (Select Po_Number From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code= :P_book_type_code And Rownum=1 ) as PO_Number
	   , (Select Invoice_Number From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code= :P_book_type_code And Rownum=1 ) as Invoice_No
	   , (Select TO_CHAR(Invoice_Date, 'mm/dd/yyyy') From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code= :P_book_type_code And Rownum=1 ) as Invoice_Date
	   , (Select vendor_Name From FA_ASSET_INVOICES FAI Where FAI.Asset_id=FA.Asset_id  
	   And FAI.book_type_code= :P_book_type_code  And Rownum=1 ) as Supplier_Name
	, FA.Attribute2 as RFID_No 
	,FA.Attribute1  as Additional_Note  
	, FA.Asset_Type
	/*, (Case When (Select Retirement_Id From FA_BOOKS B Where B.Retirement_Id Is Not Null 
	And B.Asset_Id=FA.Asset_Id And  FAB.Asset_Id=FA.Asset_Id ANd B.BOOK_TYPE_CODE=FAB.BOOK_TYPE_CODE And Rownum=1 ) Is not Null 
	Then 'Yes' Else 'No' ENd)*/
	, Nvl((Select (Case When Transaction_Type_Code !='FULL RETIREMENT' then 'No' Else 'Yes' End) From(
	Select Distinct Transaction_Type_Code,TRANSACTION_HEADER_ID From FA_TRANSACTION_HEADERS th,FA_Books bks
	Where 1=1
	And th.Asset_id=th.Asset_id
	And th.book_type_code=bks.book_type_code
	And TO_CHAR(th.Transaction_Date_Entered, 'YYYY-MM')<= :P_period_name
	AND th.TRANSACTION_HEADER_ID=(SELECT MAX(TRANSACTION_HEADER_ID) 
	FROM FA_TRANSACTION_HEADERS FB1 WHERE FB1.ASSET_ID=th.Asset_Id AND FB1.BOOK_TYPE_CODE=th.BOOK_TYPE_CODE 
	And TO_CHAR(Transaction_Date_Entered, 'YYYY-MM') <= :P_period_name)
	And th.Asset_Id =FAB.Asset_id
	And th.book_type_code= :P_book_type_code)),'No')
	  as Retirement_Id
	, FA.Attribute4 as  Funded_By,Substr(TO_CHAR(Date_Placed_In_Service, 'YYYY-MM'),1,5)||Substr(TO_CHAR(Date_Placed_In_Service, 'YYYY-MM'),7,2) as Date_In_Period
	, (Select Min(Period_Name) as  From fa_deprn_Detail A, fa_deprn_periods B  Where A.Asset_Id=FAB.Asset_Id
	 And A.period_counter=B.period_counter And A.BOOK_TYPE_CODE=b.BOOK_TYPE_CODE
	And  A.BOOK_TYPE_CODE= :P_book_type_code  And A.Deprn_Source_COde='D')as Dep_Period_Start
	, (Select Segment1  From FA_ASSET_KEYWORDS AK Where AK.Code_Combination_Id=FA.Asset_Key_CCID) As Asset_Key,

	(SELECT
		decode(FAB.conversion_date,
							NULL,
							( SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
		  WHERE 1=1  AND METH.METHOD_ID = FAB.METHOD_ID
		  AND ROWNUM =1) -
							floor(months_between(fdp1.calendar_period_close_date,
												 FAB.prorate_date)),
												 
						   (  SELECT METH.LIFE_IN_MONTHS  FROM FA_METHODS METH
		  WHERE 1=1  AND METH.METHOD_ID = FAB.METHOD_ID
		  AND ROWNUM =1)  -
							floor(months_between(fdp1.calendar_period_close_date,
												 FAB.deprn_start_date))) MON
		FROM
		fa_deprn_periods fdp1
		  WHERE 1=1
				AND FAB.book_type_code = fdp1.book_type_code 
				 AND FAB.date_ineffective IS NULL
				 AND fdp1.period_counter = (SELECT MAX(dp.period_counter)
						FROM fa_deprn_periods dp
						WHERE dp.book_type_code = fdp1.book_type_code
						AND DP.period_name = :P_period_name)
		) Balance_Useful_Life,
		
		
		Nvl((SELECT SUM(FDS.IMPAIRMENT_RESERVE)
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_Detail fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fa.asset_id = FAB.Asset_id
	   And fdp.book_type_code= :P_book_type_code
	   --And fdp.period_name= :P_period_name
	   And fdp.period_counter =(Select Max(fds1.period_counter) From fa_deprn_Detail fds1,fa_deprn_periods fdp1 Where 1=1 
	   AND fdp1.period_counter = fds1.period_counter AND fds1.asset_id=fds.asset_id And fds1.book_type_code = fds.book_type_code
	   And fdp1.period_name <= :P_period_name )
	   --AND FDS.DEPRN_SOURCE_CODE = 'D'
	   ),0) Impairment_Reserve,
		
		FAB.DEPRECIATE_FLAG,
		
		Nvl((Select SUM((FA1.ADJUSTMENT_AMOUNT)*-1) from FA_ADJUSTMENTS FA1,FA_DEPRN_PERIODS FDPP
				Where 1=1 AND Fa1.BOOK_TYPE_CODE = FDPP.BOOK_TYPE_CODE(+)
					AND Fa1.PERIOD_COUNTER_CREATED = FDPP.PERIOD_COUNTER(+)
					AND FA1.SOURCE_TYPE_CODE = 'DEPRECIATION'
					AND FA1.ADJUSTMENT_TYPE = 'EXPENSE'
					AND FA1.DEBIT_CREDIT_FLAG = 'CR'
					AND fa1.asset_id = FAB.Asset_id
					And fa1.book_type_code= :P_book_type_code
					--AND fdpp.period_counter = fdp.period_counter
					And fdpp.period_name= :P_period_name
					/* AND FA1.ADJUSTMENT_LINE_ID = (SELECT MIN(ADJUSTMENT_LINE_ID) From FA_ADJUSTMENTS FA2 Where 1=1
														AND FA2.SOURCE_TYPE_CODE = 'DEPRECIATION'
														AND FA2.ADJUSTMENT_TYPE = 'EXPENSE'
														AND fa2.asset_id = fa1.asset_id
														And fa2.book_type_code = fa1.book_type_code
														AND Fa2.PERIOD_COUNTER_CREATED = FA1.PERIOD_COUNTER_CREATED
														) */
		),0) Mnth_UNPLAN_Depn,
		
		Nvl((SELECT SUM(fds1.DEPRN_ADJUSTMENT_AMOUNT)
		  FROM FA_ADDITIONS_B        fa1,
			   fa_deprn_periods    fdp1,
			   fa_deprn_summary fds1
		 WHERE fa1.asset_id = fds1.asset_id
		   AND fdp1.period_counter = fds1.period_counter
		   AND fdp1.book_type_code = fds1.book_type_code
		   AND fa1.asset_id = FAB.Asset_id
		   And fdp1.book_type_code= :P_book_type_code
		   And fdp1.period_name= :P_period_name
			),0) Mnth_ADJ_Depn,
			
			Nvl((SELECT fds.deprn_amount
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   AND fa.asset_id = FAB.Asset_id And fdp.book_type_code= :P_book_type_code
	   And fdp.period_name= :P_period_name),0) Total_Depn,
			
			FA.ATTRIBUTE5 Additional_Note_2,
		FA.ATTRIBUTE6 Additional_Note_3,
		FA.ATTRIBUTE7 Additional_Note_4,
		FA.ATTRIBUTE8 Additional_Note_5,
		FA.ATTRIBUTE9 Additional_Note_6,
		
		(Select (CASE WHEN FTH.AMORTIZATION_START_DATE is null THEN 'NO' WHEN FTH.AMORTIZATION_START_DATE is NOT null THEN 'YES' END)  Amortized
	from FA_TRANSACTION_HEADERS FTH, FA_TRANSACTIONS_V FTRV 
	Where 1=1
	And FTH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	--AND FTH.TRANSACTION_TYPE_CODE in ('ADJUSTMENT')
	--AND FTH.TRANSACTION_HEADER_ID = FAB.TRANSACTION_HEADER_ID_OUT
	AND FTH.BOOK_TYPE_CODE = :P_book_type_code
	AND FTRV.PERIOD_NAME <= :P_period_name  
	And FTH.asset_id = FA.asset_id
	AND FTH.AMORTIZATION_START_DATE = (Select MIN(FTH1.AMORTIZATION_START_DATE) from FA_TRANSACTION_HEADERS FTH1 Where 1=1 and FTH1.asset_id = FTH.asset_id
	And fth1.book_type_code = FTH.book_type_code)
	AND rownum = 1
	) Amortization_Flag,

	(Select (CASE WHEN FTH.AMORTIZATION_START_DATE is not null THEN FTH.AMORTIZATION_START_DATE  END)  Amortized_DATE
	from FA_TRANSACTION_HEADERS FTH, FA_TRANSACTIONS_V FTRV 
	Where 1=1
	And FTH.asset_id = FTRV.asset_id
	And fth.book_type_code = ftrv.book_type_code
	AND FTH.TRANSACTION_HEADER_ID = FTRV.TRANSACTION_HEADER_ID
	--AND FTH.TRANSACTION_TYPE_CODE in ('ADJUSTMENT')
	--AND FTH.TRANSACTION_HEADER_ID = FAB.TRANSACTION_HEADER_ID_OUT
	AND FTH.BOOK_TYPE_CODE = :P_book_type_code
	AND FTRV.PERIOD_NAME <= :P_period_name  
	And FTH.asset_id = FA.asset_id
	AND FTH.AMORTIZATION_START_DATE = (Select MIN(FTH1.AMORTIZATION_START_DATE) from FA_TRANSACTION_HEADERS FTH1 Where 1=1 and FTH1.asset_id = FTH.asset_id
	And fth1.book_type_code = FTH.book_type_code)
	AND rownum = 1
	) Amortization_Date

	From FA_BOOKS FAB,FA_ADDITIONS_B FA,FA_METHODS FAM,FA_DISTRIBUTION_HISTORY FDA,Fa_Locations FL
	Where FAB.Asset_Id=FA.Asset_Id 
	AND FAB.TRANSACTION_HEADER_ID_IN=(SELECT MAX(TRANSACTION_HEADER_ID_IN) 
	FROM FA_BOOKS FB1 WHERE FB1.ASSET_ID=FAB.ASSET_ID AND FB1.BOOK_TYPE_CODE=FAB.BOOK_TYPE_CODE)
	--And FA.Asset_Number IN('10000125','10000024','10000088')
	And FAB.BOOK_TYPE_CODE= :P_book_type_code
	--And FA.Asset_Key_CCID In(Select Code_Combination_Id  From FA_ASSET_KEYWORDS Where Segment1 =Nvl(:P_Asset_Key,Segment1))
	And FAB.METHOD_ID=FAM.METHOD_ID
	And  FA.Asset_Number In(SELECT fa.asset_number
	  FROM FA_ADDITIONS_B        fa,
		   fa_deprn_periods    fdp,
		   fa_deprn_summary fds
	 WHERE fa.asset_id = fds.asset_id
	   AND fdp.period_counter = fds.period_counter
	   AND fdp.book_type_code = fds.book_type_code
	   --AND fa.asset_id = 19010 
	   And fdp.book_type_code= :P_book_type_code--:P_book_type_code
	   And fdp.period_name <= :P_period_name --'2020-7'
	   )
	   --And TO_CHAR(FAB.Date_Placed_In_Service, 'YYYY-MM')<= :P_period_name --:P_period_name
	   
	   And FAB.Asset_Id=FDA.Asset_Id 
	   And FDA.BOOK_TYPE_CODE=FAB.BOOK_TYPE_CODE
	   And FL.Location_Id=FDA.Location_id
	   
	   ----Restrict Historical for transfer and adjustment start---
	   And FDA.Transaction_Header_Id_In In(Select Max(FMA.Transaction_Header_Id_In) From  FA_DISTRIBUTION_HISTORY FMA
	   Where 1=1    And FMA.Asset_Id=FDA.Asset_Id    And FMA.BOOK_TYPE_CODE=FAB.BOOK_TYPE_CODE)
	   ----Restrict Historical for transfer and adjustment End---
	   
	)Where 1=1
	And  Company_Property Between  Nvl(:P_From_Company,Company_Property) And  Nvl(:P_TO_Company,Company_Property)
	And Major_Category = Nvl(:P_Major_Category,Major_Category)
	And Minor_Category = Nvl(:P_Minor_Category,Minor_Category)
	And Asset_No Between  Nvl(:P_From_Asset,Asset_No) And Nvl(:P_To_Asset,Asset_No)

	--And Date_In_Period <=   :P_period_name


	And Asset_Key Is NUll
	And Dep_Period_Start <= :P_period_name
	Or Dep_Period_Start Is Null

	-------------------THis is for asset key null record  Start---------------------
	) A 

	Where 1=1
	AND ( (:P_ASSET_TYPE = 'Y' and 1=1) OR (:P_ASSET_TYPE = 'N' and nvl(Asset_Type,'NA') not in 'EXPENSED') )
	And Dept Between  Nvl(:P_FROM_DEPT,Dept) And  Nvl(:P_TO_DEPT,Dept)
	And Asset_No Between  Nvl(:P_From_Asset,Asset_No) And Nvl(:P_To_Asset,Asset_No)
	--AND Asset_No  in ('10024039', '10024054')

	Order By Period,Asset_no
	
	) B
	
	Order By Period,Asset_no