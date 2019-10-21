

-- INSERT INTO ROBOT_TEST..SCHEDULE(CREATOR, CREATE_DATE, SC001, SC002, SC003, SC004, 
SC005, SC006, SC007, SC008, SC009, SC010, SC011, SC012, SC013, SC014, 
SC015, SC016, SC017, SC018, SC019, SC020, SC021, SC022, SC023, SC024, SC025, SC026)

SELECT CREATOR, CREATE_DATE, SC001, SC002, SC003, SC004, SC005, SC006, SC007, SC008, 
SC009, SC010, SC011, SC012, SC013, SC014, SC015, SC016, SC017, SC018, SC019, SC020, 
SC021, SC022, SC023, SC024, SC025, SC026 
FROM WG_DB..SC_PLAN AS SC0
WHERE 1=1
AND NOT EXISTS ( SELECT 1 FROM ROBOT_TEST..SCHEDULE AS SC1 WHERE SC0.SC001 = SC1.SC001 AND SC0.SC003 = SC1.SC003 )
AND SC023 = '生产五部'
ORDER BY CREATE_DATE

