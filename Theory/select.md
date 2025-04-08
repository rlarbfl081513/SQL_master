# 조건문 구문
1. 기본 코드
      ```sql
      CASE
          WHEN 조건1 THEN 결과1
          WHEN 조건2 THEN 결과2
          ELSE 기본값
      END
      ```

2. 문제 활용
   - [문제링크](../programers/SELECT/LV3_대장균의크기에따라%20분류하기.md)
   - 코드
     ```sql
     -- [문제]
     -- 개체의 크기가 100이하면 = LOW, 100초과 1000이하면 =미디움, 1000초과면 하이로 분류
     
      SELECT 
        ID, 
        CASE
            WHEN SIZE_OF_COLONY <= 100 THEN 'LOW'
            WHEN SIZE_OF_COLONY <= 1000 THEN 'MEDIUM'
            ELSE 'HIGH'
          END AS SIZE

      FROM ECOLI_DATA
      ORDER BY ID;

     ```