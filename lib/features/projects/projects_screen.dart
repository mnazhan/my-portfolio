import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/features/projects/models/project_model.dart';
import 'package:my_portfolio/features/projects/widgets/project_card.dart';

/// Full project list screen, extracted from the Stitch "Project Hub" designs.
///
/// Layout:
///   Mobile  (< 600 px)  → single-column list
///   Tablet  (600–1024)  → 2-column grid
///   Desktop (≥ 1024)    → 3-column grid
///
/// Each [ProjectCard] receives a staggered [entranceDelay] so the cards
/// spring in one-by-one, 80 ms apart.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  static const Duration _staggerStep = Duration(milliseconds: 80);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final projects = ProjectModel.all;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Eyebrow
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SELECTED WORK',
                        style: tt.labelSmall?.copyWith(
                          color: AppTheme.primary,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                    ).createShader(bounds),
                    child: Text(
                      'Project Hub',
                      style: tt.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white, // masked by shader
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'A showcase of high-performance Flutter applications\nwith clean architectures and pixel-perfect UIs.',
                    style: tt.bodyLarge?.copyWith(color: AppTheme.textSubtle),
                  ),

                  const SizedBox(height: 8),

                  // Project count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.10),
                      borderRadius: AppTheme.borderRadiusPill,
                      border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.25)),
                    ),
                    child: Text(
                      '${projects.length} Projects',
                      style: tt.labelSmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Divider(color: AppTheme.border),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),

          // ── Responsive grid ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: _ProjectGrid(
              projects: projects,
              staggerStep: _staggerStep,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}

// ─── Responsive Project Grid ──────────────────────────────────────────────────

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({
    required this.projects,
    required this.staggerStep,
  });

  final List<ProjectModel> projects;
  final Duration staggerStep;

  int _crossAxisCount(double width) {
    if (width >= 1024) return 3;
    if (width >= 600) return 2;
    return 1; // mobile → single-column list
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final cols = _crossAxisCount(constraints.crossAxisExtent);

        // ── Mobile: natural-height list (no fixed aspect ratio) ──────────
        // A fixed childAspectRatio on mobile causes render overflow because
        // card content (tags, description, padding) exceeds the cell height.
        if (cols == 1) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: EdgeInsets.only(
                    bottom: i < projects.length - 1 ? 16 : 0),
                child: ProjectCard(
                  project: projects[i],
                  entranceDelay: staggerStep * i,
                  onTap: () {},
                ),
              ),
              childCount: projects.length,
            ),
          );
        }

        // ── Tablet / Desktop: fixed-ratio grid ───────────────────────────
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, i) => ProjectCard(
              project: projects[i],
              entranceDelay: staggerStep * (i % cols + i ~/ cols),
              onTap: () {},
            ),
            childCount: projects.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.88,
          ),
        );
      },
    );
  }
}
