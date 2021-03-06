-- =============================================
-- Author:		Harvey
-- Create date: 2020/4/14
-- Description:	根据传入的单别，对相应的表查找，获取最新的单号
-- =============================================
CREATE PROCEDURE [dbo].P_GETDH 
@MQ001 AS varchar(10) = '' -- 单别
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DH VARCHAR(20) -- 返回的单号
	SET @DH = ''
	
	IF (@MQ001!='') AND EXISTS (SELECT 1 FROM CMSMQ(NOLOCK) WHERE MQ001 = @MQ001 AND MQ029='N')
		BEGIN 
			DECLARE @NYR VARCHAR(8), @NY VARCHAR(6), @XH INT, 
			@MQ003 CHAR(2), -- 单据性质
			@MQ004 CHAR(1), -- 编码方式:1.日编，2.月编，3.流水号，4.手动编号
			@MQ005 INT, -- 年位数
			@MQ006 INT -- 流水号位数
			
			SELECT @NYR = CONVERT(VARCHAR(20), GETDATE(), 112)
			SELECT @NY = LEFT(@NYR, 6)
			
			SELECT @MQ003=MQ003, @MQ004=MQ004, @MQ005=CAST(MQ005 AS INT) + 2, @MQ006=CAST(MQ006 AS INT) FROM CMSMQ(NOLOCK) WHERE MQ001 = @MQ001
			
			-- 库存交易单
			IF (@MQ003 IN ('11'))
			BEGIN 
				IF (@MQ004 NOT IN ('4'))
				BEGIN 
					IF (@MQ004 = '1')
					BEGIN
						IF EXISTS(SELECT 1 FROM INVTA(NOLOCK) WHERE TA001 = @MQ001 AND LEFT(TA002, @MQ005) = RIGHT(@NYR, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TA002)), @MQ006) AS INT) FROM INVTA(NOLOCK) WHERE TA001 = @MQ001 AND LEFT(TA002, @MQ005) = RIGHT(@NYR, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NYR, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '2')
					BEGIN
						IF EXISTS(SELECT 1 FROM INVTA(NOLOCK) WHERE TA001 = @MQ001 AND LEFT(TA002, @MQ005) = RIGHT(@NY, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TA002)), @MQ006) AS INT) FROM INVTA(NOLOCK) WHERE TA001 = @MQ001 AND LEFT(TA002, @MQ005) = RIGHT(@NY, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NY, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '3')
					BEGIN
						IF EXISTS(SELECT 1 FROM INVTA(NOLOCK) WHERE TA001 = @MQ001)
						BEGIN 
							SELECT @XH = CAST(MAX(RTRIM(TA002)) AS INT) FROM INVTA WHERE TA001 = @MQ001 
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
				END
			END
			
			-- 客户订单
			IF (@MQ003='22')
			BEGIN 
				IF (@MQ004 NOT IN ('4'))
				BEGIN 
					IF (@MQ004 = '1')
					BEGIN
						IF EXISTS(SELECT 1 FROM COPTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NYR, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TC002)), @MQ006) AS INT) FROM COPTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NYR, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NYR, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '2')
					BEGIN
						IF EXISTS(SELECT 1 FROM COPTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NY, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TC002)), @MQ006) AS INT) FROM COPTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NY, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NY, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '3')
					BEGIN
						IF EXISTS(SELECT 1 FROM COPTC(NOLOCK) WHERE TC001 = @MQ001)
						BEGIN 
							SELECT @XH = CAST(MAX(RTRIM(TC002)) AS INT) FROM COPTC(NOLOCK) WHERE TC001 = @MQ001 
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
				END
			END
			
			-- 销货单
			IF (@MQ003='23')
			BEGIN 
				IF (@MQ004 NOT IN ('4'))
				BEGIN 
					IF (@MQ004 = '1')
					BEGIN
						IF EXISTS(SELECT 1 FROM COPTG(NOLOCK) WHERE TG001 = @MQ001 AND LEFT(TG002, @MQ005) = RIGHT(@NYR, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TG002)), @MQ006) AS INT) FROM COPTG(NOLOCK) WHERE TG001 = @MQ001 AND LEFT(TG002, @MQ005) = RIGHT(@NYR, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NYR, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '2')
					BEGIN
						IF EXISTS(SELECT 1 FROM COPTG(NOLOCK) WHERE TG001 = @MQ001 AND LEFT(TG002, @MQ005) = RIGHT(@NY, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TG002)), @MQ006) AS INT) FROM COPTG(NOLOCK) WHERE TG001 = @MQ001 AND LEFT(TG002, @MQ005) = RIGHT(@NY, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NY, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '3')
					BEGIN
						IF EXISTS(SELECT 1 FROM COPTG(NOLOCK) WHERE TG001 = @MQ001)
						BEGIN 
							SELECT @XH = CAST(MAX(RTRIM(TG002)) AS INT) FROM COPTG(NOLOCK) WHERE TG001 = @MQ001 
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
				END
			END
			
			-- 采购单
			IF (@MQ003='33')
			BEGIN 
				IF (@MQ004 NOT IN ('4'))
				BEGIN 
					IF (@MQ004 = '1')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NYR, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TC002)), @MQ006) AS INT) FROM PURTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NYR, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NYR, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '2')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NY, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TC002)), @MQ006) AS INT) FROM PURTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NY, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NY, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '3')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTC(NOLOCK) WHERE TC001 = @MQ001)
						BEGIN 
							SELECT @XH = CAST(MAX(RTRIM(TC002)) AS INT) FROM PURTC WHERE TC001 = @MQ001 
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
				END
			END
			
			-- 采购进货单
			IF (@MQ003='34')
			BEGIN 
				IF (@MQ004 NOT IN ('4'))
				BEGIN 
					IF (@MQ004 = '1')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTG(NOLOCK) WHERE TG001 = @MQ001 AND LEFT(TG002, @MQ005) = RIGHT(@NYR, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TG002)), @MQ006) AS INT) FROM PURTG(NOLOCK) WHERE TG001 = @MQ001 AND LEFT(TG002, @MQ005) = RIGHT(@NYR, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NYR, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '2')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTG(NOLOCK) WHERE TG001 = @MQ001 AND LEFT(TG002, @MQ005) = RIGHT(@NY, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TG002)), @MQ006) AS INT) FROM PURTG(NOLOCK) WHERE TG001 = @MQ001 AND LEFT(TG002, @MQ005) = RIGHT(@NY, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NY, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '3')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTG(NOLOCK) WHERE TG001 = @MQ001)
						BEGIN 
							SELECT @XH = CAST(MAX(RTRIM(TG002)) AS INT) FROM PURTG(NOLOCK) WHERE TG001 = @MQ001 
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
				END
			END
			
			-- 采购退货单
			IF (@MQ003='35')
			BEGIN 
				IF (@MQ004 NOT IN ('4'))
				BEGIN 
					IF (@MQ004 = '1')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTI(NOLOCK) WHERE TI001 = @MQ001 AND LEFT(TI002, @MQ005) = RIGHT(@NYR, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TI002)), @MQ006) AS INT) FROM PURTI(NOLOCK) WHERE TI001 = @MQ001 AND LEFT(TI002, @MQ005) = RIGHT(@NYR, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NYR, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '2')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTI(NOLOCK) WHERE TI001 = @MQ001 AND LEFT(TI002, @MQ005) = RIGHT(@NY, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TI002)), @MQ006) AS INT) FROM PURTI(NOLOCK) WHERE TI001 = @MQ001 AND LEFT(TI002, @MQ005) = RIGHT(@NY, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NY, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '3')
					BEGIN
						IF EXISTS(SELECT 1 FROM PURTI(NOLOCK) WHERE TI001 = @MQ001)
						BEGIN 
							SELECT @XH = CAST(MAX(RTRIM(TI002)) AS INT) FROM PURTI(NOLOCK) WHERE TI001 = @MQ001 
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
				END
			END
			
			-- 领退料单
			IF (@MQ003 IN ('54', '56'))
			BEGIN 
				IF (@MQ004 NOT IN ('4'))
				BEGIN 
					IF (@MQ004 = '1')
					BEGIN
						IF EXISTS(SELECT 1 FROM MOCTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NYR, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TC002)), @MQ006) AS INT) FROM MOCTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NYR, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NYR, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '2')
					BEGIN
						IF EXISTS(SELECT 1 FROM MOCTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NY, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TC002)), @MQ006) AS INT) FROM MOCTC(NOLOCK) WHERE TC001 = @MQ001 AND LEFT(TC002, @MQ005) = RIGHT(@NY, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NY, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '3')
					BEGIN
						IF EXISTS(SELECT 1 FROM MOCTC(NOLOCK) WHERE TC001 = @MQ001)
						BEGIN 
							SELECT @XH = CAST(MAX(RTRIM(TC002)) AS INT) FROM MOCTC(NOLOCK) WHERE TC001 = @MQ001 
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
				END
			END
			
			-- 生产入库单
			IF (@MQ003 IN ('58'))
			BEGIN 
				IF (@MQ004 NOT IN ('4'))
				BEGIN 
					IF (@MQ004 = '1')
					BEGIN
						IF EXISTS(SELECT 1 FROM MOCTF(NOLOCK) WHERE TF001 = @MQ001 AND LEFT(TF002, @MQ005) = RIGHT(@NYR, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TF002)), @MQ006) AS INT) FROM MOCTF(NOLOCK) WHERE TF001 = @MQ001 AND LEFT(TF002, @MQ005) = RIGHT(@NYR, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NYR, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '2')
					BEGIN
						IF EXISTS(SELECT 1 FROM MOCTF(NOLOCK) WHERE TF001 = @MQ001 AND LEFT(TF002, @MQ005) = RIGHT(@NY, @MQ005))
						BEGIN 
							SELECT @XH = CAST(RIGHT(MAX(RTRIM(TF002)), @MQ006) AS INT) FROM MOCTF(NOLOCK) WHERE TF001 = @MQ001 AND LEFT(TF002, @MQ005) = RIGHT(@NY, @MQ005)
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT(@NY, @MQ005) + RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
					IF (@MQ004 = '3')
					BEGIN
						IF EXISTS(SELECT 1 FROM MOCTF(NOLOCK) WHERE TF001 = @MQ001)
						BEGIN 
							SELECT @XH = CAST(MAX(RTRIM(TF002)) AS INT) FROM MOCTF(NOLOCK) WHERE TF001 = @MQ001 
						END 
						ELSE 
						BEGIN 
							SET @XH = 0 
						END 
						SELECT @DH = RIGHT('000000000000000000000' + CAST(@XH+1 AS VARCHAR(20)), @MQ006)
					END
				END
			END
	END 
	SET NOCOUNT OFF
	SELECT @DH AS DH 
END