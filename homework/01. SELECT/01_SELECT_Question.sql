--1) 모든 학생의 정보를 검색해라
SELECT *
	FROM STUDENT;

--2) 모든 과목의 정보를 검색해라
SELECT *
	FROM COURSE;

--3) 기말고사 시험점수를 검색해라
SELECT RESULT
	FROM SCORE;

--4) 학생들의 학과와 학년을 검색해라
SELECT MAJOR
	 , SYEAR
	FROM STUDENT;

--5) 각 과목의 이름과 학점을 검색해라
SELECT CNO
	 , ST_NUM
	FROM COURSE;

--6) 모든 교수의 직위를 검색해라
SELECT DISTINCT ORDERS
	FROM PROFESSOR;
