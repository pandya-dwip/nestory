# Nestory

A private, offline-first personal memory vault and calendar companion for Android, built with Flutter, Material 3, and Drift (SQLite). Nestory gives every day a dedicated canvas to capture personal memories, photographs, and scheduled calendar events — browse them on a continuous monthly scroll, revisit them by date, and keep your personal data strictly on your device.

Styled with **Obsidian Ethereal**, a custom monochrome glassmorphism design language (detailed in [`DESIGN.md`](DESIGN.md)): deep void backgrounds, translucent surfaces, subtle specular borders, and a restrained black-and-white aesthetic.

[![Flutter](https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Material 3](https://img.shields.io/badge/Material-3-757575?logo=materialdesign&logoColor=white)](https://m3.material.io)
[![SQLite](https://img.shields.io/badge/SQLite-Drift-003B57?logo=sqlite&logoColor=white)](https://drift.simonbinder.eu)
[![Platform](https://img.shields.io/badge/Platform-Android_API_21+-3DDC84?logo=android&logoColor=white)](https://developer.android.com)
[![Privacy](https://img.shields.io/badge/Privacy-100%25_Offline--First-00C853)](https://github.com)
[![Tests](https://img.shields.io/badge/Tests-32%20passed-success)](test)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
  - [1. Calendar-First Browsing & Day Agenda](#1-calendar-first-browsing--day-agenda)
  - [2. Personal Memory Vault](#2-personal-memory-vault)
  - [3. Offline-First Google Calendar Sync](#3-offline-first-google-calendar-sync)
  - [4. Physical Database Isolation (Zero Cloud Leakage)](#4-physical-database-isolation-zero-cloud-leakage)
  - [5. Full Vault Backup & Lossless Restore](#5-full-vault-backup--lossless-restore)
  - [6. Profile & Storage Analytics](#6-profile--storage-analytics)
- [Design Language: Obsidian Ethereal](#design-language-obsidian-ethereal)
- [Architecture & Directory Structure](#architecture--directory-structure)
- [Database Schemas & Persistence](#database-schemas--persistence)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation & Build](#installation--build)
  - [Database Code Generation](#database-code-generation)
- [Google Calendar Setup Guide (Open-Source / Self-Hosted)](#google-calendar-setup-guide-open-source--self-hosted)
  - [1. Google Cloud Project Setup](#1-google-cloud-project-setup)
  - [2. Obtaining Your Keystore SHA-1 Fingerprint](#2-obtaining-your-keystore-sha-1-fingerprint)
  - [3. Creating Android OAuth 2.0 Credentials](#3-creating-android-oauth-20-credentials)
  - [4. Building with Optional Environment Variables](#4-building-with-optional-environment-variables)
- [Testing & Quality Assurance](#testing--quality-assurance)
- [Privacy & Security Commitment](#privacy--security-commitment)
- [License](#license)

---

## Overview

Most calendar apps prioritize corporate meetings and productivity at the expense of personal reflection. Most journal apps sequester memories into isolated feeds disconnected from daily context.

**Nestory bridges both worlds:**
1. **The Calendar is Your Canvas**: Every day holds your scheduled life (appointments, celebrations, daily events) alongside the memories you made on that date.
2. **Offline-First & Sovereign**: Your personal journals, private photos, and profile never leave your device unless you explicitly export an encrypted-ready backup archive.
3. **Seamless Cloud Sync**: Google Calendar syncs two-ways using an offline mutation outbox, delta tokens, and idempotent recovery — all while remaining completely physically separated from your personal memory database.

---

## Key Features

### 1. Calendar-First Browsing & Day Agenda
- **Infinite Rolling Calendar**: Smooth, physics-driven vertical scrolling spanning 100+ years of history with physical wheel-roll tilt transitions on month boundaries.
- **Fast Month & Year Jump**: Bottom sheet jump picker allowing instant navigation to any month across decades without endless scrolling.
- **Visual Memory Covers**: Days with memories display their cover photographs directly inside the calendar cell, turning your monthly view into a living visual scrapbook.
- **Titanium Event Dots**: Subtle monochrome badges signify scheduled events for the day.
- **Unified Day Agenda**: Tap any date to reveal an Obsidian Ethereal bottom sheet displaying all scheduled events and personal memories side-by-side, with instant inline creation, editing, and deletion.

### 2. Personal Memory Vault
- **Multi-Photo Stories**: Attach multiple high-resolution photos to any memory entry with seamless camera or gallery import.
- **Flexible Photo Framing Modes**: Customize how each photograph is presented:
  - **Fill**: Uniform edge-to-edge crop for balanced grid layouts.
  - **Fit**: Complete uncropped letterboxed view preserving the entire composition.
  - **Landscape Priority**: Dynamically adapts aspect ratio to horizontal photography.
  - **Portrait Priority**: Dynamically adapts aspect ratio to vertical photography.
- **Rich Metadata & Tag Taxonomy**: Organize entries with custom tags, rich descriptions, and favorite bookmarks.
- **Instant Search**: Real-time full-text search across memory titles, descriptions, and tag categories.

### 3. Offline-First Google Calendar Sync
- **Two-Way Synchronization**: Synchronize events with Google Calendar using efficient delta sync tokens (`nextSyncToken`) without blocking the UI or draining battery.
- **Offline Mutation Outbox**: Create, update, or delete calendar events completely offline. Mutations are enqueued in a persistent SQLite outbox (`calendar_outbox` table) and drained automatically when connectivity resumes.
- **Idempotent Mutation IDs**: Mutations use base32hex UUIDs conforming to Google Calendar client event specifications (`[0-9a-v]{5,1024}`) to safely prevent duplicate event creation across retries.
- **Self-Healing Error Recovery**:
  - **HTTP 410 (Gone / Expired Token)**: Automatically purges invalid sync tokens and performs a clean resync without data loss.
  - **HTTP 412 (Precondition Failed)**: Preserves conflicting changes in an audit table (`sync_conflicts`) so no edits are silently lost.
- **Multi-Calendar Toggle**: View all calendars associated with your Google account and selectively toggle which ones display and synchronize in Nestory.

### 4. Physical Database Isolation (Zero Cloud Leakage)
Nestory enforces a strict security boundary by maintaining two completely distinct SQLite database files:
1. `nestory.sqlite`: Contains your personal memories, photo records, tags, and profile metadata.
2. `calendar_cache.sqlite`: Contains cached Google Calendar events, outbox queues, and sync metadata.

Because the Google Calendar synchronization service operates exclusively on `calendar_cache.sqlite`, it is physically impossible for cloud synchronization routines to read, write, upload, or compromise your personal journal and photo vault.

### 5. Full Vault Backup & Lossless Restore
- **Self-Contained Archives**: Export your entire vault — including the SQLite database and all original high-resolution photos — into a single `.zip` archive.
- **Lossless Restore**: Restore your archive onto any Android device running Nestory at any time. Ideal for device migrations, clean reinstalls, or offline archiving.

### 6. Profile & Storage Analytics
- **Local Profile**: Configure display name, personal bio, and profile avatar stored locally on-device.
- **Storage Footprint Breakdown**: Real-time analytics displaying total memories, attached photos, and physical disk space occupied by the vault.

---

## Design Language: Obsidian Ethereal

Nestory is crafted around **Obsidian Ethereal**, an original monochrome design system optimized for modern OLED displays:

- **Deep Void Backgrounds**: Pure `#0A0A0A` obsidian surfaces minimize power consumption and eliminate visual clutter.
- **Translucent Glassmorphism**: Cards and navigation bars feature subtle Gaussian blur (`BackdropFilter`), semi-transparent fills, and hairline specular borders (`#FFFFFF` at 6–12% opacity).
- **Titanium & Ash Typography**: High-contrast titanium silver (`#EDEDED`) headers paired with muted ash (`#8E8E93`) secondary text for effortless readability.
- **Fluid Motion**: Spring-damped transitions, sheet reveals, and tactile haptic feedback accompany user interactions.

For detailed design specifications, color tokens, and elevation guidelines, consult [`DESIGN.md`](DESIGN.md).

---

## Architecture & Directory Structure

Nestory follows a clean, reactive layered architecture separating presentation widgets, reactive state repositories, typed SQLite DAOs, and background synchronization services:

```
lib/
├── core/
│   └── theme/                       # Colors, typography, spacing, glass tokens (Obsidian Ethereal)
├── data/
│   ├── db/
│   │   ├── app_database.dart        # Personal Vault SQLite DB (Memories, Photos, Tags, Profile)
│   │   ├── calendar/                # Calendar SQLite DB (Events, Outbox, Meta, Conflicts)
│   │   │   ├── calendar_database.dart
│   │   │   └── daos/                # Typed Drift DAOs (events, outbox, accounts, conflicts)
│   │   └── daos/                    # Personal vault DAOs (memories, tags, profile)
│   ├── demo/                        # Seed data definitions for initial app onboarding
│   ├── repositories/                # Reactive ChangeNotifier repositories (Memory, Calendar, Settings)
│   └── services/                    # GoogleAuth, CalendarSync, Backup/Restore, StorageStats
├── shared/
│   ├── models/                      # Immutable domain models (Memory, CalendarEvent, Framing)
│   └── widgets/                     # Reusable glass surfaces, buttons, date badges, cards
└── features/
    ├── home/                        # Calendar grid view, month/year wheel picker, day agenda sheet
    ├── memory/                      # Memory composer, details screen, photo previewer
    ├── calendar/                    # Event editor modal, calendar visibility toggles
    ├── profile/                     # Profile details, vault statistics, disk usage
    ├── search/                      # Real-time full-text memory and tag search
    └── settings/                    # Backup/restore, sync controls, demo data management
```

---

## Database Schemas & Persistence

### 1. Personal Vault Database (`nestory.sqlite`)

| Table | Purpose |
|---|---|
| `memories` | UUID, title, description, timestamp, favorite flag, created/updated timestamps |
| `photos` | UUID, foreign key to memory, local file path, display mode (`fill`, `fit`, `landscape`, `portrait`), sort order |
| `tags` | Unique tag names and colors |
| `memory_tags` | Many-to-many relationship mapping memories to tags |
| `user_profile` | Single-row table holding user display name, bio, and avatar file path |

### 2. Calendar Cache Database (`calendar_cache.sqlite`)

| Table | Purpose |
|---|---|
| `calendar_accounts` | Google account email, display name, and auth state |
| `calendars_meta` | Sub-calendars (ID, summary, color, visibility toggle, sync token) |
| `calendar_events` | Cached events (ID, calendar ID, title, start/end time, location, description, status) |
| `calendar_outbox` | FIFO queue for offline mutations (`create`, `update`, `delete`) with retry counter |
| `sync_conflicts` | Audit log of HTTP 412 conflicts preserving rejected local changes |

---

## Getting Started

### Prerequisites
- **Flutter SDK**: `3.44.0` or higher ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: `3.12.0` or higher
- **Android Studio** or **VS Code** with Flutter extensions installed
- **Android SDK**: API level 21 or higher (Android 5.0 Lollipop+)
- A physical Android device or emulator with Google Play Services enabled

### Installation & Build

1. **Clone the repository**:
   ```bash
   git clone https://github.com/<your-username>/nestory.git
   cd nestory
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on a connected device**:
   ```bash
   flutter run
   ```

4. **Build a release APK**:
   ```bash
   flutter build apk --release
   ```

### Database Code Generation

Nestory uses [Drift](https://drift.simonbinder.eu/) for type-safe SQLite database access. When modifying tables or DAO queries, regenerate the database code with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Google Calendar Setup Guide (Open-Source / Self-Hosted)

Google Calendar integration in Nestory is completely optional. If you choose to enable it for your personal build or fork, follow these instructions to register your own OAuth 2.0 client in Google Cloud Console.

> [!NOTE]
> On Android, Google Sign-In authenticates securely via Google Play Services on your device using your app's **Android Package Name** and **Keystore SHA-1 Fingerprint**. No secret keys or private credentials need to be stored in the repository.

### 1. Google Cloud Project Setup

1. Open the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project (e.g., `nestory-calendar`).
3. Navigate to **APIs & Services > Library**, search for **Google Calendar API**, and click **Enable**.
4. Navigate to **APIs & Services > OAuth consent screen**:
   - User Type: Select **External**.
   - App Name: `Nestory` (or your preferred name).
   - User support email & Developer contact: Your email address.
   - Click **Save and Continue**.
5. Under **Audience > Test users**:
   - Click **Add Users** and enter the Gmail address(es) you intend to use for testing.

### 2. Obtaining Your Keystore SHA-1 Fingerprint

To allow Google Play Services to authorize your application, extract the SHA-1 certificate fingerprint of your local Android debug keystore:

**Option A — Using Gradle (Recommended):**
```bash
# On Linux / macOS:
cd android && ./gradlew signingReport

# On Windows PowerShell:
cd android; .\gradlew.bat signingReport
```
Look for the `SHA1` entry under the `debug` variant (e.g., `Variant: debugAndroidTest, Config: debug`).

**Option B — Using Java Keytool:**
```bash
# On Windows PowerShell:
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# On macOS / Linux:
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### 3. Creating Android OAuth 2.0 Credentials

1. In the Google Cloud Console, navigate to **APIs & Services > Credentials**.
2. Click **Create Credentials > OAuth client ID**.
3. Select **Application type**: **Android**.
4. Fill in the details:
   - **Name**: `Nestory Android Client`
   - **Package name**: `com.nestory.app` (or your custom package name defined in `android/app/build.gradle.kts`)
   - **SHA-1 certificate fingerprint**: Paste the SHA-1 string obtained in Step 2.
5. Click **Create**.

Google Play Services on your device will now automatically authorize sign-in requests matching this package name and signing key.

### 4. Building with Optional Environment Variables

If you configure a Web Client ID or wish to specify a custom client ID at build time, pass it via `--dart-define` without editing source code:

```bash
flutter run --dart-define=GOOGLE_CLIENT_ID=<YOUR_CLIENT_ID>.apps.googleusercontent.com
```

---

## Testing & Quality Assurance

Nestory maintains a comprehensive test suite covering schema migrations, reactive caching, outbox persistence, backup isolation, and synchronization logic:

```bash
# Run all unit, repository, and widget tests
flutter test

# Run static analysis and linting
flutter analyze
```

### Test Coverage Highlights
- **Schema & Migration Tests**: Verifies table creation, version upgrades, and index performance for both databases.
- **Outbox Persistence Tests**: Ensures pending offline mutations survive database reboots and unexpected application closures.
- **Idempotent Sync Recovery**: Validates HTTP 409 duplicate recovery and Google Calendar base32hex event ID compliance.
- **Sync Engine Engine Resilience**: Simulates HTTP 410 expired tokens, incremental delta sync pagination, and HTTP 412 concurrency conflicts.
- **Memory Vault CRUD & Search**: Asserts reactive cache consistency across insertions, photo attachments, deletions, and multi-field queries.

---

## Privacy & Security Commitment

- **Zero Analytics & Telemetry**: Nestory contains no third-party tracking libraries, advertising SDKs, or behavioral analytics services.
- **Local SQLite Storage**: Your memories, photographs, tags, and profile stay strictly inside your device's sandboxed storage directory.
- **Isolated Sync Surface**: The calendar sync service can only interact with the calendar cache database, ensuring personal memories are never accessible over the network.
- **Encrypted-Ready Exports**: Full backups are generated locally and handed directly to your system file picker without uploading to intermediate servers.
- **Network Scope Transparency**: Network connectivity permissions are strictly utilized for communicating with Google Calendar endpoints (`googleapis.com`) when explicitly enabled by the user.

---

## License

This project is licensed under the [MIT License](LICENSE) — see the LICENSE file for details.
