/// Definitions for "Set Demo Data" — realistic memories backed by real
/// bundled photographs (see `assets/demo_photos/`), never generated
/// placeholders or network fetches.
class DemoMemoryDef {
  const DemoMemoryDef({
    required this.title,
    required this.description,
    required this.monthsAgo,
    required this.day,
    required this.tags,
    required this.photoAssets,
    this.isFavorite = false,
  });

  final String title;
  final String description;

  /// Months before "now" — 0 means this month.
  final int monthsAgo;

  /// Day of month, clamped to the target month's length.
  final int day;

  final List<String> tags;
  final List<String> photoAssets;
  final bool isFavorite;

  DateTime dateFor(DateTime now) {
    final target = DateTime(now.year, now.month - monthsAgo, 1);
    final lastDayOfMonth = DateTime(target.year, target.month + 1, 0).day;
    return DateTime(target.year, target.month, day.clamp(1, lastDayOfMonth));
  }
}

const _assetDir = 'assets/demo_photos';

final demoMemoryDefs = <DemoMemoryDef>[
  DemoMemoryDef(
    title: 'Movie Night',
    description: 'Popcorn, dimmed lights, and a film none of us could agree on beforehand — worth it anyway.',
    monthsAgo: 0,
    day: 3,
    tags: const ['Friends', 'Evening'],
    photoAssets: const ['$_assetDir/nestory_movie-1.jpg', '$_assetDir/nestory_movie-2.jpg'],
  ),
  DemoMemoryDef(
    title: 'Goa Trip',
    description: 'Salt air, late sunsets, and a week that felt twice as long in the best way.',
    monthsAgo: 1,
    day: 14,
    tags: const ['Travel', 'Beach', 'Friends'],
    photoAssets: const [
      '$_assetDir/nestory_goa-1.jpg',
      '$_assetDir/nestory_goa-2.jpg',
      '$_assetDir/nestory_goa-3.jpg',
      '$_assetDir/nestory_goa-4.jpg',
      '$_assetDir/nestory_goa-5.jpg',
    ],
    isFavorite: true,
  ),
  DemoMemoryDef(
    title: 'Birthday Celebration',
    description: 'Too much cake, a slightly off-key round of singing, and everyone I love in one room.',
    monthsAgo: 2,
    day: 21,
    tags: const ['Family', 'Celebration'],
    photoAssets: const [
      '$_assetDir/nestory_birthday-1.jpg',
      '$_assetDir/nestory_birthday-2.jpg',
      '$_assetDir/nestory_birthday-3.jpg',
      '$_assetDir/nestory_birthday-4.jpg',
    ],
    isFavorite: true,
  ),
  DemoMemoryDef(
    title: 'College Farewell',
    description: 'Four years condensed into one long afternoon of photos, signatures, and promises to keep in touch.',
    monthsAgo: 3,
    day: 9,
    tags: const ['Friends', 'Milestone'],
    photoAssets: const [
      '$_assetDir/nestory_college-1.jpg',
      '$_assetDir/nestory_college-2.jpg',
      '$_assetDir/nestory_college-3.jpg',
      '$_assetDir/nestory_college-4.jpg',
    ],
  ),
  DemoMemoryDef(
    title: 'First Salary',
    description: 'Framed the payslip, then immediately spent too much of it on dinner for the people who got me here.',
    monthsAgo: 4,
    day: 1,
    tags: const ['Milestone', 'Career'],
    photoAssets: const ['$_assetDir/nestory_salary-1.jpg', '$_assetDir/nestory_salary-2.jpg'],
  ),
  DemoMemoryDef(
    title: 'Family Dinner',
    description: 'No occasion, just a Sunday table that somehow fit six conversations at once.',
    monthsAgo: 0,
    day: 10,
    tags: const ['Family', 'Food'],
    photoAssets: const [
      '$_assetDir/nestory_dinner-1.jpg',
      '$_assetDir/nestory_dinner-2.jpg',
      '$_assetDir/nestory_dinner-3.jpg',
    ],
  ),
  DemoMemoryDef(
    title: 'Trekking Adventure',
    description: 'Twelve kilometers, one wrong turn, and a summit view that made the wrong turn worth it.',
    monthsAgo: 5,
    day: 17,
    tags: const ['Adventure', 'Mountains'],
    photoAssets: const [
      '$_assetDir/nestory_trek-1.jpg',
      '$_assetDir/nestory_trek-2.jpg',
      '$_assetDir/nestory_trek-3.jpg',
      '$_assetDir/nestory_trek-4.jpg',
      '$_assetDir/nestory_trek-5.jpg',
    ],
  ),
];
