-- 1. 다중행함수(GROUP 함수)
-- 다중행 함수는 여러개의 데이터가 들어와서 여러개의 데이터가 리턴되는 함수
-- 그룹함수가 다중행 함수에 포함된다.
-- 그룹함수는 데이터들의 통계를 내는 함수들이 대부분이며 GROUP BY라는 키워드와 함께 사용된다.
-- GROUP BY는 데이터들의 통계를 내는데 어떤 컬럼을 기준으로 그룹화하여 통계를 낼건지 지정하는 구문이다.
-- 그룹함수를 사용할 때 주의할 점은 SELECT 절에 포함된 모든 컬럼들은 GROUP BY 절에 명시돼야 한다.
-- 학년별 학생들의 평점의 평균을 구하는 그룹함수
SELECT *
	FROM STUDENT
	ORDER BY SYEAR;

SELECT SYEAR
	 , SNAME 
	 , AVG(AVR)
	FROM STUDENT
	GROUP BY SYEAR, SNAME
	ORDER BY SYEAR, SNAME;

-- SELECT절에 포함된 컬럼들이 모두 GROUP BY에 명시돼야 하는 규칙때문에 데이터가 변질된다.
SELECT SYEAR
	 , MAJOR
	 , AVG(AVR)
	FROM STUDENT
	GROUP BY SYEAR, MAJOR
	ORDER BY SYEAR;

-- 원하는 통계함수 데이터를 조회하는 쿼리를 서브쿼리로 만들어서 다른 데이터들과 조인하여 사용한다.
SELECT ST.SNO
	 , ST.SNAME
	 , ST.MAJOR
	 , ST.SYEAR
	 , ST.AVR
	 , A.AVR
	FROM STUDENT ST
	JOIN (
		SELECT SYEAR
			 , AVG(AVR) AS AVR
			FROM STUDENT
			GROUP BY SYEAR
			ORDER BY SYEAR
	) A
	ON ST.SYEAR = A.SYEAR;
	
-- 1-1. MAX: 데이터들의 최고 값을 조회하는 그룹함수
-- 과목별 기말고사의 최고점 조회
SELECT CNO
	 , MAX(RESULT)
	FROM SCORE
	GROUP BY CNO;

-- 과목별 기말고사 최고점 조회하는데 과목번호, 과목이름, 점수 조회
SELECT SC.CNO
	 , C.CNAME
	 , MAX(SC.RESULT)
	FROM SCORE SC
	JOIN COURSE C
	  ON SC.CNO = C.CNO
	GROUP BY SC.CNO, C.CNAME;

-- 과목별 기말고사 최고점 조회하는데 과목번호, 과목이름, 학생번호, 학생이름, 점수 조회
SELECT A.CNO
	 , A.CNAME
	 , ST.SNO
	 , ST.SNAME 
	 , ST.SYEAR 
	 , ST.MAJOR
	 , A.MAX_RESULT
	FROM (
		SELECT SC.CNO
			 , C.CNAME
			 , MAX(SC.RESULT) AS MAX_RESULT
			FROM SCORE SC
			JOIN COURSE C
			  ON SC.CNO = C.CNO
			GROUP BY SC.CNO, C.CNAME
	) A
	JOIN SCORE SSC
	  ON A.CNO = SSC.CNO 
	 AND A.MAX_RESULT = SSC.RESULT 
	JOIN STUDENT ST
	  ON SSC.SNO = ST.SNO;

-- 잘못된 쿼리
SELECT SC.CNO
	 , C.CNAME
	 , ST.SNO
	 , ST.SNAME
	 , MAX(SC.RESULT) AS MAX_RESULT
	FROM SCORE SC
	JOIN COURSE C
	  ON SC.CNO = C.CNO
	JOIN STUDENT ST
	  ON SC.SNO = ST.SNO
	GROUP BY SC.CNO, C.CNAME, ST.SNO, ST.SNAME;
