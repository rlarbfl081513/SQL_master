# 문자열 수정
`UPPER`
1. UPPER()는 값을 변환하는 함수이고, SET절에서는 반드기 '컬럼 = 값' 형식으로 써야함.
2. 예시
   ```SQL
    -- 잘못된 코드
    UPDATE HOTELS
    SET UPPPER(grade); -- 어느컬럼에 어떤 값을 넣을지가 없음

    -- 올바른 코드
    UPDATE hotels
    SET grade = UPPER(grade);
   ```
<br><br>
# FOREIGN KEY 개념 정리

## ✅ FOREIGN KEY란?
- **FOREIGN KEY(외래 키)**는 **다른 테이블의 기본 키를 참조하는 컬럼**이다.
- 두 테이블 간 **관계(연결)를 정의**하며, 데이터의 **정합성(무결성)**을 유지하는 데 사용된다.
- 관계를 표현할 때 자주 사용되는 자료형은 **INTEGER**이며, 이는 참조 대상인 기본 키의 타입과 일치해야 한다.

## 💡 왜 FOREIGN KEY에서 INTEGER를 많이 쓰는가?
- 대부분의 테이블은 고유한 ID를 식별자로 사용하며, 이 ID는 일반적으로 `INTEGER PRIMARY KEY`로 정의됨
- 외래 키는 참조 대상의 기본 키 타입과 일치해야 하므로, 외래 키도 자연스럽게 `INTEGER`로 선언됨
- 정수는 비교와 검색 속도가 빠르고, 메모리 효율도 좋아서 관계형 데이터베이스에서 선호됨
- 문자열이나 복합키도 외래 키로 사용할 수 있지만, 관리와 성능 측면에서 정수형 키가 더 유리함
- 
## 기본코드
```sql
CREATE TABLE 테이블명 (
  외래키_필드명 자료형,
  ...
  FOREIGN KEY (외래키_필드명) REFERENCES 참조할_테이블(참조할_컬럼)
);

```
## ✅ 외래 키(Foreign Key)는 자동으로 값을 넣어주지 않는다

### ❗ 오해하기 쉬운 점
- 외래 키는 "다른 테이블의 값을 가져오는 기능"이 아님
- 단지 "이 필드에는 반드시 저 테이블의 어떤 값만 들어올 수 있다"는 **제약 조건**일 뿐임
- 따라서 값을 연결하려면 **직접 참조할 ID를 지정**해야 함
- 외래 키로 연결했다고 해서 **값이 자동으로 채워지는 건 아님**
- 외래 키는 "제약조건"일 뿐, 값을 가져오는 기능은 없음

###  올바른 사용 방식
- 외래 키 필드는 **INSERT할 때 직접 값 입력**해야 함

```sql
INSERT INTO reservations (customer_id, room_num, check_in, check_out)
VALUES (1, 101, '2024-12-02', '2024-12-20');
```

### 왜 직접 값을 넣어야 할까?
- 외래 키는 "참조 관계"만 만들 뿐, 값을 자동으로 가져오지 않음
- 예를 들어 `customer_id = 1`이라고 쓰면:
  → 이 예약은 customer 테이블의 ID 1번 고객과 연결된다는 뜻이지, 그 데이터를 복사하는 게 아님
- 만약 연결된 ID와 전혀 관련 없는 정보가 들어간다면, 외래 키 제약 조건이 무시되고 있을 수 있음

### 주의할 점
- 외래 키로 참조하는 테이블(customer, hotels)에 값이 먼저 있어야 함
- SQLite에서는 반드시 아래 구문으로 외래 키 기능을 켜야 함:
```sql
PRAGMA foreign_keys = ON;
```

### 🧠 요약
| 개념 | 설명 |
|------|------|
| FOREIGN KEY | 다른 테이블의 값을 참조하도록 제한하는 제약조건 |
| 자동 입력? | ❌ 아니요. 직접 값을 지정해야 함 |
| 권장 순서 | 1) 참조 테이블에 데이터 삽입 → 2) 외래 키 테이블에 연결하여 삽입 |



### 🧠 핵심 포인트
| 구분 | 설명 |
|------|------|
| PRIMARY KEY | 해당 테이블에서 각 행(row)을 유일하게 식별 |
| FOREIGN KEY | 다른 테이블의 PRIMARY KEY 또는 UNIQUE 값을 참조 |
| 목적 | 두 테이블 간 관계 연결 + 무결성 유지 (없는 값을 참조 못 하게 함) |
| 관련 자료형 | 보통 INTEGER로 선언 (참조하는 키의 자료형과 동일해야 함) |

---
  
<br><br>

##  ✅ 예시 : reservations 테이블 설계 시나리오 설명

### 📌 전제 조건
- **reservations** 테이블은 다음과 같은 두 테이블과 관계를 맺는다:
  - **hotels** 테이블과 N:1 관계
  - **customers** 테이블과 N:1 관계

### 📋 관계 구조 설명

#### 1. hotels 테이블과의 관계
- 한 호텔(`room_num`)에 여러 예약(`reservations`)이 가능 → **N:1 관계**
- 따라서 `reservations` 테이블에 `room_num`을 외래 키로 둠

#### 2. customers 테이블과의 관계
- 한 고객(`id`)이 여러 번 예약할 수 있음 → **N:1 관계**
- 따라서 `reservations` 테이블에 `customer_id`를 외래 키로 둠

---

### ✅ 테이블 정의 예시 (SQLite 기준)
```sql
CREATE TABLE reservations (
  reservation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_num INTEGER,          -- 외래 키로 참조할 필드 (자료형 필요!)
  customer_id INTEGER,       -- 마찬가지
  reservation_date TEXT NOT NULL,
  FOREIGN KEY (room_num) REFERENCES hotels(room_num),         -- hotels 테이블의 room_num 참조
  FOREIGN KEY (customer_id) REFERENCES customers(id)          -- customers 테이블의 id 참조
);

```

### 📌 설명:
- `room_num` → hotels 테이블의 `room_num`을 참조 (N:1)
- `customer_id` → customers 테이블의 `id`를 참조 (N:1)
- `reservation_date` → 예약 날짜 정보 저장

---

### 🧩 시각적 관계 요약 (N:1)

```
reservations           hotels
--------------         -----------
room_num     ─────────▶ room_num (PK)

reservations           customers
--------------         ------------
customer_id  ─────────▶ id (PK)
```

이와 같이 외래 키를 통해 테이블 간 관계를 명확히 정의하고 연결할 수 있다.

---

필요하면 CASCADE(연쇄 삭제/수정) 옵션이나 JOIN 예제도 추가해줄 수 있어요!

<br><br>

# Delete
## ✅ SQLite에서 DELETE + ORDER BY + LIMIT은 직접 지원되지 않음

### 🧠 흔한 시도 (하지만 SQLite에서는 오류)
```sql
DELETE FROM reservations
ORDER BY id
LIMIT 4;  -- ❌ SQLite는 이렇게 실행 불가
```

- 이 쿼리는 MySQL 등 일부 DBMS에서는 가능하지만, SQLite는 `DELETE`에서 `ORDER BY`, `LIMIT` 조합을 직접 허용하지 않음

---

##  SQLite에서 원하는 순서로 삭제하려면: 서브쿼리 활용

```sql
DELETE FROM reservations
WHERE id IN (
  SELECT id
  FROM reservations
  ORDER BY id
  LIMIT 4
);
```

### 설명
- 먼저 `ORDER BY id LIMIT 4`로 삭제 대상 ID 4개를 골라냄
- `WHERE id IN (...)`으로 해당 행만 삭제

---

## 유사한 응용 예시
- `check_in` 날짜 빠른 순서로 2개 삭제:
```sql
DELETE FROM reservations
WHERE id IN (
  SELECT id
  FROM reservations
  ORDER BY check_in
  LIMIT 2
);
```

---

이처럼 SQLite에서는 `DELETE`할 때도 서브쿼리를 활용해 유연하게 조건을 지정할 수 있다.

