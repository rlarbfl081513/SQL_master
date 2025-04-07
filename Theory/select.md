# 에러 해결: 1055 - ONLY_FULL_GROUP_BY 관련 에러

📌 에러 메시지:
```
1055, "Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column '...'
which is not functionally dependent on columns in GROUP BY clause;
this is incompatible with sql_mode=only_full_group_by"
```

---

## 🧠 에러 원인
MySQL의 `ONLY_FULL_GROUP_BY` 모드에서는,
**GROUP BY에 없는 컬럼을 SELECT에서 그냥 쓰면 안 됨.**
→ 해당 컬럼이 **집계함수(Aggregate)** 또는 **GROUP BY 절에 명시**되어야 함.

---

## ✅ 예시
```sql
SELECT ID, NAME, COUNT(*)
FROM ECOLI_DATA
GROUP BY NAME;
```
🔻 에러 발생! → ID는 GROUP BY에 없고, 집계함수도 아님.

---

## ✅ 해결 방법

### 1. 모든 SELECT 컬럼을 GROUP BY에 포함
```sql
SELECT ID, NAME, COUNT(*)
FROM ECOLI_DATA
GROUP BY ID, NAME;
```
> 단점: ID가 유일하면 `COUNT(*)`는 1이 되어버림 → 그룹화 의미 없음

### 2. SELECT 컬럼에 집계함수 사용
```sql
SELECT MAX(ID), NAME, COUNT(*)
FROM ECOLI_DATA
GROUP BY NAME;
```
> ID 중 대표값만 보고 싶을 때 적절함

### 3. SQL 모드 변경 (⚠️ 권장하지 않음)
```sql
SET GLOBAL sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
```
> 실무 환경에서는 데이터 무결성 문제로 위험할 수 있음

---

## ✨ 정리
- `GROUP BY`를 쓸 땐, SELECT 컬럼 중
  - 🔹 그룹화된 컬럼이거나
  - 🔹 집계함수 안에 있어야 한다.

---