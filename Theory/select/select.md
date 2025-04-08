# ✅ 조건문 구문
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
  
  <br><br>
## SQL 조건문 정리: LIKE, IN, LIMIT 사용 시 주의점

### ❌ 잘못된 문법 예시
```sql
SELECT *
FROM artists
WHERE Name IN (LIKE 'Vinícius%' LIMIT 2);
```

### 🚫 왜 틀렸는가?
- `IN`과 `LIKE`는 **함께 사용할 수 없는 구조**이다.
- `LIKE`는 **문자열 패턴 일치 조건**으로 단독 사용해야 한다.
- `LIMIT`은 **`SELECT` 문에서만 사용 가능**하며, `WHERE` 절 내부에서는 사용할 수 없다.

---

### ✅ 올바른 문법 예시
```sql
SELECT *
FROM artists
WHERE Name LIKE 'Vinícius%'
LIMIT 2;
```

### 📌 이 쿼리가 의미하는 것
- `Name LIKE 'Vinícius%'` : 이름이 "Vinícius"로 시작하는 데이터를 찾는다.
- `LIMIT 2` : 그중 최대 2개의 결과만 출력한다.

---

### 💡 배운 개념 요약
| 개념 | 설명 |
|------|------|
| `LIKE` | 문자열이 특정 패턴과 일치하는지 확인할 때 사용. `%`는 와일드카드로 사용됨. |
| `IN` | 특정 값들 중 하나와 일치하는지 확인할 때 사용. 예: `WHERE Name IN ('A', 'B')` |
| `LIMIT` | 결과 행의 개수를 제한할 때 사용. 반드시 `SELECT` 문에서만 사용 가능. |

---

### 🧠 추가 팁
- SQLite에서는 `LIKE`가 기본적으로 **대소문자 구분을 하지 않음**
- 보다 정확한 검색이 필요할 경우 `COLLATE` 또는 `LOWER()` 활용 가능
- 두 개 다 **문자열 비교할 때 대소문자 구분을 제어하기 위한 방법**이야.


#### `LOWER()` 함수

- 문자열을 **전부 소문자**로 변환함
- 대소문자 구분 없이 비교하고 싶을 때 유용함

```sql
SELECT *
FROM artists
WHERE LOWER(Name) LIKE 'vinícius%';
```

> → Name 컬럼을 소문자로 바꿔서 `'vinícius%'`와 비교

---

#### `COLLATE NOCASE`

- SQLite의 `COLLATE`는 **문자열 비교 방식(정렬 규칙)**을 지정할 수 있음
- `COLLATE NOCASE`는 **대소문자 무시하고 비교하겠다**는 뜻

```sql
SELECT *
FROM artists
WHERE Name LIKE 'vinícius%' COLLATE NOCASE;
```

> → 대소문자 구분 없이 "Vinícius", "vinícius", "VINÍCIUS" 등 모두 찾음

---

### 비교 정리

| 방법 | 설명 | 특징 |
|------|------|------|
| `LOWER()` | 소문자로 바꾼 후 비교 | 문자열 가공 (약간 느릴 수 있음) |
| `COLLATE NOCASE` | 비교 시 대소문자 무시 | 더 SQL스러움, 성능에도 유리할 수 있음 |

---


<br><br>

# ✅ 날짜 데이터
1. strftime
     - sqlite에서 날짜와 시간을 원하는 형식의 문자열로 변환해주는 함수
     - string format time : 시간 데이터를 문자열로 포맷팅하는 함수
     - 기본형식 
       ```sql
         strftime('포맷코드', 날짜컬럼)
         strftime('%Y', 테이블)       -- 년도
         strftime('%m', '2023-05-12') -- 월
         strftime('%d', '2023-05-12') -- 일
         strftime('%h', '2023-05-12') -- 시 
         strftime('%M', '2023-05-12') -- 분 
         strftime('%s', '2023-05-12') -- 초 

         strftime('%Y-%m', '2023-05-12') -- 년 월 

       ```
2. 활용 코드
   1. 년도만 추출
      ```sql
      -- 년월일로 주어져있을떄 여기서 년도만을 기준으로 그룹화하여 조회 
        SELECT 
          strftime('%Y', InvoiceDate) AS Year,  -- ← 여기서 만든 'Year'
          SUM(Total) AS TotalSales
        FROM invoices
        GROUP BY Year   -- ← 여기서 그 'Year'를 기준으로 묶는 것!
      ```