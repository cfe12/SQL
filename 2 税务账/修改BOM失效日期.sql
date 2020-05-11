SELECT MB001,MB002, CB001, CB005, CB013, CB014, MD011, MD012
-- UPDATE BOMCB SET CB014 = '20200417'
-- UPDATE BOMMD SET MD012 = '20200417'
-- INTO [BOM-SX_20200430_BAK]
FROM INVMB 
INNER JOIN BOMCB ON CB005 = MB001
INNER JOIN BOMMD ON MD003 = CB005 AND MD001 = CB001
WHERE 1=1
AND MB001 IN (SELECT WLNO FROM [192.168.0.99].ATEST.dbo.[239-BOM-SX_20200430])
AND ((CB014 IS NULL OR RTRIM(CB014) = '') OR (MD012 IS NULL OR RTRIM(MD012) = ''))
AND CB001 NOT LIKE '%c%'
ORDER BY MB001
