-- 1. 추가적인 조인
-- 1-1. NATURAL JOIN: 조인조건을 명시하지 않아도 자동으로 조인될 컬럼을 추적해서 조인을 해주는 조인
-- 조인되는 컬럼은 테이블의 별칭을 사용할 수 없다.
-- 학생의 학생번호, 학생이름, 과목번호, 기말고사 성적 조회
-- 기존 JOIN 사용
SELECT ST.SNO
	 , ST.SNAME
	 , SC.CNO
	 , SC.RESULT
	FROM STUDENT ST
	JOIN SCORE SC
	  ON ST.SNO = SC.SNO
	ORDER BY ST.SNO, SC.CNO;
	
-- NATURAL JOIN 사용
SELECT SNO
	 , ST.SNAME
	 , SC.CNO
	 , SC.RESULT
	FROM STUDENT ST
	NATURAL JOIN SCORE SC
	ORDER BY SNO, SC.CNO;

-- NATURAL JOIN을 이용해서 학생번호, 학생이름, 해당학생의 기말고사 평균점수 조회
SELECT SNO
	 , ST.SNAME
	 , AVG(SC.RESULT)
	FROM STUDENT ST
	NATURAL JOIN SCORE SC
	GROUP BY SNO, ST.SNAME
	ORDER BY SNO;

SELECT SNO
	 , AVG(RESULT)
	FROM SCORE
	GROUP BY SNO
	ORDER BY SNO;

-- NATURAL JOIN을 이용해서 최대급여가 4000만원 이상인 부서번호, 부서이름, 최대급여 조회
SELECT DNO
	 , D.DNAME 
	 , MAX(E.SAL)
	FROM EMP E
	NATURAL JOIN DEPT D
	GROUP BY DNO, D.DNAME
	HAVING MAX(E.SAL) >= 4000
	ORDER BY DNO;
	
-- NATURAL JOIN은 테이블구조를 잘 모르는 개발자가 쿼리를 봤을 때 난해하게 보일 수 있고
-- 조인될 컬럼이 없으면 CROSS JOIN 일어나기 때문에 자주 사용되는 JOIN 방식은 아니다.
SELECT ST.SNO
	 , ST.SNAME
	 , P.PNO
	 , P.PNAME
	FROM STUDENT ST
	NATURAL JOIN PROFESSOR P;

-- 1-2. JOIN ~ USING
-- USING 절에 조인될 컬럼을 소괄호로 묶어서 명시. 조인될 컬럼은 테이블 별칭(식별자)을 사용할 수 없다.
-- 학생의 학생번호, 학생이름, 해당 학생의 기말고사 성적의 평균
SELECT SNO
	 , ST.SNAME
	 , AVG(SC.RESULT)
	FROM STUDENT ST
	JOIN SCORE SC
	USING (SNO)
	GROUP BY SNO, ST.SNAME
	ORDER BY SNO;

-- 학점이 3학점인 과목의 과목번호, 과목이름, 학점, 교수번호, 교수이름 조회(JOIN ~ USING 절 사용)
SELECT C.CNO
	 , C.CNAME
	 , C.ST_NUM
	 , PNO
	 , P.PNAME
	FROM COURSE C
	JOIN PROFESSOR P
--	  ON C.PNO = P.PNO
	USING(PNO)
	WHERE C.ST_NUM = 3;

-- 2. 다중컬럼 IN절
-- 여러개의 컬럼의 값과 여러개의 데이터를 비교하고 싶을 때 사용하는 구문
-- (컬럼1, 컬럼2) IN ((데이터1-1, 데이터2-1), (데이터1-2, 데이터2-2), ...., (데이터1-N, 데이터2-N))
-- => (컬럼1 = 데이터1-1 AND 컬럼2 = 데이터2-1) OR (컬럼1 = 데이터1-2 AND 컬럼2 = 데이터2-2) OR .... 
-- OR (컬럼1 = 데이터1-N AND 컬럼2 = 데이터2-N)
-- 부서번호가 10이면서 업무가 분석이나 개발인 사원의 사원번호, 사원이름, 업무, 부서번호 조회
SELECT ENO
	 , ENAME
	 , JOB
	 , DNO
	FROM EMP
	WHERE DNO = '10'
	  AND JOB IN ('개발', '분석');
	 
SELECT ENO
	 , ENAME
	 , JOB
	 , DNO
	FROM EMP
	WHERE (DNO, JOB) IN (('10', '개발'), ('10', '분석'));

SELECT ENO
	 , ENAME
	 , JOB
	 , DNO
	FROM EMP
	WHERE (DNO = '10' AND JOB = '개발') 
	   OR (DNO = '10' AND JOB = '분석');

-- 다중 컬럼 IN절을 사용해서 화학과 1학년 학생이거나 물리학과 3학년인 학생의 학생번호, 학생이름, 전공, 학년 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE (MAJOR, SYEAR) IN (('화학', 1), ('물리', 3));
	  
-- 다중 컬럼 IN절을 사용해서 부서번호는 01이나 02면서 사수번호가 0001인 사원의 사원번호, 사원이름, 사수번호, 부서번호 조회
SELECT ENO
	 , ENAME
	 , MGR
	 , DNO
	FROM EMP
	WHERE (DNO, MGR) IN (('01', '0001'), ('02', '0001'));
	  
-- 다중 컬럼 IN절을 사용해서 기말고사 성적의 평균이 48점이상인 과목의 과목번호, 과목이름, 기말고사 평균점수, 교수번호, 교수이름 조회
SELECT SC.CNO
	 , C.CNAME
	 , AVG(SC.RESULT)
	 , C.PNO
	 , P.PNAME
	FROM SCORE SC
	JOIN COURSE C
	  ON SC.CNO = C.CNO 
	JOIN PROFESSOR P
	  ON C.PNO = P.PNO 
	GROUP BY SC.CNO, C.CNAME, C.PNO, P.PNAME 
	HAVING AVG(SC.RESULT) >= 48;
	
SELECT SC.CNO
	 , C.CNAME
	 , AVG(SC.RESULT)
	 , C.PNO
	 , P.PNAME
	FROM SCORE SC
	JOIN COURSE C
	  ON SC.CNO = C.CNO 
	JOIN PROFESSOR P
	  ON C.PNO = P.PNO 
	GROUP BY SC.CNO, C.CNAME, C.PNO, P.PNAME 
	HAVING (SC.CNO, C.PNO) IN (
		SELECT S.CNO
			 , CO.PNO
			FROM SCORE S
			JOIN COURSE CO
			  ON S.CNO = CO.CNO
			GROUP BY S.CNO, CO.PNO
			HAVING AVG(S.RESULT) >= 48
	);
	
-- 3. WITH
-- SELECT 구문이 시작되기 전에 가상테이블을 먼저 구성하는 방식
-- SELECT문이 시작되고 가상테이블을 생성하는 서브쿼리보다 속도가 빠르기 때문에 많이 사용된다.
-- 서브쿼리를 너무 많이 사용하면 쿼리의 속도가 현저하게 느려지기 때문에 WITH 절을 적절히 잘 사용해야 한다.
-- SELECT 구문 위에 WITH절로 가상테이블을 구성한다.
WITH DNO10 AS (
	SELECT ENO
		 , ENAME
		 , DNO
		FROM EMP
		WHERE DNO = '10'
)
SELECT DNO10.ENO
	 , DNO10.ENAME
	 , DNO10.DNO
	 , D.DNAME
	FROM DNO10
	JOIN DEPT D
	  ON DNO10.DNO = D.DNO;
	 
-- 기말고사 성적의 평균점수가 50점 이상인 과목번호, 과목이름, 기말고사 성적의 평균점수를 가지는 
-- 가상테이블 OVER50를 WITH절로 구현하고 해당 과목을 수강하는 학생들의 학생 정보조회
-- 과목번호, 과목이름, 과목별 기말고사 성적의 평균점수, 학생번호, 학생이름 조회
WITH OVER50 AS (
	SELECT SC.CNO
		 , C.CNAME
		 , AVG(SC.RESULT) AS AVG_RESULT
		FROM SCORE SC
		JOIN COURSE C
		  ON SC.CNO = C.CNO
		GROUP BY SC.CNO, C.CNAME
		HAVING AVG(SC.RESULT) >= 50
)
SELECT OVER50.CNO
	 , OVER50.CNAME
	 , OVER50.AVG_RESULT
	 , ST.SNO 
	 , ST.SNAME
	FROM OVER50
	JOIN SCORE SSC
 	  ON OVER50.CNO = SSC.CNO
 	JOIN STUDENT ST
 	  ON ST.SNO = SSC.SNO;
	 
-- WITH 절로 두 개이상의 가상테이블을 만들 때는 ,로 연결해서 만든다.
WITH
	DNO10 AS (
		SELECT ENO
			 , ENAME
			 , DNO
			FROM EMP
			WHERE DNO = '10'
	),
	JOBDEV AS (
		SELECT ENO
			 , ENAME
			 , JOB
			FROM EMP
			WHERE JOB = '개발'
	),
	OVER3000 AS (
		SELECT ENO
			 , ENAME
			 , SAL
			FROM EMP
			WHERE SAL >= 3000
	)
SELECT DNO10.ENO
	 , DNO10.ENAME
	 , DNO10.DNO
	 , JOBDEV.JOB
	 , OVER3000.SAL
	FROM DNO10
	JOIN JOBDEV
	  ON DNO10.ENO = JOBDEV.ENO
	JOIN OVER3000
	  ON DNO10.ENO = OVER3000.ENO;
	 
-- 화학과 1학년 학생의 학생번호, 학생이름, 학년을 가지고 있는 가상테이블 CHMSTU와
-- 과목명에 화학이 포함된 과목의 과목번호, 과목이름, 기말고사 성적, 학생번호를 가지는 가상테이블 CHMRES를 WITH 절로 구현하고
-- 화학과 1학년 학생의 학생번호, 학생이름, 학생의 기말고사 성적의 평균점수(소수점 둘째 자리까지 표시)를 조회
WITH
	CHMSTU AS (
		SELECT SNO
			 , SNAME
			 , SYEAR
			FROM STUDENT
			WHERE MAJOR = '화학'
			  AND SYEAR = 1 
	),
	CHMRES AS (
		SELECT SC.CNO
			 , C.CNAME
			 , SC.RESULT
			 , SC.SNO
			FROM COURSE C
			JOIN SCORE SC
			  ON C.CNO = SC.CNO
			WHERE C.CNAME LIKE '%화학%'
	)
SELECT CHMSTU.SNO
	 , CHMSTU.SNAME
	 , ROUND(AVG(CHMRES.RESULT), 2)
	FROM CHMSTU
	JOIN CHMRES
	  ON CHMSTU.SNO = CHMRES.SNO
	GROUP BY CHMSTU.SNO, CHMSTU.SNAME
	ORDER BY CHMSTU.SNO;