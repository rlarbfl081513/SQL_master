```sql
-- 대장균의 크기에 따라 분류하기1

-- [문제]
-- 개체의 크기가 100이하면 = LOW, 100초과 1000이하면 =미디움, 1000초과면 하이로 분류

SELECT ID,
    CASE
        WHEN SIZE_OF_COLONY <= 100 THEN 'LOW' 
        WHEN 100 < SIZE_OF_COLONY AND SIZE_OF_COLONY <= 1000 THEN 'MEDIUM' 
        WHEN SIZE_OF_COLONY > 1000 THEN 'HIGH' 
    END AS SIZE
FROM ECOLI_DATA
ORDER BY ID;
```