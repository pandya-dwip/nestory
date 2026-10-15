import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nestory/data/db/app_database.dart';
import 'package:nestory/data/demo/demo_memories.dart';
import 'package:nestory/data/repositories/memory_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late MemoryRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.setInstanceForTesting(db);
    repo = MemoryRepository.instance;
    await repo.reload();
  });

  tearDown(() async {
    await db.close();
    AppDatabase.setInstanceForTesting(null);
  });

  group('Memory Vault Regression Tests (CRUD, Favorites, Deletion)', () {
    test(
      'Create memory saves to database and populates reactive repository cache',
      () async {
        final date = DateTime(2026, 10, 14);
        final created = await repo.create(
          title: 'Autumn Walk in Kyoto',
          description:
              'Golden maples and cool mountain breeze near Arashiyama.',
          date: date,
          tags: ['travel', 'kyoto', 'autumn'],
          photoPaths: const [],
          isFavorite: false,
        );

        expect(created.id, isPositive);
        expect(created.title, 'Autumn Walk in Kyoto');
        expect(created.tags, containsAll(['travel', 'kyoto', 'autumn']));
        expect(created.isFavorite, isFalse);

        // Verify in repository cache
        expect(repo.all.length, 1);
        expect(repo.all.first.id, created.id);
        expect(repo.hasMemoriesOn(date), isTrue);
        expect(repo.onDate(date).first.title, 'Autumn Walk in Kyoto');
      },
    );

    test(
      'Update memory modifies title, description, date, and tags without data corruption',
      () async {
        final date = DateTime(2026, 10, 10);
        final created = await repo.create(
          title: 'Initial Title',
          description: 'Draft notes',
          date: date,
          tags: ['draft'],
          photoPaths: const [],
        );

        final newDate = DateTime(2026, 10, 12);
        await repo.update(
          id: created.id,
          title: 'Finalized Memory',
          description: 'Complete memory description with reflections.',
          date: newDate,
          tags: ['journal', 'reflections'],
          photoPaths: const [],
          isFavorite: true,
        );

        final updated = repo.byId(created.id);
        expect(updated, isNotNull);
        expect(updated!.title, 'Finalized Memory');
        expect(
          updated.description,
          'Complete memory description with reflections.',
        );
        expect(updated.date, newDate);
        expect(updated.tags, containsAll(['journal', 'reflections']));
        expect(updated.isFavorite, isTrue);

        // Old date must no longer have memories, new date must
        expect(repo.hasMemoriesOn(date), isFalse);
        expect(repo.hasMemoriesOn(newDate), isTrue);
      },
    );

    test('Toggle favorite flips isFavorite state correctly', () async {
      final created = await repo.create(
        title: 'Stargazing at Joshua Tree',
        description: 'Milky way was clearly visible.',
        date: DateTime(2026, 9, 20),
        tags: ['night', 'stars'],
        photoPaths: const [],
        isFavorite: false,
      );

      expect(repo.byId(created.id)!.isFavorite, isFalse);

      await repo.toggleFavorite(created.id);
      expect(repo.byId(created.id)!.isFavorite, isTrue);

      await repo.toggleFavorite(created.id);
      expect(repo.byId(created.id)!.isFavorite, isFalse);
    });

    test(
      'Delete memory removes entry from database and reactive cache',
      () async {
        final m1 = await repo.create(
          title: 'Memory 1',
          description: 'To be kept',
          date: DateTime(2026, 8, 1),
          tags: ['keep'],
          photoPaths: const [],
        );
        final m2 = await repo.create(
          title: 'Memory 2',
          description: 'To be deleted',
          date: DateTime(2026, 8, 2),
          tags: ['delete'],
          photoPaths: const [],
        );

        expect(repo.all.length, 2);

        await repo.delete(m2.id);

        expect(repo.all.length, 1);
        expect(repo.byId(m2.id), isNull);
        expect(repo.byId(m1.id), isNotNull);
      },
    );
  });

  group('Memory Search & Statistics', () {
    test('Search finds memories by title, description, and tags', () async {
      await repo.create(
        title: 'Nordic Cabin Weekend',
        description: 'Fireside reading in snowstorm',
        date: DateTime(2026, 1, 15),
        tags: ['winter', 'norway'],
        photoPaths: const [],
      );

      await repo.create(
        title: 'Espresso Tasting in Rome',
        description: 'Visited small roasteries near the Pantheon',
        date: DateTime(2026, 5, 20),
        tags: ['coffee', 'italy'],
        photoPaths: const [],
      );

      // Search by title substring
      expect(repo.search('Nordic').length, 1);
      expect(repo.search('Nordic').first.title, 'Nordic Cabin Weekend');

      // Search by description substring
      expect(repo.search('roasteries').length, 1);
      expect(repo.search('roasteries').first.title, 'Espresso Tasting in Rome');

      // Search by tag
      expect(repo.search('norway').length, 1);
      expect(repo.search('italy').length, 1);

      // Search case insensitivity
      expect(repo.search('ESPRESSO').length, 1);

      // Empty query returns nothing
      expect(repo.search('   '), isEmpty);
    });

    test(
      'Statistics calculate total memories, unique tags, and first memory year',
      () async {
        await repo.create(
          title: 'Graduation Day',
          description: 'University graduation ceremony',
          date: DateTime(2022, 6, 15),
          tags: ['milestone', 'education'],
          photoPaths: const [],
        );

        await repo.create(
          title: 'First Solo Hike',
          description: 'Pacific Crest Trail section',
          date: DateTime(2025, 7, 4),
          tags: ['hike', 'milestone'], // 'milestone' is duplicate
          photoPaths: const [],
        );

        expect(repo.totalMemories, 2);
        expect(repo.totalTags, 3); // ['milestone', 'education', 'hike']
        expect(repo.firstMemoryYear, 2022);
      },
    );
  });

  group('Demo Memory Definitions', () {
    test(
      'demoMemoryDefs has structured sample content with valid tags and relative dates',
      () {
        expect(demoMemoryDefs, isNotEmpty);
        final now = DateTime.now();

        for (final def in demoMemoryDefs) {
          expect(def.title, isNotEmpty);
          expect(def.description, isNotEmpty);
          expect(def.tags, isNotEmpty);
          final date = def.dateFor(now);
          expect(date.year, inInclusiveRange(now.year - 5, now.year + 1));
        }
      },
    );
  });
}
