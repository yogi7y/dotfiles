# Flutter Rules

- Never use `dynamic` type. If you don't know the type, use `Object?` instead.
  For example, instead of `dynamic name`, use `Object? name`. Instead of `Map<String, dynamic>`, use `Map<String, Object?>`.
- Never use the bang operator (`!`). Handle nullability explicitly using null checks, conditional access, or default values instead.
