-- 1. DML(DATA MANIPULATION LANGUAGE): 데이터 조작 언어
-- 데이터를 저장, 수정, 삭제하는 언어로 INSERT INTO, UPDATE SET, DELETE FROM이 존재한다.
-- DML은 트랜잭션을 완료하기 위해서 항상 COMMIT이나 ROLLBACK을 동반한다.
-- 1-1. INSERT INTO: 테이블에 데이터를 저장하는 명령어
-- 일부 컬럼에 대한 데이터를 저장
INSERT INTO EMP(ENO, ENAME, JOB, HDATE) VALUES ('9997', '장길산', '설계', SYSDATE);
COMMIT;

SELECT *
	FROM EMP;
	
INSERT INTO EMP(ENO, ENAME, JOB, HDATE) VALUES ('9996', '임꺽정', '개발', SYSDATE);
COMMIT;
INSERT INTO EMP(ENO, ENAME, JOB, HDATE) VALUES ('9995', '홍길동', '회계', SYSDATE);
INSERT INTO EMP(ENO, ENAME, JOB, HDATE) VALUES ('9994', '조병조', '지원', SYSDATE);
INSERT INTO EMP(ENO, ENAME, JOB, HDATE) VALUES ('9993', '정도전', '경영', SYSDATE);
-- COMMIT이 발생한 작업에 대해서는 ROLLBACK으로 취소할 수 없다.
ROLLBACK;

-- INSERT INTO 시  지정한 컬럼의 개수와 컬럼의 타입에 맞는 데이터를 입력해야 한다.
INSERT INTO EMP(ENO, ENAME, JOB, HDATE) VALUES ('9993', '정도전', '경영');
INSERT INTO EMP(SAL) VALUES ('ㅁㅁㅁㅁㅁㅁ');
-- VARCHAR타입의 숫자 값이 NUMBER 타입으로 형변환이 일어나면서 저장된다.
INSERT INTO EMP(SAL) VALUES ('12838');

-- 모든 컬럼에 데이터를 저장할 때는 컬럼지정을 생략해도 된다.
INSERT INTO EMP(ENO, ENAME, JOB, MGR, HDATE, SAL, COMM, DNO)
	VALUES('9996', '임꺽정', '회계', '0001', SYSDATE, 4000, 300, '10');

INSERT INTO EMP VALUES('9995', '조병조', '경영', '0201', SYSDATE, 3700, 280, '20');

COMMIT;

-- 다량의 데이터를 SELECT 구문을 이용해서 저장
CREATE TABLE EMP_DNO30(
	ENO VARCHAR2(4),
	ENAME VARCHAR2(20),
	JOB VARCHAR2(10),
	MGR VARCHAR2(4),
	HDATE DATE,
	SAL NUMBER(5, 0),
	COMM NUMBER(5, 0),
	DNO VARCHAR2(2)
);

-- DNO이 30인 사원 목록을 EMP 테이블에서 조회해서 EMP_DNO30에 저장
INSERT INTO EMP_DNO30 
SELECT *
	FROM EMP
	WHERE DNO = '30';
COMMIT;

SELECT *
	FROM EMP_DNO30;

-- SELECT 구문을 이용해서 다량의 데이터를 저장하는 데 특정 컬럼의 데이터만 저장
-- DNO이 10인 사원의 사원번호, 사원이름만 EMP 테이블에서 조회해서 EMP_DNO30 테이블에 저장
INSERT INTO EMP_DNO30(ENO, ENAME)
SELECT ENO
	 , ENAME
	FROM EMP
	WHERE DNO = '10';
COMMIT;

INSERT INTO EMP_DNO30(ENO, ENAME)
SELECT DNO
	 , DNAME
	FROM DEPT
	WHERE LOC = '서울';
COMMIT;

DROP TABLE COURSE_PRFESSOR;

CREATE TABLE COURSE_PRFESSOR(
	CNUM VARCHAR2(8),
	COURSE_NAME VARCHAR2(20),
	ST_NUM NUMBER(1, 0),
	PNUM VARCHAR2(8),
	PROFESSOR_NAME VARCHAR2(20)
);

-- 모든 과목의 과목번호, 과목이름, 학점, 담당하는 교수의 교수번호, 교수이름을  COURSE_PRFESSOR 저장
-- 담당교수가 없는 과목은 담당교수번호와 이름을 NULL로 저장
INSERT INTO COURSE_PRFESSOR
SELECT C.CNO
	 , C.CNAME 
	 , C.ST_NUM 
	 , P.PNO 
	 , P.PNAME
	FROM COURSE C
	LEFT JOIN PROFESSOR P
	  ON C.PNO = P.PNO;
	 
COMMIT;

SELECT *
	FROM COURSE_PRFESSOR;

-- 1-2. UPDATE SET: 데이터를 수정하는 명령어
-- WHERE 절을 사용하지 않으면 모든 데이터가 수정된다.
UPDATE EMP_DNO30
	SET 
		MRG = '0002';
	
COMMIT;

SELECT *
	FROM EMP_DNO30;

-- WHERE 절로 특정 데이터만 수정
-- EMP_DNO30테이블에서 ENO 2007인 사원의 급여를 3100으로 수정
UPDATE EMP_DNO30 
	SET 
		SAL = 3100
	WHERE ENO = '2007';
COMMIT;

-- 여러 개의 컬럼 데이터를 한 번에 수정할 때는 수정할 컬럼을 ,로 묶어서 지정
-- EMP_DNO30테이블에서 ENO이 3004인 사원의 업무를 경영으로 MGR은 2003으로 HDATE는 오늘날짜로 SAL은 5000으로
-- COMM는 500으로 수정
UPDATE EMP_DNO30 
	SET 
		JOB = '경영',
		MRG = '2003',
		HDATE = SYSDATE,
		SAL = 5000,
		COMM = 500
	WHERE ENO = '3004';
COMMIT;

SELECT *
	FROM EMP_DNO30;
		
DELETE FROM EMP_DNO30;
COMMIT;

INSERT INTO EMP_DNO30
SELECT *
	FROM EMP;
COMMIT;

DROP TABLE EMP_DNO30;

-- EMP_DNO30 테이블에서 DNO이 20, 30부서를 60 부서로 통합하고
-- 해당 부서의 사원들의 보너스를 50%인상
UPDATE EMP_DNO30 
	SET 
		DNO = '60',
		COMM = COMM * 1.5
	WHERE DNO IN ('20', '30');
COMMIT;

SELECT *
	FROM EMP_DNO30;

-- 서브쿼리를 이용한 데이터 수정
-- SET 절에 서브쿼리의 결과로 나오는 컬럼의 개수만큼 ()묶은 컬럼을 지정하고 = 다음에 서브쿼리를 작성한다.
-- ()로 묶인 컬럼의 개수와 타입이 서브쿼리의 결과의 데이터의 컬럼개수와 타입이 일치해야 한다.
-- 서브쿼리의 결과는 한 행만 조회돼야 한다.
CREATE TABLE DEPT_COPY1
	AS SELECT * FROM DEPT;

-- DEPT_COPY1 테이블에서 DNO 20, 30인 부서를 50부서와 통합
UPDATE DEPT_COPY1 
	SET
		(DNO, DNAME, LOC, DIRECTOR) = (
										  SELECT DNO 
										  	   , DNAME 
										  	   , LOC 
										  	   , DIRECTOR 
										  	  FROM DEPT
										  	  WHERE DNO = '50'
									  )
	WHERE DNO IN ('20', '30');
COMMIT;

SELECT *
	FROM DEPT_COPY1;

-- DEPT_COPY1 테이블에서 DNO이 40인 부서의 DIRECTOR를 
-- EMP테이블에서 최고급여를 받는 사원으로 수정
SELECT MAX(SAL)
	FROM EMP;

SELECT ENO
	FROM EMP
	WHERE SAL = (
		SELECT MAX(SAL)
			FROM EMP
	);

UPDATE DEPT_COPY1 
	SET 
		DIRECTOR = (
						SELECT ENO
							FROM EMP
							WHERE SAL = (
								SELECT MAX(SAL)
									FROM EMP
							)
				   )
	WHERE DNO = '40';
COMMIT;

SELECT *
	FROM DEPT_COPY1;

-- 1-3. DELETE FROM: 데이터를 삭제하는 명령어
-- 행 단위로 데이터를 삭제하기 때문에 컬럼을 지정할 필요가 없다.
-- WHERE 절을 사용하지 않으면 테이블의 모든 데이터를 삭제한다.
DELETE FROM DEPT_COPY1;
COMMIT;

-- WHERE 절로 특정 데이터만 삭제
DELETE FROM EMP_DNO30
	WHERE DNO IN ('01', '10');
COMMIT;

SELECT *
	FROM EMP_DNO30;

-- WHERE 절에 서브쿼리로 특정 데이터를 지정할 수도 있다.
DELETE FROM EMP_DNO30
	WHERE ENO IN (
		SELECT ENO
			FROM EMP_DNO30
			WHERE SAL >= 4000
	);
COMMIT;

CREATE TABLE STUDENT_COPY1
	AS SELECT * FROM STUDENT;

-- STUDENT_COPY1 테이블에서 기말고사 성적의 평균이 60점 이하인 학생을 모두 삭제
SELECT SNO
	FROM SCORE
	GROUP BY SNO
	HAVING AVG(RESULT) <= 60;

DELETE FROM STUDENT_COPY1
	WHERE SNO IN (
		SELECT SNO
			FROM SCORE
			GROUP BY SNO
			HAVING AVG(RESULT) <= 60
	);
COMMIT;

SELECT *
	FROM STUDENT_COPY1;

UPDATE EMP_DNO30 
	SET ENAME = 'RRR'
	WHERE DNO = '60';