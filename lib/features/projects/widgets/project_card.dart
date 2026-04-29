import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/features/projects/models/project_model.dart';
import 'package:my_portfolio/features/projects/project_detail_screen.dart';

/// A reusable portfolio project card with two physics-driven animations:
///
/// 1. **Entrance bounce** — on first build, the card springs up from a slight
///    vertical offset using a damped [SpringSimulation]. Each card in a list
///    should receive a unique [entranceDelay] so they stagger into view.
///
/// 2. **Hover scale** — on mouse-enter the card smoothly scales to 1.04 via
///    a tight spring, and snaps back on mouse-exit.  On touch devices the
///    spring fires on tap-down / tap-up via [GestureDetector] long-press.
class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.entranceDelay = Duration.zero,
    this.onTap,
  });

  final ProjectModel project;

  /// How long to wait before the card's entrance animation begins.
  /// Use multiples of ~80 ms across list items for a stagger effect.
  final Duration entranceDelay;

  final VoidCallback? onTap;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with TickerProviderStateMixin {
  // ── Entrance animation ──────────────────────────────────────────────────────
  late final AnimationController _entranceCtrl;
  late final Animation<double> _entranceScale;
  late final Animation<double> _entranceOpacity;
  late final Animation<Offset> _entranceSlide;

  // ── Hover / press spring ────────────────────────────────────────────────────
  late final AnimationController _hoverCtrl;

  bool _isHovered = false;
  bool _isPressed = false;

  // Spring description: medium stiffness, well-damped — feels snappy.
  static const _kHoverSpring = SpringDescription(
    mass: 1,
    stiffness: 350,
    damping: 26,
  );

  @override
  void initState() {
    super.initState();

    // ── Entrance controller ───────────────────────────────────────────────
    _entranceCtrl = AnimationController(
      vsync: this,
      // Duration is ignored when animateWith(SpringSimulation) is used,
      // but we set a fallback so the controller is valid.
      duration: const Duration(milliseconds: 900),
    );

    // Entrance scale: 0.80 → 1.0 with an overshoot spring feel via Curves.
    _entranceScale = Tween<double>(begin: 0.80, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: Curves.elasticOut, // built-in spring-like bounce
      ),
    );

    _entranceOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        // Fade finishes before the spring overshoot so glitch-free.
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _entranceSlide = Tween<Offset>(
      begin: const Offset(0, 0.12), // small downward start
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: Curves.elasticOut,
      ),
    );

    // ── Hover controller (drives scale 1.0 ↔ 1.04) ───────────────────────
    // Range: 0 = default, 1 = hovered.
    _hoverCtrl = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
    );

    // Trigger entrance after the user-specified delay.
    Future.delayed(widget.entranceDelay, _startEntrance);
  }

  void _startEntrance() {
    if (!mounted) return;
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _hoverCtrl.dispose();
    super.dispose();
  }

  // ── Hover / press helpers ─────────────────────────────────────────────────

  void _onHoverEnter() {
    _isHovered = true;
    _springHoverTo(1.0);
  }

  void _onHoverExit() {
    _isHovered = false;
    if (!_isPressed) _springHoverTo(0.0);
  }

  void _onTapDown(TapDownDetails _) {
    _isPressed = true;
    HapticFeedback.lightImpact();
    _springHoverTo(1.0);
  }

  void _onTapUp(TapUpDetails _) {
    _isPressed = false;
    if (!_isHovered) _springHoverTo(0.0);
  }

  void _onTapCancel() {
    _isPressed = false;
    if (!_isHovered) _springHoverTo(0.0);
  }

  void _springHoverTo(double target) {
    final sim = SpringSimulation(
      _kHoverSpring,
      _hoverCtrl.value,
      target,
      0, // initial velocity
    );
    _hoverCtrl.animateWith(sim);
  }

  // ── Scale derived from hover controller ──────────────────────────────────
  // Maps controller 0→1 to scale 1.0→1.045
  double get _hoverScale => 1.0 + _hoverCtrl.value * 0.045;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceCtrl, _hoverCtrl]),
      builder: (context, _) {
        return FadeTransition(
          opacity: _entranceOpacity,
          child: SlideTransition(
            position: _entranceSlide,
            child: Transform.scale(
              // Entrance scale × hover scale compose multiplicatively.
              scale: _entranceScale.value * _hoverScale,
              child: _buildCard(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final project = widget.project;
    final accent = project.accentColor;
    final isStealth = project.isStealthMode;

    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          final isMobile = MediaQuery.sizeOf(context).width < 600;
          if (isMobile) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: AppTheme.background,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (context) => ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: ProjectDetailScreen(projectId: widget.project.id),
              ),
            );
          } else {
            context.push('/projects/${widget.project.id}');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: AppTheme.borderRadiusDefault,
            border: Border.all(
              color: _isHovered
                  ? accent.withValues(alpha: 0.55)
                  : AppTheme.border,
              width: 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.18),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: AppTheme.borderRadiusDefault,
            child: Stack(
              children: [
                // Subtle gradient header strip
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 3,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent,
                          accent.withValues(alpha: _isHovered ? 0.6 : 0.3),
                        ],
                      ),
                    ),
                  ),
                ),

                // Card body
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon badge — Hero source matching ProjectDetailScreen
                      Hero(
                        tag: 'project-hero-${project.id}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: accent.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            child: Icon(project.icon, color: accent, size: 22),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        project.title,
                        style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isStealth
                              ? AppTheme.textSubtle
                              : AppTheme.onBackground,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Subtitle / category
                      Text(
                        project.subtitle,
                        style: tt.bodySmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        project.description,
                        style: tt.bodyMedium?.copyWith(
                          color: AppTheme.textSubtle,
                          height: 1.5,
                        ),
                        maxLines: isStealth ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 16),

                      // Tag chips — capped on mobile to prevent Wrap overflow
                      _TagWrap(tags: project.tags, accent: accent),

                      if (!isStealth) ...[
                        const SizedBox(height: 12),

                        // "View project" — removed from layout when not hovered
                        // (instead of opacity-hidden, which still consumes height)
                        Visibility(
                          visible: _isHovered,
                          maintainSize: false,
                          maintainAnimation: false,
                          maintainState: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'View project',
                                style: tt.labelMedium?.copyWith(
                                  color: accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: accent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Stealth mode blur overlay
                if (isStealth)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: AppTheme.borderRadiusDefault,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppTheme.surface.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: AppTheme.borderRadiusPill,
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lock_outline_rounded,
                                  size: 12,
                                  color: AppTheme.textSubtle),
                              const SizedBox(width: 6),
                              Text(
                                'Stealth Mode',
                                style: tt.labelSmall?.copyWith(
                                    color: AppTheme.textSubtle,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tag Wrap (overflow-safe) ─────────────────────────────────────────────────

/// Shows up to [_kMaxVisible] chips and collapses the rest into a "+N" badge.
/// On desktop (hover cards with fixed height) all chips are shown.
class _TagWrap extends StatelessWidget {
  const _TagWrap({required this.tags, required this.accent});

  final List<String> tags;
  final Color accent;

  /// Max chips to show before collapsing to "+N more".
  static const int _kMaxVisible = 3;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final visibleTags =
        isMobile && tags.length > _kMaxVisible ? tags.take(_kMaxVisible).toList() : tags;
    final overflow = tags.length - visibleTags.length;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...visibleTags.map((tag) => _TagChip(label: tag, accent: accent)),
        if (overflow > 0)
          _TagChip(label: '+$overflow more', accent: accent),
      ],
    );
  }
}

// ─── Tag Chip ─────────────────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: AppTheme.borderRadiusPill,
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}
