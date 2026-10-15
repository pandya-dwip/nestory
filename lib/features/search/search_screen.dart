import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/repositories/memory_repository.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/glass_container.dart';
import '../../shared/widgets/glass_icon_button.dart';
import '../../shared/widgets/memory_card.dart';
import '../memory/memory_details_screen.dart';

/// Live search over title, description, and tags — case-insensitive,
/// updates as the user types. Opens with the keyboard already up.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final query = _controller.text;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.unit,
                AppSpacing.gutter,
                AppSpacing.stackSm,
              ),
              child: Row(
                children: [
                  GlassIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSpacing.stackSm),
                  Expanded(
                    child: GlassContainer(
                      active: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.stackMd,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: colors.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.stackSm),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              style: Theme.of(context).textTheme.bodyLarge,
                              cursorColor: colors.onSurface,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search memories...',
                                hintStyle: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: colors.onSurface.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          if (query.isNotEmpty)
                            GestureDetector(
                              onTap: _controller.clear,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.stackMd,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: colors.onSurfaceVariant,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: MemoryRepository.instance,
                builder: (context, _) {
                  if (query.trim().isEmpty) {
                    return const EmptyState(
                      'Start typing to search your memories.',
                    );
                  }
                  final results = MemoryRepository.instance.search(query);
                  if (results.isEmpty) {
                    return const EmptyState('No memories found.');
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.stackSm,
                      AppSpacing.gutter,
                      AppSpacing.stackLg,
                    ),
                    itemCount: results.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.stackMd),
                    itemBuilder: (context, index) {
                      final memory = results[index];
                      return MemoryCard(
                        memory: memory,
                        showDate: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MemoryDetailsScreen(memory: memory),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
