--1) 화학과 학생을 검색하라
SELECT *
	FROM STUDENT
	WHERE MAJOR = '화학';

--2) 평점이 2.0 미만인 학생을 검색하라
SELECT *
	FROM STUDENT
	WHERE AVR < 2.0;

--3) 관우 학생의 평점을 검색하라
SELECT AVR AS "관우 학생의 평점"
	FROM STUDENT
	WHERE SNAME = '관우';

--4) 정교수 명단을 검색하라
SELECT PNAME AS "정교수 명단"
	FROM PROFESSOR
	WHERE ORDERS = '정교수';

--5) 화학과 소속 교수의 명단을 검색하라
SELECT PNAME AS "화학과 소속 교수 명단"
	FROM PROFESSOR
	WHERE SECTION = '화학';

--6) 송강 교수의 정보를 검색하라
SELECT *
	FROM PROFESSOR
	WHERE PNAME = '송강';

--7) 학년별로 화학과 학생의 성적을 검색하라
SELECT SYEAR
	 , SNAME
	 , AVR
	FROM STUDENT
	WHERE MAJOR = '화학'
	ORDER BY SYEAR;

--8) 2000년 이전에 부임한 교수의 정보를 부임일순으로 검색하라
SELECT *
	FROM PROFESSOR
	WHERE HIREDATE < TO_DATE('2000-01-01:00:00:00', 'YYYY-MM-DD:HH24:MI:SS')
	ORDER BY HIREDATE ASC;


--9) 담당 교수가 없는 과목의 정보를 검색하라
SELECT *
	FROM COURSE
	WHERE PNO IS NULL;






