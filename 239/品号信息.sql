USE Comfortseating

SELECT 
RTRIM(MB001) AS 品号, 
RTRIM(MB002) AS 品名, 
RTRIM(MB003) AS 规格, 
RTRIM(MB064) AS 库存量, 
RTRIM(MB025) AS 品号属性, 
(CASE WHEN MB109 = 'Y' THEN '已核准' WHEN MB109 = 'y' THEN '尚未核准' WHEN MB109 = 'N' THEN '不准交易' END ) AS 核准状况, 
RTRIM(MB032) AS 供应商编码, 
RTRIM(MA002) 供应商简称 

FROM INVMB
LEFT JOIN PURMA ON MA001 = MB032
ORDER BY MB109 DESC , MB025, MB001
