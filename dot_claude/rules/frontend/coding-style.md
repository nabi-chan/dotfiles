---
name: coding-style
description: 프론트엔드 코딩 스타일 규칙
---

# 코딩 스타일

## 네이밍

| 대상                     | 규칙             | 예시                              |
| ------------------------ | ---------------- | --------------------------------- |
| 컴포넌트/타입/인터페이스 | PascalCase       | `UserProfile`, `ButtonProps`      |
| 함수/변수                | camelCase        | `getUserName`, `isVisible`        |
| 상수                     | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `API_BASE_URL` |
| 파일                     | dashed-case      | `user-profile.tsx`, `use-auth.ts` |

- boolean 변수는 `is`, `has`, `can`, `should` 접두사 사용
- 이벤트 핸들러는 `handle` + 동사: `handleClick`, `handleSubmit`
- 콜백 prop은 `on` + 동사: `onClick`, `onSubmit`

## 불변성

객체와 배열은 항상 새로 생성, 직접 변경 금지:

```typescript
// BAD
user.name = name;
array.push(item);
array.sort();

// GOOD
const updated = { ...user, name };
const added = [...array, item];
const sorted = [...array].sort();
```

React 상태도 동일 원칙 적용:

```typescript
// BAD
setState((prev) => {
  prev.items.push(item);
  return prev;
});

// GOOD
setState((prev) => ({ ...prev, items: [...prev.items, item] }));
```

## 함수 설계

- 함수는 **50줄 미만**, 하나의 역할만 수행
- 중첩 **3레벨 이하** 유지, 얼리 리턴 활용:

```typescript
function processOrder(order: Order): Result {
  if (!order.items.length) return { error: "empty" };
  if (!order.payment) return { error: "no_payment" };

  const validated = validateItems(order.items);
  const total = calculateTotal(validated);

  return submitOrder({ ...order, total });
}
```

## 파일 구성

- 파일 크기: 200~400줄 권장, 800줄 초과 시 분리
- **도메인별** 구성: `domains/<도메인>/` 하위에 `components/`, `hooks/` 등으로 분리
- 하위 도메인이 필요한 경우 `domains/<도메인>/domains/<하위도메인>/`으로 중첩 가능
- 여러 도메인에서 공유하는 코드는 `shared/`에 배치

```typescript
import { useState } from "react";
import { clsx } from "clsx";

import { api } from "@/lib/api";
import { Button } from "@/components/Button";

import { formatPrice } from "./utils";
import type { ProductProps } from "./types";
```

## 오류 처리

시스템 경계(사용자 입력, API 호출)에서만 처리. 내부 코드는 신뢰:

```typescript
// API 호출 — 외부 경계이므로 처리
async function fetchUser(id: string): Promise<User> {
  const res = await api.get(`/users/${id}`);
  if (!res.ok) throw new ApiError(res.status, "사용자 조회 실패");
  return res.data;
}

// 내부 유틸 — 불필요한 방어 코드 금지
function formatUserName(user: User): string {
  return `${user.firstName} ${user.lastName}`;
}
```
