--Supplier Bank Account
SELECT hp.party_name                              supplier_name, 
       site.attribute1                            EBS_Supplier_Number, 
       supp.segment1                              supplier_number, 
       site.vendor_site_code                      supplier_site, 
       hro.name Business_Unit, 
       uses.bank_account_num, 
       bank_account_name, 
       bank.bank_name, 
       bank.bank_branch_name, 
       bank.eft_swift_code, 
	   uses.BANK_ACCOUNT_TYPE,
       --,iepa.DEFAULT_PAYMENT_METHOD_CODE Payment_method_code           ,  
       ipmv.payment_method_name, 
	   iepa.REMIT_ADVICE_DELIVERY_METHOD,
	   iepa.REMIT_ADVICE_EMAIL,
       uses.iban, 
       uses.currency_code, 
       To_char(uses.start_date, 'dd-mon-yyyy')    payee_use_Start_date, 
       To_char(uses.end_date, 'dd-mon-yyyy')      payee_use_End_date, 
       uses.foreign_payment_use_flag, 
       ipy.primary_flag                           Payee_instrument_primary_flag, 
       To_char(ipy.start_date, 'dd-mon-yyyy')     external_account_start_date, 
       To_char(ipy.end_date, 'dd-mon-yyyy')       external_account_end_date, 
       To_char(uses.creation_date, 'DD-MON-YYYY') creation_date 
FROM   iby_ext_bank_accounts uses, 
       iby_pmt_instr_uses_all ipy, 
       iby_external_payees_all iepa, 
       ce_all_bank_branches_v bank, 
       poz_supplier_sites_all_m site, 
       poz_suppliers supp, 
       hz_parties hp, 
       iby_ext_party_pmt_mthds ieppm, 
       iby_payment_methods_vl ipmv,
	   hr_operating_units hro
WHERE  1 = 1 --AND supp.segment1 = '1008353'    
       AND iepa.supplier_site_id = site.vendor_site_id 
       AND ipy.instrument_id = uses.ext_bank_account_id (+) 
       AND iepa.ext_payee_id = ipy.ext_pmt_party_id (+) 
       AND site.vendor_id = supp.vendor_id 
	   and site.prc_bu_id = hro.organization_id
       AND uses.branch_id = bank.branch_party_id (+) 
       AND hp.party_id = supp.party_id 
       AND ieppm.primary_flag (+) = 'Y' 
       AND ieppm.ext_pmt_party_id (+) = iepa.ext_payee_id 
       AND ipmv.payment_method_code (+) = ieppm.payment_method_code 
       AND ipy.end_date  >= (SELECT  SYSDATE  FROM   dual) 
       AND hro.name in(:BU)
UNION ALL 
SELECT hp.party_name                              supplier_name, 
       (SELECT attribute1 
        FROM   poz_supplier_sites_all_m ass 
        WHERE  vendor_id = supp.vendor_id 
               AND ROWNUM = 1)                    EBS_Supplier_Number, 
       supp.segment1                              supplier_number, 
       ''                                         supplier_site, 
       hro.name Business_Unit, 
       uses.bank_account_num, 
       bank_account_name, 
       bank.bank_name, 
       bank.bank_branch_name, 
       bank.eft_swift_code, 
	   uses.BANK_ACCOUNT_TYPE,
       --,iepa.DEFAULT_PAYMENT_METHOD_CODE Payment_method_code              
       ipmv.payment_method_name, 
	   iepa.REMIT_ADVICE_DELIVERY_METHOD,
	   iepa.REMIT_ADVICE_EMAIL,
       uses.iban, 
       uses.currency_code, 
       To_char(uses.start_date, 'dd-mon-yyyy')    payee_use_Start_date, 
       To_char(uses.end_date, 'dd-mon-yyyy')      payee_use_End_date, 
       uses.foreign_payment_use_flag, 
       ipy.primary_flag                           Payee_instrument_primary_flag, 
       To_char(ipy.start_date, 'dd-mon-yyyy')     external_account_start_date, 
       To_char(ipy.end_date, 'dd-mon-yyyy')       external_account_end_date, 
       To_char(uses.creation_date, 'DD-MON-YYYY') creation_date 
FROM   iby_ext_bank_accounts uses, 
       iby_pmt_instr_uses_all ipy, 
       iby_external_payees_all iepa, 
       ce_all_bank_branches_v bank, 
       poz_supplier_sites_all_m site,   
       poz_suppliers supp, 
       hz_parties hp, 
       iby_ext_party_pmt_mthds ieppm, 
       iby_payment_methods_vl ipmv,
       hr_operating_units hro	   
WHERE  1 = 1 -- AND supp.segment1 = '1008353'     
       AND iepa.payee_party_id (+) = supp.party_id 
       AND site.vendor_id = supp.vendor_id 
	   AND iepa.party_site_id IS NULL 
       AND iepa.supplier_site_id IS NULL 
       AND ipy.instrument_id = uses.ext_bank_account_id (+) 
       AND iepa.ext_payee_id = ipy.ext_pmt_party_id (+) 
       AND uses.branch_id = bank.branch_party_id (+) 
       AND hp.party_id = supp.party_id 
       AND ieppm.primary_flag (+) = 'Y' 
       AND ieppm.ext_pmt_party_id (+) = iepa.ext_payee_id 
       AND ipmv.payment_method_code (+) = ieppm.payment_method_code 
	   and site.prc_bu_id = hro.organization_id
       AND hro.name in (:BU) 
ORDER  BY 1,  3

--Lookup

select distinct NAME from HR_OPERATING_UNITS 
Where name in ('AIT','ATS','CHZ','COSMOS','MPET','PSAFE','PSAA','PSAZ','PPIT','PSL','PST','MIP','MMI','MMP','SGP','NPCT1')
order by 1