import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/l10n/app_strings.dart';
import 'package:my_portfolio/core/l10n/locale_notifier.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';

// ─── Nav item model ──────────────────────────────────────────────────────────

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;
}

// Nav items are now label-less; labels are resolved from AppStrings at render time.
const List<_NavItem> _navItems = [
  _NavItem(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    path: '/',
  ),
  _NavItem(
    label: 'Projects',
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view_rounded,
    path: '/projects',
  ),
  _NavItem(
    label: 'Experience',
    icon: Icons.history_edu_outlined,
    activeIcon: Icons.history_edu_rounded,
    path: '/experience',
  ),
];

/// Returns the localised label for a nav item at [index].
String _navLabel(int index, AppStrings s) {
  switch (index) {
    case 0: return s.navHome;
    case 1: return s.navProjects;
    case 2: return s.navExperience;
    default: return _navItems[index].label;
  }
}

// ─── Breakpoints ─────────────────────────────────────────────────────────────

/// Mobile layout strictly below this width.
const double _kMobileBreakpoint = 600;

/// True Bento grid/desktop layout active at or above this width.
/// Between 600 and 1024, it falls back to the sidebar layout but adapts spacing.
const double _kBentoBreakpoint = 1024;

// ─── MainScreen ──────────────────────────────────────────────────────────────

/// Adaptive shell that wraps every routed page.
/// - Mobile  (< 768 px) → [_MobileShell] with a bottom navigation bar.
/// - Desktop (≥ 768 px) → [_DesktopShell] with a fixed left sidebar.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.child});

  /// The currently active routed page injected by go_router's [ShellRoute].
  final Widget child;

  /// Returns the [_NavItem] index that matches [location].
  static int _indexForLocation(String location) {
    // Walk in reverse so more-specific paths win (e.g. /projects/detail).
    for (int i = _navItems.length - 1; i >= 0; i--) {
      if (_navItems[i].path == '/'
          ? location == '/'
          : location.startsWith(_navItems[i].path)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexForLocation(location);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < _kMobileBreakpoint;

        return isMobile
            ? _MobileShell(
                currentIndex: currentIndex,
                child: child,
              )
            : _DesktopShell(
                currentIndex: currentIndex,
                isBento: constraints.maxWidth >= _kBentoBreakpoint,
                child: child,
              );
      },
    );
  }
}

// ─── Mobile Shell ─────────────────────────────────────────────────────────────

class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.currentIndex, required this.child});

  final int currentIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        titleSpacing: 20,
        title: ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppTheme.primary, AppTheme.secondary],
          ).createShader(b),
          child: const Text(
            'NF.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
        ),
        actions: const [
          _LanguagePickerButton(),
          SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      bottomNavigationBar: _StitchBottomNav(
        currentIndex: currentIndex,
        onTap: (i) => context.go(_navItems[i].path),
      ),
      body: child,
    );
  }
}

/// Bottom nav bar styled to match the Stitch mobile screens.
/// Uses a frosted-glass-style surface with the primary-accent indicator.
class _StitchBottomNav extends StatelessWidget {
  const _StitchBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final isActive = i == currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(i);
                  },
                  borderRadius: AppTheme.borderRadiusDefault,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Active indicator pill
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isActive ? 24 : 0,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            key: ValueKey(isActive),
                            color: isActive ? AppTheme.primary : AppTheme.textSubtle,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: isActive ? AppTheme.primary : AppTheme.textSubtle,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                              ),
                          child: Text(_navLabel(i, AppStrings.of(context))),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Desktop / Tablet Shell ───────────────────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.currentIndex,
    required this.child,
    required this.isBento,
  });

  final int currentIndex;
  final Widget child;
  final bool isBento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _StitchSidebar(
            currentIndex: currentIndex,
            onTap: (i) => context.go(_navItems[i].path),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: AppTheme.border),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Unbounded if not bento, otherwise cap at 1200 for ultrawide
                  maxWidth: isBento ? 1200 : double.infinity,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Left sidebar styled to match the Stitch desktop "My webpage" screen.
/// Contains the logo/avatar area, nav items, and social/footer links.
class _StitchSidebar extends StatelessWidget {
  const _StitchSidebar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: 220,
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo / identity area ──────────────────────────────────────
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Glowing avatar badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.35),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'NF',
                      style: TextStyle(
                        color: AppTheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Nazhan Fahmy',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onBackground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Flutter Developer',
                  style: tt.bodySmall?.copyWith(color: AppTheme.textSubtle),
                ),
                const SizedBox(height: 4),
                // Online indicator
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
                            color:
                                const Color(0xFF2CDB8A).withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Available for hire',
                      style:
                          tt.labelSmall?.copyWith(color: AppTheme.textSubtle),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Divider
          const Divider(color: AppTheme.border, thickness: 1, height: 1),
          const SizedBox(height: 24),

          // ── Nav items ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isActive = i == currentIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _SidebarNavItem(
                    item: item,
                    isActive: isActive,
                    onTap: () => onTap(i),
                  ),
                );
              }),
            ),
          ),

          const Spacer(),

          // ── Footer / location ─────────────────────────────────────────
          const Divider(color: AppTheme.border, thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppTheme.textSubtle),
                    const SizedBox(width: 4),
                    Text(
                      'Galle - Sri Lanka',
                      style: tt.labelSmall
                          ?.copyWith(color: AppTheme.textSubtle),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Social + language row
                Row(
                  children: [
                    // _SocialIcon(
                    //   icon: Icons.link,
                    //   tooltip: 'LinkedIn',
                    //   onTap: () {},
                    // ),
                    // const SizedBox(width: 8),
                    // _SocialIcon(
                    //   icon: Icons.code,
                    //   tooltip: 'GitHub',
                    //   onTap: () {},
                    // ),
                    // const SizedBox(width: 8),
                    // _SocialIcon(
                    //   icon: Icons.email_outlined,
                    //   tooltip: 'Email',
                    //   onTap: () {},
                    // ),
                    // const SizedBox(width: 8),
                    // _SocialIcon(
                    //   icon: Icons.call,
                    //   tooltip: 'WhatsApp',
                    //   onTap: () {},
                    // ),
                    const Spacer(),
                    const _LanguagePickerButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sidebar Nav Item ─────────────────────────────────────────────────────────

class _SidebarNavItem extends StatefulWidget {
  const _SidebarNavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isActive = widget.isActive;
    final isHighlighted = isActive || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primary.withValues(alpha: 0.12)
                : _hovered
                    ? AppTheme.surfaceVariant
                    : Colors.transparent,
            borderRadius: AppTheme.borderRadiusDefault,
            border: isActive
                ? Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3), width: 1)
                : null,
          ),
          child: Row(
            children: [
              // Left accent bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color:
                      isActive ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                isActive ? widget.item.activeIcon : widget.item.icon,
                size: 20,
                color: isHighlighted ? AppTheme.primary : AppTheme.textSubtle,
              ),
              const SizedBox(width: 10),
              Text(
                _navLabel(_navItems.indexOf(widget.item), AppStrings.of(context)),
                style: tt.titleSmall?.copyWith(
                  color: isHighlighted ? AppTheme.onBackground : AppTheme.textSubtle,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Social Icon ──────────────────────────────────────────────────────────────

class _SocialIcon extends StatefulWidget {
  const _SocialIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _hovered ? AppTheme.primary.withValues(alpha: 0.15) : AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _hovered ? AppTheme.primary.withValues(alpha: 0.4) : AppTheme.border,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: _hovered ? AppTheme.primary : AppTheme.textSubtle,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Language Picker Button ───────────────────────────────────────────────────

/// Globe icon that opens [_LanguagePicker] as a bottom sheet / dialog.
class _LanguagePickerButton extends StatelessWidget {
  const _LanguagePickerButton();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Language',
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          HapticFeedback.lightImpact();
          showModalBottomSheet(
            context: context,
            backgroundColor: AppTheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const _LanguagePicker(),
          );
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Icon(Icons.language_rounded,
              size: 16, color: AppTheme.textSubtle),
        ),
      ),
    );
  }
}

// ─── Language Picker Sheet ────────────────────────────────────────────────────

class _LanguagePicker extends ConsumerWidget {
  const _LanguagePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final tt = Theme.of(context).textTheme;
    final currentLocale = ref.watch(appLocaleProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.language_rounded,
                    color: AppTheme.primary, size: 20),
                const SizedBox(width: 10),
                Text('Language',
                    style: tt.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 16),
            ...s.availableLocales.map((entry) {
              final (locale, name) = entry;
              final isSelected = locale.languageCode ==
                  currentLocale.languageCode;
              return _LocaleTile(
                locale: locale,
                name: name,
                isSelected: isSelected,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(appLocaleProvider.notifier).setLocale(locale);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _LocaleTile extends StatelessWidget {
  const _LocaleTile({
    required this.locale,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  final Locale locale;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  static const _flags = {'en': '🇬🇧', 'si': '🇱🇰', 'ta': '🇱🇰'};

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final flag = _flags[locale.languageCode] ?? '🌐';

    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.borderRadiusDefault,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.10)
              : AppTheme.surfaceVariant,
          borderRadius: AppTheme.borderRadiusDefault,
          border: Border.all(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.4)
                : AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(name,
                style: tt.titleSmall?.copyWith(
                  color: isSelected
                      ? AppTheme.onBackground
                      : AppTheme.textSubtle,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                )),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_rounded,
                  color: AppTheme.primary, size: 18),
          ],
        ),
      ),
    );
  }
}
