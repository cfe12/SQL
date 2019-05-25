
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

--|领料单未生成二次单据的
-- SELECT MOCTENoTwice.*, TC001, TC002 FROM MOCTENoTwice 
-- LEFT JOIN MOCTC ON TE001=TC019 AND TE002=TC020
-- INNER JOIN MOCTB ON TE011=TB001 AND TE012=TB002 AND TE004=TB003 AND TE009=TB006
-- WHERE TE005 != WLL
-- AND TC002 IS NULL
-- AND TB004-TB005>0
-- ORDER BY CREATE_DATE

--|层级码带X
SELECT DISTINCT '层级码带X' AS INF, RTRIM(TR001) AS T1--,TR002 AS T2,TR003 AS T3,TR004 AS T4,TR009 AS T5 
--DELETE 
FROM COPTR
WHERE TR003 like 'X%'
AND TR001 = '10840161'

SELECT '层级码超长' AS INF, TR001 AS T1,TR002 AS T2,TR003 AS T3,TR004 AS T4,TR009 AS T5 FROM COPTR WHERE LEN(TR003) >= 58
