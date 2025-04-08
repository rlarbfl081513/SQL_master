# ✅ 개념: GROUP BY와 SELECT의 규칙

### 💬 핵심 문장
> `GROUP BY`를 쓰면, **그룹마다 1개의 결과 행(row)**만 나오기 때문에  
> `SELECT`에 쓰는 컬럼은 반드시 **집계함수이거나**, **GROUP BY에 명시한 컬럼**이어야 한다.

---

## 📌 예제 없이 이 말만 보면 좀 추상적이니까, 예제로 설명할게!

### 🎯 예제 테이블: `employees`

| id | name  | departmentId | salary |
|----|-------|--------------|--------|
| 1  | Alice | 1            | 500    |
| 2  | Bob   | 1            | 500    |
| 3  | Carol | 2            | 600    |
| 4  | Dave  | 2            | 700    |

---

### ❌ 잘못된 쿼리 예 (에러 또는 비표준):

```sql
SELECT name, MAX(salary)
FROM employees
GROUP BY departmentId;
```

- `MAX(salary)`는 집계함수니까 OK
- 근데 `name`은 뭐야? 집계함수도 아니고, `GROUP BY departmentId`에도 안 들어감.

> ❗이 상황에서 SQL은 **이 그룹 중 누구의 name을 보여줘야 할지 모름.**

#### → 결과:
- **MySQL**: 그냥 그룹 내에서 임의로 한 명(name) 선택해서 보여줌  
- **PostgreSQL / Oracle 등**: **에러 발생** – `name`이 그룹화되지 않았다고!

---

### ✅ 올바른 쿼리 예:

```sql
SELECT departmentId, MAX(salary)
FROM employees
GROUP BY departmentId;
```

- `departmentId`는 `GROUP BY`에 들어가 있어서 OK
- `MAX(salary)`는 집계함수니까 OK

> 🎯 부서별로 한 행씩 나오고, 그 안에 `MAX(salary)`도 같이 보여줌!

---

### ✅ 다른 예: COUNT와 함께 쓰기

```sql
SELECT departmentId, COUNT(*) AS 인원수
FROM employees
GROUP BY departmentId;
```

- 부서별 인원 수 세는 아주 기본적인 예

---

## ✍️ 요약 정리

| SELECT에 넣은 컬럼 | 허용 조건                                 |
|--------------------|--------------------------------------------|
| 집계함수            | ✅ OK (e.g. `MAX(salary)`, `COUNT(*)`)      |
| GROUP BY에 포함된 컬럼 | ✅ OK (e.g. `departmentId`)                 |
| 둘 다 아닌 일반 컬럼 | ❌ NG (표준 SQL에선 에러. 일부 DB는 임의 선택) |

---
