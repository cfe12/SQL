
SELECT DISTINCT TW.CREATE_DATE 领料单单身审核时间,
RTRIM(TA001) AS 工单别, RTRIM(TA002) AS 工单号, 
(CASE TA011 WHEN '1' THEN '未生产' WHEN '2' THEN '已发料' WHEN '3' THEN '生产中' WHEN 'Y' THEN '已完工' END) AS 工单状态, 
RTRIM(TB003) AS 品号, RTRIM(MB002) AS 品名, TB006 AS 工艺, TB009 AS 工单仓位,TB004 AS 工单需领用量, CONVERT(VARCHAR(20), (CONVERT(FLOAT, TB004) - CONVERT(FLOAT, TB005))) AS 工单未领用量, 
RTRIM(TC019) 来源单别, RTRIM(TC020) 来源单号, RTRIM(TC001) AS 领退料单别, RTRIM(TC002) AS 领退料单号, RTRIM(TC009) AS 领退料单头审核码, RTRIM(MOCTE.TE019) AS 领退料单身审核码, 
MOCTE.TE003 AS 领退料单序号, (CASE SUBSTRING(TC001,1,2) WHEN '54' THEN '领料' WHEN '56' THEN '退料' ELSE TC001 END) 领退料, MOCTE.TE005 AS 领退料数量, MOCTE.TE027 AS 领退料库存数量, MOCTE.TE008 AS 领料单仓位, MOCTE.TE010 AS 领料单批号

FROM MOCTA
INNER JOIN MOCTB ON TA001 = TB001 AND TA002 = TB002
LEFT JOIN MOCTE ON TB001 = MOCTE.TE011 AND TB002 = MOCTE.TE012 AND TB003 = MOCTE.TE004 AND MOCTE.TE009 = TB006
INNER JOIN MOCTC ON MOCTE.TE001 = TC001 AND MOCTE.TE002 = TC002 
LEFT JOIN INVLA ON LA006 = TC001 AND LA007 = TC002 AND LA001 = MOCTE.TE004 AND RTRIM(TA001) + '-' + RTRIM(TA002) = RTRIM(LA024) AND LA008 = MOCTE.TE003
INNER JOIN INVMB ON TB003 = MB001

INNER JOIN MOCTENoTwice AS TW ON TW.TE011 = TB001 AND TW.TE012 = TB002 AND TW.TE004 = TB003 AND TW.TE009 = TB006

WHERE 1=1
AND TA013 != 'V' AND TA011 != 'y' --AND TC009 != 'V'
--AND TC009 = 'Y'
--AND MOCTE.TE019 = 'N'
--AND TA002 = '18121243' --工单号
--AND CONVERT(FLOAT, TB004) - CONVERT(FLOAT, TB005) > 0  --工单需领数量
--AND MOCTE.TE005 != LA011 --领料数量与库存交易明细不一致
--AND RTRIM(TC001) + '-' + RTRIM(TC002) = '5601-19010002' --领退料单号
--AND TB003 = '3070202011' --品号
--AND MOCTE.TE009 = '0302' --工艺
--AND LA011 IS NOT NULL AND CONVERT(FLOAT, TB004) - CONVERT(FLOAT, TB005) > 0--工单未领用量没发生变化
AND TA011 IN ('2', '3')
AND SUBSTRING(TW.CREATE_DATE, 1, 8) = '20190108'
ORDER BY RTRIM(TA001), RTRIM(TA002), RTRIM(TB003), TB006, RTRIM(TC001), RTRIM(TC002), MOCTE.TE003