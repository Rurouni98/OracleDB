--1) STUDENT 테이블을 참조하여 ST_TEMP 테이블을 만들고 모든 학생의 성적을 4.5만점 기준으로 수정하세요
CREATE TABLE ST_TEMP2
    AS SELECT * FROM STUDENT;
    
UPDATE ST_TEMP2
    SET
        AVR = AVR * 4.5 / 4.0;
    
SELECT *
    FROM ST_TEMP2;

--2) PROFESSOR 테이블을 참조하여 PF_TEMP 테이블을 만들고 모든 교수의 부임일자를 100일 앞으로 수정하세요
CREATE TABLE PF_TEMP2
    AS SELECT * FROM PROFESSOR;
    
UPDATE PF_TEMP2
    SET
        HIREDATE = HIREDATE - 100;
    
SELECT *
    FROM PF_TEMP2;
    
--3) ST_TEMP 테이블에서 화학과 2학년 학생의 정보를 삭제하세요
DELETE FROM ST_TEMP2
    WHERE MAJOR = '화학'
      AND SYEAR = 2;

--4) PF_TEMP 테이블에서 조교수의 정보를 삭제하세요
DELETE FROM PF_TEMP2
    WHERE  ORDERS = '조교수';

--5) EMP 테이블을 참조하여 EMP2 테이블을 만들고 
-- DNO = 30인 사원의 보너스를 15프로 상승시킨 값으로 변경하시고
-- DNO = 10인 사원의 보너스를 5프로 상승시킨 값으로 변경, 
-- DNO = 20인 사원의 급여를 10프로 상승시킨 값으로 변경하세요.
CREATE TABLE EMP4
    AS SELECT * FROM EMP;
    
UPDATE EMP4
    SET
        COMM = DECODE(DNO, '30', COMM * 1.15, '10', COMM * 1.05, COMM); 

UPDATE EMP4
    SET
        SAL = SAL * 1.1
    WHERE DNO = '20';

SELECT *
    FROM EMP4;

--6) 화학과 2학년 학생중 기말고사 성적의 등급이 A, B인 정보를 갖는 테이블 SCORE_STGR을 생성하세요.
--(SNO, SNAME, MAJOR, SYEAR, RESULT, CNO, CNAME, GRADE)
CREATE TABLE SCORE_STGR2
    AS SELECT SNO
            , ST.SNAME
            , ST.MAJOR
            , ST.SYEAR
            , SC.CNO
            , C.CNAME
            , SC.RESULT
            , SG.GRADE
           FROM STUDENT ST
           NATURAL JOIN SCORE SC
           JOIN COURSE C
             ON SC.CNO = C.CNO
           JOIN SCGRADE SG
           ON SC.RESULT BETWEEN SG.LOSCORE AND SG.HISCORE
           WHERE SG.GRADE IN ('A', 'B');

SELECT *
    FROM SCORE_STGR2;

--7) 생물학과 학생중 평점이 2.7이상인 학생이 수강중인 과목의 정보를 갖는 테이블 ST_COURSEPF를 생성하세요. 
--(SNO, SNAME, CNO, CNAME, PNO, PNAME, RESULT, AVR)
CREATE TABLE ST_COURSEPF2
    AS SELECT SNO
            , ST.SNAME
            , CNO
            , C.CNAME
            , PNO
            , P.PNAME
            , SC.RESULT
            , ST.AVR
           FROM STUDENT ST
           NATURAL JOIN SCORE SC
           NATURAL JOIN COURSE C
           NATURAL JOIN PROFESSOR P
           WHERE ST.MAJOR = '생물'
             AND ST.AVR >= 2.7;
             
SELECT *
    FROM ST_COURSEPF2;