-- 1. Inner Join
-- JOIN은 여러 테이블에 분산되어 있는 데이터를 한 번에 조회하기 위해 사용하는 기능
-- JOIN에는 INNER JOIN과 OUTER JOIN이 존재한다.
-- JOIN 절에는 항상 공통 컬럼에 해당하는 조건을 ON 절로 만들어줘야 한다.
-- Inner Join은 두 테이블에 공통된 데이터를 조회하는 기능
-- 두 테이블에 존재하는 공통된 컬럼을 조인 조건으로 명시한다.
-- 학생의 학생번호, 학생이름, 과목번호, 기말고사 성적 조회
SELECT ST.SNO
	 , ST.SNAME
	 , SC.CNO
	 , SC.RESULT
	FROM STUDENT ST
	INNER JOIN SCORE SC
	   ON ST.SNO = SC.SNO
	ORDER BY ST.SNO;
	
SELECT *
	FROM STUDENT
	ORDER BY SNO;
	
SELECT *
	FROM SCORE
	ORDER BY SNO;
	
-- 과목번호, 과목이름, 담당교수 번호, 담당교수 이름 조회(COURSE, PROFESSOR 테이블 조인)
SELECT C.CNO
	 , C.CNAME
	 , C.PNO
	 , P.PNAME
	FROM COURSE C
	INNER JOIN PROFESSOR P
	   ON C.PNO = P.PNO;
	  
-- INNER JOIN에서 INNER는 생략 가능하다.
SELECT C.CNO
	 , C.CNAME
	 , C.PNO
	 , P.PNAME
	FROM COURSE C
	JOIN PROFESSOR P
	   ON C.PNO = P.PNO;

-- 1-1. 등가조인
-- 등가조인은 공통된 컬럼의 데이터가 같은 데이터만을 조회하는 조인
-- 사원의 사원번호, 사원이름, 업무, 급여, 보너스, 부서번호, 부서이름, 부서지역 조회
-- ANSI 표준 방식
SELECT E.ENO	
	 , E.ENAME
	 , E.JOB
	 , E.SAL
	 , E.COMM
	 , E.DNO
	 , D.DNO
	 , D.DNAME
	 , D.LOC
	FROM EMP E
	JOIN DEPT D
	  ON E.DNO = D.DNO;
	 
-- ORACLE에서만 사용하는 방식의 JOIN
SELECT E.ENO	
	 , E.ENAME
	 , E.JOB
	 , E.SAL
	 , E.COMM
	 , E.DNO
	 , D.DNO
	 , D.DNAME
	 , D.LOC
	FROM EMP E
	   , DEPT D
	WHERE E.DNO = D.DNO;

-- 세 개 테이블 이상의 테이블 조인
-- 학생의 학생번호, 학생이름, 과목번호, 과목이름, 기말고사성적 조회
SELECT ST.SNO
	 , ST.SNAME
	 , SC.CNO
	 , C.CNAME
     , SC.RESULT
    FROM STUDENT ST
    JOIN SCORE SC
      ON ST.SNO = SC.SNO
    JOIN COURSE C
      ON SC.CNO = C.CNO
     ORDER BY SNO;

-- 학생의 학생번호, 학생이름, 과목번호, 과목이름, 기말고사성적, 담당교수 번호, 담당교수 이름 조회
SELECT ST.SNO
	 , ST.SNAME
	 , SC.CNO
	 , C.CNAME
     , SC.RESULT
     , C.PNO
     , P.PNAME 
    FROM STUDENT ST
    JOIN SCORE SC
      ON ST.SNO = SC.SNO
    JOIN COURSE C
      ON SC.CNO = C.CNO
    JOIN PROFESSOR P
      ON C.PNO = P.PNO
     ORDER BY SNO;

-- 1-2. 비등가조인
-- 비등가 조인은 해당 컬럼의 데이터 값이 크진 작은지, 사이값인지 부등호나 BETWEEN AND 절을 이용해서 비교하는 조인 구문
-- 학생의 학생번호, 학생이름, 과목번호, 과목이름, 기말고사 성적, 기말고사 성적의 등급 조회
SELECT ST.SNO
	 , ST.SNAME
	 , SC.CNO
	 , C.CNAME
	 , SC.RESULT
	 , GR.GRADE 
	FROM STUDENT ST
	JOIN SCORE SC
	  ON ST.SNO = SC.SNO
	JOIN COURSE C
	  ON SC.CNO = C.CNO
	JOIN SCGRADE GR
	--비등가조인사용
	  ON SC.RESULT <= GR.HISCORE 
	 AND SC.RESULT >= GR.LOSCORE
	ORDER BY ST.SNO, SC.CNO;

-- 학생의 학생번호, 학생이름, 과목번호, 과목이름, 기말고사 성적, 기말고사 성적의 등급 조회(BETWEEN AND 절 사용)
SELECT ST.SNO
	 , ST.SNAME
	 , SC.CNO
	 , C.CNAME
	 , SC.RESULT
	 , GR.GRADE 
	FROM STUDENT ST
	JOIN SCORE SC
	  ON ST.SNO = SC.SNO
	JOIN COURSE C
	  ON SC.CNO = C.CNO
	JOIN SCGRADE GR
	--비등가조인사용
	  ON SC.RESULT BETWEEN GR.LOSCORE AND GR.HISCORE 
	ORDER BY ST.SNO, SC.CNO;

-- 사원의 사원번호, 사원이름, 급여, 급여등급 조회(EMP, SALGRADE)
SELECT E.ENO 
	 , E.ENAME 
	 , E.SAL 
	 , S.GRADE 
	FROM EMP E
	JOIN SALGRADE S
	  ON E.SAL BETWEEN S.LOSAL AND S.HISAL;
	 
-- 1-3. 셀프조인
-- 조인되는 두 테이블이 동일할 때 셀프조인이라 부른다.
-- 사원의 사원번호, 사원이름, 사수번호, 사수이름
SELECT E.ENO
	 , E.ENAME
	 , E.MGR
	 , EM.ENAME 
	FROM EMP E
	JOIN EMP EM
	  ON E.MGR = EM.ENO;

-- 1-4. CROSS JOIN
-- 여러 테이블을 조인할 때 조인 조건을 지정하지 않으면 cross join이 일어난다.
-- cross join은 조인되는 모든 테이블의 데이터들이 1대1로 매핑되어 조회되는 현상이다.
-- 테이블들을 조인할 때는 항상 조인 조건을 명시하여 cross join이 일어나지 않도록 한다.
SELECT ST.SNO
	 , ST.SNAME
	 , SC.CNO
	 , C.CNAME
	 , SC.RESULT
	FROM STUDENT ST
	   , SCORE SC
	   , COURSE C;

-- 2. OUTER JOIN
-- OUTER JOIN은 INNER JOIN 결과에 추가로 기준이 되는 테이블에 남아있는 데이터를 조회하는 기능
-- 기준이 되는 테이블은 OUTER JOIN 앞에 LEFT, RIGHT, FULL로 지정한다.
-- LEFT로 기준 테이블을 지정하면 FROM 절에 사용한 테이블이 기준이 되고
-- RIGHT로 기준 테이블을 지정하면 조인되는 테이블이 기준이 된다.
-- FULL로 기준 테이블을 지정하면 FROM절 테이블과 조인되는 테이블 모두가 기준이 되어 INNER JOIN 결과에 
-- FROM 절 테이블에만 존재하는 데이터와 조인되는 테이블에만 존재하는 데이터도 모두 추가로 조회한다.
	  
-- 2-1. LEFT OUTER JOIN
-- FROM 절의 테이블에만 존재하는 데이터를 추가로 조회하는 JOIN
-- 학생의 학생번호, 학생이름, 기말고사 성적을 조회하는 데 기말고사 성적이 존재하지 않는 학생의 정보도 조회
INSERT INTO STUDENT VALUES('999999', '고기천', '남', 1, '컴공', 3.0);
COMMIT;

-- ANSI 표준 방식
SELECT ST.SNO
	 , ST.SNAME
	 , SC.RESULT
	FROM STUDENT ST
	LEFT OUTER JOIN SCORE SC
	  ON ST.SNO = SC.SNO
	ORDER BY ST.SNO DESC;

-- ORACLE에서만 사용하는 LEFT OUTER JOIN 방식 (+) 기호를 이용한다
-- (+) 기호는 LEFT OUTER JOIN과 RIGHT OUTER JOIN만 사용가능
SELECT ST.SNO
	 , ST.SNAME
	 , SC.RESULT
	FROM STUDENT ST
	   , SCORE SC
	WHERE ST.SNO = SC.SNO(+)
	ORDER BY ST.SNO DESC;

-- 과목번호, 과목이름, 교수번호, 교수이름을 조회하는데 담당교수가 배정되지 않은 과목정보도 조회
-- NVL 담당교수가 배정되지 않은 과목의 교수번호와 교수이름은 담당교수 배정되지 않음 으로 조회
SELECT C.CNO 
	 , C.CNAME 
	 , NVL(C.PNO, '담당교수 배정되지 않음') AS PNO 
	 , NVL(P.PNAME, '담당교수 배정되지 않음') AS PNAME 
	FROM COURSE C
	LEFT OUTER JOIN PROFESSOR P
	  ON C.PNO = P.PNO;

-- 사원의 사원번호, 사원이름, 사수번호, 사수이름 조회하는 데 사수가 배정되지 않은 사원의 정보도 조회(셀프조인)
SELECT E.ENO
	 , E.ENAME
	 , E.MGR
	 , EM.ENAME
	FROM EMP E
	LEFT OUTER JOIN EMP EM
	  ON E.MGR = EM.ENO;
	 
-- LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN 에서 OUTER는 생략 가능하다.
SELECT E.ENO
	 , E.ENAME
	 , E.MGR
	 , EM.ENAME
	FROM EMP E
	LEFT JOIN EMP EM
	  ON E.MGR = EM.ENO;
	 
	 
-- 2-2. RIGHT OUTER JOIN
-- INNER JOIN 조회 결과와 추가로 조인되는 테이블에만 존재하는 데이터를 조회하는 JOIN
-- 과목번호, 과목이름, 교수번호, 교수이름 조회하는데 아직 담당과목을 배정받지 못한 교수 정보도 조회
SELECT C.CNO
	 , C.CNAME
	 , P.PNO
	 , P.PNAME
	FROM COURSE C
	RIGHT OUTER JOIN PROFESSOR P
	  ON C.PNO = P.PNO;
	 
SELECT C.CNO
	 , C.CNAME
	 , P.PNO
	 , P.PNAME
	FROM PROFESSOR P
	LEFT OUTER JOIN COURSE C
	  ON C.PNO = P.PNO;

-- 3. FULL OUTER JOIN
-- FULL OUTER JOIN은 INNER JOIN된 조회 결과에 FROM 절 테이블에만 존재하는 데이터, 조인되는 테이블에만 존재하는 데이터
-- 모두 조회하는 JOIN
-- 과목번호, 과목이름, 교수번호, 교수이름 조회하는데 교수가 배정되지 않은 과목과 담당과목이 배정되지 않은 교수의 정보도 모두 조회
SELECT C.CNO
	 , C.CNAME
	 , P.PNO
	 , P.PNAME
	FROM COURSE C
	FULL OUTER JOIN PROFESSOR P
	  ON C.PNO = P.PNO;
	 
INSERT INTO EMP VALUES ('9999', '고기천', '개발', NULL, SYSDATE, 3000, 300, NULL);
INSERT INTO DEPT VALUES ('70', '분석', '서울', NULL);
COMMIT;
-- 사원의 사원번호, 사원이름, 부서번호, 부서이름을 조회하는데 부서를 배정받지 못한 사원의 정보와 사원이 한명도 존재하지 않는 부서의
-- 정보도 함께 조회
SELECT E.ENO
	 , E.ENAME
	 , D.DNO
	 , D.DNAME
	FROM EMP E
	FULL JOIN DEPT D
	  ON E.DNO = D.DNO;

-- 4. 다중 테이블 조인
-- 사원의 사원번호, 사원이름, 급여, 급여등급, 부서번호, 부서이름 조회하는데 부서를 배정받지 않은 사원의 정보도 조회
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 , GR.GRADE
	 , E.DNO
	 , D.DNAME
	FROM EMP E
	JOIN SALGRADE GR
	  ON E.SAL BETWEEN GR.LOSAL AND GR.HISAL
	LEFT JOIN DEPT D
	  ON E.DNO = D.DNO;

-- ON절에도 조건을 여러개 추가할 때는 WHERE 절과 마찬가지로
-- AND, OR를 사용해서 여러개 조건을 명시할 수 있다.
-- 급여가 3000이상이고 부서번호가 01, 10, 20, 60인 
-- 사원의 사원번호, 사원이름, 급여, 급여등급, 부서번호, 부서이름 조회하는데 부서를 배정받지 않은 사원의 정보도 조회
-- OUTER JOIN이라서 조인조건이 달라져서 다른 데이터가 나오게 된다.
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 , GR.GRADE
	 , E.DNO
	 , D.DNAME
	FROM EMP E
	JOIN SALGRADE GR
	  ON E.SAL BETWEEN GR.LOSAL AND GR.HISAL
	 AND E.SAL >= 3000
	LEFT JOIN DEPT D
	  ON E.DNO = D.DNO
	 AND E.DNO IN ('01', '10', '20', '60'); 

-- 다른 데이터가 조회되는 조건
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 , GR.GRADE
	 , E.DNO
	 , D.DNAME
	FROM EMP E
	JOIN SALGRADE GR
	  ON E.SAL BETWEEN GR.LOSAL AND GR.HISAL
	LEFT JOIN DEPT D
	  ON E.DNO = D.DNO
	WHERE E.SAL >= 3000
      AND E.DNO IN ('01', '10', '20', '60'); 
	 
SELECT E.ENO
	 , E.ENAME
	 , E.DNO
	 , D.DNAME
	FROM EMP E
	LEFT JOIN DEPT D
	  ON E.DNO = D.DNO
	 AND E.DNO IN ('01', '10', '20', '60');

SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 , GR.GRADE
	 , E.DNO
	 , D.DNAME
	FROM EMP E
	JOIN SALGRADE GR
	  ON E.SAL BETWEEN GR.LOSAL AND GR.HISAL
	 AND E.SAL >= 3000
	JOIN DEPT D
	  ON E.DNO = D.DNO
     AND E.DNO IN ('01', '10', '20', '60');
	 
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 , GR.GRADE
	 , E.DNO
	 , D.DNAME
	FROM EMP E
	JOIN SALGRADE GR
	  ON E.SAL BETWEEN GR.LOSAL AND GR.HISAL
	JOIN DEPT D
	  ON E.DNO = D.DNO
	WHERE E.SAL >= 3000
	  AND E.DNO IN ('01', '10', '20', '60');

-- 학생의 학생번호, 학생이름, 과목번호, 과목이름, 기말고사 성적, 기말고사 성적 등급, 담당교수 번호, 담당교수 이름 조회
SELECT P.PNO
	 , P.PNAME
	 , C.CNO
	 , C.CNAME
	 , SC."RESULT"
	 , GR.GRADE 
	 , ST.SNO 
	 , ST.SNAME
	FROM COURSE C
	JOIN SCORE SC
	  ON C.CNO = SC.CNO 
	JOIN PROFESSOR P
	  ON C.PNO = P.PNO 
	JOIN SCGRADE GR
	  ON SC."RESULT" BETWEEN GR.LOSCORE AND GR.HISCORE 
	JOIN STUDENT ST
	  ON SC.SNO = ST.SNO;