import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/repositories/memory_repository.dart';
import '../../shared/widgets/glass_bottom_sheet.dart';
import '../../shared/widgets/glass_icon_button.dart';
import '../memory/create_edit_memory_screen.dart';
import '../memory/memory_details_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/memory_sheet_content.dart';
import 'widgets/month_calendar.dart';

const _monthWindowBefore = 12;
const _monthWindowAfter = 12;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<DateTime> _months = List.generate(
    _monthWindowBefore + _monthWindowAfter + 1,
    (i) {
      final now = DateTime.now();
      return DateTime(now.year, now.month - _monthWindowBefore + i, 1);
    },
  );
  late final PageController _monthController = PageController(initialPage: _monthWindowBefore);

  DateTime? _selectedDate;

  @override
  void dispose() {
    _monthController.dispose();
    super.dispose();
  }

  Future<void> _openDay(DateTime date) async {
    setState(() => _selectedDate = date);
    final memories = MemoryRepository.instance.onDate(date);
    await GlassBottomSheet.show(
      context,
      title: _formatDayTitle(date),
      subtitle: '${memories.length} ${memories.length == 1 ? 'Memory' : 'Memories'}',
      builder: (context) => MemorySheetContent(
        memories: memories,
        onAddMemory: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CreateEditMemoryScreen(initialDate: date)),
          );
        },
        onOpenMemory: (memory) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => MemoryDetailsScreen(memory: memory)),
          );
        },
      ),
    );
    if (mounted) setState(() => _selectedDate = null);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: Stack(
        children: [
          ListenableBuilder(
            listenable: MemoryRepository.instance,
            builder: (context, _) => PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _monthController,
              itemCount: _months.length,
              itemBuilder: (context, index) => MonthCalendarPage(
                month: _months[index],
                selectedDate: _selectedDate,
                onSelectDate: _openDay,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.stackSm),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors.void_.withValues(alpha: 0.85), colors.void_.withValues(alpha: 0)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GlassIconButton(
                      icon: Icons.search,
                      semanticLabel: 'Search',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      ),
                    ),
                    GlassIconButton(
                      icon: Icons.person_outline,
                      semanticLabel: 'Profile',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      ),
                    ),
                    GlassIconButton(
                      icon: Icons.settings_outlined,
                      semanticLabel: 'Settings',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String _formatDayTitle(DateTime date) => '${_monthNames[date.month - 1]} ${date.day}';
