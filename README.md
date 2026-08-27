# 🌸 FlowCycle — Smart Menstrual & Fertility Intelligence Companion

[![Flutter CI](https://github.com/your-org/flowcycle/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/your-org/flowcycle/actions/workflows/flutter_ci.yml)
[![Tests](https://img.shields.io/badge/Tests-170%20Passed-success.svg)](test/)
[![Flutter](https://img.shields.io/badge/Flutter-3.24%2B-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)
[![Privacy](https://img.shields.io/badge/Privacy-Offline--First-green.svg)](docs/PRIVACY_POLICY.md)

**FlowCycle** is a privacy-first, medically-grounded menstrual cycle tracker and fertility intelligence companion built with Flutter. Featuring two adaptive modes (**Cycle Awareness** and **Trying to Conceive**), an on-device AI Companion powered by Google Gemini, biphasic Basal Body Temperature (BBT) thermal analysis, docked glowing quick-log action bar, and offline local data storage.

---

## ✨ Key Features

### 🌟 1. Dual-Mode Clinical Adaptation
* **Cycle Awareness Mode**: 4-phase biological cycle ring (Menstrual, Follicular, Ovulation, Luteal), daily hormone level curve, dynamic energy/mood forecasts, and phase celebration alerts.
* **Trying to Conceive (TTC) Mode**: 6-day fertile window countdown, daily pregnancy chance probability meter (Low, Medium, High, Peak), ovulation predictor kit (OPK/LH) tracker, and intimacy logs.

### 🧠 2. AI Companion & Learn Hub (Google Gemini & Offline Fallback)
* **Real-time Streaming Chat**: Context-aware clinical guidance and phase-based health tips with real-time token streaming.
* **100% Free & Air-Gapped**: Built-in offline clinical intelligence engine delivers recommendations with zero cloud requirement.
* **Curated Article Library**: Evidence-backed articles on PCOS, endometriosis, fertility optimization, and cycle nutrition.

### 📊 3. Interactive Biomarker Scrubbing & OB-GYN Export
* **Biphasic BBT Thermal Scrubbing**: Interactive touch-scrubbing curve tracking the post-ovulatory progesterone thermal shift.
* **Docked Glowing Action Bar**: Centered 52dp quick-log floating action button for rapid logging of flow, cramps, cervical mucus, mood, sleep, water, and supplements.
* **Doctor Clinical Export**: 1-Tap PDF & CSV report generation for OB-GYN consultations.

### 🔒 4. Uncompromising Privacy & Security
* **Offline-First Storage**: Intimate health data remains locally on the user's device.
* **Zero Ad Tracking**: No third-party data broker analytics or tracking pixels.
* **PIN & Biometric Lock**: Optional 4-digit passcode shield.
* **Pluggable Authentication**: Supports Google Sign-In, Apple Sign-In (with private relay), and Email.

---

## 🏗️ Architecture & Tech Stack

```
lib/
├── app/
│   ├── app.dart                    # Main MaterialApp setup
│   └── router/                     # GoRouter declarative navigation
├── core/
│   ├── data/                       # AppDataManager & DemoDataGenerator
│   ├── database/                   # LocalDatabaseService (Offline JSON/SQLite)
│   ├── services/                   # AiService, AuthService, NotificationService
│   └── theme/                      # AppColors, AppGradients, Typography, Radius
├── features/
│   ├── ai_companion/               # AI Chat, Article Reader, Smart Reminders
│   ├── authentication/             # Login, Register, Social Auth Buttons
│   ├── calendar/                   # Dual-Mode Month View & Cycle Day Dots
│   ├── daily_log/                  # Biomarker & Symptom Logging Modal
│   ├── dashboard/                  # Cycle Awareness & TTC Hero Ring Dashboards
│   ├── insights/                   # Fertility Score, Trends, & BBT Curves
│   ├── onboarding/                 # 5-Step Personalized Intake Flow
│   ├── patterns/                   # Regularity Metrics & OB-GYN Export Sheet
│   ├── profile/                    # User Profile, Theme Switcher & Settings
│   └── splash/                     # Animated Splash & Welcome Screen
└── shared/
    ├── models/                     # UserProfile, DailyLogEntry, AppMode
    ├── providers/                  # CycleDataController & AppScope
    └── widgets/                    # Docked Glowing Nav Bar, Micro-Animations
```

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (3.24.0 or higher)
* Dart SDK (3.5.0 or higher)

### Installation
```bash
# Clone the repository
git clone https://github.com/your-org/flowcycle.git

# Navigate into project directory
cd flowcycle

# Install dependencies
flutter pub get

# Run all automated tests
flutter test

# Start the application on Chrome / Desktop
flutter run -d chrome
```

---

## 🧪 Testing & Verification

FlowCycle maintains an automated test suite with **170 passing tests across 34 test files**:

```bash
flutter test
```

| Component | Test Suite | Status |
| :--- | :--- | :--- |
| **Authentication & Social Sign-In** | `test/features/authentication/` | ✅ Passing |
| **Gemini AI & Offline Companion** | `test/features/ai_companion/` | ✅ Passing |
| **Dual Dashboards & Cycle Rings** | `test/features/dashboard/` | ✅ Passing |
| **Daily Biomarker Logging** | `test/features/daily_log/` | ✅ Passing |
| **Insights & BBT Thermal Curves** | `test/features/insights/` | ✅ Passing |
| **Patterns & Doctor Export** | `test/features/patterns/` | ✅ Passing |
| **Global State Sync & Persistence** | `test/features/state_sync/` | ✅ Passing |
| **Demo Data Generator** | `test/core/data/` | ✅ Passing |
| **Multi-Device Responsiveness** | `test/shared/` | ✅ Passing |

---

## 📄 Documentation

* [App Store & Google Play Listing](docs/APP_STORE_LISTING.md)
* [Health Data Privacy Policy](docs/PRIVACY_POLICY.md)
* [Complete Implementation Walkthrough](walkthrough.md)

---

## ⚖️ License

Distributed under the MIT License. See `LICENSE` for more information.
