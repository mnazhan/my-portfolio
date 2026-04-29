import 'package:flutter/material.dart';

// ─── Media Model ──────────────────────────────────────────────────────────────

enum ProjectMediaType { image, video }

/// A single image or video asset belonging to a project.
class ProjectMedia {
  const ProjectMedia({required this.assetPath, required this.type});

  final String assetPath;
  final ProjectMediaType type;

  bool get isVideo => type == ProjectMediaType.video;
  bool get isImage => type == ProjectMediaType.image;
}

// ─── Project Model ────────────────────────────────────────────────────────────

/// A single portfolio project.
class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.accentColor,
    required this.icon,
    this.isStealthMode = false,
    this.media = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final Color accentColor;
  final IconData icon;
  final bool isStealthMode;

  /// Images and screen recordings for the project detail page.
  final List<ProjectMedia> media;

  /// Live portfolio projects.
  static const List<ProjectModel> all = [
    ProjectModel(
      id: 'vestai',
      title: 'VestAI',
      subtitle: 'AI-Powered Tuna Grading System',
      description:
          'VestAI automates tuna quality grading using on-device AI — no internet '
          'required for detection. A user captures or uploads a tuna sample image and '
          'the app runs it through an on-device TFLite model, returning a grade '
          'classification and confidence score instantly.\n\n'
          'Key features include AI-based fish grading via camera or gallery, '
          'supplier & receiver management synced between Cloud Firestore and SQLite, '
          'PDF report generation with batch weight logging, email distribution of '
          'reports via Firebase Storage, a full reports history with swipe-to-send, '
          'and secure Firebase Auth login.\n\n'
          'Built by Nazhan Fahmy & Shakthi Lakmal.\n',
      tags: [
        'Flutter',
        'TensorFlow Lite',
        'Firebase Firestore',
        'SQLite',
        'Firebase Storage',
        'Firebase Auth',
        'PDF Generation',
        'Provider',
        'On-Device AI',
      ],
      accentColor: Color(0xFFFF6B35),
      icon: Icons.set_meal_rounded,
      media: [
        ProjectMedia(
          assetPath: 'assets/projects/vestai/vetai_app_screen_recording.mp4',
          type: ProjectMediaType.video,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/vestai/log_in_screen.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/vestai/sing_in_screen.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/vestai/dashboard_screen.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/vestai/user_screen.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/vestai/supplier_screen.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/vestai/receiver_screen.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/vestai/report_screen.jpeg',
          type: ProjectMediaType.image,
        ),
      ],
    ),
    ProjectModel(
      id: 'school360',
      title: 'School360 Guru',
      subtitle: 'Mobile Education Management',
      description:
          'School360 Guru is a specialized mobile ecosystem designed to digitize the daily '
          'operations of educators and school administrators. Built as a high-performance '
          'extension of the broader School360 suite, the app acts as a real-time digital assistant.\n\n'
          'By replacing traditional paper-based workflows with a modular, mobile-first approach, '
          'it empowers teachers to focus on student engagement while providing principals with '
          'instant, actionable insights into school operations.\n\n'
          'Core features include Smart Attendance, Dynamic Timetables, an Administrative '
          'Dashboard, and a Unified Communication hub.\n\n'
          'Technical highlights: Google Sign-In (OAuth 2.0), Role-Based Access Control (RBAC), '
          'Firebase Cloud Messaging (FCM), real-time cloud synchronization, and automated '
          'testing (Unit & Widget).',
      tags: [
        'Flutter',
        'Firebase',
        'Google Cloud',
        'Flutter Test',
        'RBAC',
        'OAuth 2.0',
      ],
      accentColor: Color(0xFF25D1F4),
      icon: Icons.school_rounded,
      // No local assets yet for School360
      media: [],
    ),
    ProjectModel(
      id: 'gsis',
      title: 'GSIS',
      subtitle: 'Graduate Students Information System',
      description:
          'An integrated, dual-platform solution bridging the communication gap between '
          'students, faculty supervisors, and university administration by digitizing '
          'academic milestones and complex documentation.\n\n'
          'Mobile App (Flutter) — Built for research supervisors to monitor student '
          'progress and research milestones in real time, featuring push notifications '
          'and tracking dashboards.\n\n'
          'Web App (PHP Core) — A robust administrative panel for the Admission '
          'Office to manage records, verify documents, and maintain the central '
          'database with secure document management.\n\n'
          'Engineered the backend with a normalized MySQL schema and developed a '
          'custom REST API layer to synchronize data seamlessly between the web backend '
          'and the cross-platform Flutter interface.\n\n'
          'Final Year Project supervised by Dr. Muhammad Asif & Dr. Waqar Ahmad.',
      tags: [
        'Flutter',
        'PHP Core',
        'MySQL',
        'REST API',
        'HTML5/CSS3',
      ],
      accentColor: Color(0xFF8B5CF6),
      icon: Icons.language_rounded,
      media: [
        ProjectMedia(
          assetPath: 'assets/projects/GSIS/gsis_screen1.png',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GSIS/gsis_screen_2.png',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GSIS/gsis_screen_3.png',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GSIS/gsis_screen_4.png',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GSIS/gsis_mobile_screen_record.mp4',
          type: ProjectMediaType.video,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GSIS/gsis_mobile_screen_record_2.mp4',
          type: ProjectMediaType.video,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GSIS/gsis_web_complete_details_video.mp4',
          type: ProjectMediaType.video,
        ),
      ],
    ),
    ProjectModel(
      id: 'gym-tracker',
      title: 'GYM Workout',
      subtitle: 'Personal Fitness Companion App',
      description:
          'A full-featured personal fitness tracker built with Flutter & Dart. '
          'Managing your fitness journey shouldn\'t be complicated — this app brings '
          'everything you need into one clean, easy-to-use interface.\n\n'
          'Workout Scheduling — Create and manage multiple workout schedules with '
          'custom exercises, sets, and reps.\n\n'
          'Live Workout Tracking — Log daily workouts in real time, track start/end '
          'times and exercise completion.\n\n'
          'Quick Stats & Insights — Visual charts showing workout frequency, current '
          'streak, weekly goal progress, and muscle group breakdown.\n\n'
          'Weight Tracker — Log your weight over time with a visual progress chart.\n\n'
          'Health Dashboard — Track BMI, calculate daily calorie needs (TDEE), and get '
          'personalized macro breakdowns (protein, carbs, fat) based on your body stats '
          'and goals using the Mifflin-St Jeor Equation.\n\n'
          'Google Sign-In — Secure OAuth authentication with a personalized welcome experience.\n\n'
          'Fully offline — all data is stored locally on-device using SQLite.',
      tags: [
        'Flutter',
        'SQLite',
        'fl_chart',
        'table_calendar',
        'Google Sign-In',
        'Mifflin-St Jeor',
        'Privacy-focused',
      ],
      accentColor: Color(0xFF2CDB8A),
      icon: Icons.fitness_center_rounded,
      media: [
        ProjectMedia(
          assetPath: 'assets/projects/GYM/gym_1.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GYM/gym_2.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GYM/gym_3.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GYM/gym_4.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GYM/gym_5.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/GYM/gym_screen_record.mp4',
          type: ProjectMediaType.video,
        ),
      ],
    ),
    ProjectModel(
      id: 'card-game',
      title: 'Card Game',
      subtitle: 'Mobile Game',
      description:
          'A fun and engaging mobile card game built with Flutter. '
          'Features smooth animations, game state management, and a polished UI.',
      tags: ['Flutter', 'Game Dev', 'Animations'],
      accentColor: Color(0xFFFF6B6B),
      icon: Icons.casino_rounded,
      media: [
        ProjectMedia(
          assetPath: 'assets/projects/card_game/card_game_1.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/card_game/card_game_2.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/card_game/card_game_3.jpeg',
          type: ProjectMediaType.image,
        ),
        ProjectMedia(
          assetPath: 'assets/projects/card_game/card_game_screen_record.mp4',
          type: ProjectMediaType.video,
        ),
      ],
    ),
  ];
}
