--1) 과목번호, 과목이름, 과목별 평균 기말고사 성적을 갖는 레코드의 배열을 만들고
--   기본 LOOP문을 이용해서 모든 과목의 과목번호, 과목이름, 과목별 평균 기말고사 성적을 출력하세요.
DECLARE
    CURSOR CO_SCO_CUR IS
        SELECT C.CNO
             , C.CNAME
             , ROUND(AVG(SC.RESULT), 2)
            FROM COURSE C
            JOIN SCORE SC
            ON C.CNO = SC.CNO
            GROUP BY C.CNO, C.CNAME;

    TYPE CO_SCO_REC IS RECORD(
        CNO COURSE.CNO%TYPE,
        CNAME COURSE.CNAME%TYPE,
        AVG_RES NUMBER
    );

    TYPE CO_SCO_REC_ARR IS TABLE OF CO_SCO_REC
    INDEX BY PLS_INTEGER;

    COSCORECARR CO_SCO_REC_ARR;
    IDX NUMBER := 1;
BEGIN
    OPEN CO_SCO_CUR;
    
    LOOP
        FETCH CO_SCO_CUR INTO COSCORECARR(IDX);

        EXIT WHEN CO_SCO_CUR%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(COSCORECARR(IDX).CNO);
        DBMS_OUTPUT.PUT_LINE(COSCORECARR(IDX).CNAME);
        DBMS_OUTPUT.PUT_LINE(COSCORECARR(IDX).AVG_RES);

        IDX := IDX + 1;
    END LOOP;
END;
/

--2) 학생번호, 학생이름과 학생별 평균 기말고사 성적을 갖는 테이블 T_STAVGSC를 만들고
--   커서를 이용하여 학생번호, 학생이름, 학생별 평균 기말고사 성적을 조회하고 
--   조회된 데이터를 생성한 테이블인 T_STAVGSC에 저장하세요.
DECLARE
    CURSOR ST_RES_CUR IS
        SELECT ST.SNO
             , ST.SNAME
             , ROUND(AVG(SC.RESULT), 2)
            FROM STUDENT ST
            JOIN SCORE SC
            ON ST.SNO = SC.SNO
            GROUP BY ST.SNO, ST.SNAME;
    
    TYPE ST_RES_RES IS RECORD(
        SNO STUDENT.SNO%TYPE,
        SNAME STUDENT.SNAME%TYPE,
        AVG_RES NUMBER(5, 2)
    );

    STRESREC ST_RES_RES;
BEGIN
    OPEN ST_RES_CUR;
    
    LOOP
        FETCH ST_RES_CUR INTO STRESREC;
        
        EXIT WHEN ST_RES_CUR%NOTFOUND;
        
        INSERT INTO T_STAVGSC
        VALUES STRESREC;
        
    END LOOP;
    
    CLOSE ST_RES_CUR;
END;
/