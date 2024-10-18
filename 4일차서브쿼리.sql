-- 서브쿼리 : 다른 SQL 쿼리문 내에 포함되는 쿼리문을 말함
-- 주로 데이터를 필터링하거나 데이터 집계에 사용
-- 서브쿼리는 SELECT, INSERT, UPDATE, DELETE문에 모두 사용 가능
-- 단일행 서브쿼리(단 하나의 행으로 결과가 반환)와 다중행 서브쿼리(여러행의 결과가 반환)가 있음

-- 특정한 사원이 소속된 부서의 이름을 가져옴
SELECT dname AS "부서이름"
FROM DEPT
WHERE DEPTNO = (
	SELECT DEPTNO
	FROM emp
	WHERE ename = 'KING'
);
-- 등가 조인을 사용해서 구현
SELECT dname
FROM EMP e JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
WHERE e.ename = 'KING';

-- 서브쿼리로 'JONES'의 급여보다 높은 급여를 받는 사원 정보 출력
SELECT * 
FROM emp
WHERE SAL > (
	SELECT sal
	FROM emp
	WHERE ename = 'JONES'  -- 동명이인이 없다는 가정
);
-- 자체 조인(SELF)로 풀기
SELECT e1.*
FROM EMP e1 JOIN EMP e2
	ON e1.sal > e2.sal
WHERE e2.ename = 'JONES';

-- 서브쿼리는 연산자와 같은 비교 또는 조회 대상의 오른쪽에 놓이며 괄호()로 묶어서 표현
-- 특정한 경우를 제외하고는 ORDER BY 절을 사용할 수 없음
-- 서브쿼리의 SELECT 절에 명시한 열은 메인 쿼리의 비교 대상과 같은 자료형과 같은 개수로 지정해야 함

-- 문제 : EMP 테이블의 사원 정보 중에서 사원 이름이 ALLEN인 사원의 추가 수당보다 많은 사원 정보 출력
SELECT *
FROM EMP
WHERE COMM > (
	SELECT COMM
	FROM EMP
	WHERE ename = 'ALLEN'
);

-- 문제 : JAMES(1981.12.03)보다 먼저 입사한 사원들의 정보 출력
SELECT *
FROM EMP
WHERE HIREDATE < (
	SELECT HIREDATE
	FROM EMP
	WHERE ename = 'JAMES'
)
ORDER BY HIREDATE;

-- 문제 : 20번 부서에 속한 사원 중 전체 사원의 평균 급여(2077)보다 높은 급여를 받는 사원 정보과 소속부서 조회
SELECT EMPNO AS "사원 번호", ENAME AS "이름", JOB AS "직책", SAL AS "급여",
	e.DEPTNO AS "부서 번호", DNAME AS "부서 이름", LOC AS "부서 위치"
FROM EMP e JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
WHERE e.DEPTNO = 20
	AND e.SAL > (
		SELECT AVG(SAL)
		FROM EMP
	);

-- 실행 결과가 여러개인 다중행 서브쿼리
-- IN : 메인 쿼리의 데이터가 서브쿼리의 결과 중 하나라도 일치 데이터가 있다면 true
-- ANY, SOME : 메인 쿼리의 조건식을 만족하는 서브쿼리의 결과가 하나 이상이면 true
-- ALL : 메인 퀄의 조건식을 서브쿼리의 결과 모두가 만족하면 true
-- EXISTS : 서브쿼리의 결과가 존재하면(즉, 한개 이상의 행이 결과를 만족하면) true

-- 메인쿼리에 급여가 서브쿼리에서 각 부서의 최대 급여와 같은 사원의 모든 정보가 출력
SELECT *
FROM EMP
WHERE sal IN (
	SELECT MAX(SAL)
	FROM EMP
	GROUP BY DEPTNO 
);

SELECT empno, ename, sal
FROM EMP
WHERE sal > ANY (
	SELECT SAL 
	FROM EMP
	WHERE job = 'SALESMAN'
);

SELECT empno, ename, sal
FROM EMP
WHERE sal = ANY (
	SELECT SAL 
	FROM EMP
	WHERE job = 'SALESMAN'
);

-- 30번 부서 사원들의 급여보다 적은 급여를 받는 사원 정보 출력
SELECT empno, ename, sal, deptno
FROM EMP
WHERE sal < (
	SELECT MIN(sal)
	FROM EMP
	WHERE DEPTNO = 30
);
-- ALL 연산자 사용해서 동일 결과 만들기
SELECT empno, ename, sal, deptno
FROM EMP
WHERE sal < ALL(
	SELECT sal
	FROM EMP
	WHERE DEPTNO = 30
);

-- 직책이 'MANAGER'인 사원보다 많은 급여를 받는 사원의 사원번호, 이름, 급여, 부서이름 출력하기
SELECT e.empno, e.ename, e.sal, d.dname
FROM EMP e JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
WHERE e.sal > (
	SELECT MAX(sal)
	FROM EMP
	WHERE job = 'MANAGER'
);

-- EXISTS : 서브쿼리의 결과값이 하나 이상 존재하면 true
SELECT *
FROM EMP
WHERE EXISTS (
	SELECT dname
	FROM DEPT
	WHERE DEPTNO = 10
);

-- 다중열 서브 쿼리 : 서브 쿼리의 결과가 두 개 이상의 컬럼으로 반환되어 메인 쿼리에 전달하는 쿼리
SELECT empno, ename, sal, deptno
FROM EMP
WHERE (DEPTNO, SAL) IN (
	SELECT DEPTNO, SAL
	FROM EMP
	WHERE DEPTNO = 30
);

SELECT *
FROM EMP
WHERE (DEPTNO, SAL) IN (
	SELECT DEPTNO, MAX(SAL)
	FROM EMP
	GROUP BY DEPTNO
);

-- FROM 절에 사용하는 서브쿼리 : 인라인뷰라고 하기도 함
-- 테이블 내 데이터 규모가 너무 크거나 현재 작업에
-- 불필요한 열이 너무 많아 일부 행과 열만 사용하고자 할 때 유용
SELECT e10.empno, e10.ename, e10.deptno, d.dname, d.loc
FROM (
	SELECT ename, empno, deptno
	FROM EMP
	WHERE deptno = 10) e10
	JOIN DEPT d
		ON e10.deptno = d.DEPTNO;

-- 먼저 정렬하고 해당 갯수만 가져오기 : 급여가 많은 5명에 대한 정보 보여줘
SELECT ROWNUM, ename, sal
FROM (
	SELECT *
	FROM EMP
	ORDER BY sal desc)
WHERE ROWNUM <= 5;

-- SELECT 절에 사용하는 서브쿼리 : 단일행 서브쿼리를 스칼라 서브쿼리라고 함
-- SELECT 절에 명시하는 서브쿼리는 반드시 하나의 결과만 반환하도록 작성해야 함
SELECT empno, ename, job, sal, 
	(
		SELECT grade
		FROM SALGRADE
		WHERE e.sal BETWEEN losal AND hisal  -- 비등가조인
	) AS "급여 등급",
	DEPTNO AS "부서 번호",
	(
		SELECT dname
		FROM DEPT d 
		WHERE e.DEPTNO = d.deptno
	) AS "부서 이름"
FROM EMP e
ORDER BY "급여 등급";
-- JOIN문으로 변경하기
SELECT e.empno, e.ename, e.job, e.sal, s.grade AS "급여등급", d.deptno, d.dname
FROM EMP e
	JOIN SALGRADE s 
	ON e.sal BETWEEN s.losal AND s.hisal
	JOIN DEPT d 
	ON e.DEPTNO = d.deptno
ORDER BY "급여등급";

-- 부서 위치가 NEW YORK인 경우에는 본사, 그외에는 분점으로 반환
SELECT empno, ename,
	CASE 
		WHEN deptno = (
			SELECT deptno
			FROM DEPT
			WHERE loc = 'NEW YORK'
		) THEN '본사'
		ELSE '분점'
	END AS "소속"
FROM EMP
ORDER BY "소속" desc;

-- 연습문제 1번
-- 전체 사원 중 ALLEN과 같은 직책(JOB)인 사원들의 사원 정보, 부서 정보를
-- 다음과 같이 출력하는 SQL문을 작성하세요. (직책, 사원번호, 사원이름, 급여, 부서번호, 부서이름)
SELECT e.job, e.empno, e.ename, e.sal, d.deptno, d.dname
FROM EMP e 
	JOIN DEPT d
	ON e.DEPTNO  = d.DEPTNO
WHERE job = (
		SELECT job
		FROM EMP
		WHERE ename = 'ALLEN'
	);
	
-- 연습문제 2번
-- 전체 사원의 평균급여(SAL)보다 높은 급여를 받는 사원들의 사원정보, 부서정보,
-- 급여 등급 정보를 출력하는 SQL문을 작성하세요
-- (단 출력할 때 급여가 많은 순으로 정렬하되 급여가 같을 경우에는 사원번호를 기준으로 오름차순 정렬)
-- (사원번호, 이름, 입사일, 급여, 급여등급, 부서이름, 부서위치)
SELECT e.empno, e.ename, e.hiredate, e.sal, s.grade, d.dname, d.loc
FROM EMP e 
	JOIN DEPT d 
	ON e.DEPTNO = d.DEPTNO
	JOIN SALGRADE s 
	ON e.SAL BETWEEN s.LOSAL AND s.HISAL 
WHERE sal > (
		SELECT AVG(sal)
		FROM EMP
	)
ORDER BY sal, ename DESC;
	
-- 연습문제 3번
-- 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의
-- 사원번호, 부서정보를 다음과 같이 출력하는 SQL문을 작성하세요.
-- (사원번호, 사원이름, 직책, 부서번호, 부서이름, 부서위치)
SELECT e.empno, e.ename, e.job, d.deptno, d.dname, d.loc
FROM EMP e
	JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
WHERE e.DEPTNO = 10
	AND job NOT IN (
			SELECT job
			FROM EMP
			WHERE DEPTNO = 30
		);
	
-- 연습문제 4번
-- 직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의
-- 사원정보, 급여등급 정보를 다음과 같이 출력하는 SQL문을 작성하세요.
-- (단, 서브쿼리를 활용할 때 다중행 함수를 사용하는 방법과 사용하지 않는 방법을 통해
-- 사원 번호를 기준으로 오름차순으로 정렬하세요.)
-- (사원번호, 사원이름, 급여, 급여 등급)
SELECT e.empno, e.ename, e.sal, s.grade
FROM EMP e
	JOIN SALGRADE s 
	ON e.sal BETWEEN s.LOSAL AND s.HISAL
WHERE e.sal > (
		SELECT MAX(sal)
		FROM EMP
		WHERE job = 'SALESMAN'
	)
ORDER BY e.EMPNO;

SELECT e.empno, e.ename, e.sal, s.grade
FROM EMP e
	JOIN SALGRADE s 
	ON e.sal BETWEEN s.LOSAL AND s.HISAL
WHERE e.sal > ALL(
		SELECT sal
		FROM EMP
		WHERE job = 'SALESMAN'
	)
ORDER BY e.EMPNO;











