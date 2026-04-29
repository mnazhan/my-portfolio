import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

/// A reusable wrapper that adds two forms of feedback on press:
///
/// 1. **Visual** — springs the child down to [pressedScale] (e.g. 0.96×) on
///    tap-down and springs back to 1.0× on release using [SpringSimulation].
/// 2. **Haptic** — fires [HapticFeedback.lightImpact] on tap-down, mimicking
///    the tactile click of an iOS button.
///
/// Usage:
/// ```dart
/// PressableFeedback(
///   onTap: () { /* ... */ },
///   child: YourWidget(),
/// )
/// ```
class PressableFeedback extends StatefulWidget {
  const PressableFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.96,
    this.enableHaptic = true,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Scale factor while the finger is held down.
  final double pressedScale;

  /// Whether to fire [HapticFeedback.lightImpact] on press.
  final bool enableHaptic;

  @override
  State<PressableFeedback> createState() => _PressableFeedbackState();
}

class _PressableFeedbackState extends State<PressableFeedback>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  static const _kSpring = SpringDescription(
    mass: 1,
    stiffness: 600,
    damping: 28,
  );

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // 0 → 1 maps to 1.0 → pressedScale
  double get _scale =>
      1.0 - _ctrl.value * (1.0 - widget.pressedScale);

  void _press() {
    if (widget.enableHaptic) HapticFeedback.lightImpact();
    _springTo(1.0);
  }

  void _release() => _springTo(0.0);

  void _springTo(double target) {
    _ctrl.animateWith(
      SpringSimulation(_kSpring, _ctrl.value, target, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press(),
      onTapUp: (_) {
        _release();
        widget.onTap?.call();
      },
      onTapCancel: _release,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) => Transform.scale(scale: _scale, child: child),
        child: widget.child,
      ),
    );
  }
}
