---
name: coding-style
description: 공통 코딩 스타일 규칙
---

# 코딩 스타일 (공통)

## 네이밍

| 대상        | 규칙             | 예시                                   |
| ----------- | ---------------- | -------------------------------------- |
| 타입/클래스 | PascalCase       | `UserProfile`, `OrderRepository`       |
| 함수/변수   | camelCase        | `getUserName`, `isActive`              |
| 상수        | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `DEFAULT_PAGE_SIZE` |

- boolean 변수/메서드는 `is`, `has`, `can`, `should` 접두사 사용

## 불변성

객체와 컬렉션은 직접 변경하지 않고 새로 생성한다.

## 함수 설계

- 하나의 역할만 수행
- 중첩 **3레벨 이하** 유지, 얼리 리턴 활용

## 코드 구성

- **도메인별** 구성 (타입별 X)
- 하위 도메인이 필요한 경우 중첩 가능
- 여러 도메인에서 공유하는 코드는 `shared/` 에 배치

## 오류 처리

- 시스템 경계(사용자 입력, 외부 API 호출)에서만 처리
- 내부 코드는 신뢰 — 불필요한 방어 코드 금지
