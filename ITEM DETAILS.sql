SELECT INVENTORY_ORGANIZATION,
         ITEM_NUMBER,
         DESCRIPTION,
         CATEGORY_CODE,
                   TO_CHAR (
                      CAST (
                         (FROM_TZ (CAST (max(COST_DATE) AS TIMESTAMP), '+00:00')
                             AT TIME ZONE 'Asia/Singapore') AS DATE),
                      'DD-MON-YYYY HH24:MI') COST_DATE,   
                  TO_CHAR (
                      CAST (
                         (FROM_TZ (CAST (max(COST_ASOF_DATE) AS TIMESTAMP),
                                   '+00:00')
                             AT TIME ZONE 'Asia/Singapore') AS DATE),
                      'DD-MON-YYYY HH24:MI') COST_ASOF_DATE,					  
         TO_NUMBER(MAX (ITEM_COST)) ITEM_COST,
         Serial_number,
		 ITEM_CLASS_NAME,
		 (COST_ORG_NAME||'-'||INVENTORY_ORGANIZATION||'-'||Serial_number) VALUATION_UNIT
		 
    FROM (  SELECT ORG.ORGANIZATION_CODE INVENTORY_ORGANIZATION,
                   CICV.ITEM_NUMBER,
                   CICV.DESCRIPTION,
                   ECB.CATEGORY_CODE,
                      CICV.COST_DATE,
                      CICV.COST_ASOF_DATE,
					  CICV.COST_ORG_NAME,
                   ROUND ( (CICV.TOTAL_COST), CICV.EXTENDED_PRECISION) ITEM_COST,
                   REGEXP_SUBSTR (CICV.VAL_UNIT_CODE,
                                  '[^-]+',
                                  1,
                                  3)
                      Serial_number,
		 EICT.ITEM_CLASS_NAME
              FROM CST_ITEM_COSTS_V CICV,
                   EGP_ITEM_CATEGORIES EIC,
                   EGP_CATEGORY_SETS_B ECSB,
                   EGP_CATEGORIES_B ECB,
                   INV_ORG_PARAMETERS ORG,
				   EGP_SYSTEM_ITEMS ESI,
				   EGP_ITEM_CLASSES_TL EICT
             WHERE     CICV.inventory_item_id = EIC.inventory_item_id
                   AND CICV.organization_id = EIC.organization_id
                   AND ECSB.category_set_id = EIC.category_set_id
                   AND UPPER (ECSB.CATALOG_CODE) = 'EP_INVENTORY_CATALOG'
                   AND EIC.category_id = ECB.category_id
                   AND ECB.CATEGORY_CODE = 'FinishedGoods'
                   AND ORG.ORGANIZATION_ID = CICV.ORGANIZATION_ID
                   --AND ORG.ORGANIZATION_CODE = :P_ORG
				   and CICV.ITEM_NUMBER = '20372-R450-1_15-4' 
				   AND CICV.inventory_item_id 		= ESI.inventory_item_id
                   AND CICV.organization_id 		= ESI.organization_id
				   AND ESI.ITEM_CATALOG_GROUP_ID 	= EICT.ITEM_CLASS_ID
          ORDER BY CICV.cost_date DESC)
GROUP BY INVENTORY_ORGANIZATION,
         ITEM_NUMBER,
         DESCRIPTION,
         CATEGORY_CODE,                 
         Serial_number,
		 ITEM_CLASS_NAME,
		 COST_ORG_NAME