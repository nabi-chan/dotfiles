---
name: swagger
description: Swagger (OpenAPI) 문서화 규칙
---

# Swagger (OpenAPI)

## @Schema

- `name`: CamelCase로 지정하되, 클래스명과 동일하면 생략
- validation 어노테이션으로 스키마 제약조건 정의

```java
// BAD — 클래스명과 동일한 name 지정, validation 누락
@Schema(name = "CreateUserRequest")
public record CreateUserRequest(
    @Schema(description = "이메일")
    String email,
    @Schema(description = "이름")
    String name
) {}

// GOOD — name 생략, validation으로 스키마 제약조건 표현
public record CreateUserRequest(
    @Email @NotBlank @Schema(description = "이메일")
    String email,
    @NotBlank @Size(max = 50) @Schema(description = "이름")
    String name
) {}

// 클래스명과 다른 스키마명이 필요한 경우에만 name 지정
@Schema(name = "UserSummary")
public record UserListItemResponse(
    @NotNull @Schema(description = "사용자 ID")
    Long id,
    @NotBlank @Schema(description = "이름")
    String name
) {}
```

## @Parameter

컨트롤러 메서드의 path variable, query parameter에 사용. Spring이 추론 가능한 속성은 생략:

```java
// BAD — description 없이 사용, 불필요한 required 명시
@GetMapping("/users/{id}")
public UserResponse getUser(
    @PathVariable @Parameter(required = true) Long id) { ... }

// GOOD — description 명시, Spring이 추론 가능한 속성은 생략
@GetMapping("/users/{id}")
public UserResponse getUser(
    @PathVariable @Parameter(description = "사용자 ID") Long id) { ... }

@GetMapping("/users")
public List<UserResponse> listUsers(
    @RequestParam(defaultValue = "0") @Parameter(description = "페이지 번호") int page,
    @RequestParam(defaultValue = "20") @Parameter(description = "페이지 크기") int size) { ... }
```

## @ParameterObject

query parameter를 DTO로 받을 때 record가 아닌 class에 사용:

```java
@GetMapping("/users/search")
public List<UserResponse> searchUsers(UserSearchRequest request) { ... }

@ParameterObject
@Getter
@Setter
public class UserSearchRequest {
    @Parameter(description = "검색 키워드")
    private String keyword;
    @Parameter(description = "페이지 번호") @Min(0)
    private Integer page = 0;
    @Parameter(description = "페이지 크기") @Min(1) @Max(100)
    private Integer size = 20;
}
```
