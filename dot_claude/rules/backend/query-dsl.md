---
name: query-dsl
description: QueryDSL 사용 규칙
---

# QueryDSL

## 리포지토리 구조

커스텀 리포지토리 인터페이스 + 구현체 분리:

```java
// 인터페이스
public interface OrderRepositoryCustom {
    List<OrderResponse> searchOrders(OrderSearchRequest request);
}

// 구현체 — 반드시 인터페이스명 + Impl
@RequiredArgsConstructor
public class OrderRepositoryCustomImpl implements OrderRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public List<OrderResponse> searchOrders(OrderSearchRequest request) {
        return queryFactory
            .select(new QOrderResponse(order.id, order.status, user.name))
            .from(order)
            .join(order.user, user)
            .where(
                statusEq(request.status()),
                createdAfter(request.from())
            )
            .orderBy(order.createdAt.desc())
            .fetch();
    }
}

// JpaRepository에 커스텀 인터페이스 상속
public interface OrderRepository extends JpaRepository<Order, Long>, OrderRepositoryCustom {}
```

## Q클래스 사용

Q클래스는 static import:

```java
import static com.example.order.models.QOrder.order;
import static com.example.user.models.QUser.user;
```

같은 엔티티를 셀프 조인할 때만 별칭 생성:

```java
QCategory parent = new QCategory("parent");
QCategory child = new QCategory("child");
```

## 동적 쿼리

조건 메서드는 `BooleanExpression`을 반환하고, 조건이 없으면 `null` 반환 (where절에서 자동 무시):

```java
private BooleanExpression statusEq(OrderStatus status) {
    return status != null ? order.status.eq(status) : null;
}

private BooleanExpression createdAfter(LocalDate from) {
    return from != null ? order.createdAt.goe(from.atStartOfDay()) : null;
}

private BooleanExpression priceBetween(Integer min, Integer max) {
    if (min != null && max != null) return order.price.between(min, max);
    if (min != null) return order.price.goe(min);
    if (max != null) return order.price.loe(max);
    return null;
}
```

조건 메서드 네이밍:

| 패턴              | 용도      | 예시                            |
| ----------------- | --------- | ------------------------------- |
| `xxxEq`           | 일치      | `statusEq`, `userIdEq`          |
| `xxxIn`           | 포함      | `statusIn`, `categoryIdIn`      |
| `xxxBetween`      | 범위      | `priceBetween`, `dateBetween`   |
| `xxxLike`         | 부분 일치 | `nameLike`, `titleLike`         |
| `xxxAfter/Before` | 날짜 비교 | `createdAfter`, `createdBefore` |

## 프로젝션 (DTO 조회)

`@QueryProjection`을 사용하여 컴파일 타임 타입 안전성 확보:

```java
public record OrderResponse(
    Long id,
    OrderStatus status,
    String userName
) {
    @QueryProjection
    public OrderResponse {}
}

// 사용
queryFactory
    .select(new QOrderResponse(order.id, order.status, user.name))
    .from(order)
    .join(order.user, user)
    .fetch();
```

엔티티 전체가 아닌 필요한 컬럼만 조회한다.

## 페이징

```java
public Page<OrderResponse> searchOrders(OrderSearchRequest request, Pageable pageable) {
    var content = queryFactory
        .select(new QOrderResponse(order.id, order.status, user.name))
        .from(order)
        .join(order.user, user)
        .where(statusEq(request.status()))
        .offset(pageable.getOffset())
        .limit(pageable.getPageSize())
        .orderBy(order.createdAt.desc())
        .fetch();

    var count = queryFactory
        .select(order.count())
        .from(order)
        .where(statusEq(request.status()))
        .fetchOne();

    return new PageImpl<>(content, pageable, count != null ? count : 0L);
}
```
