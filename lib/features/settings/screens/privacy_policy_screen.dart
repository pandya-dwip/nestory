import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/glass_icon_button.dart';
import '../../../shared/widgets/section_title.dart';

class _PolicyPoint {
  const _PolicyPoint(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

const _points = [
  _PolicyPoint(
    Icons.smartphone_outlined,
    'Everything stays on this device',
    'Every memory, photo, and setting is stored locally in your private app storage. Nothing leaves your phone.',
  ),
  _PolicyPoint(
    Icons.person_off_outlined,
    'No account required',
    'There is no sign-up, login, or user profile tied to an external identity. Nestory works the moment you open it.',
  ),
  _PolicyPoint(
    Icons.cloud_off_outlined,
    'No cloud synchronization',
    "Nestory doesn't talk to any server. Backups are files you create and manage yourself, on your own terms.",
  ),
  _PolicyPoint(
    Icons.block_outlined,
    'No data collection',
    'Nestory does not collect, transmit, or sell any personal information.',
  ),
  _PolicyPoint(
    Icons.query_stats_outlined,
    'No analytics',
    "Your usage isn't tracked, measured, or reported anywhere.",
  ),
  _PolicyPoint(
    Icons.share_outlined,
    'No third-party tracking',
    'Nestory embeds no third-party trackers, ad SDKs, or telemetry libraries.',
  ),
];

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.unit),
              child: Row(
                children: [
                  GlassIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.of(context).pop()),
                  Expanded(
                    child: Text(
                      'PRIVACY POLICY',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16, letterSpacing: 3),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.stackMd),
                children: [
                  const SectionTitle('Your data, your device', dim: true),
                  const SizedBox(height: AppSpacing.stackSm),
                  Text(
                    'Nestory is built to work entirely offline. This page explains exactly what that means.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  for (final point in _points) ...[
                    _PolicyRow(point: point),
                    const SizedBox(height: AppSpacing.stackMd),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({required this.point});

  final _PolicyPoint point;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(point.icon, color: colors.onSurfaceVariant, size: 22),
        const SizedBox(width: AppSpacing.stackMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(point.title, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(point.body, style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}
