# 문제: 부모 균주의 자식 수 세기
📚 카테고리: JOIN + GROUP BY
🧩 난이도: 중간 이상 (자연스럽게 JOIN 사고 필요)


[대쟝균 문제](https://school.programmers.co.kr/learn/courses/30/lessons/299305)

[그룹화관련 에러](../../Theory/select.md)


---

## 📄 문제 설명

`ECOLI_DATA` 테이블에서 각 균주 ID가 **부모 균주일 경우**,
그 균주를 부모로 가지는 자식 균주의 수(`CHILD_COUNT`)를 구하는 SQL문을 작성하시오.
- 자식이 없는 균주는 `CHILD_COUNT`가 0으로 표시되어야 함
- 결과는 `ID` 기준 오름차순 정렬

---

## ❌ 내가 처음에 잘못 작성한 쿼리와 문제점

```sql
SELECT ID, IFNULL(COUNT(PARENT_ID),0) AS CHILD_COUNT
FROM ECOLI_DATA
GROUP BY ID, IFNULL(COUNT(PARENT_ID),0)
ORDER BY PARENT_ID;
```

### 문제점:
1. `COUNT(PARENT_ID)`는 숫자라 `IFNULL()`이 불필요 (집계 함수는 NULL 무시)
2. `GROUP BY` 대상이 잘못됨 → `ID`가 아니라 `PARENT_ID` 기준으로 자식을 세야 함
3. `ORDER BY PARENT_ID`는 SELECT에 없는 컬럼이라 에러 발생
4. 자식이 없는 부모는 아예 집계되지 않음 → `LEFT JOIN`이 필요함

---

## ✅ 정답 쿼리 (LEFT JOIN 사용)

```sql
SELECT
  E.ID,
  COUNT(C.ID) AS CHILD_COUNT
FROM ECOLI_DATA E
LEFT JOIN ECOLI_DATA C
  ON E.ID = C.PARENT_ID
GROUP BY E.ID
ORDER BY E.ID;
```

---

## 🔍 해설
- `E`는 부모 후보 / `C`는 자식
- `E.ID = C.PARENT_ID`로 연결하여 자식이 있는 행을 만듦
- 자식이 없으면 `C.ID`는 NULL → `LEFT JOIN` 덕분에 부모는 살아 있음
- `COUNT(C.ID)`는 NULL은 무시되므로, 자식이 없으면 0으로 나옴

---

## 📌 새롭게 알게 된 점 요약
- 자식 수처럼 **역방향 관계를 세기 위해선 JOIN이 필요함**
- `LEFT JOIN`을 쓰면 **없는 관계도 포함 가능**
- `COUNT(NULL)`은 0으로 처리되기 때문에 따로 `IFNULL` 안 써도 됨
- `GROUP BY`는 **묶고 싶은 대상**에 맞게 구성해야 함 (이 문제는 부모 기준)
- `ORDER BY`에는 SELECT한 컬럼만 써야 함

---

## ✨ 보너스
- 자식 수가 많은 순으로 보고 싶다면 `ORDER BY COUNT(C.ID) DESC`
- 자식 수가 0인 균주만 보고 싶다면 `HAVING COUNT(C.ID) = 0`

---

필요하면 이걸 바탕으로 자식 수 평균, 가장 자식 많은 균주도 구할 수 있음 😎

