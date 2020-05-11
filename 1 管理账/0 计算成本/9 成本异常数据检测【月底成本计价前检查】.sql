--进货日期当月，进货单本币税前<>发票本币税前
SELECT TA003,TB008,TB001,TB002,TB003,TB005,TB006,TB007,TB017,TH047
FROM ACPTA LEFT JOIN ACPTB ON TA001=TB001 AND TA002=TB002 
LEFT JOIN PURTH ON TB005=TH001 AND TB006=TH002 AND TB007=TH003
WHERE SUBSTRING(TA003,1,6)='202004' AND SUBSTRING(TB008,1,6)='202004'
AND TA024='Y' AND TA079='1' --AND TB004='1'
AND TB017<>TH047 
ORDER BY TB001,TB002,TB003

--进货日期非当月，进货单本币税前<>本币税前-价差
SELECT TA003,TB008,TB001,TB002,TB003,TB005,TB006,TB007,TB017,TB055,TH047
FROM ACPTA LEFT JOIN ACPTB ON TA001=TB001 AND TA002=TB002 
LEFT JOIN PURTH ON TB005=TH001 AND TB006=TH002 AND TB007=TH003
WHERE SUBSTRING(TA003,1,6)='202004' AND SUBSTRING(TB008,1,6)<>'202004'
AND TA024='Y' AND TA079='1' --AND TB004='1'
AND (TB017-TB055)<>TH047 
ORDER BY TB001,TB002,TB003

--进货单本币税前<>成本要素档金额
SELECT LH001,TH001,TH002,TH003,TH004,TH005,TH006,TH047 本币税前,SUM(LH008) 成本要素档金额
FROM PURTH INNER JOIN INVLH 
ON TH001=LH002 AND TH002=LH003 AND TH003=LH004  
WHERE LH001='202004'
GROUP BY LH001,TH001,TH001,TH002,TH003,TH004,TH005,TH006,TH047 
HAVING TH047<>SUM(LH008)
ORDER BY PURTH.TH001,TH002,TH003

--进货单本币税前<>LA013
SELECT LA001,LA006,LA007,LA008,TH047 本币税前,LA013 库存交易档金额
FROM PURTH INNER JOIN INVLA
ON TH001=LA006 AND TH002=LA007 AND TH003=LA008  
WHERE SUBSTRING(LA004,1,6)='202004'
AND TH047<>LA013

--退货日期当月，退货单本币税前<>发票本币税前
SELECT TA003,TB008,TB001,TB002,TB003,TB005,TB006,TB007,TB017,TJ032
FROM ACPTA LEFT JOIN ACPTB ON TA001=TB001 AND TA002=TB002 
LEFT JOIN PURTJ ON TB005=TJ001 AND TB006=TJ002 AND TB007=TJ003
WHERE SUBSTRING(TA003,1,6)='202004' AND SUBSTRING(TB008,1,6)='202004'
AND TA024='Y' AND TA079='1' --AND TB004='1'
AND (TB017+TJ032)<>'0'
ORDER BY TB001,TB002,TB003

--退货日期非当月，退货单本币税前<>价差-本币税前
SELECT TA003,TB008,TB001,TB002,TB003,TB005,TB006,TB007,TB017,TB055,TJ032
FROM ACPTA LEFT JOIN ACPTB ON TA001=TB001 AND TA002=TB002 
LEFT JOIN PURTJ ON TB005=TJ001 AND TB006=TJ002 AND TB007=TJ003
WHERE SUBSTRING(TA003,1,6)='202004' AND SUBSTRING(TB008,1,6)<>'202004'
AND TA024='Y' AND TA079='1' --AND TB004='1'
AND (TB055-TB017)<>TJ032 
ORDER BY TB001,TB002,TB003

--退货单本币税前<>成本要素档金额
SELECT LH001,TJ001,TJ002,TJ003,TJ004,TJ005,TJ006,TJ032 本币税前,SUM(LH008) 成本要素档金额
FROM PURTJ INNER JOIN INVLH ON TJ001=LH002 AND TJ002=LH003 AND TJ003=LH004  
WHERE LH001='202004'
GROUP BY LH001,TJ001,TJ001,TJ002,TJ003,TJ004,TJ005,TJ006,TJ032 
HAVING TJ032<>SUM(LH008)
ORDER BY PURTJ.TJ001,TJ002,TJ003

--退货单本币税前<>LA013
SELECT LA001,LA006,LA007,LA008,TJ032 本币税前,LA013 库存交易档金额
FROM PURTJ INNER JOIN INVLA ON TJ001=LA006 AND TJ002=LA007 AND TJ003=LA008  
WHERE SUBSTRING(LA004,1,6)='202004'
AND TJ032<>LA013

--其他单据不存在成本要素档
SELECT LA006,LA007,LA008,LA001,LA004,LA013,LH002,LH003,LH004
FROM INVLA LEFT JOIN INVLH ON LH002=LA006 AND LH003=LA007 AND LH004=LA008
WHERE SUBSTRING(LA004,1,6)='202004' AND LA013<>0 AND LH002 IS NULL
-- AND LA006 LIKE '56%'
ORDER BY LA006,LA007,LA008 


--确认是否存在当月暂估当月开票数据
SELECT TQ001,TQ002,TQ003,TQ010,TQ011,TQ012 FROM ACPTQ
WHERE EXISTS (SELECT 1 FROM ACPTB WHERE TQ010=TB005 AND TQ011=TB006 AND TQ012=TB007 AND TB012='Y')
AND TQ001='7G01' AND TQ002='20040001' 

SELECT TB001,TB002,TB003,TB004,TB005,TB006,TB007
FROM ACPTA LEFT JOIN ACPTB ON TA001=TB001 AND TA002=TB002 
WHERE SUBSTRING(TA003,1,6)='202004' AND TA024='Y' AND TB004='1'
AND EXISTS (SELECT 1 FROM ACPTQ WHERE TQ010=TB005 AND TQ011=TB006 AND TQ012=TB007 AND TQ001='7G01' AND TQ002='20040001')

SELECT TB001,TB002,TB003,TQ001,TQ002,TQ003,TQ010,TQ011,TQ012
FROM ACPTQ INNER JOIN ACPTB ON TQ010=TB005 AND TQ011=TB006 AND TQ012=TB007
WHERE TQ001='7G01' AND TQ002='20040001' AND TB012='Y'
ORDER BY TB001,TB002,TB003,TQ001,TQ002,TQ003,TQ010,TQ011,TQ012
