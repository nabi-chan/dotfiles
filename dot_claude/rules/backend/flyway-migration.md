---
name: flyway-migration
description: flyway를 이용한 DB 마이그레이션
---

# Flyway 마이그레이션

## 파일 네이밍

```
V{버전}__{설명}.sql       # 버전 마이그레이션 (되돌릴 수 없음)
R__{설명}.sql             # 반복 마이그레이션 (변경 시 재실행)
```

- 버전: `YYYYMMDD_XXXX` 형식 (같은 날 여러 파일 시 4자리 순번 증가)
- 설명: snake_case, 변경 내용을 명확히 기술
- 예시: `V20260211_0001__create_user_table.sql`, `V20260211_0002__add_email_to_user.sql`

## 마이그레이션 파일 위치

```
src/main/resources/db/migration/
```

## 작성 규칙

- 한 파일에 하나의 논리적 변경만 포함
- DDL 문에 `IF NOT EXISTS` / `IF EXISTS`를 사용하여 멱등성 확보
- MySQL에서 `IF EXISTS`를 지원하지 않는 구문은 프로시저로 감싸서 처리
- 테이블/컬럼 삭제 시 별도 마이그레이션으로 분리
- `DROP TABLE`, `DROP COLUMN`은 반드시 사용자에게 확인 후 작성

## 작성 패턴

```sql
-- 테이블 생성
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_users_email (email)
);

-- 컬럼 추가 (IF NOT EXISTS 지원하지 않는 경우 프로시저 사용)
DROP PROCEDURE IF EXISTS migrate;
DELIMITER //
CREATE PROCEDURE migrate()
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'users' AND column_name = 'phone'
    ) THEN
        ALTER TABLE users ADD COLUMN phone VARCHAR(20);
    END IF;
END //
DELIMITER ;
CALL migrate();
DROP PROCEDURE migrate;
```

## 주의사항

- 이미 적용된 마이그레이션 파일은 **절대 수정 금지** — 새 파일로 변경사항 추가
- 대량 데이터 변경(DML)은 배치 처리 고려
- 외래 키 제약조건 추가 시 기존 데이터 정합성 먼저 확인
- 운영 환경 적용 전 `flyway validate`로 검증
