import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/app_settings_repository.dart';
import '../../data/repositories/calendar_event_repository.dart';
import '../../data/repositories/memory_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/services/calendar_sync_service.dart';
import '../../data/services/google_auth_service.dart';
import '../../data/services/widget_snapshot_service.dart';
import '../home/home_screen.dart';

/// First screen shown on launch. Plays a short brand entrance while the
/// local database and repositories warm up in the background, then
/// crossfades into [HomeScreen] — so Home never shows its own loading
/// flicker once it's on screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  late final _wordmarkFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
  );
  late final _wordmarkScale = Tween<double>(begin: 0.92, end: 1.0).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    ),
  );
  late final _glowFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
  );
  late final _ruleWidth = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
  );
  late final _taglineFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.55, 0.95, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final stopwatch = Stopwatch()..start();
    await Future.wait([
      MemoryRepository.instance.init(),
      ProfileRepository.instance.init(),
      AppSettingsRepository.instance.init(),
      CalendarEventRepository.instance.init(),
      GoogleAuthService.instance.init(),
    ]);
    CalendarSyncService.instance.init();
    CalendarSyncService.instance.triggerOutboxDrain();
    await WidgetSnapshotService.instance.init();
    // Keep the entrance on screen for a minimum stretch so it always reads
    // as an intentional brand moment, never a flicker on fast devices.
    const minimumDisplay = Duration(milliseconds: 1700);
    final remaining = minimumDisplay - stopwatch.elapsed;
    if (remaining > Duration.zero) await Future.delayed(remaining);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, _) =>
            FadeTransition(opacity: animation, child: const HomeScreen()),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.void_,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                FadeTransition(
                  opacity: _glowFade,
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          colors.onSurface.withValues(alpha: 0.08),
                          colors.onSurface.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _wordmarkFade,
                      child: ScaleTransition(
                        scale: _wordmarkScale,
                        child: Text(
                          'NESTORY',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 40,
                            letterSpacing: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 64 * _ruleWidth.value,
                      height: 1,
                      child: ColoredBox(
                        color: colors.outline.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FadeTransition(
                      opacity: _taglineFade,
                      child: Text(
                        'EVERY DAY, KEPT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 4,
                          color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
