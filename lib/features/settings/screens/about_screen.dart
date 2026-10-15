import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/glass_icon_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter,
                vertical: AppSpacing.unit,
              ),
              child: Row(
                children: [
                  GlassIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'ABOUT',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter,
                  vertical: AppSpacing.stackLg,
                ),
                children: [
                  Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.glassBorder.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Icon(
                        Icons.auto_awesome_outlined,
                        size: 36,
                        color: colors.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  Center(
                    child: Text(
                      'NESTORY',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackSm),
                  Center(
                    child: Text(
                      "Nestory is a private, offline memory vault designed to preserve life's most meaningful moments.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  GlassContainer(
                    borderRadius: AppRadius.md,
                    padding: const EdgeInsets.all(AppSpacing.stackMd),
                    child: Column(
                      children: [
                        const _InfoRow(label: 'Version', value: '1.0.0'),
                        const _Divider(),
                        const _InfoRow(label: 'Build', value: '1'),
                        const _Divider(),
                        const _InfoRow(label: 'Developer', value: 'Nestory'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.stackSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(color: colors.outline),
          ),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: context.colors.glassBorder.withValues(alpha: 0.1),
    );
  }
}
