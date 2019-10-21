CREATE TRIGGER T_JOBQUEUE
ON DSCSYS.dbo.JOBQUEUE
FOR INSERT
AS
--=====================================
--Author: 钟耀辉
--Date: 2019-09-27
--Description: 后台任务队列插入时，处理相应事务
--=====================================
DECLARE @JOBNAME VARCHAR(50)
SELECT @JOBNAME = JOBNAME FROM INSERTED
IF (@JOBNAME = 'BMSAB01') 
BEGIN
	
	DELETE
	FROM COMFORT.dbo.LL_LYXA
	WHERE 1=1
	AND RTRIM(LLXA001) + '-' + RTRIM(LLXA002) IN
	(	
		SELECT DISTINCT RTRIM(TC001) + '-' + RTRIM(TC002) FROM COMFORT.dbo.LL_LYXA
		INNER JOIN COMFORT.dbo.MOCTC ON TC001 = LLXA001 AND TC002 = LLXA002
		WHERE 1=1 AND LLXA019 = 'N' AND TC009 = 'Y'
	) 
	
END

