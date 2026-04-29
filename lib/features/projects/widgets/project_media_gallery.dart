import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/features/projects/models/project_model.dart';

// ─── Public Gallery Widget ────────────────────────────────────────────────────

/// Horizontal scrollable gallery of images and videos for a project.
/// Tapping an image opens a full-screen lightbox.
/// Tapping a video opens a full-screen video player.
class ProjectMediaGallery extends StatelessWidget {
  const ProjectMediaGallery({
    super.key,
    required this.media,
    required this.accent,
  });

  final List<ProjectMedia> media;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: AppTheme.borderRadiusDefault,
          border: Border.all(color: AppTheme.border),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.photo_library_outlined,
                  color: AppTheme.textSubtle, size: 32),
              const SizedBox(height: 8),
              Text(
                'No media available yet',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppTheme.textSubtle),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < media.length; i++)
            Padding(
              padding: EdgeInsets.only(right: i < media.length - 1 ? 14 : 0),
              child: media[i].isVideo
                  ? _VideoThumb(
                      media: media[i],
                      accent: accent,
                      index: i,
                    )
                  : _ImageThumb(
                      media: media[i],
                      accent: accent,
                      allMedia: media,
                      index: i,
                    ),
            ),
        ],
      ),
    );
  }
}

// ─── Image Thumbnail ──────────────────────────────────────────────────────────

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({
    required this.media,
    required this.accent,
    required this.allMedia,
    required this.index,
  });

  final ProjectMedia media;
  final Color accent;
  final List<ProjectMedia> allMedia;
  final int index;

  // Phone portrait aspect — matches typical mobile screenshot dimensions.
  static const double _kWidth = 160;
  static const double _kHeight = 284;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openLightbox(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: _kWidth,
          height: _kHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                media.assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.surfaceVariant,
                  child: const Icon(Icons.broken_image_outlined,
                      color: AppTheme.textSubtle),
                ),
              ),
              // Subtle gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Tap hint
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.zoom_out_map_rounded,
                      size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLightbox(BuildContext context) {
    // Collect only image media for lightbox navigation
    final images = allMedia.where((m) => m.isImage).toList();
    final startIndex = images.indexOf(media);
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) => _LightboxPage(
          images: images,
          initialIndex: startIndex < 0 ? 0 : startIndex,
        ),
      ),
    );
  }
}

// ─── Video Thumbnail ──────────────────────────────────────────────────────────

class _VideoThumb extends StatelessWidget {
  const _VideoThumb({
    required this.media,
    required this.accent,
    required this.index,
  });

  final ProjectMedia media;
  final Color accent;
  final int index;

  static const double _kWidth = 160;
  static const double _kHeight = 284;

  String get _label {
    final name = media.assetPath.split('/').last;
    if (name.contains('web')) return 'Web Demo';
    if (name.contains('mobile') && name.contains('2')) return 'Mobile #2';
    if (name.contains('mobile')) return 'Mobile #1';
    return 'Recording ${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPlayer(context),
      child: Container(
        width: _kWidth,
        height: _kHeight,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.3)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Play icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.15),
                border: Border.all(color: accent.withValues(alpha: 0.4)),
              ),
              child: Icon(Icons.play_arrow_rounded, color: accent, size: 32),
            ),
            // Label at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(11)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.videocam_rounded, size: 12, color: accent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPlayer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) =>
            _VideoPlayerPage(assetPath: media.assetPath, accent: accent),
      ),
    );
  }
}

// ─── Lightbox (full-screen image viewer) ─────────────────────────────────────

class _LightboxPage extends StatefulWidget {
  const _LightboxPage({required this.images, required this.initialIndex});

  final List<ProjectMedia> images;
  final int initialIndex;

  @override
  State<_LightboxPage> createState() => _LightboxPageState();
}

class _LightboxPageState extends State<_LightboxPage> {
  late final PageController _page;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _page = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_current + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        controller: _page,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, i) => InteractiveViewer(
          child: Center(
            child: Image.asset(
              widget.images[i].assetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white38,
                size: 64,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Full-screen Video Player ─────────────────────────────────────────────────

class _VideoPlayerPage extends StatefulWidget {
  const _VideoPlayerPage({required this.assetPath, required this.accent});

  final String assetPath;
  final Color accent;

  @override
  State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<_VideoPlayerPage> {
  late final VideoPlayerController _ctrl;
  bool _initialized = false;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _ctrl = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          _ctrl.play();
        }
      }).catchError((_) {
        if (mounted) setState(() => _hasError = true);
      });
    _ctrl.setLooping(true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggleControls() => setState(() => _showControls = !_showControls);
  void _togglePlay() {
    setState(() {
      _ctrl.value.isPlaying ? _ctrl.pause() : _ctrl.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _hasError
          ? _ErrorView(accent: widget.accent)
          : !_initialized
              ? Center(
                  child: CircularProgressIndicator(color: widget.accent),
                )
              : GestureDetector(
                  onTap: _toggleControls,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video
                      Center(
                        child: AspectRatio(
                          aspectRatio: _ctrl.value.aspectRatio,
                          child: VideoPlayer(_ctrl),
                        ),
                      ),

                      // Controls overlay
                      AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.35),
                          child: Center(
                            child: GestureDetector(
                              onTap: _togglePlay,
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.accent.withValues(alpha: 0.2),
                                  border: Border.all(
                                      color: widget.accent, width: 1.5),
                                ),
                                child: ValueListenableBuilder(
                                  valueListenable: _ctrl,
                                  builder: (_, val, __) => Icon(
                                    val.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Progress bar
                      if (_showControls)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                            child: ValueListenableBuilder(
                              valueListenable: _ctrl,
                              builder: (_, val, __) {
                                final pos = val.position.inMilliseconds
                                    .toDouble()
                                    .clamp(
                                        0.0,
                                        val.duration.inMilliseconds
                                            .toDouble()
                                            .clamp(1.0, double.infinity)
                                            .toDouble())
                                    .toDouble();
                                final dur = val.duration.inMilliseconds
                                    .toDouble()
                                    .clamp(1.0, double.infinity)
                                    .toDouble();
                                return Column(
                                  children: [
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 6),
                                        trackHeight: 3,
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                                overlayRadius: 12),
                                        activeTrackColor: widget.accent,
                                        inactiveTrackColor:
                                            Colors.white.withValues(alpha: 0.2),
                                        thumbColor: widget.accent,
                                        overlayColor: widget.accent
                                            .withValues(alpha: 0.2),
                                      ),
                                      child: Slider(
                                        value: pos,
                                        min: 0,
                                        max: dur,
                                        onChanged: (v) => _ctrl.seekTo(
                                            Duration(milliseconds: v.toInt())),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_fmt(val.position),
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11)),
                                          Text(_fmt(val.duration),
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, color: accent, size: 48),
          const SizedBox(height: 12),
          Text(
            'Could not load video',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'The file may be too large to stream from assets.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
