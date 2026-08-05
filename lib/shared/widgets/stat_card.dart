import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Icon + big number + label used in the Profile statistics grid.
class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.stackSm),
          child: Column(
            children: [
              Icon(icon, color: colors.onSurface.withValues(alpha: 0.7), size: 24),
              const SizedBox(height: AppSpacing.unit),
              Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
