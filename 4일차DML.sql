-- DML (Data Manipulation Language) : insert(입력), update(수정), delete(삭제)
-- DDL은 테이블 관련된것. 트랜잭션 개념이 없음. drop하면 끝임. CREATE, ALTER, DROP

-- 연습용 테이블 생성하기
CREATE TABLE DEPT_TEMP
AS SELECT * FROM dept;

SELECT *
FROM dept_temp;

-- 테이블에 데이터를 추가하는 insert문
-- insert into 테이블명(컬럼명...) values(데이터...) 
INSERT INTO DEPT_TEMP(deptno, dname, loc)
	VALUES (50, 'DATABASE', 'SEOUL');
	
INSERT INTO DEPT_TEMP VALUES(60, 'BACKEND', 'BUSAN');

INSERT INTO DEPT_TEMP(deptno) VALUES(70);
INSERT INTO DEPT_TEMP VALUES(80, 'FRONTEND', 'INCHEON');
INSERT INTO DEPT_TEMP(dname, loc) VALUES('APP', 'DAEGU');
INSERT INTO DEPT_TEMP VALUES(80, 'FRONTEND', 'INCHEON');

SELECT * FROM DEPT_TEMP;

DELETE FROM DEPT_TEMP
WHERE dname = 'APP';

DELETE FROM DEPT_TEMP
WHERE deptno = 80;

DELETE FROM DEPT_TEMP
WHERE deptno = 70;

INSERT INTO DEPT_TEMP VALUES(70, '웹개발', '');  -- ''으로 하면 NULL값으로 들어감

CREATE TABLE EMP_TEMP
	AS SELECT * 
	   FROM EMP
	   WHERE 1 != 1; -- WHERE 1 != 1 조건은 항상 거짓. 그래서 테이블의 구조만 복사됨

SELECT * FROM EMP_TEMP;

INSERT INTO EMP_TEMP(empno, ename, job, mgr, hiredate, sal, comm, deptno)
	VALUES (9001, '나영석', 'PD', NULL, '2020/01/01', 9900, 1000, 50);

INSERT INTO EMP_TEMP(empno, ename, job, mgr, hiredate, sal, comm, deptno)
	VALUES (9002, '강호동', 'MC', NULL, TO_DATE('2020/01/01', 'YYYY/MM/DD'), 8000, 1000, 60);

INSERT INTO EMP_TEMP(empno, ename, job, mgr, hiredate, sal, comm, deptno)
	VALUES (9001, '서장훈', 'MC', NULL, SYSDATE, 9000, 1000, 70);

SELECT * FROM DEPT_TEMP;

INSERT INTO DEPT_TEMP(deptno, dname, loc) VALUES(80, 'FRONTEND', 'SUWON');
ROLLBACK;

UPDATE DEPT_TEMP
	SET dname = 'WEB-PROGRAM',
		loc = 'SUWON'
	WHERE deptno = 70;

DELETE FROM DEPT_TEMP
WHERE DEPTNO = 70;

COMMIT;

DELETE FROM DEPT_TEMP;
ROLLBACK;















