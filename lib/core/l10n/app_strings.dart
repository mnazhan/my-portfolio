import 'package:flutter/material.dart';

/// Provides localised string look-ups without code generation.
///
/// Call [AppStrings.of(context)] anywhere below [MaterialApp] to get strings
/// for the current locale.  Falls back to English for any missing key.
class AppStrings {
  const AppStrings._(this._locale);

  final Locale _locale;

  static AppStrings of(BuildContext context) =>
      AppStrings._(Localizations.localeOf(context));

  /// Convenience accessor that doesn't need a [BuildContext].
  static AppStrings forLocale(Locale locale) => AppStrings._(locale);

  static const _strings = <String, Map<String, String>>{
    // ── Navigation ────────────────────────────────────────────────────────
    'nav_home': {
      'en': 'Home',
      'si': 'ගෙදර',
      'ta': 'முகப்பு',
    },
    'nav_projects': {
      'en': 'Projects',
      'si': 'ව්‍යාපෘති',
      'ta': 'திட்டங்கள்',
    },
    'nav_experience': {
      'en': 'Experience',
      'si': 'අත්දැකීම',
      'ta': 'அனுபவம்',
    },

    // ── Project List ──────────────────────────────────────────────────────
    'projects_eyebrow': {
      'en': 'SELECTED WORK',
      'si': 'තෝරාගත් කාර්යයන්',
      'ta': 'தேர்ந்தெடுத்த பணிகள்',
    },
    'projects_title': {
      'en': 'Project Hub',
      'si': 'ව්‍යාපෘති කේන්ද්‍රය',
      'ta': 'திட்ட மையம்',
    },
    'projects_subtitle': {
      'en': 'A showcase of high-performance Flutter applications\nwith clean architectures and pixel-perfect UIs.',
      'si': 'සිතූ ගෘහ නිර්මාණ ශිල්පයෙන් හා නිරවද්‍ය UI සහිත Flutter යෙදවුම් ප්‍රදර්ශනය.',
      'ta': 'சுத்தமான கட்டமைப்புகள் மற்றும் pixel-perfect UI கொண்ட Flutter பயன்பாடுகளின் தொகுப்பு.',
    },

    // ── Project Detail ────────────────────────────────────────────────────
    'detail_tech_stack': {
      'en': 'Tech Stack',
      'si': 'තාක්ෂණ ස්ටෑක්',
      'ta': 'தொழில்நுட்ப குவியல்',
    },
    'detail_screen_recording': {
      'en': 'Screen Recording',
      'si': 'තිර පටිගත කිරීම',
      'ta': 'திரை பதிவு',
    },
    'detail_back': {
      'en': 'Back',
      'si': 'ආපසු',
      'ta': 'பின்செல்',
    },

    // ── Language names (shown inside the picker) ──────────────────────────
    'lang_en': {
      'en': 'English',
      'si': 'ඉංග්‍රීසි',
      'ta': 'ஆங்கிலம்',
    },
    'lang_si': {
      'en': 'Sinhala',
      'si': 'සිංහල',
      'ta': 'சிங்களம்',
    },
    'lang_ta': {
      'en': 'Tamil',
      'si': 'දෙමළ',
      'ta': 'தமிழ்',
    },
  };

  String _get(String key) {
    final lang = _locale.languageCode;
    return _strings[key]?[lang] ?? _strings[key]?['en'] ?? key;
  }

  // ── Public accessors ────────────────────────────────────────────────────

  String get navHome => _get('nav_home');
  String get navProjects => _get('nav_projects');
  String get navExperience => _get('nav_experience');

  String get projectsEyebrow => _get('projects_eyebrow');
  String get projectsTitle => _get('projects_title');
  String get projectsSubtitle => _get('projects_subtitle');

  String get detailTechStack => _get('detail_tech_stack');
  String get detailScreenRecording => _get('detail_screen_recording');
  String get detailBack => _get('detail_back');

  String get langEn => _get('lang_en');
  String get langSi => _get('lang_si');
  String get langTa => _get('lang_ta');

  /// Ordered list of (Locale, display name) pairs for the language picker.
  List<(Locale, String)> get availableLocales => [
        (const Locale('en'), langEn),
        (const Locale('si'), langSi),
        (const Locale('ta'), langTa),
      ];
}
