---
paths:
  - "lib/**"
---

# Architecture Rules

## Layer Dependency (Strict)

```
presentation -> domain (NEVER directly to data)
data -> domain (implements interfaces)
domain -> nothing
core -> nothing
```

### Violations to Avoid
- NEVER import `data/` from `presentation/`
- NEVER import `presentation/` from `domain/`
- NEVER import concrete repositories in screens (use providers)

## Entity Rules (`lib/domain/entities/`)

- Extend `Equatable` for value equality
- Immutable with `final` fields
- Factory constructors for creation patterns
- No framework dependencies (pure Dart)
- `copyWith()` for state updates

## Repository Rules

### Interface (`lib/domain/repositories/`)
- Abstract class defining contract
- Returns domain entities (not models)
- Async methods return `Future<T>`

### Implementation (`lib/data/repositories/`)
- Implements domain interface
- Handles data source coordination
- Maps models -> entities
- Naming: `Mock{Name}Repository` (static), `Supabase{Name}Repository` (remote)

## UseCase Rules (`lib/domain/usecases/`)

- Single responsibility (one public method)
- Depends on repository interfaces
- Returns domain entities
- Contains business logic orchestration

## Service Rules (`lib/domain/services/`)

- Stateless business logic
- Pure functions where possible
- No framework dependencies
- Can depend on repository interfaces

## Data Model Rules (`lib/data/models/`)

- `fromJson()` / `toJson()` for serialization
- `toEntity()` for domain conversion
- `fromEntity()` for reverse mapping
- Keep separate from domain entities

## Datasource Fallback Chain

```
Remote (Supabase) -> Local (Hive cache) -> Static (bundled JSON)
```

- Always provide offline fallback
- Cache remote data locally on success
- Static data as last resort
