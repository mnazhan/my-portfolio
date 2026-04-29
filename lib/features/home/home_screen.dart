import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/features/home/contact_section.dart';
import 'package:my_portfolio/features/home/reference_section.dart';
import 'package:url_launcher/url_launcher.dart';

// ── CV URL — replace with the real link when ready ────────────────────────────
const _kCvUrl =
    'https://drive.google.com/file/d/17LtOoo8lNwE0k8PHDx9YuQ137mEReXnA/view?usp=sharing';

// ─────────────────────────────────────────────────────────────────────────────
// HomeScreen
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Staggered intervals — each section fades + slides up slightly
  static const _totalDuration = Duration(milliseconds: 1200);

  late final Animation<double> _fadeProfile;
  late final Animation<Offset> _slideProfile;

  late final Animation<double> _fadeName;
  late final Animation<Offset> _slideName;

  late final Animation<double> _fadeTagline;
  late final Animation<double> _fadeObjective;
  late final Animation<double> _fadeCta;

  late final Animation<double> _fadeTechHeader;
  late final Animation<double> _fadeTechGrid;

  late final Animation<double> _fadeContact;
  late final Animation<double> _fadeReference;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _totalDuration);

    Animation<double> _fade(double start, double end) =>
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

    Animation<Offset> _slide(double start, double end) =>
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

    _fadeProfile  = _fade(0.00, 0.30);
    _slideProfile = _slide(0.00, 0.35);
    _fadeName     = _fade(0.15, 0.45);
    _slideName    = _slide(0.15, 0.45);
    _fadeTagline  = _fade(0.25, 0.50);
    _fadeObjective= _fade(0.35, 0.60);
    _fadeCta      = _fade(0.45, 0.70);
    _fadeTechHeader = _fade(0.55, 0.78);
    _fadeTechGrid   = _fade(0.62, 0.88);
    _fadeContact    = _fade(0.75, 1.00);
    _fadeReference  = _fade(0.85, 1.00);

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  Widget _animated({
    required Animation<double> fade,
    required Widget child,
    Animation<Offset>? slide,
  }) {
    Widget w = FadeTransition(opacity: fade, child: child);
    if (slide != null) w = SlideTransition(position: slide, child: w);
    return w;
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Profile Picture ─────────────────────────────────────────
                Center(
                  child: _animated(
                    fade: _fadeProfile,
                    slide: _slideProfile,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surfaceVariant,
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.15),
                            blurRadius: 24,
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/nazhan.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Name ────────────────────────────────────────────────────
                _animated(
                  fade: _fadeName,
                  slide: _slideName,
                  child: Center(
                    child: Text(
                      'Nazhan Fahmy',
                      style: tt.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [AppTheme.primary, AppTheme.secondary],
                          ).createShader(
                              const Rect.fromLTWH(0, 0, 400, 80)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Role tagline ────────────────────────────────────────────
                _animated(
                  fade: _fadeTagline,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Flutter Developer',
                          style: tt.titleMedium?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.textSubtle,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF2CDB8A),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2CDB8A)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Open to Opportunities',
                              style: tt.titleSmall?.copyWith(
                                color: AppTheme.textSubtle,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Objective ───────────────────────────────────────────────
                _animated(
                  fade: _fadeObjective,
                  child: Text(
                    'A highly motivated individual seeking a dynamic organisation to '
                    'contribute, learn, and grow in a collaborative and innovative '
                    'environment. Dedicated to gaining practical experience, '
                    'expanding skills, and making a positive impact while enhancing '
                    'professional growth.',
                    style: tt.bodyLarge?.copyWith(
                      color: AppTheme.textSubtle,
                      height: 1.7,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),

                // ── CTA buttons ─────────────────────────────────────────────
                _animated(
                  fade: _fadeCta,
                  child: Center(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        // Download CV
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Download CV'),
                          onPressed: () async {
                            final uri = Uri.parse(_kCvUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                        ),
                        // View Projects
                        OutlinedButton.icon(
                          icon: const Icon(Icons.grid_view_rounded, size: 18),
                          label: const Text('View Projects'),
                          onPressed: () => context.go('/projects'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 56),

                // ── Tech Stack header ───────────────────────────────────────
                _animated(
                  fade: _fadeTechHeader,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SKILLS & TOOLS',
                        style: tt.labelMedium?.copyWith(
                          color: AppTheme.primary,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tech Stack',
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Technologies and tools I work with day-to-day.',
                        style: tt.bodyMedium?.copyWith(
                          color: AppTheme.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Tech Stack grids ────────────────────────────────────────
                _animated(
                  fade: _fadeTechGrid,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TechGroup(
                        label: 'MOBILE & STATE',
                        chips: [
                          _TechChip(iconPath: 'assets/images/flutter_logo.svg',  label: 'Flutter',  isSvg: true),
                          _TechChip(iconPath: 'assets/images/dart_logo.svg',     label: 'Dart',     isSvg: true),
                          _TechChip(iconPath: 'assets/images/provider_logo.svg', label: 'Provider', isSvg: true),
                          _TechChip(iconPath: 'assets/images/riverpod_logo.svg', label: 'Riverpod', isSvg: true),
                          _TechChip(iconPath: 'assets/images/bloc_logo.svg',     label: 'Bloc',     isSvg: true),
                          _TechChip(iconPath: 'assets/images/test_logo.svg',     label: 'Testing',  isSvg: true),
                        ],
                      ),
                      SizedBox(height: 32),
                      _TechGroup(
                        label: 'BACKEND & DATABASE',
                        chips: [
                          _TechChip(iconPath: 'assets/images/firebase_logo.svg', label: 'Firebase', isSvg: true),
                          _TechChip(iconPath: 'assets/images/supa_base.svg',     label: 'Supabase', isSvg: true),
                          _TechChip(iconPath: 'assets/images/mysql_logo.svg',    label: 'MySQL',    isSvg: true),
                          _TechChip(iconPath: 'assets/images/mysql_logo.svg',    label: 'SQL',      isSvg: true),
                          _TechChip(iconPath: 'assets/images/sql_lite.svg',      label: 'SQLite',   isSvg: true),
                        ],
                      ),
                      SizedBox(height: 32),
                      _TechGroup(
                        label: 'PROGRAMMING LANGUAGES',
                        chips: [
                          _TechChip(iconPath: 'assets/images/c-programming.svg', label: 'C',          isSvg: true),
                          _TechChip(iconPath: 'assets/images/c++.svg',           label: 'C++',        isSvg: true),
                          _TechChip(iconPath: 'assets/images/c-sharp.svg',       label: 'C#',         isSvg: true),
                          _TechChip(iconPath: 'assets/images/python.svg',        label: 'Python',     isSvg: true),
                          _TechChip(iconPath: 'assets/images/java.svg',          label: 'Java',       isSvg: true),
                          _TechChip(iconPath: 'assets/images/html.svg',          label: 'HTML',       isSvg: true),
                          _TechChip(iconPath: 'assets/images/php.png',           label: 'PHP',        isSvg: false),
                          _TechChip(iconPath: 'assets/images/css.svg',           label: 'CSS',        isSvg: true),
                          _TechChip(iconPath: 'assets/images/javascript.svg',    label: 'JavaScript', isSvg: true),
                          _TechChip(iconPath: 'assets/images/angularjs.svg',     label: 'Angular',    isSvg: true),
                        ],
                      ),
                      SizedBox(height: 32),
                      _TechGroup(
                        label: 'TOOLS & PRACTICES',
                        chips: [
                          _TechChip(iconPath: 'assets/images/git_logo.svg',    label: 'Git',     isSvg: true),
                          _TechChip(iconPath: 'assets/images/arduino.svg',     label: 'Arduino', isSvg: true),
                          _TechChip(iconPath: 'assets/images/linux.png',       label: 'Linux',   isSvg: false),
                          _TechChip(iconPath: 'assets/images/windows.svg',     label: 'Windows', isSvg: true),
                          _TechChip(iconPath: 'assets/images/agile_logo.svg',  label: 'Agile',   isSvg: true),
                          _TechChip(iconPath: 'assets/images/scrum.png',       label: 'Scrum',   isSvg: false),
                        ],
                      ),
                      SizedBox(height: 32),
                      _TechGroup(
                        label: 'ADDITIONAL SKILLS',
                        chips: [
                          _TechChip(iconData: Icons.psychology_rounded, label: 'Problem Solving & Analytical Thinking'),
                          _TechChip(iconData: Icons.groups_rounded, label: 'Leadership & Team Collaboration'),
                          _TechChip(iconData: Icons.forum_rounded, label: 'Effective Communication in Agile'),
                          _TechChip(iconData: Icons.auto_awesome_rounded, label: 'Quick Learner & Adaptable'),
                        ],
                      ),
                      SizedBox(height: 32),
                      _TechGroup(
                        label: 'SPOKEN LANGUAGES',
                        chips: [
                          _TechChip(iconData: Icons.language_rounded, label: 'English (Fluent)'),
                          _TechChip(iconData: Icons.language_rounded, label: 'Sinhala (Native)'),
                          _TechChip(iconData: Icons.language_rounded, label: 'Tamil (Conversational)'),
                          _TechChip(iconData: Icons.language_rounded, label: 'Urdu (Basic)'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56),

                // ── Contact ─────────────────────────────────────────────────
                _animated(
                  fade: _fadeContact,
                  child: const ContactSection(),
                ),
                const SizedBox(height: 56),

                // ── References ──────────────────────────────────────────────
                _animated(
                  fade: _fadeReference,
                  child: const ReferenceSection(),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TechGroup — labelled category with a chip wrap
// ─────────────────────────────────────────────────────────────────────────────

class _TechGroup extends StatelessWidget {
  const _TechGroup({required this.label, required this.chips});

  final String label;
  final List<_TechChip> chips;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category overline
        Row(
          children: [
            Container(
              width: 16,
              height: 1.5,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.secondary],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: tt.labelSmall?.copyWith(
                color: AppTheme.textSubtle,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: chips,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TechChip — unified hover-animated chip (SVG + PNG)
// ─────────────────────────────────────────────────────────────────────────────

class _TechChip extends StatefulWidget {
  const _TechChip({
    this.iconPath,
    this.iconData,
    required this.label,
    this.isSvg = false,
  });

  final String? iconPath;
  final IconData? iconData;
  final String label;
  final bool isSvg;

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: _hovered
              ? AppTheme.primary.withValues(alpha: 0.08)
              : AppTheme.surfaceVariant,
          borderRadius: AppTheme.borderRadiusDefault,
          border: Border.all(
            color: _hovered
                ? AppTheme.primary.withValues(alpha: 0.5)
                : AppTheme.border,
            width: 1.2,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.10),
                    blurRadius: 12,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.iconPath != null) ...[
              widget.isSvg
                  ? SvgPicture.asset(widget.iconPath!, width: 18, height: 18)
                  : Image.asset(widget.iconPath!, width: 18, height: 18),
              const SizedBox(width: 8),
            ] else if (widget.iconData != null) ...[
              Icon(widget.iconData, size: 18, color: _hovered ? AppTheme.primary : AppTheme.textSubtle),
              const SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: tt.bodyMedium?.copyWith(
                color: _hovered ? AppTheme.primary : AppTheme.onBackground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
