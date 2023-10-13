-- 스크립트 실행하면 됨
-- 주의: 반드시 DELIVERY_TEST 계정에서 실행할 것

/* ---------------------------- 테이블 생성 ------------------------------ */
-- 유저 테이블
CREATE TABLE USER_CODE(
	U_CODE NUMBER(1) CONSTRAINT UC_UCODE_PK PRIMARY KEY,
	U_CNAME VARCHAR2(30) CONSTRAINT UC_CNAME_UNQNN UNIQUE NOT NULL
);

CREATE TABLE USER_INFO(
	U_ID VARCHAR2(20) CONSTRAINT UI_UID_PK PRIMARY KEY,
	U_PW VARCHAR2(1000) CONSTRAINT UI_PW_NN NOT NULL,
	U_RNAME VARCHAR2(12) CONSTRAINT UI_RNAME_NN NOT NULL,
	U_PHONE VARCHAR2(11) CONSTRAINT UI_PN_UNQNN UNIQUE NOT NULL,
	U_NNAME VARCHAR2(30),
	U_CODE NUMBER(1) CONSTRAINT UI_CODE_FKNN NOT NULL REFERENCES USER_CODE(U_CODE),
	U_REGDATE DATE DEFAULT SYSDATE,
	U_IMG VARCHAR2(1000)
);

CREATE TABLE USER_ADDR(
	U_ID VARCHAR2(20) CONSTRAINT UA_UID_FK REFERENCES USER_INFO(U_ID),
	U_ATAG VARCHAR2(30),
	U_ADDR VARCHAR2(1000),
	CONSTRAINT UA_UID_ATAG_PK PRIMARY KEY(U_ID, U_ATAG)
);

--CREATE TABLE USER_FAV(
--	U_ID VARCHAR2(20) CONSTRAINT UF_UID_FKNN NOT NULL REFERENCES USER_INFO(U_ID),
--	R_ID NUMBER CONSTRAINT UF_RID_FKNN NOT NULL REFERENCES REST_INFO(R_ID)
--);
-- R_ID 칼럼이 있는 REST_INFO 테이블이 아래에서 생성되기 때문에 나중에 테이블 생성



-- 가게 테이블
CREATE TABLE CAT_CODE(
	C_CODE NUMBER(2) CONSTRAINT CC_CCODE_PK PRIMARY KEY,
	C_CNAME VARCHAR2(30) CONSTRAINT CC_CCNAME_UNQNN UNIQUE NOT NULL
);

CREATE TABLE PAY_CODE(
	P_CODE NUMBER(2) CONSTRAINT PC_PCODE_PK PRIMARY KEY,
	P_CNAME VARCHAR2(30) CONSTRAINT PC_PCNAME_UNQNN UNIQUE NOT NULL
);

CREATE TABLE FRAN_CODE(
	F_CODE NUMBER CONSTRAINT FC_FCODE_PK PRIMARY KEY,
	F_CNAME VARCHAR2(30) CONSTRAINT FC_FCNAME_UNQNN UNIQUE NOT NULL
);

CREATE TABLE WEEK_CODE(
	W_CODE NUMBER(1) CONSTRAINT WC_WCODE_PK PRIMARY KEY,
	W_CNAME VARCHAR2(3) CONSTRAINT WC_WCNAME_UNQNN UNIQUE NOT NULL
);

CREATE TABLE REST_INFO(
	R_ID NUMBER,
	R_LICNUM VARCHAR2(10),
	U_ID VARCHAR2(20) CONSTRAINT RI_UID_FKNN NOT NULL REFERENCES USER_INFO(U_ID),
	R_LNAME VARCHAR2(100) CONSTRAINT RI_LNAME_UNQNN UNIQUE NOT NULL,
	R_ADDR VARCHAR2(1000) CONSTRAINT RI_ADDR_NN NOT NULL,
	R_BNAME VARCHAR2(100),
	R_TEL VARCHAR2(10) CONSTRAINT RI_TEL_UNQNN UNIQUE NOT NULL,
	F_CODE NUMBER CONSTRAINT RI_FCODE_FK REFERENCES FRAN_CODE(F_CODE),
	R_INTRO VARCHAR2(1000),
	R_MINPRICE NUMBER,
	R_IMG VARCHAR2(1000),
	CONSTRAINT RI_RID_LICNUM_PK PRIMARY KEY(R_ID, R_LICNUM),
	CONSTRAINT RI_RID_UNQ UNIQUE(R_ID)
);

CREATE TABLE REST_CAT(
	R_ID NUMBER CONSTRAINT RC_RID_FK REFERENCES REST_INFO(R_ID),
	C_CODE NUMBER(2) CONSTRAINT RC_CCODE_FK REFERENCES CAT_CODE(C_CODE),
	CONSTRAINT RC_RID_CCODE_PK PRIMARY KEY(R_ID, C_CODE)
);

CREATE TABLE REST_OPEN(
	R_ID NUMBER CONSTRAINT RO_RID_FKNN NOT NULL REFERENCES REST_INFO(R_ID),
	W_CODE NUMBER(1) CONSTRAINT RO_WCODE_FKNN NOT NULL REFERENCES WEEK_CODE(W_CODE),
	R_OPENT DATE,
	R_CLOSET DATE
);

CREATE TABLE USER_FAV(
	U_ID VARCHAR2(20) CONSTRAINT UF_UID_FKNN NOT NULL REFERENCES USER_INFO(U_ID),
	R_ID NUMBER CONSTRAINT UF_RID_FKNN NOT NULL REFERENCES REST_INFO(R_ID)
);

CREATE TABLE PAY_METHOD(
	P_CODE NUMBER(1) CONSTRAINT PM_PCODE_FK REFERENCES PAY_CODE(P_CODE),
	R_ID NUMBER CONSTRAINT PM_RID_FK REFERENCES REST_INFO(R_ID),
	CONSTRAINT PM_PCODE_RID_PK PRIMARY KEY(P_CODE, R_ID)
);



-- 메뉴 테이블
CREATE TABLE MENU_CODE(
	M_CODE NUMBER(1) CONSTRAINT MC_MCODE_PK PRIMARY KEY,
	M_CNAME VARCHAR2(30) CONSTRAINT MC_MCNAME_UNQNN UNIQUE NOT NULL
);

CREATE TABLE MENU_INFO(
	M_ID NUMBER CONSTRAINT MI_MID_PK PRIMARY KEY,
	R_ID NUMBER CONSTRAINT MI_RID_FKNN NOT NULL REFERENCES REST_INFO(R_ID),
	M_NAME VARCHAR2(100) CONSTRAINT MI_MNAME_NN NOT NULL,
	M_PRICE NUMBER CONSTRAINT MI_MPRICE_NN NOT NULL,
	M_CAT VARCHAR2(100),
	M_INTRO VARCHAR2(1000),
	M_CODE NUMBER(1) CONSTRAINT MI_MCODE_FKNN NOT NULL REFERENCES MENU_CODE(M_CODE),
	M_IMG VARCHAR2(1000)
);

CREATE TABLE MENU_ADD(
	A_ID NUMBER CONSTRAINT MO_OID_PK PRIMARY KEY,
	M_ID NUMBER CONSTRAINT MO_MID_FKNN NOT NULL REFERENCES MENU_INFO(M_ID),
	A_NAME VARCHAR2(100) CONSTRAINT MO_ONAME_NN NOT NULL,
	A_PRICE NUMBER CONSTRAINT MO_OPRICE_NN NOT NULL
);



-- 주문 테이블
CREATE TABLE TYPE_CODE(
	T_CODE NUMBER(1) CONSTRAINT TC_TCODE_PK PRIMARY KEY,
	T_CNAME VARCHAR2(30) CONSTRAINT TC_TCNAME_UNQNN UNIQUE NOT NULL
);

CREATE TABLE STAT_CODE(
	S_CODE NUMBER(1) CONSTRAINT SC_SCODE_PK PRIMARY KEY,
	S_CNAME VARCHAR2(30) CONSTRAINT SC_SCNAME_UNQNN UNIQUE NOT NULL
);

CREATE TABLE ORDER_INFO(
	O_NUM NUMBER CONSTRAINT OI_ONUM_PK PRIMARY KEY,
	R_ID NUMBER CONSTRAINT OI_RID_FKNN NOT NULL REFERENCES REST_INFO(R_ID),
	U_ID VARCHAR2(20) CONSTRAINT OI_UID_FKNN NOT NULL REFERENCES USER_INFO(U_ID),
	O_ADDR VARCHAR2(1000) CONSTRAINT OI_ADDR_NN NOT NULL,
	O_DATE DATE DEFAULT SYSDATE,
	T_CODE NUMBER(1) CONSTRAINT OI_TCODE_FKNN NOT NULL REFERENCES TYPE_CODE(T_CODE),
	S_CODE NUMBER(1) CONSTRAINT OI_SCODE_FKNN NOT NULL REFERENCES STAT_CODE(S_CODE),
	O_REQ VARCHAR2(1000)
);

CREATE TABLE ORDER_MENU(
	O_NUM NUMBER CONSTRAINT OM_ONUM_FK REFERENCES ORDER_INFO(O_NUM),
	M_ID NUMBER CONSTRAINT OM_MID_FK REFERENCES MENU_INFO(M_ID),
	M_NUM NUMBER CONSTRAINT OM_MNUM_NN NOT NULL,
	M_TPRICE NUMBER CONSTRAINT OM_TPRICE_NN NOT NULL,
	CONSTRAINT OM_ONUM_MID_PK PRIMARY KEY(O_NUM, M_ID)
);



-- 리뷰 테이블
CREATE TABLE REVIEW_INFO(
	O_NUM NUMBER CONSTRAINT RV_ONUM_FKNN REFERENCES ORDER_INFO(O_NUM),
	R_CONTENT VARCHAR2(4000),
	R_SCORE NUMBER(2,1) CONSTRAINT RV_RSCORE_NN NOT NULL,
	R_WRIDATE DATE DEFAULT SYSDATE,
	CONSTRAINT RV_ONUM_PK PRIMARY KEY(O_NUM)
);

CREATE TABLE REVIEW_IMG(
    O_NUM NUMBER CONSTRAINT RI_ONUM_FKNN REFERENCES ORDER_INFO(O_NUM),
    R_IMG VARCHAR2(1000) CONSTRAINT REI_RIMG_NN NOT NULL
);



/* ---------------------------- 시퀀스 생성 ------------------------------ */
-- 가게 아이디 시퀀스 & 트리거
CREATE SEQUENCE RI_RID_SEQ NOCACHE;

CREATE OR REPLACE TRIGGER RI_RID_SEQ
BEFORE INSERT
ON USER_INFO
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT RI_RID_SEQ.NEXTVAL INTO :NEW.NUM FROM DUAL;
END;
--/

-- 메뉴 아이디 시퀀스 & 트리거
CREATE SEQUENCE MI_MID_SEQ NOCACHE;

CREATE OR REPLACE TRIGGER MI_MID_SEQ
BEFORE INSERT
ON MENU_INFO
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT MI_MID_SEQ.NEXTVAL INTO :NEW.NUM FROM DUAL;
END;
--/

-- 메뉴 추가사항 시퀀스 & 트리거
CREATE SEQUENCE MA_AID_SEQ NOCACHE;

CREATE OR REPLACE TRIGGER MA_AID_SEQ
BEFORE INSERT
ON MENU_ADD
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT MA_AID_SEQ.NEXTVAL INTO :NEW.NUM FROM DUAL;
END;
--/

-- 주문번호 시퀀스 & 트리거
CREATE SEQUENCE OI_ONUM_SEQ NOCACHE;

CREATE OR REPLACE TRIGGER OI_ONUM_SEQ
BEFORE INSERT
ON ORDER_INFO
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT OI_ONUM_SEQ.NEXTVAL INTO :NEW.NUM FROM DUAL;
END;
--/



/* ---------------------------- 데이터 입력 ------------------------------ */
-- 회원 코드
INSERT INTO USER_CODE VALUES(0, '관리자');
INSERT INTO USER_CODE VALUES(1, '일반');
INSERT INTO USER_CODE VALUES(2, '사업자');

-- 카테고리 코드
INSERT INTO CAT_CODE VALUES(0, '전체');
INSERT INTO CAT_CODE VALUES(1, '치킨');
INSERT INTO CAT_CODE VALUES(2, '피자');
INSERT INTO CAT_CODE VALUES(3, '한식');
INSERT INTO CAT_CODE VALUES(4, '고기/족발');
INSERT INTO CAT_CODE VALUES(5, '회');
INSERT INTO CAT_CODE VALUES(6, '중식');
INSERT INTO CAT_CODE VALUES(7, '일식/돈까스');
INSERT INTO CAT_CODE VALUES(8, '아시안');
INSERT INTO CAT_CODE VALUES(9, '양식');
INSERT INTO CAT_CODE VALUES(10, '도시락');
INSERT INTO CAT_CODE VALUES(11, '분식');
INSERT INTO CAT_CODE VALUES(12, '패스트푸드');
INSERT INTO CAT_CODE VALUES(13, '카페/디저트');
INSERT INTO CAT_CODE VALUES(20, '포장');
INSERT INTO CAT_CODE VALUES(21, '신속배달');
INSERT INTO CAT_CODE VALUES(22, '프렌차이즈');
INSERT INTO CAT_CODE VALUES(23, '1인분');
INSERT INTO CAT_CODE VALUES(24, '야식');

-- 지불방식 코드
INSERT INTO PAY_CODE VALUES(0, '현금');
INSERT INTO PAY_CODE VALUES(1, '카드');
INSERT INTO PAY_CODE VALUES(2, '네이버페이');
INSERT INTO PAY_CODE VALUES(3, '카카오페이');
INSERT INTO PAY_CODE VALUES(4, '삼성페이');
INSERT INTO PAY_CODE VALUES(5, '애플페이');

-- 프렌차이즈 코드
INSERT INTO FRAN_CODE VALUES(0, '없음');

-- 요일 코드
INSERT INTO WEEK_CODE VALUES(0, '일');
INSERT INTO WEEK_CODE VALUES(1, '월');
INSERT INTO WEEK_CODE VALUES(2, '화');
INSERT INTO WEEK_CODE VALUES(3, '수');
INSERT INTO WEEK_CODE VALUES(4, '목');
INSERT INTO WEEK_CODE VALUES(5, '금');
INSERT INTO WEEK_CODE VALUES(6, '토');

-- 메뉴 코드
INSERT INTO MENU_CODE VALUES(0, '일반메뉴');
INSERT INTO MENU_CODE VALUES(1, '추천메뉴');
INSERT INTO MENU_CODE VALUES(2, '신메뉴');

-- 주문상태 코드
INSERT INTO STAT_CODE VALUES(0, '접수취소');
INSERT INTO STAT_CODE VALUES(1, '주문접수');
INSERT INTO STAT_CODE VALUES(2, '조리중');
INSERT INTO STAT_CODE VALUES(3, '배달중');
INSERT INTO STAT_CODE VALUES(4, '배달완료');

-- 주문형태 코드
INSERT INTO TYPE_CODE VALUES(0, '포장');
INSERT INTO TYPE_CODE VALUES(1, '배달');
INSERT INTO TYPE_CODE VALUES(2, '신속배달');