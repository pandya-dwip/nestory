# Nestory

A premium, offline-first personal memory vault for Android. Every day gets one
place to hold a photo and a story — browse them on a calendar, revisit them
by date, and keep the whole vault local to your device.

Built with Flutter, styled after a monochrome glassmorphism design language
("Obsidian Ethereal" — see [`DESIGN.md`](DESIGN.md)): heavy backdrop blur,
translucent glass surfaces, and a restrained black-and-white palette.

## Features

- **Calendar-first browsing** — every month is a page; each day with a memory
  shows its cover photo right on the date.
- **Rich memories** — title, description, multiple photos per entry, tags,
  and per-photo display modes (fill / fit / landscape / portrait priority).
- **Fully offline** — all data and photos are stored locally via a normalized
  SQLite database (Drift); nothing leaves the device unless you export it.
- **Backup & restore** — export the entire vault (database + photos) to a
  single archive, or restore from one.
- **Profile & settings** — editable profile with photo and bio, theme
  control, storage usage stats, and demo data seeding for trying the app out.
- **Search** — find memories by title, description, or tag.

## Tech stack

- [Flutter](https://flutter.dev) / Dart, Material 3
- [Drift](https://drift.simonbinder.eu) (SQLite ORM) for local persistence
- `image_picker` / `file_picker` for photo and file selection
- `archive` for backup/restore packaging
- `path_provider` for on-device file storage

## Getting started

```bash
flutter pub get
flutter run
```

The app targets Android. On first launch it seeds a small set of demo
memories (with real sample photos) so the calendar isn't empty — clear or
regenerate demo data any time from Settings.

## Project structure

```
lib/
  core/        # Theme tokens (colors, typography, spacing, glass effects)
  shared/      # Reusable widgets and cross-feature models
  data/        # Drift database, DAOs, repositories, services (backup, storage)
  features/    # Home (calendar), memory details/editing, profile, settings, search
```
