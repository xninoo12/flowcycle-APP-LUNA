# FlowCycle — Technical Architecture Document (TAD)

**Document Version:** 1.0.0  
**Author:** Principal Flutter Solutions Architect  
**Project:** FlowCycle (iOS & Android)  
**Status:** Approved Technical Blueprint  

---

## 1. High-Level Architecture

FlowCycle utilizes a **Feature-First Layered Architecture**. Rather than grouping code strictly by technical artifact (e.g., all models together, all controllers together), the codebase is organized around business features, with each feature containing its own self-contained layers:

```text
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                     │
│   (Widgets, Screens, StateControllers, Riverpod Notifiers)  │
└──────────────────────────────┬──────────────────────────────┘
                               │ Observes & Triggers
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                        DOMAIN LAYER                         │
│       (Entities, Calculation Engines, Use Cases / Rules)    │
└──────────────────────────────▲──────────────────────────────┘
                               │ Implements & Supplies Data
┌──────────────────────────────┴──────────────────────────────┐
│                         DATA LAYER                          │
│   (Repositories, Local Data Sources, Remote Firebase APIs)  │
└─────────────────────────────────────────────────────────────┘
```

### Why Feature-First over Pure Clean Architecture?
1. **High Cohesion, Low Coupling:** Women's reproductive features (e.g., Daily Log vs. AI Companion vs. Calendar) have distinct domain logic and data lifecycle models. Feature-first keeps related files in close proximity.
2. **Reduced Boilerplate:** Avoids over-abstracting simple CRUD operations with superfluous use-case interfaces while preserving clean abstraction boundaries where domain complexity warrants it (e.g., the cycle prediction algorithm).
3. **Developer Velocity:** Isolated feature modules allow parallel development without merge conflicts or cross-feature regression risks.

---

## 2. Complete Folder Structure

```text
lib/
├── app/
│   ├── app.dart                     # MaterialApp.router bootstrap widget
│   └── router/
│       ├── app_router.dart          # GoRouter configuration & route guards
│       ├── main_shell.dart          # Bottom navigation shell widget
│       └── route_names.dart         # Path and name string constants
│
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart       # Remote API URLs & keys
│   │   └── app_constants.dart       # Cycle defaults (e.g., 28-day cycle length)
│   ├── error/
│   │   ├── exceptions.dart          # Low-level infrastructure exceptions
│   │   └── failures.dart            # User-facing domain failures
│   ├── services/
│   │   ├── analytics_service.dart   # Analytics event abstraction
│   │   ├── notification_service.dart# Local & push notification scheduler
│   │   └── storage_service.dart     # Secure and key-value storage wrapper
│   ├── theme/
│   │   ├── app_colors.dart          # Color palette & cycle phase tokens
│   │   ├── app_gradients.dart       # Gradient definitions
│   │   ├── app_radius.dart          # Corner radius tokens
│   │   ├── app_shadows.dart         # Elevation shadows
│   │   ├── app_spacing.dart         # Spacing scale & padding helpers
│   │   ├── app_text_styles.dart     # Typography styles
│   │   └── app_theme.dart           # ThemeData light configuration
│   └── utils/
│       ├── date_time_utils.dart     # Cycle date calculation utilities
│       └── extensions.dart          # BuildContext, String, and DateTime helpers
│
├── shared/
│   ├── models/
│   │   ├── app_mode.dart            # CycleAwareness vs. TTC enum
│   │   └── app_state.dart           # Global session data model
│   ├── providers/
│   │   ├── app_mode_provider.dart   # Mode toggle controller
│   │   ├── app_state_provider.dart  # Global state notifier
│   │   └── auth_state_provider.dart # Auth session notifier
│   └── widgets/
│       ├── buttons/                 # Primary, Secondary, Text, Icon buttons
│       ├── cards/                   # Primary, Gradient, Glass, Statistics cards
│       ├── containers/              # RoundedContainer, EmptyStateWidget
│       ├── dialogs/                 # ConfirmationDialog
│       ├── headers/                 # SectionHeader, ScreenHeader
│       ├── indicators/              # PhaseBadge, StatusChip
│       ├── inputs/                  # PrimaryTextField, SearchField
│       └── loading/                 # LoadingIndicator, SkeletonCard
│
├── features/
│   ├── ai_companion/
│   │   ├── data/                    # AI API client, message repository
│   │   ├── domain/                  # Prompt builders, context injection
│   │   └── presentation/            # Chat screen, message bubbles
│   ├── authentication/
│   │   ├── data/                    # FirebaseAuth repository
│   │   ├── domain/                  # Auth validation logic
│   │   └── presentation/            # Login, Register, ForgotPassword screens
│   ├── calendar/
│   ├── daily_log/
│   ├── dashboard/
│   ├── insights/
│   ├── learn/
│   ├── onboarding/
│   ├── patterns/
│   ├── profile/
│   ├── settings/
│   ├── splash/
│   └── subscription/
│
└── main.dart                        # App bootstrap entry point
```

---

## 3. State Management (Riverpod 2.x)

FlowCycle standardizes on **Flutter Riverpod 2.x** with compile-time safety and automatic disposal.

```
┌─────────────────────────────────────────────────────────────┐
│                    RIVERPOD STATE ENGINE                    │
├──────────────────────────────┬──────────────────────────────┤
│ Provider Type                │ Purpose                      │
├──────────────────────────────┼──────────────────────────────┤
│ Provider<T>                  │ Stateless singletons (repos) │
│ NotifierProvider<N, S>       │ Synchronous state (AppMode)  │
│ AsyncNotifierProvider<N, S>  │ Async data with loading/error│
│ StreamProvider<T>            │ Live Firestore streams       │
└──────────────────────────────┴──────────────────────────────┘
```

### 3.1 State Hierarchy
* **Global State:** Placed in `lib/shared/providers/` (`authProvider`, `appModeProvider`, `userPreferencesProvider`). Shared across top-level routing and multiple features.
* **Feature-Level State:** Placed in `lib/features/<feature_name>/presentation/providers/` (e.g., `dailyLogNotifierProvider`, `calendarMonthProvider`). Automatically disposed via `autoDispose` when the screen unmounts.

### 3.2 Guidelines for `ref.watch` vs `ref.read`
* Use **`ref.watch`** inside `build()` methods to rebuild UI whenever the observed state changes.
* Use **`ref.read`** inside callbacks, button event handlers, and lifecycle hooks (`onPressed`, `initState`) to trigger actions without creating unnecessary rebuild subscriptions.
* Use **`ref.listen`** in presentation layers for side-effects (e.g., showing SnackBar alerts or triggering modal dialogs on state change).

---

## 4. Navigation (GoRouter)

FlowCycle uses **GoRouter** to enable declarative routing, persistent bottom-navigation tabs, and declarative route guards.

```text
                                [ App Router ]
                                      │
              ┌───────────────────────┴───────────────────────┐
              ▼                                               ▼
     [ Top-Level Routes ]                           [ StatefulShellRoute ]
  (/splash, /login, /onboarding,                     (Main 5-Tab Bar)
   /ai-companion, /settings)                                  │
                                     ┌──────────┬───────────┬─┴─────────┬──────────┐
                                     ▼          ▼           ▼           ▼          ▼
                                   /home    /calendar   /daily-log  /insights  /profile
```

### 4.1 Key Capabilities:
1. **Stateful Nested Shell:** `StatefulShellRoute.indexedStack` preserves scroll position and state across all 5 primary bottom navigation tabs.
2. **Auth Redirect Guard:** A centralized `redirect` interceptor evaluates `(isAuthenticated, hasCompletedOnboarding)` on every route transition, preventing unauthenticated access to the main dashboard.
3. **Deep Link Readiness:** Standard URI paths (`/calendar?date=2026-08-12` or `/learn/article-123`) configured for universal link integration.

---

## 5. Backend & Cloud Infrastructure (Firebase)

```
┌─────────────────────────────────────────────────────────────┐
│                      FIREBASE BACKEND                       │
├──────────────────────┬──────────────────────────────────────┤
│ Service              │ Responsibility                       │
├──────────────────────┼──────────────────────────────────────┤
│ Firebase Auth        │ Email/Password, Apple Sign-In, Google│
│ Cloud Firestore      │ NoSQL document database (Cycle, Logs)│
│ Firebase Storage     │ Profile avatars, exported PDF reports│
│ Firebase Messaging   │ Push notification delivery (FCM)     │
│ Firebase Analytics   │ Privacy-compliant event telemetry    │
│ Firebase Crashlytics │ Real-time crash diagnostics & logs   │
│ Remote Config        │ Dynamic paywall features & flags     │
└──────────────────────┴──────────────────────────────────────┘
```

---

## 6. Local Storage Strategy

FlowCycle adheres to a tiered local storage paradigm:

| Technology | Data Stored | Justification |
| :--- | :--- | :--- |
| **Flutter Secure Storage** | Auth tokens, refresh tokens, biometric encryption keys | Hardware-backed Keychain (iOS) & EncryptedSharedPreferences (Android). |
| **SharedPreferences** | `isFirstLaunch`, `themeMode`, `currentMode`, simple UI flags | Lightweight key-value storage for non-sensitive configurations. |
| **Local Database (Hive / Isar)** | Offline cycle history, daily symptom logs, cached articles | High-speed NoSQL document storage supporting offline querying and instant app launch. |

---

## 7. Offline-First Architecture

FlowCycle operates with 100% functionality even with zero network connectivity:

```text
[ User Logs Symptom ] ──► [ Save to Local Hive DB ] ──► [ Update UI Instantly ]
                                     │
                                     ▼
                          (Is Internet Available?)
                             ├── Yes ──► [ Sync to Firestore ]
                             └── No  ──► [ Enqueue in Sync Queue ]
                                               │
                                     (Network Reconnected)
                                               │
                                               ▼
                                   [ Flush Pending Sync Queue ]
```

1. **Optimistic Updates:** All user inputs (daily symptoms, cycle dates) are written directly to local storage first, updating the UI immediately.
2. **Background Sync:** A background synchronization engine commits mutations to Cloud Firestore once network connectivity is restored.
3. **Conflict Resolution:** Last-write-wins with millisecond-precision timestamps (`updatedAt`).

---

## 8. AI Health Companion Architecture

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                           AI COMPANION PIPELINE                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  [ User Message ] ──► [ Context Injector ] ──► [ Prompt Sanitizer ]     │
│                              │                                          │
│                     (Pulls cycle phase,                                 │
│                      symptoms & TTC goal)                               │
│                                                                         │
│                                      ▼                                  │
│                          [ Cloud AI Gateway / LLM ]                     │
│                                      │                                  │
│                                      ▼                                  │
│                      [ Medical Guardrail Filter ]                       │
│                                      │                                  │
│                                      ▼                                  │
│                      [ Streaming SSE Response to UI ]                   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Technical Design:
* **Context Window Injection:** The client constructs a prompt payload containing:
  - Active AppMode (`Cycle Awareness` or `TTC`)
  - Current Cycle Day & Phase (e.g., `Day 14, Ovulation Phase`)
  - Recent logged symptoms (past 3 days)
* **Safety Guardrails:** All AI responses pass through an automated medical disclaimer filter and strictly avoid prescribing medications or diagnostic diagnoses.
* **Streaming UI:** Uses Server-Sent Events (SSE) to render characters in real-time, matching modern conversational interfaces.

---

## 9. Notifications Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 NOTIFICATION SCHEDULER                      │
├──────────────────────────────┬──────────────────────────────┤
│ Type                         │ Delivery Mechanism           │
├──────────────────────────────┼──────────────────────────────┤
│ Upcoming Period Reminder     │ flutter_local_notifications  │
│ Fertile Window & Ovulation   │ flutter_local_notifications  │
│ Daily Evening Symptom Log    │ flutter_local_notifications  │
│ Product Updates / Articles   │ Firebase Cloud Messaging     │
└──────────────────────────────┴──────────────────────────────┘
```

* **Local Scheduling:** Period and ovulation reminders are scheduled locally using exact alarm permissions so notifications fire reliably offline without server dependency.
* **Dynamic Rescheduling:** Whenever the user logs a new period, the notification service recalculates and updates future alarm triggers.

---

## 10. Security & Privacy

1. **HIPAA & GDPR Best-Practice Alignment:** Reproductive health data is treated as sensitive Protected Health Information (PHI).
2. **Firestore Security Rules:** Access is restricted per user UID. A user can strictly read and write documents in `/users/{userId}/...`.
3. **Client-Side Biometric Lock:** Optional Face ID / Fingerprint challenge via `local_auth` required to view sensitive logs.
4. **Data Export & Deletion:** One-tap PDF export of cycle logs and complete Account Deletion complying with Apple App Store guidelines.

---

## 11. Error Handling, Logging & Monitoring

* **Failure Abstraction:** Domain repositories return `Result<T, Failure>` or `Either<Failure, T>` rather than throwing unhandled exceptions.
* **Global Error Catcher:** `FlutterError.onError` and `PlatformDispatcher.instance.onError` hook directly into **Firebase Crashlytics**.
* **Structured Logging:** A centralized logger with distinct debug/info/warning/error logs that are stripped in release builds.

---

## 12. Testing Strategy

```text
               ┌──────────────────────────────┐
               │    INTEGRATION TESTS (10%)   │  -> Critical user journeys
               ├──────────────────────────────┤
               │      WIDGET TESTS (30%)      │  -> Shared UI Component Library
               ├──────────────────────────────┤
               │       UNIT TESTS (60%)       │  -> Cycle math, models, repositories
               └──────────────────────────────┘
```

* **Unit Tests (60%):** Test cycle prediction calculations, phase determination, and data serialization.
* **Widget Tests (30%):** Verify all shared widgets (`PrimaryButton`, `StatisticsCard`, `PhaseBadge`, etc.) under varied states and themes.
* **Integration Tests (10%):** Verify complete authentication, onboarding, and daily log submission flows.

---

## 13. Scalability & Future Modules

* **Pregnancy Mode:** Designed to activate as a third `AppMode` without restructuring dashboard architecture.
* **Partner Mode:** Cloud Firestore sub-collection sharing with fine-grained access control.
* **Apple HealthKit & Health Connect:** Data layer is prepared with standardized biomarker converters for bidirectional heart rate, BBT, and menstrual flow sync.

---

## 14. Recommended Production Packages

| Package | Version | Purpose |
| :--- | :--- | :--- |
| `flutter_riverpod` | `^2.6.1` | Robust, compile-safe state management |
| `go_router` | `^14.8.1` | Declarative routing & nested navigation |
| `firebase_core` | `^3.12.0` | Firebase bootstrap SDK |
| `firebase_auth` | `^5.5.1` | Secure authentication & identity |
| `cloud_firestore` | `^5.6.5` | Real-time cloud database |
| `flutter_secure_storage`| `^9.2.4` | Hardware-backed keystore/keychain |
| `shared_preferences` | `^2.5.2` | Simple key-value storage |
| `hive_flutter` | `^1.1.0` | High-speed offline NoSQL database |
| `flutter_local_notifications` | `^18.0.1` | Offline exact-alarm notifications |
| `intl` | `^0.20.2` | Date formatting & localization |
| `google_fonts` | `^6.2.1` | Premium typography (Outfit/Inter) |

---

The technical blueprint has been persisted to [`docs/TAD.md`](file:///C:/Users/HP/.gemini/antigravity-ide/scratch/flowcycle/docs/TAD.md).
Phase 1 Foundation is now 100% complete. Ready for **Phase 2: Core Experience**.
