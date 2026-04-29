import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Data Models ───────────────────────────────────────────────────────────────

enum TimelineType { work, education, leadership }

/// Represents a single event in the unified experience + education timeline.
class TimelineEvent {
  const TimelineEvent({
    required this.year,
    required this.title,
    required this.subtitle,
    required this.bullets,
    required this.type,
    this.isCurrent = false,
    this.chips = const [],
    this.detail,
    this.linkUrl,
    this.linkLabel,
  });

  final String year;
  final String title;
  final String subtitle;
  final List<String> bullets;
  final TimelineType type;
  final bool isCurrent;

  /// Small tag chips (e.g. tech stack for work, CGPA for education)
  final List<String> chips;

  /// Optional extra detail label (e.g. "CGPA: 3.57")
  final String? detail;

  final String? linkUrl;
  final String? linkLabel;
}

// ─── Static Data ──────────────────────────────────────────────────────────────

const List<TimelineEvent> _events = [
  TimelineEvent(
    year: 'June 2025 – Present',
    title: 'Flutter Developer',
    subtitle: 'School360',
    type: TimelineType.work,
    isCurrent: true,
    chips: ['Flutter', 'Firebase', 'REST API', 'Riverpod', 'FCM', 'Git'],
    bullets: [
      'Developing & maintaining mobile apps for the School360 education platform.',
      'Integrated Google Sign-In and Firebase Cloud Messaging for real-time push notifications.',
      'Built and consumed RESTful APIs; optimised app performance and responsiveness.',
      'Implemented scalable state management and designed responsive UIs with Prokit UI.',
    ],
  ),
  TimelineEvent(
    year: '2016 – 2018, 2025 – Present',
    title: 'Teacher - Volunteer',
    subtitle: 'Katugoda Ahadiya School (Ahadhiyya Daham Pasal)',
    type: TimelineType.leadership, 
    isCurrent: true,
    bullets: [],
  ),
  TimelineEvent(
    year: 'Dec 2024 – June 2025',
    title: 'Flutter Developer Intern',
    subtitle: 'School360',
    type: TimelineType.work,
    chips: ['Flutter', 'Firebase', 'Git', 'Scrum'],
    bullets: [
      'Contributed to feature development for the School360 Flutter application.',
      'Assisted in UI implementation and API integration tasks.',
      'Gained hands-on experience with Firebase services.',
      'Participated in Scrum sprints and collaborative Git workflows.',
    ],
  ),
  TimelineEvent(
    year: '2020 – 2024',
    title: 'BS. Computer Science',
    subtitle: 'National Textile University, Faisalabad, Pakistan',
    type: TimelineType.education,
    chips: ['CGPA 3.57 / 4.00'],
    bullets: [],
    linkUrl: 'https://drive.google.com/file/d/1HXh0zioaPIHphvxO7CQmAcx7Islx-xCE/view?usp=sharing',
    linkLabel: 'View Transcript',
  ),
  TimelineEvent(
    year: '2020 – 2024',
    title: 'Member',
    subtitle: 'National Textile University CS Society',
    type: TimelineType.leadership,
    bullets: [],
  ),
  TimelineEvent(
    year: '2019',
    title: 'G.C.E Advanced Level',
    subtitle: 'Malharus Sulhiya Central College, Galle, Sri Lanka',
    type: TimelineType.education,
    chips: ['Physical Science'],
    bullets: [],
  ),
  TimelineEvent(
    year: '2019',
    title: 'Secretary',
    subtitle: 'Katugoda Welfare Association',
    type: TimelineType.leadership,
    bullets: [],
  ),
  TimelineEvent(
    year: '2019',
    title: 'Volunteer',
    subtitle: 'ACTED Sri Lanka',
    type: TimelineType.leadership,
    bullets: [],
  ),
  TimelineEvent(
    year: '2019',
    title: 'Volunteer',
    subtitle: 'Sarvodaya Shanthi Sena',
    type: TimelineType.leadership,
    bullets: [],
  ),
  TimelineEvent(
    year: '2018',
    title: 'Senior Head Prefect',
    subtitle: 'Malaharus Sulhiya College',
    type: TimelineType.leadership,
    bullets: [],
  ),
  TimelineEvent(
    year: '2017',
    title: 'Head Prefect',
    subtitle: 'Malaharus Sulhiya College',
    type: TimelineType.leadership,
    bullets: [],
  ),
  TimelineEvent(
    year: '2015',
    title: 'G.C.E Ordinary Level',
    subtitle: 'Malharus Sulhiya Central College, Galle, Sri Lanka',
    type: TimelineType.education,
    chips: ['3C · 6A · 2B'],
    bullets: [],
  ),
];

// ─── Screen ────────────────────────────────────────────────────────────────────

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              sliver: SliverToBoxAdapter(
                child: _AnimatedEntry(
                  delay: Duration.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CAREER TIMELINE',
                        style: tt.labelMedium?.copyWith(
                          color: AppTheme.primary,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Experience, Education & Leadership',
                        style: tt.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.onBackground,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'My professional journey, academic background, and community involvement.',
                        style: tt.bodyLarge?.copyWith(
                          color: AppTheme.textSubtle,
                          height: 1.6,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Unified Timeline ─────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = _events[index];
                    final isLast = index == _events.length - 1;

                    return _AnimatedEntry(
                      delay: Duration(milliseconds: 100 + index * 120),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Left: Node & Line ──────────────────────
                            SizedBox(
                              width: 32,
                              child: Column(
                                children: [
                                  const SizedBox(height: 6),
                                  _TimelineNode(
                                    type: event.type,
                                    isActive: event.isCurrent,
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        margin: const EdgeInsets.only(top: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              () {
                                                switch (event.type) {
                                                  case TimelineType.work:
                                                    return AppTheme.primary.withValues(alpha: 0.4);
                                                  case TimelineType.education:
                                                    return AppTheme.secondary.withValues(alpha: 0.4);
                                                  case TimelineType.leadership:
                                                    return const Color(0xFF2CDB8A).withValues(alpha: 0.4);
                                                }
                                              }(),
                                              AppTheme.border,
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(1),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // ── Right: Content ─────────────────────────
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: _TimelineCard(event: event),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _events.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ─── Timeline Card ─────────────────────────────────────────────────────────────

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.event});

  final TimelineEvent event;

  Color get _accentColor {
    switch (event.type) {
      case TimelineType.work:
        return AppTheme.primary;
      case TimelineType.education:
        return AppTheme.secondary;
      case TimelineType.leadership:
        return const Color(0xFF2CDB8A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withValues(alpha: 0.6),
        borderRadius: AppTheme.borderRadiusDefault,
        border: Border.all(
          color: event.isCurrent
              ? _accentColor.withValues(alpha: 0.35)
              : AppTheme.border,
        ),
        boxShadow: event.isCurrent
            ? [
                BoxShadow(
                  color: _accentColor.withValues(alpha: 0.08),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Year badge + type label ──────────────────────────────
          Row(
            children: [
              _Pill(
                label: event.year,
                color: event.isCurrent ? _accentColor : AppTheme.textSubtle,
                filled: event.isCurrent,
              ),
              const Spacer(),
              _Pill(
                label: () {
                  switch (event.type) {
                    case TimelineType.work: return '💼 Work';
                    case TimelineType.education: return '🎓 Education';
                    case TimelineType.leadership: return '🤝 Leadership';
                  }
                }(),
                color: _accentColor,
                filled: false,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Title ────────────────────────────────────────────────
          Text(
            event.title,
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.onBackground,
            ),
          ),
          const SizedBox(height: 4),

          // ── Subtitle / Company ───────────────────────────────────
          Text(
            event.subtitle,
            style: tt.titleSmall?.copyWith(
              color: _accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          // ── Bullet Points ────────────────────────────────────────
          if (event.bullets.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...event.bullets.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _accentColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        b,
                        style: tt.bodyMedium?.copyWith(
                          color: AppTheme.textSubtle,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ── Tech / Info Chips ────────────────────────────────────
          if (event.chips.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: event.chips
                  .map((chip) => _TechChip(label: chip, accent: _accentColor))
                  .toList(),
            ),
          ],

          // ── Link Button ──────────────────────────────────────────
          if (event.linkUrl != null) ...[
            const SizedBox(height: 16),
            _LinkButton(
              url: event.linkUrl!,
              label: event.linkLabel ?? 'View Details',
              accentColor: _accentColor,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Link Button ───────────────────────────────────────────────────────────────

class _LinkButton extends StatefulWidget {
  const _LinkButton({
    required this.url,
    required this.label,
    required this.accentColor,
  });

  final String url;
  final String label;
  final Color accentColor;

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? widget.accentColor.withValues(alpha: 0.15) : AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? widget.accentColor : AppTheme.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.link_rounded,
                size: 16,
                color: _hovered ? widget.accentColor : AppTheme.textSubtle,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: tt.labelSmall?.copyWith(
                  color: _hovered ? widget.accentColor : AppTheme.onBackground,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pill Badge ────────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    required this.filled,
  });

  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: AppTheme.borderRadiusPill,
        border: Border.all(
          color: filled ? color.withValues(alpha: 0.35) : AppTheme.border,
        ),
      ),
      child: Text(
        label,
        style: tt.labelSmall?.copyWith(
          color: filled ? color : AppTheme.textSubtle,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ─── Tech Chip ─────────────────────────────────────────────────────────────────

class _TechChip extends StatelessWidget {
  const _TechChip({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        label,
        style: tt.labelSmall?.copyWith(
          color: accent.withValues(alpha: 0.9),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─── Animated Entry ────────────────────────────────────────────────────────────

/// Fades in + slides up on first build.
class _AnimatedEntry extends StatefulWidget {
  const _AnimatedEntry({required this.child, required this.delay});

  final Widget child;
  final Duration delay;

  @override
  State<_AnimatedEntry> createState() => _AnimatedEntryState();
}

class _AnimatedEntryState extends State<_AnimatedEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ─── Timeline Node ─────────────────────────────────────────────────────────────

class _TimelineNode extends StatefulWidget {
  const _TimelineNode({required this.type, required this.isActive});

  final TimelineType type;
  final bool isActive;

  @override
  State<_TimelineNode> createState() => _TimelineNodeState();
}

class _TimelineNodeState extends State<_TimelineNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _glow = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    if (widget.isActive) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent;
    final IconData activeIcon;
    final IconData inactiveIcon;

    switch (widget.type) {
      case TimelineType.work:
        accent = AppTheme.primary;
        activeIcon = Icons.work_rounded;
        inactiveIcon = Icons.work_outline_rounded;
        break;
      case TimelineType.education:
        accent = AppTheme.secondary;
        activeIcon = Icons.school_rounded;
        inactiveIcon = Icons.school_outlined;
        break;
      case TimelineType.leadership:
        accent = const Color(0xFF2CDB8A);
        activeIcon = Icons.groups_rounded;
        inactiveIcon = Icons.groups_outlined;
        break;
    }

    if (widget.isActive) {
      return AnimatedBuilder(
        animation: _glow,
        builder: (context, _) => _NodeDot(
          accent: accent,
          isActive: true,
          glowOpacity: _glow.value,
          icon: activeIcon,
        ),
      );
    }

    return _NodeDot(
      accent: accent,
      isActive: false,
      glowOpacity: 0,
      icon: inactiveIcon,
    );
  }
}

class _NodeDot extends StatelessWidget {
  const _NodeDot({
    required this.accent,
    required this.isActive,
    required this.glowOpacity,
    required this.icon,
  });

  final Color accent;
  final bool isActive;
  final double glowOpacity;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? accent.withValues(alpha: 0.15)
            : AppTheme.surfaceVariant,
        border: Border.all(
          color: isActive ? accent : AppTheme.border,
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: glowOpacity * 0.5),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: 14,
        color: isActive ? accent : AppTheme.textSubtle,
      ),
    );
  }
}
