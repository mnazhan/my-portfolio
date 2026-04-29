import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

// ── Contact data model ─────────────────────────────────────────────────────

class _ContactItem {
  const _ContactItem({
    required this.label,
    required this.value,
    required this.displayValue,
    required this.icon,
    this.url,
  });

  final String label;
  final String value;
  final String displayValue; // shorter string shown in the card
  final IconData icon;
  final String? url; // null → non-tappable (e.g. location)
}

const _contacts = [
  _ContactItem(
    label: 'LinkedIn',
    value: 'https://www.linkedin.com/in/nazhanfahmy',
    displayValue: 'linkedin.com/in/nazhanfahmy',
    icon: Icons.link_rounded,
    url: 'https://www.linkedin.com/in/nazhanfahmy',
  ),
  _ContactItem(
    label: 'GitLab',
    value: 'https://gitlab.com/mnazhan',
    displayValue: 'gitlab.com/mnazhan',
    icon: Icons.code_rounded,
    url: 'https://gitlab.com/mnazhan',
  ),
  _ContactItem(
    label: 'WhatsApp',
    value: 'https://wa.me/94767957093',
    displayValue: '+94 76 795 7093',
    icon: Icons.chat_bubble_outline_rounded,
    url: 'https://wa.me/94767957093',
  ),
  _ContactItem(
    label: 'Email',
    value: 'mailto:nazhanfahmy1@gmail.com',
    displayValue: 'nazhanfahmy1@gmail.com',
    icon: Icons.mail_outline_rounded,
    url: 'mailto:nazhanfahmy1@gmail.com',
  ),
  _ContactItem(
    label: 'Medium',
    value: 'https://medium.com/@nazhanfahmy1',
    displayValue: 'medium.com/@nazhanfahmy1',
    icon: Icons.article_outlined,
    url: 'https://medium.com/@nazhanfahmy1',
  ),
  _ContactItem(
    label: 'Location',
    value: '32, Udugama Road, Makuluwa, Galle',
    displayValue: '32, Udugama Rd, Makuluwa, Galle',
    icon: Icons.location_on_outlined,
    // no url → non-tappable
  ),
];

// ── Public widget ──────────────────────────────────────────────────────────

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

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
              'Contact',
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
            "Feel free to reach out — I'm always open to new opportunities.",
            style: tt.bodyMedium?.copyWith(color: AppTheme.textSubtle),
          ),
        ),
        const SizedBox(height: 24),

        // ── Cards ────────────────────────────────────────────────────────
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _contacts.map((item) => _ContactCard(item: item)).toList(),
        ),
      ],
    );
  }
}

// ── Individual animated card ───────────────────────────────────────────────

class _ContactCard extends StatefulWidget {
  const _ContactCard({required this.item});
  final _ContactItem item;

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;

  void _onEnter() => setState(() => _hovered = true);
  void _onExit() => setState(() => _hovered = false);

  Future<void> _launch() async {
    final url = widget.item.url;
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final tappable = widget.item.url != null;

    return MouseRegion(
      cursor: tappable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: tappable ? _launch : null,
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
                  widget.item.icon,
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
                      widget.item.label.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        color: AppTheme.textSubtle,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.item.displayValue,
                      style: tt.bodyMedium?.copyWith(
                        color: _hovered
                            ? AppTheme.primary
                            : AppTheme.onBackground,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),

              // ── External link arrow (only when hovered + tappable) ─
              if (tappable) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}
