-- 스프링 팀 프로젝트 C조 프로젝트 테스트 테이블 쿼리문
-- 스크립트 실행하면 됨
-- 주의: 반드시 SYSTEM 계정에서 실행할 것

/* ------------------------- 임시 데이터베이스 생성 ------------------------- */
DROP USER DELIVERY_TEST CASCADE; -- 만약 데이터베이스가 이미 존재한다면 삭제

CREATE USER DELIVERY_TEST IDENTIFIED BY delivery; -- 계정생성 아이디: DELIVERY_TEST, 비밀번호: delivery

GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM TO DELIVERY_TEST; -- 권한부여: 접속, DML, DDL, 뷰, 동의어