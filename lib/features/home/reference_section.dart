import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

// ── Reference data model ─────────────────────────────────────────────────────

class _ReferenceItem {
  const _ReferenceItem({
    required this.name,
    required this.title,
    required this.email,
    required this.emailUrl,
  });

  final String name;
  final String title;
  final String email;
  final String emailUrl;
}

const _references = [
  _ReferenceItem(
    name: 'Dr. Muhammad Asif',
    title: 'Chairman, Dept. of Computer Science, NTU | FYP Supervisor',
    email: 'asif@ntu.edu.pk / asi135@gmail.com',
    emailUrl: 'mailto:asif@ntu.edu.pk',
  ),
  _ReferenceItem(
    name: 'Waqar Ahmad',
    title: 'Assistant Professor, NTU | FYP Co-Supervisor',
    email: 'waqar@ntu.edu.pk / waqarzahoor@gmail.com',
    emailUrl: 'mailto:waqar@ntu.edu.pk',
  ),
  _ReferenceItem(
    name: 'Lahiru Gambheera',
    title: 'Director School360',
    email: 'lahiru.gambheera@gmail.com',
    emailUrl: 'mailto:lahiru.gambheera@gmail.com',
  ),
  _ReferenceItem(
    name: 'Asiri Rajapaksha',
    title: 'Director School360',
    email: 'asiri.l.rajapaksha59@gmail.com',
    emailUrl: 'mailto:asiri.l.rajapaksha59@gmail.com',
  ),
];

// ── Public widget ──────────────────────────────────────────────────────────

class ReferenceSection extends StatelessWidget {
  const ReferenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section divider line ─────────────────────────────────────────
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withValues(alpha: 0.5),
                AppTheme.secondary.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Header row ───────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4,
              height: 26,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.primary, AppTheme.secondary],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'References',
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.onBackground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            "Professionals I have had the pleasure of working with.",
            style: tt.bodyMedium?.copyWith(color: AppTheme.textSubtle),
          ),
        ),
        const SizedBox(height: 24),

        // ── Cards ────────────────────────────────────────────────────────
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _references.map((item) => _ReferenceCard(item: item)).toList(),
        ),
      ],
    );
  }
}

// ── Individual animated card ───────────────────────────────────────────────

class _ReferenceCard extends StatefulWidget {
  const _ReferenceCard({required this.item});
  final _ReferenceItem item;

  @override
  State<_ReferenceCard> createState() => _ReferenceCardState();
}

class _ReferenceCardState extends State<_ReferenceCard> {
  bool _hovered = false;

  void _onEnter() => setState(() => _hovered = true);
  void _onExit() => setState(() => _hovered = false);

  Future<void> _launch() async {
    final uri = Uri.parse(widget.item.emailUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          // Fixed width so we get a 2-across grid inside the 800 px column
          width: 368,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.surface.withValues(alpha: 0.95)
                : AppTheme.surfaceVariant,
            borderRadius: AppTheme.borderRadiusDefault,
            border: Border.all(
              color: _hovered
                  ? AppTheme.primary.withValues(alpha: 0.55)
                  : AppTheme.border,
              width: 1.2,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon badge ─────────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _hovered
                      ? AppTheme.primary.withValues(alpha: 0.15)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _hovered
                        ? AppTheme.primary.withValues(alpha: 0.45)
                        : AppTheme.border,
                  ),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 20,
                  color: _hovered ? AppTheme.primary : AppTheme.textSubtle,
                ),
              ),
              const SizedBox(width: 14),

              // ── Label & value ──────────────────────────────────────
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.item.name,
                      style: tt.bodyLarge?.copyWith(
                        color: _hovered
                            ? AppTheme.primary
                            : AppTheme.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.title,
                      style: tt.bodySmall?.copyWith(
                        color: AppTheme.textSubtle,
                        height: 1.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline_rounded,
                          size: 14,
                          color: AppTheme.primary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.item.email,
                            style: tt.bodySmall?.copyWith(
                              color: AppTheme.textSubtle,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── External link arrow (only when hovered) ────────────
              const SizedBox(width: 6),
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.north_east_rounded,
                  size: 14,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
