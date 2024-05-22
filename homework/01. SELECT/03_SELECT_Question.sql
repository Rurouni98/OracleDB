--1) '__학과인 __학생의 현재 평점은 __입니다' 형태로 학생의 정보를 출력하라
SELECT MAJOR || '학과인 ' || SNAME || ' 학생의 현재 평점은' || AVR || '입니다'
	FROM STUDENT;

--2) '__과목은 __학점 과목입니다.' 형태로 과목의 정보를 출력하라
SELECT CNAME || ' 과목은 ' || ST_NUM || '학점 과목입니다.'
	FROM COURSE;

--3) '__교수는 __학과 소속입니다.' 형태로 교수의 정보를 출력하라
SELECT PNAME || ' 교수는 ' || SECTION || '학과 소속입니다.'
	FROM PROFESSOR;

--4) 학교에는 어떤 학과가 있는지 검색한다(학생 테이블 기반으로 검색한다)
--학과 대신 수업명 해버림
SELECT DISTINCT CS.CNAME
	FROM STUDENT ST
	JOIN SCORE SC
	  ON ST.SNO = SC.SNO
	JOIN COURSE CS
	  ON SC.CNO = CS.CNO;

--5) 학교에는 어떤 학과가 있는지 검색한다(교수 테이블 기반으로 검색한다)
--학과 대신 수업명 해버림
SELECT DISTINCT CS.CNAME
	FROM PROFESSOR PF
	JOIN COURSE CS
	  ON PF.PNO = CS.PNO;

--6) 교수의 지위는 어떤 것들이 있는지 검색한다
SELECT DISTINCT ORDERS
	FROM PROFESSOR;







