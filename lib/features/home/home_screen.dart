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
import 'widgets/month_year_picker_sheet.dart';

/// How far back/forward from today the calendar spans — bounds for both
/// the [PageView] and the year picker.
const _yearsBefore = 100;
const _yearsAfter = 20;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _now = DateTime.now();
  late final int _minYear = _now.year - _yearsBefore;
  late final int _maxYear = _now.year + _yearsAfter;
  late final int _totalMonths = (_maxYear - _minYear + 1) * 12;
  late final int _initialIndex = _indexFor(_now.year, _now.month);

  late final PageController _monthController = PageController(initialPage: _initialIndex);

  DateTime? _selectedDate;

  int _indexFor(int year, int month) => (year - _minYear) * 12 + (month - 1);

  DateTime _monthAt(int index) => DateTime(_minYear + index ~/ 12, index % 12 + 1, 1);

  @override
  void dispose() {
    _monthController.dispose();
    super.dispose();
  }

  Future<void> _jumpTo(int index) async {
    final clamped = index.clamp(0, _totalMonths - 1);
    await _monthController.animateToPage(
      clamped,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onSelectMonth(DateTime currentPageMonth, int month) {
    _jumpTo(_indexFor(currentPageMonth.year, month));
  }

  void _onSelectYear(DateTime currentPageMonth, int year) {
    _jumpTo(_indexFor(year, currentPageMonth.month));
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
              itemCount: _totalMonths,
              physics: const _SmoothPageScrollPhysics(parent: BouncingScrollPhysics()),
              itemBuilder: (context, index) {
                final month = _monthAt(index);
                return _RollingPage(
                  controller: _monthController,
                  index: index,
                  child: MonthCalendarPage(
                    month: month,
                    selectedDate: _selectedDate,
                    onSelectDate: _openDay,
                    onSelectMonth: (m) => _onSelectMonth(month, m),
                    onSelectYear: (y) => _onSelectYear(month, y),
                    minYear: _minYear,
                    maxYear: _maxYear,
                  ),
                );
              },
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

String _formatDayTitle(DateTime date) => '${monthNames[date.month - 1]} ${date.day}';

/// A softer, non-oscillating spring than [PageScrollPhysics]'s default —
/// lower stiffness glides into the snap point instead of snapping briskly,
/// and a slightly over-critical damping ratio keeps it from overshooting
/// and bouncing back, so the settle reads as smooth rather than springy.
class _SmoothPageScrollPhysics extends PageScrollPhysics {
  const _SmoothPageScrollPhysics({super.parent});

  @override
  _SmoothPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SmoothPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 60,
        ratio: 1.05,
      );
}

/// Subtle wheel-roll tilt as a page scrolls past — a small `rotateX` that's
/// exactly zero when a page is centered (so it's invisible at rest) and
/// grows as the page travels toward/away from center, giving vertical
/// paging a physical "rolling" feel instead of a flat slide. Rebuilds only
/// the [Transform] each frame — [child] is built once and reused.
class _RollingPage extends StatelessWidget {
  const _RollingPage({required this.controller, required this.index, required this.child});

  final PageController controller;
  final int index;
  final Widget child;

  static const _maxAngle = 0.16; // radians (~9°) at full page offset

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, animatedChild) {
        var page = index.toDouble();
        if (controller.hasClients && controller.position.haveDimensions) {
          page = controller.page ?? page;
        }
        final delta = (page - index).clamp(-1.0, 1.0);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateX(delta * _maxAngle),
          child: animatedChild,
        );
      },
      child: child,
    );
  }
}
