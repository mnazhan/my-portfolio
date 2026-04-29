import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_notifier.g.dart';

/// Supported locales for [MaterialApp].
const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('si'),
  Locale('ta'),
];

/// Riverpod provider driving the app locale.
/// Supports English (en), Sinhala (si), and Tamil (ta).
@riverpod
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    return const Locale('en');
  }

  void setLocale(Locale loc) {
    state = loc;
  }
}
