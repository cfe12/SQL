
declare @Dates varchar(20), @StartDate varchar(20), @EndDate varchar(20)

set @Dates = '202005'
/*销货单的单据起始与结束日期*/
set @StartDate = @Dates + '01'
set @EndDate = @Dates + '31'

SELECT DISTINCT A1 AS 销货单号, A2 AS 客户简称, 
A4 AS 品号, A5 AS 品名, A6 AS 规格, B2 AS 仓库名称, 
A7 AS 销货数量, A3 AS 订单单号, 
A8 AS 销货日期, 
B3 AS 销货部门 
FROM 
(SELECT DISTINCT RTRIM(COPTH.TH001) + '-' + RTRIM(COPTH.TH002) + '-' + RTRIM(COPTH.TH003)AS A1, RTRIM(MA002) AS A2, 
RTRIM(COPTH.TH014) + '-' + RTRIM(COPTH.TH015) + '-' + RTRIM(COPTH.TH016) AS A3, RTRIM(COPTH.TH004) AS A4, 
RTRIM(INVMB.MB002) AS A5, RTRIM(INVMB.MB003) AS A6, CONVERT(FLOAT, TH008) AS A7, 
SUBSTRING(COPTG.TG003, 1, 4) + '-' + SUBSTRING(COPTG.TG003, 5, 2) + '-' + SUBSTRING(COPTG.TG003, 7, 2) AS A8 
FROM COPTG 
INNER JOIN COPTH ON COPTG.TG001 = COPTH.TH001 AND COPTG.TG002 = COPTH.TH002 
LEFT JOIN COPTD ON COPTD.TD001 = COPTH.TH014 AND COPTD.TD002 = COPTH.TH015 AND COPTD.TD003 = COPTH.TH016 AND COPTD.TD004 = COPTH.TH004 
LEFT JOIN COPTC ON COPTC.TC001 = COPTD.TD001 AND COPTC.TC002 = COPTD.TD002 
LEFT JOIN COPMA ON COPMA.MA001 = COPTC.TC004 
INNER JOIN INVMB ON INVMB.MB001 = COPTH.TH004 
WHERE 1=1 
AND COPTG.TG003 BETWEEN @StartDate AND @EndDate 
AND TG023 = 'Y' 
AND (COPTH.TH004 LIKE '1%' OR COPTH.TH004 LIKE '2%')) AS A 
LEFT JOIN 
(SELECT DISTINCT RTRIM(COPTH.TH001) + '-' + RTRIM(COPTH.TH002) + '-' + RTRIM(COPTH.TH003) AS B1, 
RTRIM(CMSMC.MC002) AS B2, RTRIM(CMSME.ME002) AS B3 
FROM COPTG 
LEFT JOIN COPTH ON COPTG.TG001 = COPTH.TH001 AND COPTG.TG002 = COPTH.TH002 
LEFT JOIN COPTD ON COPTD.TD001 = COPTH.TH014 AND COPTD.TD002 = COPTH.TH015 AND COPTD.TD003 = COPTH.TH016 AND COPTD.TD004 = COPTH.TH004 
LEFT JOIN MOCTA ON MOCTA.TA026 = COPTD.TD001 AND MOCTA.TA027 = COPTD.TD002 AND MOCTA.TA028 = COPTD.TD003 AND MOCTA.TA006 = COPTD.TD004 
LEFT JOIN MOCTG ON MOCTA.TA001 = MOCTG.TG014 AND MOCTA.TA002 = MOCTG.TG015 AND MOCTG.TG004 = COPTD.TD004 
LEFT JOIN MOCTF ON MOCTF.TF001 = MOCTG.TG001 AND MOCTF.TF002 = MOCTG.TG002 
LEFT JOIN CMSMC ON CMSMC.MC001 = MOCTG.TG010 
LEFT JOIN CMSME ON CMSME.ME001 = MOCTF.TF016 
WHERE 1=1 
AND MOCTA.TA011 = 'Y' 
) AS B ON A1 = B1 
ORDER BY A1 





-- SELECT SUM(A7)
-- FROM
-- 
-- (SELECT DISTINCT RTRIM(COPTH.TH001) + '-' + RTRIM(COPTH.TH002) + '-' + RTRIM(COPTH.TH003)AS A1, RTRIM(MA002) AS A2,
-- RTRIM(COPTH.TH014) + '-' + RTRIM(COPTH.TH015) + '-' + RTRIM(COPTH.TH016) AS A3, RTRIM(COPTH.TH004) AS A4,
-- RTRIM(INVMB.MB002) AS A5, RTRIM(INVMB.MB003) AS A6, TH008 AS A7,
-- SUBSTRING(COPTG.TG003, 1, 4) + '-' + SUBSTRING(COPTG.TG003, 5, 2) + '-' + SUBSTRING(COPTG.TG003, 7, 2) AS A8
-- 
-- FROM COPTG
-- INNER JOIN COPTH ON COPTG.TG001 = COPTH.TH001 AND COPTG.TG002 = COPTH.TH002
-- LEFT JOIN COPTD ON COPTD.TD001 = COPTH.TH014 AND COPTD.TD002 = COPTH.TH015 AND COPTD.TD003 = COPTH.TH016 AND COPTD.TD004 = COPTH.TH004
-- LEFT JOIN COPTC ON COPTC.TC001 = COPTD.TD001 AND COPTC.TC002 = COPTD.TD002
-- LEFT JOIN COPMA ON COPMA.MA001 = COPTC.TC004
-- INNER JOIN INVMB ON INVMB.MB001 = COPTH.TH004
-- WHERE 1=1
-- AND COPTG.TG003 BETWEEN @StartDate AND @EndDate
-- AND TG023 = 'Y'
-- --AND (MB005 = '1405' OR MB005 = '1406')
-- AND COPTH.TH004 LIKE '1%') AS A
-- 
-- LEFT JOIN 
-- (SELECT DISTINCT RTRIM(COPTH.TH001) + '-' + RTRIM(COPTH.TH002) + '-' + RTRIM(COPTH.TH003) AS B1,  
-- RTRIM(CMSMC.MC002) AS B2, RTRIM(CMSME.ME002) AS B3
-- FROM COPTG
-- LEFT JOIN COPTH ON COPTG.TG001 = COPTH.TH001 AND COPTG.TG002 = COPTH.TH002
-- LEFT JOIN COPTD ON COPTD.TD001 = COPTH.TH014 AND COPTD.TD002 = COPTH.TH015 AND COPTD.TD003 = COPTH.TH016 AND COPTD.TD004 = COPTH.TH004
-- LEFT JOIN MOCTA ON MOCTA.TA026 = COPTD.TD001 AND MOCTA.TA027 = COPTD.TD002 AND MOCTA.TA028 = COPTD.TD003 AND MOCTA.TA006 = COPTD.TD004 
-- LEFT JOIN MOCTG ON MOCTA.TA001 = MOCTG.TG014 AND MOCTA.TA002 = MOCTG.TG015 AND MOCTG.TG004 = COPTD.TD004
-- LEFT JOIN MOCTF ON MOCTF.TF001 = MOCTG.TG001 AND MOCTF.TF002 = MOCTG.TG002
-- LEFT JOIN CMSMC ON CMSMC.MC001 = MOCTG.TG010 
-- LEFT JOIN CMSME ON CMSME.ME001 = MOCTF.TF016
-- WHERE 1=1
-- AND MOCTA.TA011 = 'Y'
-- ) AS B ON A1 = B1
