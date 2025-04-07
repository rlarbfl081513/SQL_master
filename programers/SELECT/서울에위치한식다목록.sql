
-- 서울에위치한 식당 목록록

SELECT 
  RI.REST_ID,              -- 식당 ID
  RI.REST_NAME,            -- 식당 이름
  RI.FOOD_TYPE,            -- 음식 종류
  RI.FAVORITES,            -- 즐겨찾기 수
  RI.ADDRESS,              -- 주소
  ROUND(AVG(RR.REVIEW_SCORE), 2) AS AVG_SCORE  -- 리뷰 평균 점수를 소수 둘째 자리까지 반올림해서 AVG_SCORE라는 이름으로 표시
FROM REST_INFO RI          -- REST_INFO 테이블을 RI라는 약칭으로 사용 (별명이라고 생각하면 돼!)
JOIN REST_REVIEW RR        -- REST_REVIEW 테이블을 RR이라는 약칭으로 사용
  ON RI.REST_ID = RR.REST_ID  -- 두 테이블을 식당 ID(REST_ID)를 기준으로 연결 (JOIN 조건)
WHERE RI.ADDRESS LIKE '서울%'  -- 주소가 '서울'로 시작하는 식당만 선택
GROUP BY 
  RI.REST_ID,             -- 그룹별(식당별)로 평균 리뷰 점수를 구하기 위해 필요한 그룹 지정
ORDER BY 
  AVG_SCORE DESC,         -- 평균 점수를 기준으로 내림차순 정렬
  RI.FAVORITES DESC;      -- 평균 점수가 같을 경우 즐겨찾기 수를 기준으로 내림차순 정렬




-- 과일로 만든 아이스크림 고르기

-- [DB]
-- 아이스크림 가게의 상반기 주문 정보를 담은 'FIRST_HALF ' 테이블
-- 아이스크림 성분에 대한 정보             'ICECREAM_INFO ' 테이블

-- 문제
-- 1. 상반기 아이스크림 총주문량이 3,000보다 높으면서 
-- 2. 아이스크림의 주 성분이 과일인 아이스크림의 맛을 총주문량이 큰 순서대로 조회
 

SELECT FH.FLAVOR
FROM FIRST_HALF FH
JOIN ICECREAM_INFO II
  ON FH.FLAVOR = II.FLAVOR

WHERE FH.TOTAL_ORDER > 3000 AND II.INGREDIENT_TYPE = 'fruit_based';
