import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Small uppercase Geist "engraving" label used above lists and sections
/// ("Description", "Tags", "Appearance", ...).
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.dim = false});

  final String text;

  /// Muted variant used for settings section headers (outline color).
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: dim ? colors.outline : colors.onSurfaceVariant,
      ),
    );
  }
}
