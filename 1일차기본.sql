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

SELECT * FROM EMP
WHERE JOB = 'MANAGER' 
	OR JOB = 'SALESMAN' 
	OR JOB = 'CLERK';
-- IN 연산자 : 여러개의 열 이름을 조회할 경우 연속해서 나열할 수 있음
SELECT * FROM EMP
WHERE JOB IN ('MANAGER', 'SALESMAN', 'CLERK');

-- IN 연산자를 사용해 20번과 30번 부서에 포함된 사원의 모든 정보 출력
SELECT * FROM EMP
WHERE DEPTNO IN (20, 30);

-- NOT IN 연산자를 사용해 20번과 30번 부서에 포함된 사원 조회
SELECT * FROM EMP
WHERE DEPTNO NOT IN (10);

-- 비교 연산자와 AND 연산자를 사용하여 출력하기
SELECT * FROM EMP
WHERE JOB != 'MANAGER'
	AND JOB <> 'SALESMAN'
	AND JOB ^= 'CLERK';
	
-- BETWEEN A AND B 연산자 : 일정한 범위를 조회할 때 사용하는 연산자(A에서 B까지)
-- 급여가 2000에서 3000사이 사원의 모든 정보를 출력
SELECT * FROM EMP
WHERE SAL BETWEEN 2000 AND 3000;
-- WHERE SAL >= 2000 AND SAL <= 3000;
SELECT * FROM EMP
WHERE SAL NOT BETWEEN 2000 AND 3000;

-- 사원번호가 7689에서 7902까지의 사원의 모든 정보를 출력
SELECT * FROM EMP
WHERE EMPNO BETWEEN 7689 AND 7902;

-- 1980년이 아닌 해에 입사한 사원의 모든 정보를 출력
SELECT * FROM EMP
WHERE HIREDATE NOT BETWEEN '80/01/01' AND '80/12/31';
-- WHERE NOT HIREDATE BETWEEN '1980/01/01' AND '1980/12/31';

-- LIKE, NOT LIKE 연산자 : 문자열을 검색할 때 사용하는 연산자
-- % : 길이와 상관없이 모든 문자 데이터를 의미
-- _ : 문자 1개를 의미
SELECT EMPNO, ENAME FROM EMP
WHERE ENAME LIKE '%K%';  -- 앞과 뒤의 문자열 길이에 상관없이 K라는 문자가 ENAME에 포함된 사원의 정보 출력

-- 사원의 이름의 2번째 글자가 L인 사원만 출력
SELECT * FROM EMP
WHERE ENAME LIKE '_L%';

-- [실습 1] 사원 이름에 "AM"이 포함되어 있는 사원 데이터만 출력
SELECT * FROM EMP
WHERE ENAME LIKE '%AM%';

-- [실습 2] 사원 이름에 "AM"이 포함되어 있지 않은 사원 데이터만 출력
SELECT * FROM EMP
WHERE ENAME NOT LIKE '%AM%';

-- 와일드 카드 문자가 데이터 일부일 경우(% _) escape로 지정된 '\'뒤에 오는 %는 와일드 카드가 아니라는 의미
SELECT * FROM EMP
WHERE ENAME LIKE '%\%S' ESCAPE '\';  -- 사원이름 %S로 끝나는 사원 조회

INSERT INTO EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (1001, 'JAME%S', 'MANAGER', 7839, '2024-10-15', 3500, 450, 30);

DELETE FROM EMP
WHERE EMPNO = 1001;

-- is null 연산자 : 
-- 데이터 값에는 NULL 값을 가질 수 있음, 값이 정해지지 않음을 의미, 연산불가(계산, 비교, 할당)
SELECT ENAME, SAL, SAL * 12 + COMM "연봉", COMM
FROM EMP;

-- 비교연산으로 NULL 비교하기
SELECT * FROM EMP
WHERE COMM = NULL;  -- NULL은 비교연산 불가이므로 결과가 나오지 않음

-- 해당 데이터가 NULL인지 확인하는 방법은 is NULL 연산자를 사용해야 함
SELECT * FROM EMP
WHERE COMM IS NULL;
-- 해당 데이터가 NULL이 아닌 데이터만 출력하기
SELECT * FROM EMP
WHERE COMM IS NOT NULL;

-- 직속 상관이 있는 사원 데이터 출력
SELECT * FROM EMP
WHERE MGR IS NOT NULL;

-- 정렬을 위한 ORDER BY 절 : 오름차순 또는 내림차순 정렬 가능
SELECT * FROM EMP
ORDER BY SAL;  -- 급여에 대한 오름차순 정렬
SELECT * FROM EMP
ORDER BY SAL DESC; -- 급여에 대한 내림차순 정렬

-- 사원번호 기준 내림차순 정렬하기
SELECT * FROM EMP
ORDER BY EMPNO DESC;

-- 정렬 조건을 여러 컬럼을 설정하기
SELECT SAL, ENAME FROM EMP
ORDER BY SAL DESC, ENAME;  -- 급여가 많은 사람 순으로 정렬하고, 급여가 같으면 이름순 정렬

-- 별칭 사용과 ORDER BY
SELECT EMPNO "사원번호", ENAME "사원명", SAL "월급", HIREDATE "입사일"  -- 3. 출력해야 할 컬럼 제한
FROM EMP           -- 1. 먼저 테이블을 가져옴
WHERE SAL >= 2000  -- 2. 해당 조건에 맞는 행(튜플)을 가져옴
ORDER BY 월급 DESC, 사원명 ASC;  -- 4. 마지막 정렬을 수행함

-- 연결 연산자 : SELECT문 조회 시 컬럼 사이에 특정한 문자를 넣을 때 사용
SELECT ENAME || '의 직책은 ' || JOB "사원 정보"
FROM EMP;

-- [실습문제 1] 사원 이름이 S로 끝나는 사원 데이터를 모두 출력
SELECT * FROM EMP
WHERE ENAME LIKE '%S';
-- [실습문제 2] 30번 부서에서 근무하고 있는 사원 중,
--  직책이 SALESMAN인 사원의 사원번호, 이름, 직책, 급여, 부서번호 출력
SELECT EMPNO "사원번호", ENAME "이름", JOB "직책", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE JOB = 'SALESMAN';
-- [실습문제 3] 20번과 30번 부서에 근무하고 잇는 사원 중
-- 급여가 2000 초과인 사원의 사원번호, 이름, 직책, 급여, 부서번호 출력
SELECT EMPNO "사원번호", ENAME "이름", JOB "직책", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO IN (20, 30)
	AND SAL > 2000;
-- [실습문제 4] 급여가 2000이상 3000이하 범위 이외의 값을 가진 사원의
-- 모든 정보 출력
SELECT * FROM EMP
WHERE SAL NOT BETWEEN 2000 AND 3000;
-- [실습문제 5] 사원 이름에 E가 포함되어 있는 30번 부서의 사원 중
-- 급여가 1000 ~ 2000 사이가 아닌 사원의 이름, 번호, 급여, 부서 번호 출력
SELECT ENAME "이름", EMPNO "사원번호", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE ENAME LIKE '%E%'
	AND DEPTNO = 30
	AND SAL NOT BETWEEN 1000 AND 2000;
-- [실습문제 6] 추가 수당이 존재하지 않고, 상급자가 존재하고
-- 직책이 MANAGER, CLERK인 사원 중 사원 이름의 두번째 글자가 L이 아닌 사원의
-- 모든 정보 출력하기
SELECT * FROM EMP
WHERE COMM IS NULL
	AND MGR IS NOT NULL
	AND (JOB = 'MANAGER' OR JOB = 'CLERK')
	-- AND JOB IN ('MANAGER', 'CLERK')  -- 강사님답. IN을 생각을 못했네..
	AND ENAME NOT LIKE '_L%';
	
-- SELECT 연습 문제 -- 
-- 1. **EMP테이블에서 COMM 의 값이 NULL이 아닌 정보 조회**
SELECT *
FROM EMP
WHERE COMM IS NOT NULL;
-- 2. **EMP테이블에서 커미션을 받지 못하는 직원 조회**
SELECT *
FROM EMP
WHERE COMM IS NULL;
-- 3. **EMP테이블에서 관리자가 없는 직원 정보 조회**
SELECT *
FROM EMP
WHERE MGR IS NULL;
-- 4. **EMP테이블에서 급여를 많이 받는 직원 순으로 조회**
SELECT *
FROM EMP
ORDER BY SAL DESC;
-- 5. **EMP테이블에서 급여가 같을 경우 커미션을 내림차순 정렬 조회**
SELECT *
FROM EMP
ORDER BY SAL, COMM DESC;
-- 6. **EMP테이블에서 사원번호, 사원명,직급, 입사일 조회
-- (단, 입사일을 오름차순 정렬 처리)**
SELECT EMPNO "사원 번호", ENAME "사원명", JOB "직급", HIREDATE "입사일"
FROM EMP
ORDER BY HIREDATE;
-- 7. **EMP테이블에서 사원번호, 사원명 조회 (사원번호 기준 내림차순 정렬)**
SELECT EMPNO "사원 번호", ENAME "사원명"
FROM EMP
ORDER BY EMPNO DESC;
-- 8. **EMP테이블에서 사번, 입사일, 사원명, 급여 조회  
-- (부서번호가 빠른 순으로, 같은 부서번호일 때는 최근 입사일 순으로 처리)**
SELECT EMPNO "사번", HIREDATE "입사일", ENAME "사원명", SAL "급여"
FROM EMP
ORDER BY EMPNO, HIREDATE;
-- (PASS)9. **오늘 날짜에 대한 정보 조회**

-- 10. **EMP테이블에서 사번, 사원명, 급여 조회  
-- (PASS)(단, 급여는 100단위까지의 값만 출력 처리하고 급여 기준 내림차순 정렬)**
SELECT EMPNO "사번", ENAME "사원명", SAL "급여"
FROM EMP

-- (PASS)11. **EMP테이블에서 사원번호가 홀수인 사원들을 조회**

-- 12. **EMP테이블에서 사원명, 입사일 조회 
-- (PASS)(단, 입사일은 년도와 월을 분리 추출해서 출력)**
SELECT ENAME "사원명", HIREDATE "입사일"
FROM EMP

-- (PASS)13. **EMP테이블에서 9월에 입사한 직원의 정보 조회**

-- 14. **EMP테이블에서 81년도에 입사한 직원 조회**
SELECT *
FROM EMP
WHERE HIREDATE BETWEEN '81/01/01' AND '81/12/31';

SELECT *
FROM EMP
WHERE EXTRACT (YEAR FROM HIREDATE) = 1981;
-- 15. **EMP테이블에서 이름이 'E'로 끝나는 직원 조회**
SELECT *
FROM EMP
WHERE ENAME LIKE '%E';
-- 16. **EMP테이블에서 이름의 세 번째 글자가 'R'인 직원의 정보 조회**
SELECT *
FROM EMP
WHERE ENAME LIKE '__R%';
-- (PASS)17. **EMP테이블에서 사번, 사원명, 입사일, 입사일로부터 40년 되는 날짜 조회**
SELECT EMPNO, ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 12*40) -- 특정 날짜에 개월수를 더해 날짜 계산
FROM EMP
-- (PASS)18. **EMP테이블에서 입사일로부터 38년 이상 근무한 직원의 정보 조회**
SELECT * FROM EMP

-- (PASS)19. **오늘 날짜에서 년도만 추출**

