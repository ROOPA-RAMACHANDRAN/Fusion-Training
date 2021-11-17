SELECT  HP.PARTY_NAME,
	      AIA.INVOICE_AMOUNT,
		  AIA.AMOUNT_PAID,
              SUBSTR(to_char(AIA.INVOICE_DATE,'YYYY-MM-DD  IW="week '),11,18) AS "DATE",
	    PSSAM.VENDOR_SITE_CODE
 FROM 
         POZ_SUPPLIERS PS,
        POZ_SUPPLIER_SITES_ALL_M PSSAM,
       AP_INVOICES_ALL AIA,
         HZ_PARTIES HP
		 
 WHERE 
	      PS.VENDOR_ID = PSSAM.VENDOR_ID
	   AND PS.VENDOR_ID = AIA.VENDOR_ID
	   AND PS.PARTY_ID = HP.PARTY_ID
	     AND TRUNC(AIA.INVOICE_DATE) BETWEEN TRUNC(NVL(:FROM_TRANS_DATE,AIA.INVOICE_DATE))
		 AND TRUNC(NVL(:TO_TRANS_DATE,AIA.INVOICE_DATE))

order by AIA.INVOICE_DATE
