import 'package:flutter/material.dart';

/// A shimmer effect widget that animates a gradient across its child.
class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key, required this.child});

  final Widget child;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade600 : Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + 2.0 * _controller.value, -0.3),
              end: Alignment(1.0 + 2.0 * _controller.value, 0.3),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A single shimmer placeholder box.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Shimmer skeleton for a match-card style list (Home screen).
class MatchCardShimmer extends StatelessWidget {
  const MatchCardShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: List.generate(
            itemCount,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const ShimmerBox(width: 40, height: 40, borderRadius: 20),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: ShimmerBox(width: double.infinity, height: 14),
                        ),
                        const SizedBox(width: 12),
                        const ShimmerBox(width: 40, height: 40, borderRadius: 20),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const ShimmerBox(width: 160, height: 12),
                    const SizedBox(height: 8),
                    const ShimmerBox(width: 100, height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton for a transaction/notification list item.
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: List.generate(
            itemCount,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const ShimmerBox(width: 44, height: 44, borderRadius: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: double.infinity, height: 12),
                        SizedBox(height: 6),
                        ShimmerBox(width: 120, height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const ShimmerBox(width: 50, height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton for leaderboard top-3 podium.
class LeaderboardShimmer extends StatelessWidget {
  const LeaderboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            3,
            (i) => Column(
              children: [
                ShimmerBox(
                    width: i == 1 ? 72 : 56,
                    height: i == 1 ? 72 : 56,
                    borderRadius: 36),
                const SizedBox(height: 8),
                const ShimmerBox(width: 60, height: 10),
                const SizedBox(height: 4),
                const ShimmerBox(width: 40, height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
