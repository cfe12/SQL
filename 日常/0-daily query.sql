--# 自动脚本处理说明
--#   1.--#为注释关键字，SQL不读取，Python不读取
--#   2.--|为段首关键字，用于区分每一段脚本，SQL不读取，Python读取
--#     并且用于内容返回的标题
--#   3./****/此类为注释，Python中尚未加入判断略过
--#
--#日常查询
USE COMFORT

--|破核领料单
SELECT DISTINCT '破核领料单' AS INF, 
TC001 AS 单别, 
TC002 AS 单号, 
--TE004 AS 品号,  
TC009 AS 单头审核码, 
TE019 AS 单身审核码 
FROM MOCTC
LEFT JOIN MOCTE ON TC001 = TE001 AND TC002 = TE002
WHERE TC009 = 'U'


--|领料单头审单身未审
SELECT DISTINCT '领料单单头审单身未审' AS INF, 
RTRIM(TA001) AS 工单别, RTRIM(TA002) AS 工单号, RTRIM(TC001) AS 领料单别, RTRIM(TC002) AS 领料单号 
FROM MOCTA 
INNER JOIN MOCTB ON TA001 = TB001 AND TA002 = TB002 
INNER JOIN MOCTE ON TE011 = TA001 AND TE012 = TA002 AND TE004 = TB003 
INNER JOIN MOCTC ON TE001 = TC001 AND TE002 = TC002 
WHERE 1=1 
AND TA013 = 'Y' AND TA011 != 'y' AND TC009 != 'V' 
AND TC009 = 'Y' AND TE019 = 'N' 


--|层级码带X
SELECT '层级码带X' AS INF, RTRIM(TR001) AS T1,TR002 AS T2,TR003 AS T3,TR004 AS T4,TR009 AS T5 
--DELETE 
FROM COPTR
WHERE TR003 like 'X%'
AND TR001 = '10670102'

SELECT '层级码超长' AS INF, TR001 AS T1,TR002 AS T2,TR003 AS T3,TR004 AS T4,TR009 AS T5 FROM COPTR WHERE LEN(TR003) >= 58


----|PDA后台审核情况
SELECT DISTINCT MODI_DATE, RTRIM(LLXA001) LLXA001, RTRIM(LLXA002) LLXA002, LLXA007 FROM LL_LYXA
WHERE 1=1
AND SUBSTRING(LLXA007, 3, 8) >= '20180716'
AND MODI_DATE IS NULL
ORDER BY LLXA007, LLXA001, LLXA002

SELECT *FROM LL_LYXA
WHERE LLXA001 = '5406' AND LLXA002 = '2018101551'
