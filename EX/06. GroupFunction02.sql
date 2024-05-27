-- 1. 그룹화 관련 함수
-- 1-1. ROLLUP
-- 처음에는 GROUP BY에 지정된 모든 컬럼으로 그룹화된 결과를 보여주고
-- 다음부터는 마지막에 지정된 컬럼을 하나씩 뺀 그룹화된 결과를 보여주다가
-- 마지막에는 그룹화되지 않은 전체 데이터에 대한 결과를 보여준다.
-- ROLLUP을 사용하지 않았을 때
SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO, JOB;
	
-- ROLLUP 사용 시
SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY ROLLUP(DNO, JOB);
	
SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO, JOB;
	
SELECT DNO
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO;
	
SELECT MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP;
	
-- ROLLUP 함수를 이용해서 전공별 학년별 평점의 평균, 평점의 총합, 최고 평점 조회
-- 전공별 평점의 평균, 평점의 총합, 최고 평점 조회
-- 전체 학생에 대한 평점의 평균, 평점의 총합, 최고 평점 조회
SELECT MAJOR
	 , SYEAR
	 , AVG(AVR)
	 , SUM(AVR)
	 , MAX(AVR)
	 , COUNT(*)
	FROM STUDENT
	GROUP BY ROLLUP(MAJOR, SYEAR);
	
-- 1-2. CUBE
-- ROLLUP 함수와 지정방식은 동일하지만 동작 방식이 다르다.
-- ROLLUP 함수가 GROUP BY에 지정된 컬럼을 뒤에서부터 하나씩 빼면서 그룹화를 진행한다면
-- CUBE 함수는 GROUP BY에 지정된 컬럼의 모든 조합에 대한 그룹화를 진행한다.
-- ROLLUP 사용 시
SELECT MAJOR
	 , SYEAR
	 , SEX
	 , AVG(AVR)
	 , SUM(AVR)
	 , MAX(AVR)
	 , COUNT(*)
	FROM STUDENT
	GROUP BY ROLLUP(MAJOR, SYEAR, SEX);

-- CUBE 사용 시
SELECT MAJOR
	 , SYEAR
	 , SEX
	 , AVG(AVR)
	 , SUM(AVR)
	 , MAX(AVR)
	 , COUNT(*)
	FROM STUDENT
	GROUP BY CUBE(MAJOR, SYEAR, SEX);

-- 1-3. GROUPING SETS: GROUP BY에 지정된 컬럼들의 각각 그룹화된 결과를 보여준다.
SELECT DNO
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO
UNION
SELECT JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY JOB;

SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY GROUPING SETS(DNO, JOB);

-- 1-4. GROUPING, GROUPING_ID
-- 지정된 컬럼에 대한 그룹화여부를 확인하는 함수
-- GROUPING 함수는 매개변수를 하나만 지정할 수 있고
-- GROUPING_ID 함수는 매개변수를 여러개의 컬럼을 지정할 수 있다.
-- GROUPING 함수는 그룹화가 진행됐으면 0, 그룹화가 진행되지 않았으면 1
-- GROUPING_ID 함수는 지정된 컬럼들 각각에 대해 그룹화가 진행됐으면 0, 그룹화가 진행되지 않았으면 1
-- 을 이진수로 조합하여 출력은 십진수로 변환해서 출력한다.
-- GROUPING(DNO), GROUPING(JOB), GROUPING_ID(DNO, JOB)
--      0             0           이진수: 00 -> 십진수: 0
--      1             0           이진수: 10 -> 십진수: 2
--      0             1           이진수: 01 -> 십진수: 1
--      1             1           이진수: 11 -> 십진수: 3
SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	 , GROUPING(DNO)
	 , GROUPING(JOB)
	 , GROUPING_ID(DNO, JOB)
	FROM EMP
	GROUP BY CUBE(DNO, JOB);
	
-- CUBE 함수를 이용해서
-- 전공별 학년별 성별별 최고 평점, 평점의 합계, 평점의 평균, 학생수 조회
-- 전공별 학년별 최고 평점, 평점의 합계, 평점의 평균, 학생수 조회
-- 전공별 성별별 최고 평점, 평점의 합계, 평점의 평균, 학생수 조회
-- 학년별 성별별 최고 평점, 평점의 합계, 평점의 평균, 학생수 조회
-- 전공별 최고 평점, 평점의 합계, 평점의 평균, 학생수 조회
-- 학년별 최고 평점, 평점의 합계, 평점의 평균, 학생수 조회
-- 성별별 최고 평점, 평점의 합계, 평점의 평균, 학생수 조회
-- 전체 데이터에 대한 최고 평점, 평점의 합계, 평점의 평균, 학생수 조회하는 데 
-- 각각의 전공, 학년, 성별 컬럼이 그룹화 됐는지 확인
SELECT MAJOR
	 , SYEAR
	 , SEX
	 , MAX(AVR)
	 , SUM(AVR)
	 , AVG(AVR)
	 , COUNT(*)
	 , GROUPING(MAJOR)
	 , GROUPING(SYEAR)
	 , GROUPING(SEX)
	 , GROUPING_ID(MAJOR, SYEAR, SEX)
	FROM STUDENT
	GROUP BY CUBE(MAJOR, SYEAR, SEX);

-- 1-5. LISTAGG: 그룹화된 컬럼에 포함되는 데이터를 확인하고 싶을 때 사용하는 함수
SELECT DNO
	 , COUNT(*)
	 , LISTAGG(ENAME, ', ')
	    WITHIN GROUP(ORDER BY SAL DESC)
	FROM EMP 
	GROUP BY DNO;

-- 전공별 학년별 학생수 조회(포함된 학생이름도 함께 조회(LISTAGG함수를 사용해서), 평점높은순으로 정렬)
SELECT MAJOR
	 , SYEAR
	 , COUNT(*)
	 , LISTAGG(SNAME, ', ')
	 	WITHIN GROUP(ORDER BY AVR DESC)
	FROM STUDENT
	GROUP BY MAJOR, SYEAR;

-- LISTAGG의 구분자와 WITHIN절은 생략가능하다
SELECT MAJOR
	 , SYEAR
	 , COUNT(*)
	 , LISTAGG(SNAME)
	FROM STUDENT
	GROUP BY MAJOR, SYEAR;

-- 1-6. PIVOT, UNPIVOT
-- PIVOT: 기존 행 데이터들을 컬럼으로 변경해주는 함수
-- UNPIVOT: 기존 컬럼들을 행 데이터로 변경해주는 함수
SELECT *
	FROM (
			SELECT JOB
				 , SAL
				FROM EMP
		 )
		 PIVOT(
		 	MAX(SAL)
		 		FOR JOB IN(
		 			'경영' AS "OPER",
		 			'지원' AS "지원",
		 			'회계' AS "ACCOUNT",
		 			'개발' AS "DEVELOP",
		 			'분석' AS "분석"
		 		)
		 );

-- PIVOT은 FROM절에서 그룹화할 컬럼, 통계낼 컬럼만 조회하는 서브쿼리를 사용해야된다.
SELECT *
	FROM EMP
	PIVOT(
		MAX(SAL)
			FOR JOB IN (
				'경영' AS "OPER",
	 			'지원' AS "지원",
	 			'회계' AS "ACCOUNT",
	 			'개발' AS "DEVELOP",
	 			'분석' AS "분석"
			)
	);

SELECT *
	FROM (
			SELECT JOB
				 , SAL
				FROM EMP
		 )
		 -- 통계함수를 사용하는 데 GROUP BY를 사용하지 않는 이유는
		 -- 데이터들이 컬럼으로 변경되면서 컬럼은 중복되지 않기 때문에
		 -- 같은 값을 가지고 있는 데이터끼리 그룹화가 자동으로 일어난다.
		 PIVOT(
		 	MAX(SAL)
		 		FOR JOB IN(
		 			'경영' AS "OPER",
		 			'지원' AS "지원",
		 			'회계' AS "ACCOUNT",
		 			'개발' AS "DEVELOP",
		 			'분석' AS "분석"
		 		)
		 );

-- PIVOT으로 생성한 컬럼들은 SELECT 문에서 바로 사용가능
SELECT OPER
	 , 지원
	 , ACCOUNT
	 , DEVELOP
	 , 분석
	FROM (
			SELECT JOB
				 , SAL
				FROM EMP
		 )
		 PIVOT(
		 	MAX(SAL)
		 		FOR JOB IN(
		 			'경영' AS "OPER",
		 			'지원' AS "지원",
		 			'회계' AS "ACCOUNT",
		 			'개발' AS "DEVELOP",
		 			'분석' AS "분석"
		 		)
		 );
		
-- 전공별 학년별 최고 평점 조회하는데 PIVOT을 이용해서 전공을 컬럼으로 조회
SELECT *
	FROM (
		SELECT MAJOR
			 , SYEAR
			 , AVR
			FROM STUDENT
	)
	PIVOT(
		MAX(AVR)
			FOR MAJOR IN (
				'화학' AS "화학",
				'생물' AS "생물",
				'물리' AS "물리",
				'유공' AS "유공",
				'식영' AS "식영",
				'컴공' AS "컴공"
			)
	);

-- UNPIVOT
SELECT *
	FROM (
		SELECT MAX(DECODE(JOB, '경영', SAL)) AS "경영"
			 , MAX(DECODE(JOB, '지원', SAL)) AS "지원"
			 , MAX(DECODE(JOB, '회계', SAL)) AS "회계"
			 , MAX(DECODE(JOB, '개발', SAL)) AS "개발"
			 , MAX(DECODE(JOB, '분석', SAL)) AS "분석"
			FROM EMP
	);

SELECT *
	FROM (
		SELECT MAX(DECODE(JOB, '경영', SAL)) AS "경영"
			 , MAX(DECODE(JOB, '지원', SAL)) AS "지원"
			 , MAX(DECODE(JOB, '회계', SAL)) AS "회계"
			 , MAX(DECODE(JOB, '개발', SAL)) AS "개발"
			 , MAX(DECODE(JOB, '분석', SAL)) AS "분석"
			FROM EMP
	)
	UNPIVOT (
		MAX_SAL FOR J IN (
			경영, 지원, 회계, 개발, 분석
		)
	);

-- 정역학, 일반화학, 양자물리학의 기말고사 성적의 평균을 조회하는 데 과목이름을 컬럼으로 조회
SELECT *
	FROM (
		SELECT C.CNAME
			 , SC.RESULT
			FROM COURSE C
			JOIN SCORE SC
			  ON C.CNO = SC.CNO
	)
	PIVOT(
		AVG(RESULT)
			FOR CNAME IN (
				'정역학' AS "정역학",
				'일반화학' AS "일반화학",
				'양자물리학' AS "양자물리학"
			)
	);

-- 아래의 쿼리문을 UNPIVOT을 이용해서 각 과목이름을 행데이터로 조회
-- 기말고사 평균성적 컬럼은 AVG_RESULT
-- 과목이름은 COURSE_NAME으로 지정
SELECT *
	FROM (
		SELECT AVG(DECODE(C.CNAME, '정역학', SC.RESULT)) AS "정역학"
			 , AVG(DECODE(C.CNAME, '일반화학', SC.RESULT)) AS "일반화학"
			 , AVG(DECODE(C.CNAME, '양자물리학', SC.RESULT)) AS "양자물리학"
			FROM COURSE C
			JOIN SCORE SC
			  ON C.CNO = SC.CNO
	);
	
SELECT *
	FROM (
		SELECT AVG(DECODE(C.CNAME, '정역학', SC.RESULT)) AS "정역학"
			 , AVG(DECODE(C.CNAME, '일반화학', SC.RESULT)) AS "일반화학"
			 , AVG(DECODE(C.CNAME, '양자물리학', SC.RESULT)) AS "양자물리학"
			FROM COURSE C
			JOIN SCORE SC
			  ON C.CNO = SC.CNO
	)
	UNPIVOT (
		AVG_RESULT FOR COURSE_NAME IN (
			정역학, 일반화학, 양자물리학
		)
	);