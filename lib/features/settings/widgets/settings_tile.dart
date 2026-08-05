import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// One row inside a [SettingsSection] glass panel: icon, title, optional
/// subtitle, and a trailing affordance (chevron by default).
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final opacity = enabled ? 1.0 : 0.5;

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.stackMd, vertical: AppSpacing.stackSm + 4),
        child: Opacity(
          opacity: opacity,
          child: Row(
            children: [
              Icon(icon, color: colors.onSurfaceVariant, size: 24),
              const SizedBox(width: AppSpacing.stackMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.bodyLarge),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0, fontWeight: FontWeight.w400)),
                    ],
                  ],
                ),
              ),
              trailing ?? Icon(Icons.chevron_right, color: colors.outlineVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// A titled group of [SettingsTile]s inside one glass panel, with hairline
/// dividers between rows.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.stackSm),
          child: Text(title.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.outline)),
        ),
        const SizedBox(height: AppSpacing.unit),
        _SectionPanel(colors: colors, tiles: tiles),
      ],
    );
  }
}

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({required this.colors, required this.tiles});

  final NestoryColors colors;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(color: colors.surfaceContainer.withValues(alpha: 0.4)),
        child: Column(
          children: [
            for (var i = 0; i < tiles.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.stackMd),
                  child: Divider(height: 1, color: colors.glassBorder.withValues(alpha: 0.1)),
                ),
              tiles[i],
            ],
          ],
        ),
      ),
    );
  }
}
