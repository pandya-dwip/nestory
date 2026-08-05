# Nestory

A premium, offline-first personal memory vault for Android, built with
Flutter, Material 3, and a local SQLite database (Drift). Every day gets one
place to hold a photo and a story — browse them on a calendar, revisit them
by date, and keep the whole vault private on your device. No accounts, no
cloud, no network calls.

Styled after **Obsidian Ethereal**, a custom monochrome glassmorphism design
language (see [`DESIGN.md`](DESIGN.md)): heavy backdrop blur, translucent
glass surfaces, and a restrained black-and-white palette.

![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/Material-3-757575?logo=materialdesign&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-Drift-003B57?logo=sqlite&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)

## Key Features & Highlights

### 1. Calendar-First Memory Browsing
- Every month is its own page in a vertical scroll, with independent month
  and year pickers in the header.
- Any day with a memory shows its cover photo directly on the date circle.
- Tap a date to open a glass bottom sheet with that day's memories, then
  drill into a full memory card and details screen.

### 2. Rich Memory Entries
- Title, description, multiple photos, tags, and a favorite flag per memory.
- Per-photo display modes — **Fill**, **Fit**, **Landscape priority**, or
  **Portrait priority** — chosen individually for each photo in an entry.

### 3. Fully Offline Local Database
- A normalized SQLite schema via [Drift](https://drift.simonbinder.eu):
  `Memories`, `MemoryPhotos`, `Tags`, `MemoryTags`, `Profile`, and
  `AppSettings`, with foreign keys, cascading deletes, indexes, and versioned
  migrations.
- Everything — records and photos alike — lives on-device.

### 4. Search
- Find memories instantly by title, description, or tag.

### 5. Profile
- Editable name, bio, and profile photo, permanently copied into app storage
  so it survives restarts.
- At-a-glance stats: total memories, photos, tags, and first-memory year.

### 6. Backup & Restore
- Export the entire vault — database and photos — into a single archive.
- Restore from a previous backup archive at any time.

### 7. Settings
- Theme control, on-device storage usage breakdown, demo data seeding
  (with real bundled sample photos) for trying the app risk-free, "delete
  all memories" (keeps your profile and settings), and About / Privacy
  Policy screens.

### 8. Privacy by Design
- No accounts, no backend, no analytics, no network calls. The vault never
  leaves your device unless you explicitly export it.

## Architecture & Tech Stack

The project separates theme tokens, shared UI, data/persistence, and
features into distinct layers:

```
lib/
├── core/
│   └── theme/          # Colors, typography, spacing, glassmorphism tokens
├── data/
│   ├── db/              # Drift AppDatabase, tables, DAOs
│   ├── demo/             # Bundled demo memory definitions
│   ├── repositories/      # MemoryRepository, ProfileRepository, AppSettingsRepository
│   └── services/          # Image storage, backup/restore, storage stats
├── shared/
│   ├── models/             # Memory, PhotoDisplayMode
│   └── widgets/             # Glass components, date circle, memory card, photo carousel...
└── features/
    ├── home/                 # Calendar + month/year pickers
    ├── memory/                # Memory details, create/edit, photo picker
    ├── profile/
    ├── search/
    └── settings/               # Settings, About, Privacy Policy
```

### Core Libraries & Packages

| Package | Purpose |
|---|---|
| `flutter` | Mobile application framework |
| `drift` & `drift_flutter` | Reactive SQLite ORM for local database persistence |
| `image_picker` | Camera & gallery integration for memory and profile photos |
| `file_picker` | Native file picker for choosing/saving backup archives |
| `archive` | Zip packaging for vault backup and restore |
| `path_provider` / `path` | On-device file and directory management |
| `cupertino_icons` | iOS-style icon set |

## Getting Started

### Prerequisites
- Flutter SDK 3.44 or higher (Dart 3.12+, bundled with Flutter)
- Android Studio or VS Code with the Flutter extension
- Android SDK, API 21+ (Android 5.0+)

### Installation & Setup

```bash
git clone https://github.com/pandya-dwip/nestory.git
cd nestory
flutter pub get
flutter run
```

The app targets Android. On first launch it seeds a small set of demo
memories (with real sample photos) so the calendar isn't empty — clear or
regenerate demo data any time from Settings.

If you modify the database schema in `lib/data/db/`, regenerate the Drift
code with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing & Analysis

```bash
flutter test
flutter analyze
```

---

If you find this project interesting, consider giving it a star on GitHub!
