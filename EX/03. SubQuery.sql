-- 1. SUB QUERY
-- 1-1. 단일 행 서브쿼리
-- SELECT, FROM, JOIN, WHERE 절에서 사용가능한 서브쿼리
-- 송강교수보다 부임일자가 빠른 교수들의 교수번호, 교수이름 조회
SELECT PNO
	 , PNAME
	FROM PROFESSOR
	WHERE HIREDATE < (
						SELECT HIREDATE 
							FROM PROFESSOR
							WHERE PNAME = '송강'
					  );

-- 손하늘 사원보다 급여(연봉)가 높은 사원의 사원번호, 사원이름, 급여 조회
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	FROM EMP E
	WHERE E.SAL > (
					  SELECT SAL
					  	  FROM EMP
					  	  WHERE ENAME = '손하늘'
				  );
				 
-- 위 쿼리를 JOIN절로 변경
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 , A.SAL
	FROM EMP E
	JOIN (
		SELECT SAL 
			FROM EMP
			WHERE ENAME = '손하늘'
	) A
	ON E.SAL > A.SAL;
					 
-- 공융의 일반화학 기말고사 성적보다 높은 학생의 학생번호, 학생이름, 과목번호, 과목이름, 기말고사 성적 조회
-- 공융의 일반화학 기말고사 성적
SELECT SC.RESULT
	FROM SCORE SC
	JOIN STUDENT ST
	  ON SC.SNO = ST.SNO
	JOIN COURSE C
	  ON SC.CNO = C.CNO 
	WHERE ST.SNAME = '공융'
	  AND C.CNAME = '일반화학';

SELECT SST.SNO
	 , SST.SNAME
	 , SSC.CNO
	 , SSC.CNAME
	 , SCO.RESULT
	FROM STUDENT SST
	JOIN SCORE SCO
	  ON SST.SNO = SCO.SNO 
	JOIN COURSE SSC
	  ON SCO.CNO = SSC.CNO 
	 AND SSC.CNAME = '일반화학'
	JOIN (
		SELECT SC.RESULT
			FROM SCORE SC
			JOIN STUDENT ST
			  ON SC.SNO = ST.SNO
			JOIN COURSE C
			  ON SC.CNO = C.CNO 
			WHERE ST.SNAME = '공융'
			  AND C.CNAME = '일반화학'
	) A
	  ON SCO.RESULT > A.RESULT;

-- 1-2. 다중행 서브쿼리
-- 서브쿼리의 결과가 여러행인 서브쿼리
-- FROM, JOIN, WHERE 절에서 사용가능
-- 급여가 3000이상인 사원의 사원번호, 사원이름, 급여 조회
SELECT ENO, ENAME, SAL
	FROM EMP
	WHERE SAL >= 3000;

-- FROM, JOIN 절에서 사용
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	FROM EMP E
	JOIN (
		SELECT ENO
			FROM EMP
			WHERE SAL >= 3000
	) A
	  ON E.ENO = A.ENO;
	
-- WHERE 절에서 사용
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	FROM EMP E
	WHERE E.ENO IN (
					  SELECT ENO
						  FROM EMP
						  WHERE SAL >= 3000
				   );

-- 1-3. 다중열 서브쿼리
-- 서브쿼리의 결과가 다중행이면서 다중열인 서브쿼리
-- FROM, JOIN 절에서만 사용가능
-- 과목번호, 과목이름, 교수번호, 교수이름을 조회하는 서브쿼리를 작성하여
-- 기말고사 성적 테이블과 조인하여 과목번호, 과목이름, 교수번호, 교수이름, 기말고사 성적을 조회
SELECT C.CNO
	 , C.CNAME
	 , P.PNO
	 , P.PNAME
	 , SC.RESULT
	FROM COURSE C
	JOIN SCORE SC
	  ON C.CNO = SC.CNO
	JOIN PROFESSOR P
	  ON C.PNO = P.PNO;
	 
SELECT A.CNO
	 , A.CNAME
	 , A.PNO
	 , A.PNAME
	 , SC.RESULT
	FROM (
		SELECT C.CNO
			 , C.CNAME
			 , P.PNO
			 , P.PNAME
			FROM COURSE C
			JOIN PROFESSOR P
			  ON C.PNO = P.PNO
	) A
	JOIN SCORE SC
	  ON A.CNO = SC.CNO;

-- 서브쿼리는 그룹함수와 주로 사용된다.
SELECT ST.SNO
	 , ST.SNAME 
	 , AVG(SC.RESULT)
	FROM STUDENT ST
	JOIN SCORE SC
	  ON SC.SNO = ST.SNO
	GROUP BY ST.SNO, ST.SNAME;
	 
-- 학생번호, 학생이름, 과목번호, 과목이름, 기말고사 성적, 기말고사 성적 등급, 담당 교수번호, 담당 교수이름 조회하는 데
-- STUDENT, SCORE, SCGRADE 테이블의 내용을 서브쿼리1
SELECT ST.SNO
	 , ST.SNAME
	 , SC.CNO
	 , SC.RESULT
	 , GR.GRADE
	FROM STUDENT ST
	JOIN SCORE SC
	  ON ST.SNO = SC.SNO 
	JOIN SCGRADE GR
	  ON SC."RESULT" BETWEEN GR.LOSCORE AND GR.HISCORE;
	 
-- COURSE, PROFESSOR 테이블의 내용을 서브쿼리2 
SELECT C.CNO
	 , C.CNAME
	 , P.PNO
	 , P.PNAME
	FROM COURSE C
	JOIN PROFESSOR P
	  ON C.PNO = P.PNO;
	 
SELECT A.SNO
	 , A.SNAME
	 , A.RESULT
	 , A.GRADE
	 , B.CNO
	 , B.CNAME
	 , B.PNO
	 , B.PNAME
	FROM (
		SELECT ST.SNO
			 , ST.SNAME
			 , SC.CNO
			 , SC.RESULT
			 , GR.GRADE
			FROM STUDENT ST
			JOIN SCORE SC
			  ON ST.SNO = SC.SNO 
			JOIN SCGRADE GR
			  ON SC."RESULT" BETWEEN GR.LOSCORE AND GR.HISCORE
	) A
	JOIN (
		SELECT C.CNO
			 , C.CNAME
			 , P.PNO
			 , P.PNAME
			FROM COURSE C
			JOIN PROFESSOR P
			  ON C.PNO = P.PNO
	) B
	ON A.CNO = B.CNO;
					 