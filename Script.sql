-- SELECT와 FROM 절
-- SELECT 문은 데이터 베이스에 보관되어 있는 데이터 조회할 때 사용
-- SELECT 절은 FROM 절에 명시한 테이블에서 조회할 열을 지정할 수 있음
-- SELECT [조회할 열], [조회할 열] FROM 테이블이름;

SELECT * FROM EMP;  -- *은 모든 열(컬럼)을 의미, FROM 다음에 오는 것이 테이블 이름, SQL 수행문은 ;(세미콜론)으로 끝나야 함

-- 특정 컬럼만 선택해서 조회
SELECT EMPNO, ENAME, DEPTNO FROM EMP;

-- 사원번호와 부서번호만 나오도록 SQL 작성
SELECT EMPNO, DEPTNO FROM EMP;

-- 한눈에 보기 좋게 별칭 부여하기
SELECT ENAME, SAL, COMM, SAL * 12 + COMM
FROM EMP;
-- 한눈에 보기 좋게 별칭 부여하기
SELECT ENAME "사원 이름", SAL AS 급여, COMM AS "성과급", SAL * 12 "연봉"
FROM EMP;

-- 중복 제거하는 DISTINCT : 데이터를 조회할 때 중복되는 행이 여러 행이 조회될 때, 중복된 행을 한 개씩만 선택
SELECT DISTINCT DEPTNO
FROM EMP
ORDER BY DEPTNO;  -- default값은 ASC

-- 컬럼값을 계산하는 산술 연산자(+,-,*,/)
SELECT ENAME, SAL, SAL * 12 "연간 급여", SAL * 12 + COMM "총 연봉"
FROM EMP;

-- 연습 문제 : 직책(job)을 중복 제거하고 출력하기
SELECT DISTINCT JOB FROM EMP;

-- WHERE 구문 (조건문)
-- 데이터를 조회할 때 사용자가 원하는 조건에 맞는 데이터만 조회할 때 사용
SELECT * FROM EMP  -- 먼저 테이블이 선택되고, WHERE 절에서 행을 제한하고, 출력할 열을 결정
WHERE DEPTNO = 20;

-- 사원번호가 7369인 사원의 모든 정보를 보여줘.
SELECT * FROM EMP
WHERE EMPNO = 7369;  -- 데이터베이스에서 비교는 =(같다)라는 의미로 사용됨

-- 급여가 2500 초과인 사원번호, 이름, 직책, 급여 출력
-- EMP 테이블에서 급여가 2500 초과인 행을 선택하고, 사원번호/이름/직책/급여 컬럼을 선택해 출력
SELECT EMPNO "사원번호", ENAME "이름", JOB "직책", SAL "급여"
FROM EMP
WHERE SAL > 2500;

-- WHERE 절에 기본 연산자 사용
SELECT * FROM EMP
WHERE SAL * 12 = 36000;

-- WHERE 절에 사용하는 비교 연산자 : >, >=, <, <=
-- 성과금이 500 초과인 사람의 모든 정보 출력
SELECT * FROM EMP
WHERE COMM > 500;

-- 입사일이 81년 1월 1일 이전인 사람의 모든 정보 출력
SELECT * FROM EMP 			-- 쌍따옴표는 별칭 부여할 때 사용
WHERE HIREDATE < '90/01/01';  -- 데이터베이스의 문자열 비교시 ''(작은따옴표) 사용, DATE 타입은 날짜의 형식에 맞으면 가능
-- 900101, 90-01-01, 90/01/01 전부 가능
-- WHERE HIREDATE < TO_DATE('90/01/01', 'YY/MM/DD');  이게 정석인거같긴 함

-- 같지 않음을 표현하는 여러가지 방법 : <>, !=, ^=, NOT 컬럼명 =
SELECT * FROM EMP
WHERE DEPTNO <> 30;
SELECT * FROM EMP
WHERE DEPTNO != 30;
SELECT * FROM EMP
WHERE DEPTNO ^= 30;
SELECT * FROM EMP
WHERE NOT DEPTNO = 30;

-- 논리 연산자 : AND, OR, NOT
-- 급여가 3000 이상이고 부서가 20번 사원의 모든 정보 출력하기
SELECT * FROM EMP
WHERE SAL >= 3000 
	AND DEPTNO = 20;

-- 급여가 3000 이상이거나 부서가 20번 사원의 모든 정보 출력하기
SELECT * FROM EMP
WHERE SAL >= 3000 
	OR DEPTNO = 20;

-- 급여가 3000 이상이고, 부서가 20번이고, 입사일이 82년 1월 1일 이전인 사원의 모든 정보 출력
SELECT * FROM EMP
WHERE SAL >= 3000 
	AND DEPTNO = 20 
	AND HIREDATE < '820101';

-- 급여가 3000이상이고, 부서가 20번이거나, 입사일이 82년 1월 1일 이전 사원의 모든 정보 출력
SELECT * FROM EMP
WHERE SAL >= 3000 
	AND (DEPTNO = 20 OR HIREDATE < '82/01/01');

-- 급여가 2500 이상이고 직책이 MANAGER인 사원의 모든 정보 출력
SELECT * FROM EMP
WHERE SAL >= 2500 AND JOB = 'MANAGER';
