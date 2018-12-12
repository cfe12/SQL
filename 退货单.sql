SELECT TJ002 AS 退货单号, TJ003 AS 退货序号, TJ004 AS 退货品号, TJ009 AS 退货数量, TJ011 AS 退货仓库, TJ012 AS 退货批号,
TH002 AS 进货单号, TH003 AS 进货序号, TH007 AS 进货数量, TH015 AS 进货验收数量, ACOUNT AS 已审核退货数量, 
ML005 AS 批号库存数量

FROM PURTJ 
LEFT JOIN PURTH ON TJ013 = TH001 AND TJ014 = TH002 AND TJ015 = TH003
LEFT JOIN INVML ON ML001= TJ004 AND ML002 = TJ011 AND ML004 = TJ012
LEFT JOIN 
(
	SELECT TJ013 AS ATJ13, TJ014 AS ATJ14, TJ015 AS ATJ15, COUNT(TJ009) AS ACOUNT FROM PURTJ
	INNER JOIN PURTI ON TJ001 = TI001 AND TJ002 = TI002 
	WHERE 1=1
	AND TI013 = 'Y'
	GROUP BY TJ013, TJ014, TJ015, TJ004
) AS A ON ATJ13 = TJ013 AND ATJ14 = TJ014 AND ATJ15 = TJ015
WHERE 1=1
AND TJ002 = '18110133'
--AND TJ004 = '3040320016'
ORDER BY TJ003


SELECT TJ013 AS ATJ13, TJ014 AS ATJ14, TJ015 AS ATJ15, COUNT(TJ009) AS ACOUNT FROM PURTJ
INNER JOIN PURTI ON TJ001 = TI001 AND TJ002 = TI002 
WHERE 1=1
AND TI013 = 'Y'
AND TJ014 = '18103876'
AND TJ015 = '0001'
GROUP BY TJ013, TJ014, TJ015, TJ004