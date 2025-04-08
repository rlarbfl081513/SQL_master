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

##  서브쿼리 예제 코드 분석

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

###  서브트리 적용 관점에서 이 쿼리는?
- `SELECT MAX(age) ...`는 메인 쿼리의 WHERE 절 안에 포함된 서브트리 (하위 SELECT 블록)
- 이 서브쿼리는 부서 기준으로 그룹화된 조건을 만족하는 특정 직원만 걸러내는 역할
- 따라서 **메인 쿼리는 전체 조인 구조**, **서브트리는 필터링 조건을 위한 구조**라고 볼 수 있음

---

### 요약
| 용어 | 의미 |
|------|------|
| 서브쿼리 | 쿼리 내부에 포함된 또 다른 SELECT 문 |
| 서브트리 | SQL 실행 구조 상 서브쿼리가 놓이는 하위 트리 구조 |
| 사용 목적 | 복잡한 조건 처리, 다른 그룹값 비교, 필터링 등에 활용 |
| 이 쿼리의 구조 | 조인 + 부서별 MAX(age)를 갖는 직원만 필터링한 구조 |

## MAX에서의 서브쿼리
### 예시 :  SQL에서 부서별 최고 연봉자 조회 쿼리 차이 분석

### 🔍 문제 상황
부서별로 가장 연봉이 높은 직원을 조회하고자 할 때, 아래와 같은 SQL 쿼리를 작성할 수 있다.

---

### ✅ 예시 1: `salary = MAX(...)` 방식
```sql
SELECT E.name, E.salary
FROM employees E
WHERE E.salary = (
  SELECT MAX(salary)
  FROM employees
  WHERE departmentId = E.departmentId
);
```

- **설명**:
  - `MAX(salary)`는 해당 부서에서 가장 높은 연봉 하나를 반환한다.
  - 그 값과 같은 연봉을 받는 직원은 **여러 명일 수 있고**, **그들 모두 조회된다.**
- **결과**:
  - 같은 연봉을 받는 사람이 2명 이상이면, 그 **모든 사람이 출력**됨.
- **사용 예시**:
  - 부서별 최고 연봉을 받는 **모든 직원**을 알고 싶을 때.

---

### 예시 2: `(name, salary) = (...)` 튜플 비교 방식
```sql
SELECT E.name, E.salary
FROM employees E
WHERE (E.name, E.salary) = (
  SELECT name, MAX(salary)
  FROM employees
  WHERE departmentId = E.departmentId
);
```

- **설명**:
  - `(name, salary)`는 두 컬럼을 하나의 튜플로 묶어 **정확히 일치하는 한 사람**만 찾는다.
  - MAX(salary)는 집계함수니까 1개의 값만나옴. name은 집계함수가 아니니까 여러값 중 하나가 임의로 선택돼서 함께 반환됨. 결국 이 쿼리는 한명의 name&salart를 반환해
- **결과**:
  - 같은 연봉을 가진 여러 명 중 **임의의 한 사람만 조회됨** (나머지는 누락됨).
- 튜플을 쓰는 이유를 예시와 함께
  ```SQL
  WHERE (E.name, E.salary) = ('Alice', 500)
  -- 이름도 Alice
  -- 연봉도 500
  -- 이 두 조건을 동시에 만족하는 한 사람만 찾는 거지.
  ```

---

### ✅ 예시 3: `GROUP BY departmentId` 방식
```sql
SELECT name, MAX(salary)
FROM employees
GROUP BY departmentId;
```

- **설명**:
  - 부서별로 하나의 행만 반환하고, 각 행에는 해당 부서에서 가장 높은 연봉(`MAX(salary)`)이 나온다.
  - 하지만 `name`은 그룹화 기준도 아니고 집계 함수도 아니라서, **해당 그룹 내 아무 이름이나 가져오게 된다.**
- **결과**:
  - 부서별로 한 명씩 나오긴 하지만, 그 사람이 정말 최고 연봉자인지 보장되지 않는다.

---

### 🔎 왜 튜플을 쓰는가?
- 두 개 이상의 컬럼을 동시에 비교할 때 **튜플 비교**를 사용한다.
- `(name, salary) = (...)`는 이름과 연봉이 **정확히 일치하는 한 사람**을 찾고 싶을 때 사용된다.
- 하지만 대부분의 경우는 튜플 비교보다 **연봉 조건만 사용하는 것이 더 직관적이고 안전**하다.

---

### ✅ 정리 요약
| 쿼리 방식                        | 조회 결과 설명                                           |
|-------------------------------|------------------------------------------------------|
| `salary = (SELECT MAX(...))`  | 같은 연봉을 받는 **모든 직원** 조회                     |
| `(name, salary) = (...)`      | 연봉이 같아도 **한 명만 조회됨** (튜플로 정확히 일치하는 한 사람) |
| `GROUP BY` + `MAX(salary)`     | 연봉은 정확하지만 **이름은 임의**일 수 있음              |

---

### ✍️ 결론
- 부서별 최고 연봉자 **전원을 조회하고 싶다면** → `salary = (SELECT MAX(...))` 방식 사용
- 최고 연봉자 중 **한 명만 임의로 보더라도 괜찮다면** → 튜플 또는 `GROUP BY` 사용 가능
- 튜플 비교는 정확한 일치를 원할 때 사용하지만, **서브쿼리가 하나의 튜플만 반환해야 한다는 제한**이 있음
- 튜플과 서브쿼리 사용 시, **반환 행 수가 1개인지 주의해서 사용해야 한다.**

<br><br>

## ✅ WHERE에서 서브쿼리와 비교 연산자 사용 시 주의사항

### 🔍 문제 상황 예제
```sql
SELECT D.id, AVG(E.salary)
FROM employees E
JOIN departments D
  ON E.departmentId = D.id
WHERE E.salary = (
    SELECT salary
    FROM employees
    WHERE salary != MAX(salary)
)
GROUP BY D.id;
```

### ❓ 의도는?
> 각 부서별로 "최고 연봉이 아닌 사람들"의 평균 연봉을 구하고 싶은 것.

---

## ❌ 왜 오류가 나는가?

```sql
WHERE E.salary = (
    SELECT salary
    FROM employees
    WHERE salary != MAX(salary)
)
```

- `MAX(salary)`는 집계 함수 → 하나의 값 반환 OK
- 그런데 `salary != MAX(salary)` 조건은 → 여러 행의 salary가 나올 수 있음
- 그 결과, 이 서브쿼리는 여러 개의 salary를 반환하게 됨
- `E.salary = (...)`는 **하나의 값**과만 비교해야 하므로 **오류 발생**

> ✅ 즉, `=`는 **단일 값과의 비교만 가능**하고, **다중 결과(여러 행)**와는 비교 불가능

---

## ✅ 해결 방법

### 1. `IN` 연산자 사용
```sql
WHERE E.salary IN (
    SELECT salary
    FROM employees
    WHERE salary != (SELECT MAX(salary) FROM employees)
)
```
- `IN`은 여러 값 중 하나라도 일치하면 OK
- 다중 결과와 비교할 때 적합함

### 2. 더 간단하고 명확한 방식: `<` 사용
```sql
SELECT D.id, AVG(E.salary) AS avg_salary_excl_max
FROM employees E
JOIN departments D
  ON E.departmentId = D.id
WHERE E.salary < (
    SELECT MAX(salary)
    FROM employees
)
GROUP BY D.id;
```

- `salary < MAX(salary)`는 최고 연봉보다 작은 사람들만 남음
- **가장 직관적이고 오류 없이 동작함**

---

## 💡 WHERE에서 비교 연산자의 의미와 기능

| 연산자 | 설명 | 사용 가능 상황 |
|--------|------|----------------|
| `=`    | 값이 정확히 같은 경우 | 단일 값과 비교할 때만 가능 |
| `!=`   | 값이 다른 경우 | 단일 값과 비교 가능 (다중은 불가) |
| `<`, `>`, `<=`, `>=` | 크기 비교 | 단일 값과의 범위 비교에 적합 |
| `IN (...)` | 여러 값 중 하나에 포함되면 참 | 서브쿼리가 **여러 행 반환**할 때 사용 |
| `EXISTS (...)` | 서브쿼리가 결과를 반환하면 참 | **행 존재 여부**를 확인할 때 사용 |

---

## 📌 요약
- `=` 연산자는 서브쿼리가 **1개의 결과**만 반환해야 함
- 서브쿼리가 여러 행을 반환할 가능성이 있다면 → `IN` 사용
- 범위 조건은 `>`, `<`, `>=`, `<=` 등으로 깔끔하게 해결 가능
- 서브쿼리를 사용할 때는 **반환 행 수**와 **비교 방식**을 항상 주의할 것

