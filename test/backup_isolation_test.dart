// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nestory/data/services/backup_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProviderPlatform(this._docsPath);
  final String _docsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => _docsPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDocsDir;
  late PathProviderPlatform originalPlatform;

  setUp(() async {
    originalPlatform = PathProviderPlatform.instance;
    tempDocsDir = await Directory.systemTemp.createTemp('nestory_backup_test_');
    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDocsDir.path);
  });

  tearDown(() async {
    PathProviderPlatform.instance = originalPlatform;
    if (await tempDocsDir.exists()) {
      await tempDocsDir.delete(recursive: true);
    }
  });

  group('Backup Isolation & Calendar Immunity', () {
    test(
      'buildArchive includes memory DB and media but strictly excludes calendar_cache.sqlite and WAL files',
      () async {
        // 1. Create Nestory memory vault files
        final memoryDb = File(p.join(tempDocsDir.path, 'nestory.sqlite'));
        await memoryDb.writeAsString('SQLITE_MEMORY_DB_DATA');

        final memoryDbWal = File(
          p.join(tempDocsDir.path, 'nestory.sqlite-wal'),
        );
        await memoryDbWal.writeAsString('SQLITE_MEMORY_WAL_DATA');

        final photosDir = Directory(p.join(tempDocsDir.path, 'memory_photos'));
        await photosDir.create();
        final photoFile = File(p.join(photosDir.path, 'photo_1.jpg'));
        await photoFile.writeAsBytes([1, 2, 3, 4]);

        // 2. Create Google Calendar database and sidecars in the same documents folder
        final calendarDb = File(
          p.join(tempDocsDir.path, 'calendar_cache.sqlite'),
        );
        await calendarDb.writeAsString(
          'CALENDAR_CACHE_OFFLINE_OUTBOX_AND_EVENTS',
        );

        final calendarDbWal = File(
          p.join(tempDocsDir.path, 'calendar_cache.sqlite-wal'),
        );
        await calendarDbWal.writeAsString('CALENDAR_CACHE_WAL');

        final calendarDbShm = File(
          p.join(tempDocsDir.path, 'calendar_cache.sqlite-shm'),
        );
        await calendarDbShm.writeAsString('CALENDAR_CACHE_SHM');

        // 3. Build backup
        final zipBytes = await BackupService.buildArchive();
        expect(zipBytes, isNotEmpty);

        // 4. Verify contents of archive
        final archive = ZipDecoder().decodeBytes(zipBytes);
        final entryNames = archive.files.map((f) => f.name).toList();

        // Must include memory vault assets
        expect(entryNames, contains('db/nestory.sqlite'));
        expect(entryNames, contains('db/nestory.sqlite-wal'));
        expect(entryNames, contains('memory_photos/photo_1.jpg'));

        // MUST NOT include any calendar_cache files
        expect(entryNames, isNot(contains('db/calendar_cache.sqlite')));
        expect(entryNames, isNot(contains('db/calendar_cache.sqlite-wal')));
        expect(entryNames, isNot(contains('db/calendar_cache.sqlite-shm')));
        expect(
          entryNames.any((name) => name.contains('calendar_cache')),
          isFalse,
        );
      },
    );

    test(
      'restoreArchive clears and replaces memory DB but leaves calendar_cache.sqlite intact and untouched',
      () async {
        // 1. Simulate existing calendar data
        final calendarDb = File(
          p.join(tempDocsDir.path, 'calendar_cache.sqlite'),
        );
        const calendarContent = 'CRUCIAL_OFFLINE_MUTATION_OUTBOX_DO_NOT_DELETE';
        await calendarDb.writeAsString(calendarContent);

        final calendarWal = File(
          p.join(tempDocsDir.path, 'calendar_cache.sqlite-wal'),
        );
        await calendarWal.writeAsString('CALENDAR_WAL_ACTIVE');

        // 2. Build a valid restore archive with new memory db
        final restoreArchive = Archive();
        final memoryBytes = Uint8List.fromList(
          'NEW_RESTORED_MEMORY_DB'.codeUnits,
        );
        restoreArchive.addFile(
          ArchiveFile('db/nestory.sqlite', memoryBytes.length, memoryBytes),
        );
        final zipBytes = Uint8List.fromList(
          ZipEncoder().encode(restoreArchive),
        );

        expect(BackupService.looksLikeValidBackup(zipBytes), isTrue);

        // 3. Perform restore
        await BackupService.restoreArchive(zipBytes);

        // 4. Verify memory database was restored
        final restoredMemoryDb = File(
          p.join(tempDocsDir.path, 'nestory.sqlite'),
        );
        expect(await restoredMemoryDb.exists(), isTrue);
        expect(await restoredMemoryDb.readAsString(), 'NEW_RESTORED_MEMORY_DB');

        // 5. CRITICAL: Verify calendar_cache.sqlite was NOT deleted or modified
        expect(
          await calendarDb.exists(),
          isTrue,
          reason: 'calendar_cache.sqlite must survive restoreArchive',
        );
        expect(
          await calendarDb.readAsString(),
          calendarContent,
          reason: 'calendar_cache.sqlite data must be preserved',
        );
        expect(
          await calendarWal.exists(),
          isTrue,
          reason: 'calendar_cache.sqlite-wal must not be wiped',
        );
      },
    );

    test('looksLikeValidBackup rejects non-vault archives', () {
      final invalidArchive = Archive();
      final bytes = Uint8List.fromList('SOME_FILE'.codeUnits);
      invalidArchive.addFile(
        ArchiveFile('calendar_cache.sqlite', bytes.length, bytes),
      );
      final zipBytes = Uint8List.fromList(ZipEncoder().encode(invalidArchive));

      expect(BackupService.looksLikeValidBackup(zipBytes), isFalse);
    });
  });
}
