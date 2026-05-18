# Class Reunion 2026

A full-stack alumni directory for a school reunion with four batches:
**Science, Commerce A, Commerce B, Commerce C**.

- **Backend**: Spring Boot (Java 17) — Clean Architecture, Lombok, `Optional` for null-safety
- **Frontend**: Flutter Web — Clean Architecture, BLoC, get_it for DI

Features: stunning gradient UI, mobile-responsive layout, real-time search,
batch filters, sort, click-to-call & email, alumni registration, profile details.

---

## Project layout

```
school_reunion/
├── backend/                              # Spring Boot
│   └── src/main/java/com/reunion/
│       ├── domain/                       # Pure POJOs, repository contracts, exceptions
│       │   ├── model/                    # Alumni, Batch
│       │   ├── repository/               # AlumniRepository (interface)
│       │   └── exception/
│       ├── application/                  # Use cases (one per operation)
│       │   ├── dto/
│       │   └── usecase/
│       ├── infrastructure/               # JPA entities, repository adapter, Spring config
│       │   ├── persistence/
│       │   └── config/
│       └── presentation/                 # REST controller, request/response DTOs
│           ├── controller/
│           ├── dto/
│           └── exception/
└── frontend/                             # Flutter Web
    └── lib/
        ├── core/                         # cross-cutting concerns
        │   ├── theme/
        │   ├── network/
        │   ├── error/
        │   └── utils/
        ├── features/alumni/
        │   ├── data/
        │   │   ├── datasources/          # HTTP data source
        │   │   ├── models/               # JSON-aware models (extend domain entity)
        │   │   └── repositories/         # AlumniRepositoryImpl
        │   ├── domain/
        │   │   ├── entities/             # Alumni, Batch, Stats
        │   │   ├── repositories/         # abstract AlumniRepository
        │   │   └── usecases/             # GetAlumniList, RegisterAlumni, GetStats
        │   └── presentation/
        │       ├── bloc/                 # AlumniListBloc, RegisterBloc, StatsCubit
        │       ├── pages/                # HomePage, DirectoryPage, RegisterPage
        │       └── widgets/              # AlumniCard, AlumniDetailDialog
        ├── injection_container.dart      # get_it registrations
        └── main.dart
```

---

## Running it

### 1. Start the backend

```bash
cd backend
mvn spring-boot:run
```

Backend runs on `http://localhost:8080` with an in-memory H2 database that
auto-seeds 12 sample alumni on startup. H2 console: `http://localhost:8080/h2-console`.

### 2. Start the Flutter web app

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

The app calls `http://localhost:8080/api` by default. To point at a different
backend, pass `--dart-define`:

```bash
flutter run -d chrome --dart-define=API_URL=https://my-backend.example.com/api
```

---

## Backend API

| Method | Path                                  | Description                       |
|-------:|---------------------------------------|-----------------------------------|
|    GET | `/api/alumni`                         | List (params: `search`, `batch`)  |
|    GET | `/api/alumni/{id}`                    | Get by id                         |
|   POST | `/api/alumni`                         | Register a new alumnus            |
|    PUT | `/api/alumni/{id}`                    | Update                            |
| DELETE | `/api/alumni/{id}`                    | Delete                            |
|    GET | `/api/alumni/stats`                   | Per-batch counts + total          |

### Sample request

```bash
curl -X POST http://localhost:8080/api/alumni \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Anjali Verma",
    "batch": "SCIENCE",
    "email": "anjali@example.com",
    "phone": "+919876500000",
    "occupation": "Architect",
    "company": "Foster + Partners",
    "city": "Mumbai",
    "country": "India",
    "graduationYear": 2010
  }'
```

`batch` values: `SCIENCE | COMMERCE_A | COMMERCE_B | COMMERCE_C`.

---

## Architectural notes

### Backend — why this shape

- **Domain layer is framework-free.** `Alumni` is a plain POJO with `Optional<T>`
  getters for every nullable field — callers can't accidentally dereference null,
  they have to explicitly handle absence (`map`, `orElse`, `ifPresent`).
- **Repository interface in domain, JPA adapter in infrastructure.** This means
  the use cases never depend on Spring Data — they call an abstract contract,
  and `AlumniRepositoryImpl` adapts JPA to that contract via a mapper.
- **One use case per operation** (`CreateAlumniUseCase`, `UpdateAlumniUseCase`,
  …) — each one is small, single-purpose, and easy to test in isolation.
- **Lombok** removes boilerplate: `@Builder`, `@RequiredArgsConstructor`,
  `@Getter/@Setter`, `@Slf4j`. The `@NonNull` annotations on `Alumni`'s required
  fields make the generated constructor enforce non-null at build time.

### Frontend — why this shape

- **`core/`** holds cross-cutting plumbing (HTTP client, theme, failures,
  responsive helpers).
- **`features/alumni/domain/`** owns the business contracts — entities,
  abstract repository, use cases. No Flutter or HTTP imports here except for
  Material types in the enum extension (kept narrowly).
- **`features/alumni/data/`** depends on `domain` and implements its contracts.
  The HTTP data source talks to the backend; the repository wraps results in
  `Either<Failure, T>` (from `dartz`) so the UI never sees an exception.
- **`features/alumni/presentation/`** is BLoC + widgets. Pages dispatch events,
  BLoCs call use cases, states drive the UI. `get_it` (in
  `injection_container.dart`) wires the layers.
- **BLoCs:**
  - `AlumniListBloc` — list + search + filter + sort
  - `RegisterBloc` — registration form submission
  - `StatsCubit` — dashboard stats (cubit since it's a single async fetch)

### Why `Either<Failure, T>` on the frontend

Use cases return `Future<Either<Failure, T>>`. The BLoC can `.fold` it into a
success state or a failure state without try/catch noise, and `Failure` types
(`NetworkFailure`, `ConflictFailure`, `NotFoundFailure`, …) let the UI render
specific messages.

