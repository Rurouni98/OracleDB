-- 1. OBJECT(객체): 데이터베이스에 데이터 보관 및 관리를 용이하게 하기 위한 저장공간 또는 기능을 제공하는 역할
-- 				   테이블, 인덱스, 유저, 시퀀스, 시노님,.. 등 다양한 객체가 존재한다.
-- 1-1. 데이터 사전: 사용자가 직접 생성한 테이블이 아닌 데이터베이스의 성능과 관련된 테이블로 데이터베이스 서버를 구축할 때 자동으로
--               생성되는 테이블들. 직접 조작은 불가능하고 제공되는 뷰테이블로 SELECT 기능만 이용할 수 있다.
-- C##STUDY 계정이 사용할 수 있는 데이터 사전 조회
SELECT *
	FROM DICT;
	
-- C##STUDY 계정이 조회할 수 있는 성능 관련 데이터 사전
SELECT *
	FROM DICTIONARY
	WHERE TABLE_NAME LIKE 'V$%';
	
-- C##STUDY가 소유하고 있는 테이블 목록 조회
SELECT U.TABLE_NAME
	 , A.OWNER 
	FROM USER_TABLES U
	JOIN ALL_TABLES A
	  ON U.TABLE_NAME = A.TABLE_NAME
	WHERE A.OWNER = 'C##STUDY';

-- C##STUDY 계정이 사용할 수 있는 모든 테이블 목록 조회
-- C##STUDY는 현재 DBA 권한이 있기 때문에 관리자 계정으로 접근할 수 있는 모든 테이블을 사용할 수 있다.
SELECT *
	FROM ALL_TABLES;

-- 관리자(SYS) 계정이 소유하고 있는 시스템 관련 정보들을 담고있는 테이블 목록 조회
SELECT *
	FROM DBA_TABLES;

-- 현재 데이터베이스에 접속한 세션정보 확인
SELECT SID
	 , OSUSER
	 , SERIAL#
	 , PROGRAM
	FROM V$SESSION;

-- DB에 락 걸렸을 때 세션 접속을 끊어버리는 명령어
-- DBA 권한이 있는 계정만 사용 가능
-- ALTER SYSTEM KILL SESSION 'SID, SERIAL#' IMMEDIATE;
ALTER SYSTEM KILL SESSION '1589, 51817' IMMEDIATE;

-- 락 걸린 객체 확인
SELECT OBJECT_ID
	 , SESSION_ID
	 , ORACLE_USERNAME
	 , OS_USER_NAME
	FROM V$LOCKED_OBJECT;

-- 트랜잭션을 종료시키지 않고 락걸기
UPDATE STUDENT_COPY1  
	SET 
		SNO = '222222';
	
-- 락 걸린 세션 확인
SELECT L.OBJECT_ID
	 , S.SID
	 , L.ORACLE_USERNAME
	 , S.SERIAL#
	 , S.OSUSER
	 , S.PROGRAM
	 , T.SQL_TEXT
	FROM V$SESSION S
	JOIN V$LOCKED_OBJECT L
	  ON S.SID = L.SESSION_ID
	JOIN V$SQLTEXT T
	  ON S.SQL_ADDRESS = T.ADDRESS;

ALTER SYSTEM KILL SESSION '615, 20518' IMMEDIATE;

SELECT *
	FROM STUDENT_COPY1 sc ;

SELECT A.*
	 , B.*
	 , C.*
	FROM TABLEA A
	   , TABLEB B
	   , TABLEC C;
	  
-- 1-2. INDEX: 테이블에 색인을 추가하여 검색속도를 향상시키는 객체
-- EMP 테이블에 데이터가 1000000건이 있으면
-- INDEX가 없을 때
-- SELECT *
--	  FROM EMP
--	  WHERE ENO = '499999'
-- ENO 1번부터 하나씩 증가하면서 비교해서 나간다.
-- INDEX가 있으면
-- SELECT *
--	  FROM EMP
--	  WHERE ENO = '499999'
-- ENO 500000번보다 작은지 큰지 비교
-- ENO 250000번보다 작은지 큰지 비교
-- ENO 375000번보다 작은지 큰지 비교
-- 데이터가 천만건 이상되는 테이블에 인덱스를 생성해야 인덱스의 효율이 증가한다.
-- 인덱스는 고유인덱스와 비고유인덱스로 나눌 수 있다.
-- 고유인덱스는 인덱스로 지정된 컬럼의 데이터가 중복되면 안되는 인덱스(PK, UK)
-- 비고유인덱스는 인덱스로 지정된 컬럼의 데이터가 중복되도 되는 인덱스(직접 인덱스를 생성)
-- 비고유 인덱스 생성
-- STUDENT 테이블에 SNAME을 인덱스로 지정
CREATE INDEX STUDENT_SNAME_IDX
	ON STUDENT(SNAME);
	  
-- 여러개 컬럼을 선택하여 복합 인덱스로 지정
CREATE INDEX PROFESSOR_PNO_PNAME_IDX
	ON PROFESSOR(PNO, PNAME);
	  
-- 수식을 이용한 인덱스 생성
-- 하나의 테이블에 여러개 인덱스 생성 가능
-- STUDENT 테이블에 4.5점 만점으로 환산된 평점을 인덱스로 설정
CREATE INDEX STUDENT_CONVERT_AVR_IDX
	ON STUDENT(AVR * 1.125);
	  
-- EMP 테이블에 50% 인상된 급여를 인덱스로 설정
CREATE INDEX EMP_CONVERT_SAL_IDX
	ON EMP(SAL * 1.5);
	  
-- 생성된 인덱스 조회 쿼리
SELECT UI.INDEX_NAME 
	 , UI.TABLE_NAME 
	 , UIC.COLUMN_NAME 
	 , UIC.COLUMN_POSITION 
	 , UI.UNIQUENESS 
	FROM USER_INDEXES UI
	JOIN USER_IND_COLUMNS UIC
	  ON UI.INDEX_NAME = UIC.INDEX_NAME;

-- 인덱스 삭제
DROP INDEX EMP_CONVERT_SAL_IDX;

-- 1-3. VIEW: 원천 테이블들의 데이터를 논리적으로 모아서 생성하는 가상의 테이블
--			  원천 테이블의 데이터가 변경되면 VIEW 테이블의 데이터도 자동으로 변경된다.
--			  단순 VIEW와 복합 VIEW로 나뉘게 되고
-- 단순 VIEW: 원천 테이블이 하나인 VIEW 테이블. DML(INSERT, UPDATE, DELETE) 구문이 사용 가능
-- 복합 VIEW: 여러개의 원천 테이블을 조인해서 생성한 VIEW 테이블. DML(INSERT, UPDATE, DELETE) 구문이 사용 불가능
-- 주로 통계데이터나 원천 테이블의 데이터가 수시로 변경될 때 VIEW를 생성해서 데이터를 저장 후 사용한다.
-- 과목별 학과별 기말고사 성적의 평균 점수를 저장하는 VIEW 생성(복합 VIEW)
DROP VIEW V_COURSE_MAJOR_AVRRES;

CREATE OR REPLACE VIEW V_COURSE_MAJOR_AVGRES(
	COURSE_NUM,
	COURSE_NAME,
	MAJOR_NAME,
	AVG_RESULT
) AS (
	SELECT SC.CNO
		 , C.CNAME
		 , ST.MAJOR
		 , ROUND(AVG(SC.RESULT), 2)
		FROM SCORE SC
		JOIN COURSE C
		  ON SC.CNO = C.CNO
		JOIN STUDENT ST
		  ON ST.SNO = SC.SNO
		GROUP BY SC.CNO, C.CNAME, ST.MAJOR
);

-- VIEW 테이블의 데이터 조회
SELECT *
	FROM V_COURSE_MAJOR_AVGRES
	ORDER BY COURSE_NUM, MAJOR_NAME;

-- VIEW 테이블은 원천 테이블의 데이터의 영향을 받기 때문에
-- 원천 테이블의 데이터가 변경되면 VIEW 테이블의 데이터도 자동으로 변경된다.
UPDATE COURSE 
	SET
		CNAME = '일반화학1'
	WHERE CNAME = '일반화학';
COMMIT;
	  
-- 단순 VIEW 생성
-- 1학년 학생의 정보만 가지고 있는 VIEW 생성
CREATE OR REPLACE VIEW ST_JUNIOR(
	SNO,
	SNAME,
	MAJOR,
	SYEAR,
	AVR
) AS (
	SELECT SNO
		 , SNAME
		 , MAJOR
		 , SYEAR
		 , AVR
		FROM STUDENT
		WHERE SYEAR = 1
);

SELECT *
	FROM ST_JUNIOR;

-- 단순 VIEW에서는 DML의 사용이 가능하다.
INSERT INTO ST_JUNIOR
VALUES (
	'999998',
	'홍길동',
	'컴공',
	1,
	4.0
);
COMMIT;

SELECT *
	FROM STUDENT;

-- 1학년 학생의 정보만 모아놓은 VIEW기 때문에 다른 학년 학생의 데이터를 추가해도 VIEW에서는 조회되지 않는다.
INSERT INTO ST_JUNIOR
VALUES (
	'999997',
	'임꺽정',
	'컴공',
	3,
	2.56
);
COMMIT;

-- CHECK OPTION을 추가하면 제약조건이 생성되어서
-- 조회해온 조건에 맞는 데이터만 DML로 조작할 수 있게 된다.
-- 4학년 데이터만 조회해서 VIEW로 생성하기 때문에
-- 4학년 학생에 대한 데이터 조작이 가능해진다.
CREATE OR REPLACE VIEW ST_SENIOR(
	SNO,
	SNAME,
	MAJOR,
	SYEAR,
	AVR
) AS (
	SELECT SNO
		 , SNAME
		 , MAJOR
		 , SYEAR
		 , AVR
		FROM STUDENT
		WHERE SYEAR = 4
)
WITH CHECK OPTION CONSTRAINT ST_SENIOR_CONSTRAINT;

INSERT INTO ST_SENIOR
VALUES (
	'999996',
	'조병조',
	'컴공',
	4,
	3.13
);
COMMIT;

INSERT INTO ST_SENIOR
VALUES (
	'999995',
	'장길산',
	'컴공',
	3,
	3.84
);
COMMIT;
	  
-- 인라인 VIEW(서브쿼리): FROM/JOIN절에서 사용되는 서브쿼리를 인라인 뷰라고 부르기도 한다.
SELECT E.ENO
	 , E.ENAME
	 , E.DNO
	 , B.MINSAL
	FROM EMP E
	JOIN (
		-- 인라인 뷰
		SELECT DNO
			 , MIN(SAL) AS MINSAL
			FROM EMP
			GROUP BY DNO
	) B
	  ON E.DNO = B.DNO
	 AND E.SAL = B.MINSAL;

-- 뷰의 삭제
DROP VIEW ST_JUNIOR;

-- ORACLE의 ROWNUM: 조회된 데이터에 행번호를 붙여주는 객체
-- 급여 최상위 3명 조회
SELECT ROWNUM
	 , A.ENO
	 , A.ENAME
	 , A.SAL
	FROM (
		SELECT ENO
			 , ENAME
			 , SAL
			FROM EMP
			WHERE SAL IS NOT NULL 
			ORDER BY SAL DESC
	) A
	WHERE ROWNUM <= 3;

-- 잘못된 쿼리
-- 정렬이 되기 전에 행번호가 생성돼서 원하는 데이터와 다른 데이터가 조회된다.
-- 정렬된 데이터에 ROWNUM을 붙인다음에 사용해야 제대로 된 데이터를 조회할 수 있다.
SELECT ROWNUM
	 , ENO
	 , ENAME
	 , SAL
	FROM EMP
	WHERE SAL IS NOT NULL 
	  AND ROWNUM <= 3
	ORDER BY SAL DESC;

-- 전공별 기말고사 성적의 평균 점수가 최상위 3인 데이터 조회(전공, 기말고사 성적의 평균점수 조회)
SELECT ST.MAJOR
	 , AVG(SC.RESULT) AS AVG_RES
	FROM STUDENT ST
	JOIN SCORE SC
	  ON ST.SNO = SC.SNO 
	GROUP BY ST.MAJOR
	ORDER BY AVG_RES DESC;

SELECT ROWNUM
	 , A.MAJOR
	 , A.AVG_RES
	FROM (
		SELECT ST.MAJOR
			 , AVG(SC.RESULT) AS AVG_RES
			FROM STUDENT ST
			JOIN SCORE SC
			  ON ST.SNO = SC.SNO 
			GROUP BY ST.MAJOR
			ORDER BY AVG_RES DESC
	) A
	WHERE ROWNUM <= 3;

-- ROWNUM 위치에 따라서 결과가 바뀌기 때문에 
-- 위치를 잘 지정을 해야되고 ROWNUM을 조회하는 SELECT 구문에서는 <, <=로만 비교가 가능하다.
-- ROWNUM를 조회하는 SELECT 구문을 서브쿼리로 묶어서 사용하면 >, >=도 비교할 수 있다.
SELECT B.*
	FROM (
		SELECT ROWNUM AS RN
			 , A.MAJOR
			 , A.AVG_RES
			FROM (
				SELECT ST.MAJOR
					 , AVG(SC.RESULT) AS AVG_RES
					FROM STUDENT ST
					JOIN SCORE SC
					  ON ST.SNO = SC.SNO 
					GROUP BY ST.MAJOR
					ORDER BY AVG_RES DESC
			) A
	) B
	WHERE B.RN > 3;

-- 1-4. SEQUENCE: 유일한 값을 만들어서 제공해주는 객체. 주로 PK, UK랑 함께 사용된다.
-- SEQUENCE를 사용할 테이블 생성
CREATE TABLE EMP_COPY1(
	ENO NUMBER,
	ENAME VARCHAR2(20),
	JOB VARCHAR2(10),
	MGR NUMBER,
	HDATE DATE,
	SAL NUMBER(5, 0),
	COMM NUMBER(5, 0),
	DNO NUMBER
);

CREATE TABLE DEPT_COPY2 (
	DNO NUMBER,
	DNAME VARCHAR2(10),
	LOC VARCHAR2(10),
	DIRECTOR NUMBER
);

-- SEQUENCE 생성
-- 옵션이 추가된 SEQUENCE 생성
CREATE SEQUENCE EMP_CO_ENO_SEQ1
	START WITH 1
	INCREMENT BY 2
	MAXVALUE 10
	NOMINVALUE
	CYCLE 
	NOCACHE;

-- 옵션이 없는 SEQUENCE 생성
CREATE SEQUENCE DEPT_CO_DNO_SEQ;

-- SEQUENCE의 사용
-- 시퀀스명.NEXTVAL, 시퀀스명.CURRVAL
-- NEXTVAL: 새로운 값을 할당
INSERT INTO EMP_COPY1
VALUES (EMP_CO_ENO_SEQ1.NEXTVAL, '고기천', '개발', 0, SYSDATE, 3000, 100, 0);
COMMIT;

INSERT INTO EMP_COPY1
VALUES (EMP_CO_ENO_SEQ1.NEXTVAL, '홍길동', '개발', 0, SYSDATE, 3300, 100, 0);
COMMIT;

SELECT *
	FROM EMP_COPY1;

-- CURRVAL: 직전에 사용했던 시퀀스 값을 재사용
INSERT INTO EMP_COPY1
VALUES (EMP_CO_ENO_SEQ1.CURRVAL, '장길산', '개발', 0, SYSDATE, 3500, 100, 0);
COMMIT;

-- 옵션이 없는 SEQUENCE의 사용
INSERT INTO DEPT_COPY2
VALUES (DEPT_CO_DNO_SEQ.NEXTVAL, '개발', '서울', 0);
INSERT INTO DEPT_COPY2
VALUES (DEPT_CO_DNO_SEQ.NEXTVAL, '경영', '서울', 0);
INSERT INTO DEPT_COPY2
VALUES (DEPT_CO_DNO_SEQ.NEXTVAL, '회계', '서울', 0);
INSERT INTO DEPT_COPY2
VALUES (DEPT_CO_DNO_SEQ.NEXTVAL, '총무', '서울', 0);
INSERT INTO DEPT_COPY2
VALUES (DEPT_CO_DNO_SEQ.NEXTVAL, '인사', '서울', 0);
COMMIT;

SELECT *
	FROM DEPT_COPY2;

-- 생성된 시퀀스 조회 쿼리
SELECT SEQUENCE_NAME
	 , MAX_VALUE 
	 , MIN_VALUE 
	 , INCREMENT_BY 
	 , CACHE_SIZE 
	 , LAST_NUMBER 
	 , CYCLE_FLAG
	FROM USER_SEQUENCES;

-- CURRVAL은 주로 현재 어디까지 값이 할당됐는지 확인할 때 사용
SELECT DEPT_CO_DNO_SEQ.CURRVAL
	FROM DUAL;

-- NEXTVAL은 새로운 값을 할당받아서 값을 저장할 때 주로 사용
-- NEXTVAL이 호출되면 시퀀스는 무조건 새로운 값을 가리킨다.
SELECT DEPT_CO_DNO_SEQ.NEXTVAL
	FROM DUAL;

-- 시퀀스의 수정
-- 시퀀스는 모든 옵션을 수정할 수 있지만 시작 값은 수정하지 못한다.
ALTER SEQUENCE DEPT_CO_DNO_SEQ
	INCREMENT BY 5
	MAXVALUE 100
	CYCLE;

-- 시퀀스의 삭제
DROP SEQUENCE DEPT_CO_DNO_SEQ;

-- 1-5. SYNONYM: 오라클 객체에 별칭을 달아주는 객체
-- 현재 접속한 사용자에게 계속 사용할 수 있는 동의어 생성
CREATE SYNONYM DC
	FOR DEPT_COPY2;

SELECT *
	FROM DC;

-- PUBLIC 키워드를 사용하면 오라클에 생성된 모든 유저에게 계속 사용할 수 있는 동의어 생성
CREATE PUBLIC SYNONYM EC
	FOR C##STUDY1.EMP_COPY1;

SELECT *
	FROM EC;

-- BORAD_MAIN --- 게시판 관련 테이블 생성
-- BOARD_APP --- 게시판 DB 운영계정
-- BORAD_MAIN에 존재하는 테이블들을 SYNONYM을 통해서 BOARD_APP에서 사용할 수 있는 동의어를 생성해서
-- 개발자들은 BOARD_APP 계정을 통해서 DB 접근할 수 있도록 한다. 
-- (SELECT, INSERT, DELETE, UPDATE 권한만 줘서 사용)
-- SYNONYM 삭제
DROP SYNONYM DC;

-- PUBLIC SYNONYM 삭제
DROP PUBLIC SYNONYM EC;