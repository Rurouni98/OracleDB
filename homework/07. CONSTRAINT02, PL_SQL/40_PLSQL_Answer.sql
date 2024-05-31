--1) 과목번호, 과목이름, 교수번호, 교수이름을 담을 수 있는 변수들을 선언하고 
--   유기화학 과목의 과목번호, 과목이름, 교수번호, 교수이름을 출력하세요.
DECLARE
    CNO VARCHAR2(8);
    CNAME VARCHAR2(20);
    PNO VARCHAR2(8);
    PNAME VARCHAR2(20);
BEGIN
    SELECT C.CNO
         , C.CNAME
         , C.PNO
         , P.PNAME
        INTO CNO
           , CNAME
           , PNO
           , PNAME
        FROM COURSE C
        JOIN PROFESSOR P
        ON C.PNO = P.PNO
        WHERE C.CNO = '1212';
        
    DBMS_OUTPUT.PUT_LINE(CNO);
    DBMS_OUTPUT.PUT_LINE(CNAME);
    DBMS_OUTPUT.PUT_LINE(PNO);
    DBMS_OUTPUT.PUT_LINE(PNAME);
END;

--2) 위 데이터들을 레코드로 선언하고 출력하세요.
DECLARE
    TYPE CO_PRO_REC IS RECORD(
        CNO VARCHAR2(8),
        CNAME VARCHAR2(20),
        PNO VARCHAR2(8),
        PNAME VARCHAR2(20)
    );
    
    COPROREC CO_PRO_REC;
BEGIN
    SELECT C.CNO
         , C.CNAME
         , C.PNO
         , P.PNAME
        INTO COPROREC.CNO
           , COPROREC.CNAME
           , COPROREC.PNO
           , COPROREC.PNAME
        FROM COURSE C
        JOIN PROFESSOR P
        ON C.PNO = P.PNO
        WHERE C.CNO = '1212';
        
    DBMS_OUTPUT.PUT_LINE(COPROREC.CNO);
    DBMS_OUTPUT.PUT_LINE(COPROREC.CNAME);
    DBMS_OUTPUT.PUT_LINE(COPROREC.PNO);
    DBMS_OUTPUT.PUT_LINE(COPROREC.PNAME);
END;