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

<br><br>
# ✅ 서브쿼리(Subquery)와 서브트리(Subtree) 개념 정리

### 📌 서브쿼리(Subquery)란?
- 서브쿼리는 **SQL문 안에 포함된 또 다른 SELECT 문**을 말함
- 보통 **괄호 ()로 감싸져 있고**, 메인 쿼리 내부에서 조건을 위해 사용됨
- 서브쿼리는 **하나의 값**, **행 집합**, 또는 **테이블처럼 동작하는 결과**를 반환할 수 있음

### 📌 서브트리(Subtree)란?
- SQL 실행 계획 또는 내부 구조에서, **메인 쿼리의 하위 블록**으로 작동하는 **서브쿼리 트리 구조**를 의미함
- 하나의 SELECT 안에 포함된 서브쿼리는 **트리 형태로 쿼리 분석기에 전달되며**, 이때 하위 SELECT가 서브트리 역할을 함
- 즉, **서브쿼리 = 서브트리**라고 이해해도 됨 (문맥에 따라 용어만 다르게 부름)

---

## 서브쿼리를 사용하는 이유

- **복잡한 조건을 세부적으로 분리하여 처리**하기 위해
- **다른 테이블이나 그룹의 값을 비교 대상으로 사용**하기 위해
- **JOIN보다 간단한 구조로 문제를 해결**할 수 있음

서브쿼리는 특히 아래처럼 특정 조건을 만족하는 레코드를 찾을 때 유용하다:
```sql
WHERE column = (SELECT ...)
```

---

##  예제 코드 분석

```sql
-- 각 부서별 연장장의 나이와이름을 알아내자
SELECT
  D.name AS department_name,
  E.name AS employee_name,
  E.age AS employee_age
FROM employees E
JOIN departments D
  ON D.id = E.departmentId
WHERE E.age = (
  SELECT MAX(age)
  FROM employees
  WHERE departmentId = E.departmentId
);
```

### 설명:
- `employees` 테이블과 `departments` 테이블을 조인해서, 각 직원의 부서명을 함께 가져옴
- `WHERE` 절에 있는 서브쿼리는 **현재 부서에서 가장 나이가 많은 직원**을 찾기 위한 조건
- `departmentId = E.departmentId`로 같은 부서 기준을 유지함
- 최종적으로는 **각 부서마다 최고령 직원만 출력**됨

---

##  서브트리 적용 관점에서 이 쿼리는?
- `SELECT MAX(age) ...`는 메인 쿼리의 WHERE 절 안에 포함된 서브트리 (하위 SELECT 블록)
- 이 서브쿼리는 부서 기준으로 그룹화된 조건을 만족하는 특정 직원만 걸러내는 역할
- 따라서 **메인 쿼리는 전체 조인 구조**, **서브트리는 필터링 조건을 위한 구조**라고 볼 수 있음

---

## 요약
| 용어 | 의미 |
|------|------|
| 서브쿼리 | 쿼리 내부에 포함된 또 다른 SELECT 문 |
| 서브트리 | SQL 실행 구조 상 서브쿼리가 놓이는 하위 트리 구조 |
| 사용 목적 | 복잡한 조건 처리, 다른 그룹값 비교, 필터링 등에 활용 |
| 이 쿼리의 구조 | 조인 + 부서별 MAX(age)를 갖는 직원만 필터링한 구조 |

## 예시 코드
- 가장 연봉이 높은 직원을 조회
  ```sql
  -- 부서별 가장 많은 급여를 받은 직원의 연봉과 이름
SELECT E.name, E.salary
FROM employees E
JOIN departments D
  ON D.id = E.departmentId
WHERE E.salary = (    -- 필터를 통해서 가장 연봉이 많은 사람으 이름과 연봉이 조회되도록, 서브쿼리를 작성 
  SELECT MAX(salary)  -- 부서별 가장 높은 연봉을 조회한다. 
  FROM employees
  WHERE departmentId = E.departmentId
  -- GROUP BY departmentId=E.departmentId
  ORDER BY salary DESC
  
);
-- ORDER BY salary DESC
-- LIMIT 1

SELECT D.name, E.name, E.salary
FROM employees E
JOIN departments D
  ON E.departmentId = D.id;
WHERE E.salary IN (
  SELECT name, MAX(salary)  -- 부서별 가장 높은 연봉을 조회한다. 
  FROM employees
  GROUP BY departmentId
);

SELECT name, MAX(salary)  -- 부서별 가장 높은 연봉을 조회한다. 
FROM employees
GROUP BY departmentId
  ```