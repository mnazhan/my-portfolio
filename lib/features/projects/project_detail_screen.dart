import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/l10n/app_strings.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/features/projects/models/project_model.dart';
import 'package:my_portfolio/features/projects/widgets/project_media_gallery.dart';

/// Full-screen project detail page reached via Hero animation from [ProjectCard].
///
/// The Hero tag is 'project-hero-${project.id}' and wraps the icon badge,
/// matching the tag in [ProjectCard].
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  ProjectModel? get _project =>
      ProjectModel.all.cast<ProjectModel?>().firstWhere(
            (p) => p?.id == projectId,
            orElse: () => null,
          );

  @override
  Widget build(BuildContext context) {
    final project = _project;
    if (project == null) {
      return Scaffold(
        body: Center(
          child: Text('Project not found',
              style: Theme.of(context).textTheme.bodyLarge),
        ),
      );
    }

    final s = AppStrings.of(context);
    final tt = Theme.of(context).textTheme;
    final accent = project.accentColor;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sliver App Bar with Hero ───────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppTheme.surface,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.onBackground),
              onPressed: () => context.pop(),
            ),
            title: Text(s.detailBack,
                style: tt.titleMedium?.copyWith(color: AppTheme.textSubtle)),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient mesh background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.surface,
                          accent.withValues(alpha: 0.12),
                          AppTheme.background,
                        ],
                      ),
                    ),
                  ),
                  // Accent top strip
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accent, accent.withValues(alpha: 0.2)],
                        ),
                      ),
                    ),
                  ),
                  // Hero icon badge — must match tag in ProjectCard
                  Center(
                    child: Hero(
                      tag: 'project-hero-${project.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: accent.withValues(alpha: 0.35),
                                width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.3),
                                blurRadius: 28,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Icon(project.icon, color: accent, size: 40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + subtitle
                  Text(project.title,
                      style: tt.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(project.subtitle,
                      style: tt.titleSmall?.copyWith(color: accent)),
                  const SizedBox(height: 16),

                  // Description
                  Text(project.description,
                      style: tt.bodyLarge
                          ?.copyWith(color: AppTheme.textSubtle, height: 1.65)),
                  const SizedBox(height: 28),

                  // Divider
                  const Divider(color: AppTheme.border),
                  const SizedBox(height: 24),

                  // Tech stack
                  Text(s.detailTechStack,
                      style: tt.labelLarge?.copyWith(
                          color: AppTheme.onBackground,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.tags
                        .map((tag) => _TechChip(label: tag, accent: accent))
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  const Divider(color: AppTheme.border),
                  const SizedBox(height: 28),

                  // ── Media Gallery ─────────────────────────────────────
                  Text(
                    project.media.isEmpty
                        ? 'SCREENSHOTS & RECORDINGS'
                        : 'SCREENSHOTS & RECORDINGS',
                    style: tt.labelLarge?.copyWith(
                      color: AppTheme.onBackground,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.media.isEmpty
                        ? 'No media available yet'
                        : '${project.media.where((m) => m.isImage).length} screenshots · '
                            '${project.media.where((m) => m.isVideo).length} recordings',
                    style: tt.bodySmall?.copyWith(color: AppTheme.textSubtle),
                  ),
                  const SizedBox(height: 20),

                  ProjectMediaGallery(
                    media: project.media,
                    accent: accent,
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tech Chip ────────────────────────────────────────────────────────────────

class _TechChip extends StatelessWidget {
  const _TechChip({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: AppTheme.borderRadiusPill,
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
