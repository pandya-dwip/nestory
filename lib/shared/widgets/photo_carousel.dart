import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../models/photo_display_mode.dart';
import 'app_photo.dart';

/// Hero image carousel — horizontal peek-a-boo swipe with scale/opacity
/// falloff on neighboring slides and dot page indicators. Each slide is
/// fitted per its own stored [PhotoDisplayMode].
class PhotoCarousel extends StatefulWidget {
  const PhotoCarousel({
    super.key,
    required this.photoUrls,
    this.displayModes = const [],
    this.height = 420,
  });

  final List<String> photoUrls;
  final List<PhotoDisplayMode> displayModes;
  final double height;

  PhotoDisplayMode _modeFor(int index) =>
      index < displayModes.length ? displayModes[index] : PhotoDisplayMode.fill;

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: 0.82,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: widget.height,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.photoUrls.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    var page = index.toDouble();
                    if (_controller.hasClients &&
                        _controller.position.haveDimensions) {
                      page = _controller.page ?? page;
                    }
                    final delta = (page - index).abs().clamp(0.0, 1.0);
                    final scale = 1.0 - (delta * 0.08);
                    final opacity = (1.0 - (delta * 0.35)).clamp(0.0, 1.0);

                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: RepaintBoundary(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colors.glassBorder.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                              child: AppPhoto(
                                url: widget.photoUrls[index],
                                fit: widget._modeFor(index).boxFit,
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.55),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              var currentPage = 0;
              if (_controller.hasClients &&
                  _controller.position.haveDimensions) {
                currentPage = (_controller.page ?? 0).round();
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.photoUrls.length, (index) {
                  final active = (currentPage == index);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color:
                          colors.onSurface.withValues(alpha: active ? 1 : 0.3),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
