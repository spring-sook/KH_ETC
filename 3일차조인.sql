-- 조인 : 여러 테이블을 하나의 테이블처럼 사용하는 것
-- 이때 필요한 것이 PK(Primary Key)와 테이블 간 공통값인 FK(Foreign Key)가 필요
-- Join의 종류
-- INNER JOIN (동등 조인) : 두 테이블에서 일치하는 데이터만 선택
-- LEFT JOIN : 왼쪽 테이블의 모든 데이터와 일치하는 데이터 선택
-- RIGHT JOIN : 오른쪽 테이블의 모든 데이터와 일치하는 데이터 선택
-- FULL OUTER JOIN : 두 테이블의 모든 데이터를 선택

-- 카테시안의 곱 : 두 개의 테이블에서 조인할 때 기준 열을 지정하지 않으면, 모든행 * 모든행
SELECT * 
FROM EMP, DEPT
ORDER BY empno;

-- 등가 조인 : 일치하는 열이 존재해야 함, INNER JOIN이라고도 함, 가장 일반적인 조인 방식
-- 오라클 조인 방식
SELECT empno, ename, job, sal, e.deptno
FROM EMP e, DEPT d 
WHERE e.DEPTNO = d.DEPTNO
ORDER BY empno;
--SELECT empno, ename, job, sal, deptno   -- 이렇게 하면 오류남. 누구의 deptno인지 몰라서. e.deptno 이런식으로 하면 오류 안남
--FROM EMP e, DEPT d 
--WHERE e.DEPTNO = d.DEPTNO
--ORDER BY empno;

-- ANSI 조인
SELECT empno, ename, job, sal, e.deptno
FROM emp e JOIN dept d
	ON e.DEPTNO = d.DEPTNO
ORDER BY empno;

-- DEPT 테이블과 EMP 테이블은 1:N 관계를 가짐 (부서 테이블의 부서번호에는 여러명의 사원이 올 수 있음)

-- 조인에서 출력범위 설정하기
SELECT empno, ename, sal, d.deptno, dname, loc
FROM EMP e JOIN DEPT d 
	ON e.DEPTNO = d.DEPTNO 
WHERE sal >= 3000;

-- EMP 테이블 별칭을 E로, DEPT 테이블 별칭은 D로 하여 다음과 같이
-- 등가 조인을 했을 때 급여가 2500 이하이고,
-- 사원 번호가 9999 이하인 사원의 정보가 출력되도록 작성
-- 오라클 조인
SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
	AND sal <= 2500
	AND empno <= 9999;
-- ANSI 조인
SELECT *
FROM EMP E JOIN DEPT D
	ON E.DEPTNO = D.DEPTNO
WHERE sal <= 2500
	AND empno <= 9999;

SELECT * FROM SALGRADE;  -- 각 급여에 대한 등급 표시(등급별 급여 범위)
-- 비등가 조인 : 동일한 컬럼이 존재하지 않는 경우 조인할 때 사용, 일반적인 방식은 아님
SELECT ename, sal, grade
FROM EMP e JOIN SALGRADE s
	ON sal BETWEEN s.LOSAL AND s.HISAL;  -- 급여와 LOSAL ~ HISAL 비등가 조인

-- 자체 조인(SELF JOIN) : 자기 자신의 테이블과 조인하는 것을 말함(같은 테이블을 두번 사용)
SELECT e1.empno AS "사원 번호", e1.ename AS "사원 이름", e1.mgr AS "상관 사원번호",
	e2.empno AS "상관 사원번호",
	e2.ename AS "상관 이름"
FROM EMP e1 JOIN EMP e2
	ON e1.mgr = e2.empno;

-- 외부 조인(OUTER JOIN) : LEFT, RIGHT, FULL
-- 이건 등가조인(INNER JOIN) : 양쪽 모두 존재하는 것. 그래서 12행 출력. DEPT에 deptno 40도 있지만 emp엔 없어서 출력 안됨
SELECT e.ename, e.deptno, d.dname
FROM EMP e JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
ORDER BY e.DEPTNO;
-- 오른쪽 기준 : RIGHT OUTER JOIN
SELECT e.ename, d.deptno, d.dname
FROM EMP e RIGHT OUTER JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
ORDER BY e.DEPTNO;

-- NATURAL JOIN : 등가 조인과 비슷하지만 WHERE 조건절 없이 사용 
-- (두 테이블의 동일한 이름이 있는 열을 자동으로 찾아서 조인 해줌)
SELECT empno, ename, deptno, dname
FROM emp NATURAL JOIN DEPT;

-- JOIN ~ USING : 등가 조인을 대신하는 조인 방식
SELECT e.empno, e.ename, e.job, deptno, d.dname, d.loc
FROM EMP e JOIN DEPT d 
	USING(deptno)
ORDER BY e.empno;

-- Q1. 급여가 2000초과인 사원들의 정보 출력(부서번호, 부서이름, 사원번호, 사원이름, 급여)
-- JOIN ~ ON, NATURAL JOIN, JOIN ~ USING 아무거나 사용
SELECT e.deptno AS 부서번호,
	dname AS 부서이름,
	empno AS 사원번호,
	ename AS 사원이름,
	sal AS 급여
FROM EMP e JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
WHERE sal > 2000;

SELECT deptno AS 부서번호, dname AS 부서이름, empno AS 사원번호, ename AS 사원이름, sal AS 급여
FROM EMP e NATURAL JOIN DEPT d
WHERE sal > 2000;

SELECT deptno AS 부서번호, dname AS 부서이름, empno AS 사원번호, ename AS 사원이름, sal AS 급여
FROM EMP JOIN DEPT
	USING(deptno)
WHERE sal > 2000;

-- Q2. 각 부서별 평균 급여, 최대 급여, 최소 급여, 사원수 출력
-- (부서번호, 부서이름, 평균 급여, 최대 급여, 최소 급여, 사원수)
SELECT deptno AS "부서 번호",
	dname AS "부서 이름",
	ROUND(AVG(sal)) AS "평균 급여",
	MAX(sal) AS "최대 급여",
	MIN(sal) AS "최소 급여",
	count(empno) AS "사원 수"
FROM EMP JOIN DEPT USING(deptno)
GROUP BY deptno, dname;

-- Q3. 모든 부서 정보와 사원 정보 출력(부서 번호와 부서 이름순으로 정렬),
-- 모든 부서가 나와야됨
SELECT *
FROM EMP e FULL JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
ORDER BY e.DEPTNO, ename;























