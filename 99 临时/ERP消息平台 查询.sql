SELECT TOP 100 TD001 流水号, SUBSTRING(TD004, 1, 4) + '-' + SUBSTRING(TD004, 5, 2) + '-' + SUBSTRING(TD004, 7, 2) + ' ' + SUBSTRING(TD004, 9, 2) + ':' + SUBSTRING(TD004, 11, 2) + ':' + SUBSTRING(TD004, 13, 2) 执行时间, 
TD002 发送人, TD006 消息标题, 
SUBSTRING(CONVERT(VARCHAR(255), TD008), LEN(CONVERT(VARCHAR(255), TD008))-7, LEN(CONVERT(VARCHAR(255), TD008))) 截取内容, TD008 消息详细内容html, 
TD003 收件人信息xml--, TD007
FROM DSCSYS..ADMTD
WHERE 1=1
AND TD002 = '001167'
AND TD006 = '新增品号信息（生管）'
AND SUBSTRING(TD004, 1, 8) = '20190112'
--AND SUBSTRING(CONVERT(VARCHAR(255), TD008), LEN(CONVERT(VARCHAR(255), TD008))-7, LEN(CONVERT(VARCHAR(255), TD008)))
--	IN ('10540445', '10260429')
	
ORDER BY TD004
	
	
--SELECT TOP 100 * FROM DSCSYS..ADMTD
