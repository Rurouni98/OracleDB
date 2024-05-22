-- 1. 기본 Select 구문
-- 1-1. 과목테이블에서 과목번호, 과목이름, 학점, 담당교수번호 조회
SELECT CNO
	 , CNAME
	 , ST_NUM
	 , PNO
	FROM COURSE;

-- 1-2. 학생테이블에서 학생번호와 학생이름 조회
SELECT SNO
	 , SNAME
	FROM STUDENT;
	
-- 1-3. 조회할 테이블의 모든 컬럼의 데이터를 조회할 때는 컬럼명 대신 *를 사용해도 된다.
SELECT *
	FROM DEPT;

-- 2. 컬럼이나 테이블에 별칭 붙이기
-- 2-1. 컬럼에 별칭붙이기
-- 조회해올 데이터의 컬럼에 별칭을 붙일 수 있다. 조회된 데이터는 새로운 가상테이블을 생성하는데
-- 가상테이블의 컬럼명은 붙인 별칭으로 할당된다. 별칭은 한글로 붙여도 무방하나 대부분 영어로 붙인다.
-- AS 키워드를 이용해서 별칭을 붙일 수 있는데 AS 키워드는 생략 가능하다.
SELECT PNO AS PRFESSOR_NO
	 , PNAME AS 교수이름
	 , ORDERS 직위
	FROM PROFESSOR;

-- 2-2. 테이블에 별칭 붙이기
-- 테이블에 붙인 별칭은 Select 구문안에서 사용하기 위한 별칭이다.
-- 여러개의 테이블을 동시에 조회할 때 주로 사용된다.
-- 여러개의 테이블을 동시에 조회하면 어떤 테이블의 컬럼인지 모호해지는 경우가 있는데 그 경우를 대비하기 위해
-- 어떤테이블의 컬럼인지 명확하게 해주기 위해 주로 사용
SELECT STUDENT.SNO
	 , STUDENT.SNAME
	FROM STUDENT;

-- 테이블에 별칭을 줄 때는 AS 키워드를 사용할 수 없다. 테이블명 뒤에 바로 붙일 별칭을 달아준다.
SELECT ST.SNO
	 , ST.SNAME
	FROM STUDENT ST;

-- 여러개의 테이블 동시 조회시 모호한 컬럼의 경우
SELECT SNO
	 , SNAME
	 , RESULT
	FROM STUDENT
	JOIN SCORE
	ON STUDENT.SNO = SCORE.SNO;

SELECT ST.SNO
	 , ST.SNAME
	 , SC.RESULT
	FROM STUDENT ST
	JOIN SCORE SC
	ON ST.SNO = SC.SNO;

-- 3. NULL인 데이터의 처리방식을 지정하는 NVL
SELECT DNO
	 , DNAME
	 , LOC
	 , DIRECTOR
	FROM DEPT;

SELECT DNO
	 , DNAME
	 , LOC
	 , NVL(DIRECTOR, '팀장없음') AS DIRECTOR
	FROM DEPT;

-- 3-1. 사원테이블에서 사원번호, 사원이름, 급여, 보너스(COMM) 조회하는데
-- 보너스가 NULL인 사원은 0으로 조회
SELECT ENO
	 , ENAMe
	 , SAL
	 , NVL(COMM, 0) AS COMM
	FROM EMP;

-- 3-1. 사원테이블에서 사원번호, 사원이름, 급여, 보너스(COMM) 조회하는데
-- 보너스가 NULL인 사원은 SAL / 12로 조회
SELECT ENO
	 , ENAMe
	 , SAL
	 , NVL(COMM, SAL / 12) AS COMM
	FROM EMP;

-- 4. 연결연산자(||)
-- 한 번에 연결해서 조회하고 싶은 컬럼들을 ||를 이용해서 연결 조회할 수 있다.
-- 4-1. 사원의 급여와 이름을 -로 연결해서 조회
SELECT ENO
	 , ENAME || '-' || SAL
	FROM EMP;

-- 4-2. 학생번호와 기말고사점수를 -로 연결해서 조회(SCORE)
SELECT SNO || '-' || RESULT AS 학번
	FROM SCORE;

-- 5. 중복제거자 DISTINCT
-- 5-1. 중복을 제거하지 않았을 때
SELECT JOB
	FROM EMP;

-- 5-2. DISTINCT 사용해서 중복제거 했을 때
SELECT DISTINCT JOB
	FROM EMP;

-- 5-3. 컬럼 여러개에 대한 DISTINCT
-- 여러 개의 컬럼을 조회할 때 DISTINCT가 걸리면
-- 조회된 여러개의 컬럼을 데이터 셋 하나로 인식해서
-- 조회된 모든 컬럼의 데이터가 중복돼야 중복으로 인식한다.
SELECT DISTINCT JOB
	 , MGR
	FROM EMP;

-- 6. 데이터 정렬 기준을 정하는 ORDER BY
-- 6-1. 컬럼 하나만 정렬
-- 오름차순(ASC)로 정렬할 때는 ASC를 생략해도 된다.
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	 , AVR
	FROM STUDENT
	ORDER BY SYEAR;

-- 내림차순(DESC)로 정렬할 때는 항상 DESC를 명시해야 한다.
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	 , AVR
	FROM STUDENT
	ORDER BY SYEAR DESC;

-- DATABASE에서 정렬은 문자로도 가능.
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	 , AVR
	FROM STUDENT
	ORDER BY SNAME DESC;

-- 6-2. 컬럼 여러개로 정렬
-- 처음 지정된 컬럼으로 정렬이 된 상태에서 다음 지정된 컬럼으로 정렬한다.
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	 , AVR
	FROM STUDENT
	ORDER BY SYEAR, SNAME;

-- ORDER BY 여러개의 컬럼을 지정할 때는 각 컬럼에 정렬방식(ASC, DESC)를 각각 지정할 수 있다.
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	 , AVR
	FROM STUDENT
	ORDER BY SYEAR DESC, AVR;

SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	 , AVR
	FROM STUDENT
	ORDER BY SYEAR, MAJOR, AVR;

-- 6-3. 사원 테이블에서 사원번호, 사원이름, 부서번호, 급여 조회하는데
-- 부서번호가 빠르고 급여가 높은 사원부터 조회
SELECT ENO
	 , ENAME
	 , DNO
	 , SAL
	FROM EMP
	ORDER BY DNO, SAL DESC;

-- 6-4. 컬럼에 별칭을 붙인 경우에는 별칭으로도 정렬가능
SELECT ENO
	 , ENAME
	 , DNO AS 부서번호
	 , SAL AS 급여
	FROM EMP
	ORDER BY 부서번호, 급여 DESC;

-- 7. 조건을 걸어서 원하는 데이터만 조회하는 WHERE 절
-- WHERE 절은 FROM이나 JOIN~ON절 다음에 작성한다.
-- 7-1. WHERE 절에서 값의 크기를 비교할 때는 자바와 마찬가지로 부등호를 사용한다.(>, <, >=, <=)
-- 사원중에 급여가 3000이상인 사원번호, 사원이름, 급여 조회
SELECT ENO
	 , ENAME
	 , SAL
	FROM EMP
	WHERE SAL >= 3000;

SELECT *
	FROM EMP;

-- 학생 중에 평점이 3.0 이하인 학생번호, 학생이름, 전공, 학년, 평점 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	 , AVR
	FROM STUDENT
	WHERE AVR <= 3.0;

-- 7-2. WHERE 절에서 값의 동일여부를 비교할 때는 =, !=을 사용한다.
-- 전공이 화학과인 학생의 학생번호, 학생이름, 전공, 학년 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE MAJOR = '화학';

-- 전공이 화학과가 아닌 학생의 학생번호, 학생이름, 전공, 학년 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE MAJOR != '화학';

-- 7-3. WHERE 절에서 조건을 비교할 때는 항상 컬럼의 타입과 동일한 타입의 값으로 비교한다.
-- 사원테이블의 급여 컬럼은 NUMBER타입인데 문자열과 비교를 하게 되면
-- 급여컬럼에 있는 모든 데이터가 문자열로 변환되는 과정이 필요하다.
-- 데이터가 많아지면 많아질수록 변환되는 시간이 오래 걸리기 때문에 
-- 항상 테이블의 컬럼 데이터가 타입 변환이 일어나지 않도록 쿼리를 작성해야 한다.
-- 부적절한 쿼리
SELECT ENO
	 , ENAME
	 , HDATE
	FROM EMP
	WHERE TO_CHAR(HDATE, 'YYYY-MM-DD:HH24:MI:SS') < '2000-10-10:23:59:59';

-- 적절한 쿼리
SELECT ENO
	 , ENAME
	 , HDATE
	FROM EMP
	WHERE HDATE < TO_DATE('2000-10-10:23:59:59', 'YYYY-MM-DD:HH24:MI:SS');

-- 사원중에 업무가 경영인 사원의 사원번호, 사원이름, 업무, 급여, 보너스 조회
SELECT ENO
	 , ENAME
	 , JOB
	 , SAL
	 , COMM
	FROM EMP
	WHERE JOB = '경영';

-- 7-4. NULL인 값의 비교는 = NULL, != NULL로 하지 않고 IS NULL, IS NOT NULL이라는 특수한 구문을 이용한다.
-- 보너스가 NULL인 사원의 사원번호, 사원이름, 업무, 급여, 보너스 조회
SELECT ENO
	 , ENAME
	 , JOB
	 , SAL
	 , COMM
	FROM EMP
	WHERE COMM IS NULL;

-- 보너스가 NULL이 아닌 사원 사원의 사원번호, 사원이름, 업무, 급여, 보너스 조회
SELECT ENO
	 , ENAME
	 , JOB
	 , SAL
	 , COMM
	FROM EMP
	WHERE COMM IS NOT NULL;

-- 부서테이블에서 팀장이 NULL이 아닌 부서의 부서번호, 부서이름 조회
SELECT DNO
	 , DNAME
	FROM DEPT
	WHERE DIRECTOR IS NOT NULL;

-- 7-5. 문자열을 포함한 데이터 조회(LIKE)
-- 학생 중 이름이 우로 끝나는 학생의 학생번호, 학생이름 조회
SELECT SNO
	 , SNAME
	FROM STUDENT
	WHERE SNAME LIKE '%우';

-- 과목 중에 화학이 포함되어 있는 과목의 과목번호, 과목이름, 학점 조회
SELECT CNO
	 , CNAME
	 , ST_NUM
	FROM COURSE
	WHERE CNAME LIKE '%화학%';

-- 교수 중에 이름이 세글자인 교수의 교수번호, 교수이름 조회
SELECT PNO
	 , PNAME
	FROM PROFESSOR
	WHERE PNAME LIKE '___';

-- 8. 다중 조건을 만들어 주는 AND, OR 절
-- 8-1. 다중 조건을 모두 충족하는 데이터를 조회하는 AND 절
-- 학생 중에 1학년이면서 성이 노씨인 학생의 학생번호, 학생이름, 전공, 학년 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE SYEAR = 1
	  AND SNAME LIKE '노%';
	 
-- 사원 중에 회계업무를 하면서 급여가 3000이상인 이름이 세 글자인 사원의 사원번호, 사원이름, 업무, 급여 조회
SELECT ENO
	 , ENAME
	 , JOB
	 , SAL
	FROM EMP
	WHERE JOB = '회계'
	  AND SAL >= 3000
	  AND ENAME LIKE '___';

-- 8-2. 다중 조건 중 하나라도 충족하는 데이터들을 모두 조회하는 OR 절
-- 학생 중 1학년이거나 성이 노씨인 학생의 학생번호, 학생이름, 전공, 학년 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE SYEAR = 1
	   OR SNAME LIKE '노%';

-- 전공이 화학이거나 물리인 학생의 학생번호, 학생이름, 전공, 학년 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE MAJOR = '화학'
	   OR MAJOR = '물리';

-- 8-3. AND, OR 혼합 사용
-- AND, OR를 혼합하여 사용하면 조건을 알아보기 힘들어지기 때문에
-- () 조건의 우선순위를 정해준다.
-- 전공이 화학이거나 물리인 학생 중 1학년인 학생의 학생번호, 학생이름, 전공, 학년 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE (MAJOR = '화학'
	   OR MAJOR = '물리')
	  AND SYEAR = 1;

-- 부서번호가 10이거나 30인 사원 중 급여가 3000이상인 사원의 사원번호, 사원이름, 급여, 부서 조회
SELECT ENO
	 , ENAME
	 , SAL
	 , DNO
	FROM EMP
	WHERE (DNO = 10
	   OR DNO = 30)
	  AND SAL >= 3000;
	 
-- 9. 특정한 범위의 값인지 비교해주는 BETWEEN AND 구문
-- 급여가 3000이상 5000이하인 사원의 사원번호, 사원이름, 급여 조회
SELECT ENO
	 , ENAME
	 , SAL
	FROM EMP
	WHERE SAL BETWEEN 3000 AND 5000;
	 
SELECT ENO
	 , ENAME
	 , SAL
	FROM EMP
	WHERE SAL >= 3000 
	  AND SAL <= 5000;
	 
-- 평점이 3.0이상 3.7이하이면서 학년이 2학년이상 4학년이하인 학생의 학생번호, 학생이름, 평점, 학년, 전공 조회
SELECT SNO
	 , SNAME
	 , AVR
	 , SYEAR
	 , MAJOR
	FROM STUDENT
	WHERE AVR BETWEEN 3.0 AND 3.7

SELECT *
	FROM PROFESSOR;
	 
-- BETWEEN AND 구문에서 두 날짜 사이의 있는 데이터도 조회할 수 있다.
-- TO_DATE: 데이터의 형식을 날짜형식으로 변경한다.
-- TO_DATE(문자열, 문자열의 날짜형식)
-- 2000년 1월 1일 ~ 2001년 12월 31일 사이에 부임한 교수의 교수번호, 교수이름, 부임일자 조회
SELECT PNO
	 , PNAME
	 , HIREDATE
	FROM PROFESSOR
	WHERE HIREDATE
		BETWEEN TO_DATE('20000101 00:00:00', 'yyyymmdd hh24:mi:ss')
	 	    AND TO_DATE('2001/12/31 23:59:59', 'yyyy/mm/dd hh24:mi/ss');
	 
-- 10. 여러개의 데이터와 값을 비교하는 IN 절
-- 전공이 화학이거나 물리인 학생의 학생번호, 학생이름, 전공, 학년 조회
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE MAJOR = '화학'
	   OR MAJOR = '물리';

SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE MAJOR IN ('화학', '물리');

-- 부서번호가 10이거나 20이거나 30인 사원의 사원번호, 사원이름, 업무, 부서번호 조회
SELECT ENO
	 , ENAME
	 , JOB
	 , DNO
	FROM EMP
	WHERE DNO IN ('10', '20', '30');
	 	   
-- 전공이 생물이거나 유공이면서 1, 2, 3학년인 학생의 학생번호, 학생이름, 전공, 학년 조회	   
SELECT SNO
	 , SNAME
	 , MAJOR
	 , SYEAR
	FROM STUDENT
	WHERE MAJOR IN ('생물', '유공')
	  AND SYEAR IN (1, 2, 3);
	 	   
-- 거의 모든 DBMS에서 문자열은 작은따옴표('')로 표시한다.
-- 큰 따옴표("")는 컬럼에 대한 별칭(alias)를 붙여줄 때만 사용한다.
-- 업무가 개발이거나 경영인 사원 중에 보너스가 700이상인 사원의 사원번호, 사원이름, 업무, 급여, 보너스 조회
SELECT ENO AS "사원번호"
	 , ENAME AS "사원이름"
	 , JOB AS "업무"
	 , SAL AS "급여"
	 , COMM AS "보너스"
	FROM EMP
	WHERE JOB IN ('개발', '경영')
	  AND COMM >= 700; 
