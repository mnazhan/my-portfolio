import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';

/// A styled placeholder that represents a vertical (9:16) screen recording.
///
/// Drop this wherever you want to embed a real [video_player] later —
/// just swap the inner content for a [VideoPlayer] widget.
class VerticalVideoPlaceholder extends StatefulWidget {
  const VerticalVideoPlaceholder({
    super.key,
    this.label = 'Screen Recording',
    this.maxWidth = 220,
  });

  /// Caption displayed below the phone frame.
  final String label;

  /// Maximum width of the phone frame (height is 16/9 × width).
  final double maxWidth;

  @override
  State<VerticalVideoPlaceholder> createState() =>
      _VerticalVideoPlaceholderState();
}

class _VerticalVideoPlaceholderState extends State<VerticalVideoPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frameWidth = widget.maxWidth;
    // 9:16 vertical aspect ratio
    final frameHeight = frameWidth * (16 / 9);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Phone frame ─────────────────────────────────────────────────
        Container(
          width: frameWidth,
          height: frameHeight,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.12),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // Gradient background (mimics a dark video)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.background,
                        AppTheme.primary.withValues(alpha: 0.06),
                        AppTheme.surface,
                      ],
                    ),
                  ),
                ),

                // Scanline texture overlay
                Positioned.fill(
                  child: CustomPaint(painter: _ScanlinePainter()),
                ),

                // Animated play button
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (context, child) => Opacity(
                      opacity: _pulseAnim.value,
                      child: child,
                    ),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.5),
                            width: 2),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                  ),
                ),

                // Top status bar notch
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppTheme.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),

                // "REC" badge
                Positioned(
                  top: 20,
                  right: 14,
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, child) => Opacity(
                      opacity: _pulseAnim.value,
                      child: child,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5C6E).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle,
                              color: Colors.white, size: 6),
                          SizedBox(width: 4),
                          Text(
                            'REC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom label
                Positioned(
                  bottom: 18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Tap to play',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.textSubtle,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Caption
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_outlined,
                size: 14, color: AppTheme.textSubtle),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: AppTheme.textSubtle),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Scanline CustomPainter ───────────────────────────────────────────────────

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.onBackground.withValues(alpha: 0.025)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter old) => false;
}
