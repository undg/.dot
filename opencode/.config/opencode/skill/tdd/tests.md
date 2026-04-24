# Good and Bad Tests

## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```typescript
// GOOD: Tests observable behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Vitest is the default choice for new JS/TS projects unless the repo already uses something else. The principle is not Vitest-specific, though; the same style applies in any language.

Characteristics:

- Tests behavior users/callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```typescript
// BAD: Tests implementation details
test("checkout calls paymentService.process", async () => {
  const processSpy = vi.spyOn(paymentService, "process");
  await checkout(cart, payment);
  expect(processSpy).toHaveBeenCalledWith(cart.total);
});
```

Bad because it verifies internal collaboration instead of user-visible behavior.

Red flags:

- Mocking internal collaborators
- Testing private methods
- Asserting on call counts/order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT
- Verifying through external means instead of interface

```typescript
// BAD: Bypasses interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

```python
# GOOD: Same principle in Python
def test_create_user_makes_user_retrievable():
    user = create_user({"name": "Alice"})
    retrieved = get_user(user.id)
    assert retrieved.name == "Alice"
```

```go
// GOOD: Same principle in Go
func TestCreateUserMakesUserRetrievable(t *testing.T) {
    user := CreateUser(UserInput{Name: "Alice"})
    retrieved := GetUser(user.ID)
    if retrieved.Name != "Alice" {
        t.Fatalf("got %q, want %q", retrieved.Name, "Alice")
    }
}
```
