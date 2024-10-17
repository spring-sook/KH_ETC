-- 다중행 함수 : 여러 행에 대해서 함수가 적용되어 하나의 결과를 나타내는 함수
SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO;

-- 다중행 함수의 종류
-- SUM() : 지정한 데이터의 합을 반환
-- COUNT() : 지정한 데이터의 개수를 반환
-- MAX() : 최대값 반환
-- MIN() : 최소값 반환
-- AVG() : 평균값 반환
-- 집계함수(다중행함수) NULL값이 포함되어 있으면 무시
SELECT SUM(DISTINCT SAL), SUM(SAL)
FROM EMP;

-- 모든 사원에 대해서 급여와 추가 수당의 합을 구하기
SELECT SUM(SAL), SUM(COMM) FROM EMP;

-- 부서별 모든 사원에 대한 급여와 추가 수당의 합 구하기
SELECT DEPTNO, SUM(SAL), SUM(COMM)
FROM EMP
GROUP BY DEPTNO;

-- 각 직책별로 급여와 추가 수당의 합 구하기
SELECT JOB AS "직책", SUM(SAL) AS "급여", SUM(COMM) AS "성과금"
FROM EMP
GROUP BY JOB;

-- 각 부서별 최대(MAX) 급여를 받는 사원의 급여, 부서 출력
SELECT MAX(SAL), DEPTNO
FROM EMP
GROUP BY DEPTNO;
-- GROUP BY 없이 출력하려면?
SELECT MAX(SAL)FROM EMP WHERE DEPTNO = 10
UNION ALL
SELECT MAX(SAL) FROM EMP WHERE DEPTNO = 20
UNION ALL
SELECT MAX(SAL) FROM EMP WHERE DEPTNO = 30;
-- SELECT MAX(SAL), DEPTNO 를 하면 안되는 이유 :
-- 집계함수를 사용하고 GROUP BY가 없으면 하나의 속성만 출력 가능

-- 부서 번호가 20인 사원 중 가장 최근 입사자 출력하기
SELECT MAX(HIREDATE)
FROM EMP
WHERE DEPTNO = 20;

-- 서브쿼리 사용하기 : 각 부서별 최대(MAX) 급여 받는 사원의 사원번호, 이름, 직책, 부서번호 출력
SELECT MAX(SAL), DEPTNO
FROM EMP
GROUP BY DEPTNO;

SELECT MAX(SAL)
FROM EMP e2
WHERE e2.DEPTNO = 10;

SELECT EMPNO, ENAME, JOB, DEPTNO
FROM EMP e 
WHERE SAL = (
	SELECT MAX(SAL)
	FROM EMP e2 
	WHERE e2.DEPTNO = e.DEPTNO
);

-- HAVING 절
-- GROUP BY 존재할 때만 사용할 수 있음
-- WHERE 조건절과 동일하게 동작하지만, 그룹화된 결과 값의 범위를 제한할 때 사용
SELECT deptno, job, AVG(sal)
FROM EMP
GROUP BY deptno, job
	HAVING avg(sal) >= 2000
ORDER BY DEPTNO;
-- 아래 실행하면 "group function is not allowed here" 오류 발생
--SELECT deptno, job, AVG(sal)
--FROM EMP
--WHERE avg(sal) >= 2000
--GROUP BY deptno, job
--ORDER BY DEPTNO;

-- WHERE절과 HAVING절 함께 사용하기
SELECT deptno, job, AVG(sal)-- 5. 출력할 열 제한
FROM EMP   					-- 1. 먼저 테이블을 가져옴
WHERE sal <= 3000			-- 2. 급여 기준으로 행을 제한함
GROUP BY DEPTNO, JOB		-- 3. 부서별, 직책별 그룹화
	HAVING AVG(sal) >= 2000 -- 4. 그룹 내에서 출력할 행 제한
ORDER BY deptno, job;		-- 6. 그룹별, 직책별 오름차순 정렬

-- HAVING절을 사용하여 EMP 테이블의 부서별 직책의 평균 급여가 500 이상인
-- 사원들의 부서 번호, 직책, 부서별 직책의 평균 급여 출력
SELECT deptno, job, AVG(sal)
FROM EMP
GROUP BY DEPTNO, JOB 
	HAVING AVG(sal) >= 500
ORDER BY AVG(sal) ; 

-- EMP 테이블을 이용하여 부서번호, 평균급여, 최고급여, 최저급여, 사원수를 출력,
-- 단, 평균 급여를 출력할 때는 소수점 제외하고 부서 번호별로 출력
SELECT deptno AS "부서 번호", 
	TRUNC(AVG(sal)) AS "평균 급여", 
	MAX(sal) AS "최고 급여", 
	MIN(sal) AS "최저 급여", 
	COUNT(empno) AS "사원수 "
FROM EMP
GROUP BY DEPTNO

-- 같은 직책에 종사하는 사원이 3명 이상인 직책과 인원을 출력
SELECT job AS "직책", COUNT(empno)||'명' AS "인원"
FROM emp
GROUP BY job
	HAVING COUNT(empno) >= 3; 

-- 사원들의 입사 연도를 기준으로 부서별로 몇 명이 입사했는지 출력
SELECT deptno AS "부서 번호", 
	EXTRACT(YEAR FROM HIREDATE)||'년' AS "입사 연도", 
	COUNT(empno)||'명' AS "사원 수"
FROM EMP
GROUP BY EXTRACT(YEAR FROM HIREDATE), deptno
ORDER BY EXTRACT(YEAR FROM HIREDATE);

-- 추가 수당을 받는 사원 수와 받지 않는 사원 수를 출력 (O, X로 표기 필요)
-- 추가수당 | 사원수
--   X       8
--   O       4
SELECT NVL2(COMM, 'O', 'X') AS "추가 수당", 
	COUNT(empno) AS "사원 수"
FROM EMP
GROUP BY NVL2(COMM, 'O', 'X');

-- comm 이 0인 경우도 처리해줘야되서..!
SELECT 
	CASE
		WHEN comm IS NULL THEN 'X'
		WHEN comm = 0 THEN 'X'
		ELSE 'O'
	END AS "추가수당",
	COUNT(*) AS "사원수"
FROM EMP
GROUP BY CASE
		WHEN comm IS NULL THEN 'X'
		WHEN comm = 0 THEN 'X'
		ELSE 'O'
	END;

	
-- 각 부서의 입사 연도별 사원수, 최고 급여, 급여 합, 평균 급여를 출력
SELECT
	EXTRACT(YEAR FROM HIREDATE) AS "입사 연도",
	deptno AS "부서",
	COUNT(empno) AS "사원수",
	MAX(sal) AS "최고 급여",
	SUM(sal) AS "급여 합",
	TRUNC(AVG(sal)) AS "평균 급여"
FROM EMP
GROUP BY DEPTNO, EXTRACT(YEAR FROM HIREDATE);

-- 그룹화 관련 기타 함수 : ROLLUP (그룹화 데이터의 합계를 출력할 때 유용)
SELECT nvl(to_char(deptno), '전체부서') AS "부서번호",
	nvl(to_char(job), '부서별직책') AS "직책",
	count(*) AS "사원수",
	max(sal) AS "최대급여",
	min(sal) AS "최소급여",
	round(avg(sal)) AS "평균급여"
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY "부서번호", "직책";

-- 집합연산자 : 두개 이상의 쿼리 결과를 하나로 결합하는 연산자(수직적 처리 = 행 방향 결합)
-- 여러 개의 SELECT 문을 하나로 연결하는 기능
-- 집합 연산자로 결합하는 결과의 컬럼은 데이터 타입이 동일해야 함, 열의 개수도 동일해야 함
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 10
UNION
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 20
UNION
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 30
ORDER BY DEPTNO;

-- 교집합 : INTERSECT
-- 여러 개의 SQL문의 결과에 대한 교집합을 반환
SELECT empno, ename, sal
FROM emp
WHERE sal > 1000	-- 1001 ~ 1999
INTERSECT
SELECT empno, ename, sal
FROM emp
WHERE sal < 2000;	-- ~1999

-- 차집합 : MINUS, 중복 행에 대한 결과를 하나의 결과로 보여줌
SELECT empno, ename, sal
FROM emp
MINUS
SELECT empno, ename, sal
FROM emp
WHERE sal > 2000;


