---
name: coding-style
description: Java Spring 백엔드 코딩 스타일 규칙
---

# 코딩 스타일

## 네이밍

| 대상              | 규칙             | 예시                                   |
| ----------------- | ---------------- | -------------------------------------- |
| 클래스/인터페이스 | PascalCase       | `UserService`, `OrderRepository`       |
| 메서드/변수       | camelCase        | `findByEmail`, `isActive`              |
| 상수              | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `DEFAULT_PAGE_SIZE` |
| 패키지            | 소문자           | `com.example.user`                     |

- boolean 메서드/변수는 `is`, `has`, `can`, `should` 접두사 사용
- 인터페이스에 `I` 접두사 사용 금지 — 구현체에 `Impl` 접미사도 지양
- 축약어 지양: `usr` → `user`, `msg` → `message`

## 불변성

DTO, VO는 record 또는 불변 객체로 작성:

```java
// BAD
@Data
public class UserResponse {
    private String name;
    private String email;
}

// GOOD
public record UserResponse(String name, String email) {}
```

컬렉션은 불변으로 반환:

```java
// BAD
return users;

// GOOD
return List.copyOf(users);
```

## 레이어 구조

```
Controller → Service → Repository
```

- **Controller**: 요청 검증, 응답 변환만 담당. 비즈니스 로직 금지
- **Service**: 비즈니스 로직. 트랜잭션 경계
- **Repository**: 데이터 접근만 담당

레이어 간 역방향 참조 금지 (Service → Controller 호출 X)

## 메서드 설계

- 메서드는 **30줄 미만**, 하나의 역할만 수행
- 중첩 **3레벨 이하** 유지, 얼리 리턴 활용:

```java
public OrderResult processOrder(OrderCommand command) {
    if (command.items().isEmpty()) throw new InvalidOrderException("주문 항목 없음");

    var validated = validateItems(command.items());
    var total = calculateTotal(validated);

    return orderRepository.save(Order.create(command, total));
}
```

## 패키지 구성

- **도메인별** 구성: 최상위 패키지 아래 도메인 패키지로 분리
- 각 도메인 패키지에 `controller/`, `service/`, `models/` 등 배치
- `models/` 하위에 VO, DTO, Entity, Repository, Enum 배치
- 하위 도메인이 필요한 경우 도메인 패키지 내 중첩 가능
- 여러 도메인에서 공유하는 코드는 `common/` 또는 `shared/`에 배치

## 오류 처리

시스템 경계(Controller, 외부 API 호출)에서만 처리. 내부 코드는 예외를 던지고 `@RestControllerAdvice`에서 통합 처리:

```java
// 도메인 예외 — 발생시키기만
public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(Long id) {
        super("사용자를 찾을 수 없음: " + id);
    }
}

// 통합 처리
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handle(UserNotFoundException e) {
        return ResponseEntity.status(404).body(new ErrorResponse(e.getMessage()));
    }
}
```

## 의존성 주입

- 생성자 주입만 사용. `@Autowired` 필드 주입 금지
- 의존성이 3개 초과 시 클래스 분리 검토

```java
// BAD
@Autowired
private UserRepository userRepository;

// GOOD
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
}
```
