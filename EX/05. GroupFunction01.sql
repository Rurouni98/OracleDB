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

-- 데이터 전체에 대한 통계를 낼때는 GROUP BY를 사용하지 않는다.
SELECT MAX(AVR)
    FROM STUDENT;
    
-- 1-2. MIN: 그룹화된 데이터중 최소값을 조회하는 함수
-- 학년 별 최저 평점 조회(학년, 평점)
SELECT SYEAR
	 , MIN(AVR)
	FROM STUDENT
	GROUP BY SYEAR
	ORDER BY SYEAR;

-- 부서번호, 부서별 최저 급여 조회
SELECT DNO
	 , MIN(SAL)
	FROM EMP
	GROUP BY DNO
	ORDER BY DNO;

-- 부서번호, 부서이름, 부서별 최저 급여 조회
SELECT E.DNO
	 , D.DNAME
	 , MIN(E.SAL)
	FROM EMP E
	JOIN DEPT D
	  ON E.DNO = D.DNO
	GROUP BY E.DNO, D.DNAME
	ORDER BY E.DNO;

-- 부서번호, 부서이름, 부서별 최저 급여, 최저급여에 해당하는 사원번호, 사원이름 조회
-- 잘못된 GROUP BY
SELECT E.DNO
	 , D.DNAME
	 , MIN(E.SAL)
	 , E.ENO
	 , E.ENAME
	FROM EMP E
	JOIN DEPT D
	  ON E.DNO = D.DNO
	GROUP BY E.DNO, D.DNAME, E.ENO, E.ENAME
	ORDER BY E.DNO;

-- 통계함수의 값이 변질되지 않게 하려면 통계함수를 조회하는 쿼리를 서브쿼리로 작성한다.
SELECT A.DNO
	 , A.DNAME
	 , A.MIN_SAL
	 , EE.ENO 
	 , EE.ENAME 
	FROM (
		SELECT E.DNO
			 , D.DNAME
			 , MIN(E.SAL) AS MIN_SAL
			FROM EMP E
			JOIN DEPT D
			  ON E.DNO = D.DNO
			GROUP BY E.DNO, D.DNAME
			ORDER BY E.DNO
	) A
	JOIN EMP EE
	  ON A.DNO = EE.DNO
	 AND A.MIN_SAL = EE.SAL;
	
-- 1-3. SUM: 그룹화된 데이터의 총합을 구하는 함수
-- 사원들의 업무별 보너스의 총합
SELECT JOB
	 , SUM(NVL(COMM, 0))
	FROM EMP
	GROUP BY JOB;

-- 1-4. COUNT: 그룹화된 데이터에 대한 개수를 조회하는 함수
-- COUNT(*): 모든 컬럼데이터에 대한 행의 개수를 리턴. 특정 컬럼에 NULL이 포함되어 있어도 개수에 포함한다.
-- COUNT(특정 컬럼명): 특정 컬럼에 대한 모든 행의 개수를 리턴. 지정된 컬럼에 NULL이 있으면 카운팅을 하지 않는다.
-- 부서별 사원수 조회
SELECT DNO
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO;

SELECT DNO
	 , COUNT(DNO)
	FROM EMP
	GROUP BY DNO;

-- 1-5. AVG: 그룹화된 데이터에 대한 평균값을 구하는 함수
-- 전공별 학년별 평균 평점 조회
SELECT MAJOR
	 , SYEAR
	 , AVG(AVR)
	FROM STUDENT
	GROUP BY MAJOR, SYEAR
	ORDER BY MAJOR, SYEAR;

-- 전공별 학년별 학생수 조회
SELECT MAJOR
	 , SYEAR
	 , COUNT(*)
	FROM STUDENT
	GROUP BY MAJOR, SYEAR 
	ORDER BY MAJOR, SYEAR;

-- 1-6. HAVING: GROUP BY 에 명시된 컬럼에 대한 조건을 만들 수 있는 구문
-- 부서번호가 10, 20, 30에 대한 평균 급여 조회
SELECT DNO
	 , AVG(SAL)
	FROM EMP 
	GROUP BY DNO 
	HAVING DNO IN ('10', '20', '30');

SELECT DNO
	 , AVG(SAL)
	FROM EMP
	WHERE DNO IN ('10', '20', '30')
	GROUP BY DNO;

-- AND/OR 여러개 조건을 작성할 수 있고
-- HAVING 절에는 통계함수에 대한 조건도 작성할 수 있다.
SELECT DNO
	 , AVG(SAL)
	FROM EMP 
	GROUP BY DNO 
	HAVING DNO IN ('10', '20', '30')
	   AND AVG(SAL) >= 3000;
	  
-- HAVING 절에는 GROUP BY에 명시되지 않았거나 통계함수가 아닌 조건은 작성할 수 없다
SELECT DNO
	 , AVG(SAL)
	FROM EMP 
	GROUP BY DNO 
	HAVING COMM >= 300;

-- WHERE 절에서는 통계함수에 대한 조건을 작성할 수 없다.
SELECT DNO
	 , AVG(SAL)
	FROM EMP
	WHERE AVG(SAL) <= (
						  SELECT MAX(SAL)
						  	  FROM EMP
					  )
	GROUP BY DNO;

-- 통계함수에 대한 조건을 WHERE 절에서 사용하려면 통계함수를 포함한 쿼리를 서브쿼리로 묶는다
SELECT A.*
	FROM (
		SELECT DNO
			 , AVG(SAL) AS AVG_SAL
			FROM EMP
		GROUP BY DNO
	) A
	WHERE A.AVG_SAL <= (
						  SELECT MAX(SAL)
						  	  FROM EMP
					   );

-- 임용년도가 2000년 이전이고 임용년도가 동일한 교수의 수 조회
SELECT TRUNC(HIREDATE, 'YYYY')
	 , COUNT(*)
	FROM PROFESSOR
	GROUP BY TRUNC(HIREDATE, 'YYYY')
	HAVING TRUNC(HIREDATE, 'YYYY') < TO_DATE('2000/01/01', 'YYYY/MM/DD')
	ORDER BY TRUNC(HIREDATE, 'YYYY');

SELECT TO_CHAR(HIREDATE, 'YYYY')
	 , COUNT(*)
	FROM PROFESSOR
	GROUP BY TO_CHAR(HIREDATE, 'YYYY')
	HAVING TO_CHAR(HIREDATE, 'YYYY') < '2000'
	   AND COUNT(*) > 5
	ORDER BY TO_CHAR(HIREDATE, 'YYYY');






   
   
   
   
   
   
   
   
   
   
   
   