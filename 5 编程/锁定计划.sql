-- 锁定生产计划
SELECT COMFORT.dbo.LRPTA.*  
-- UPDATE COMFORT.dbo.LRPTA SET TA009='Y', COMPANY='COMFORT', MODIFIER='Robot', MODI_DATE=dbo.f_getTime(1), FLAG=(CONVERT ( INT, COMFORT.dbo.LRPTA.FLAG )) % 999+1 
FROM COMFORT.dbo.LRPTA
	INNER JOIN COMFORT.dbo.LRPLA ON TA001 = LA001 AND LA012 = TA050
	LEFT JOIN COMFORT.dbo.LRPLB ON LA001 = LB001 AND LA005 = LB009 AND LA012 = LB017 
WHERE 1=1
	AND LA005 = '1' AND LA013 <> '3' 
	AND RTRIM(LA001)+'-'+RTRIM(LA012)='22010000010001-0001'
	AND TA009 = 'N' 

-- 锁定采购计划 
SELECT COMFORT.dbo.LRPTC.* 
-- UPDATE COMFORT.dbo.LRPTC SET ,TC008='Y', COMPANY='COMFORT', MODIFIER='001114', MODI_DATE=dbo.f_getTime(1), FLAG=(convert(int,COMFORT.dbo.LRPTC.FLAG))%999+1 
FROM COMFORT.dbo.LRPTC 
	INNER JOIN COMFORT.dbo.LRPLA ON TC001=LA001 AND TC046 = LA012  
	LEFT  JOIN COMFORT.dbo.LRPLB ON LA001=LB001 AND LA005=LB009 AND LA012 = LB017  
WHERE 1=1 
	AND LA005='2' AND LA013 <> '3' 
	AND RTRIM(LA001)+'-'+RTRIM(LA012)='22010000010001-0001'
	AND TC008='N' 
	