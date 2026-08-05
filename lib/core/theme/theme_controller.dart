import 'package:flutter/material.dart';

/// App-wide theme mode, defaulting to dark per DESIGN.md. A bare
/// [ValueNotifier] is enough here — no state-management package needed for
/// a single global switch the Settings screen flips and [MyApp] listens to.
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);
