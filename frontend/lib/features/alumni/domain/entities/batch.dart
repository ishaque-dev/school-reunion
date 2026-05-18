import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

enum Batch { SCIENCE, COMMERCE_A, COMMERCE_B, COMMERCE_C }

extension BatchX on Batch {
  String get apiValue => name;

  String get displayName {
    switch (this) {
      case Batch.SCIENCE:
        return 'Science';
      case Batch.COMMERCE_A:
        return 'Commerce A';
      case Batch.COMMERCE_B:
        return 'Commerce B';
      case Batch.COMMERCE_C:
        return 'Commerce C';
    }
  }

  String get emoji {
    switch (this) {
      case Batch.SCIENCE:
        return '🔬';
      case Batch.COMMERCE_A:
        return '📊';
      case Batch.COMMERCE_B:
        return '💼';
      case Batch.COMMERCE_C:
        return '📈';
    }
  }

  IconData get icon {
    switch (this) {
      case Batch.SCIENCE:
        return Icons.science_outlined;
      case Batch.COMMERCE_A:
        return Icons.bar_chart_outlined;
      case Batch.COMMERCE_B:
        return Icons.business_center_outlined;
      case Batch.COMMERCE_C:
        return Icons.trending_up_outlined;
    }
  }

  Color get color {
    switch (this) {
      case Batch.SCIENCE:
        return AppColors.scienceColor;
      case Batch.COMMERCE_A:
        return AppColors.commerceAColor;
      case Batch.COMMERCE_B:
        return AppColors.commerceBColor;
      case Batch.COMMERCE_C:
        return AppColors.commerceCColor;
    }
  }

  Color get lightColor {
    switch (this) {
      case Batch.SCIENCE:
        return AppColors.scienceLight;
      case Batch.COMMERCE_A:
        return AppColors.commerceALight;
      case Batch.COMMERCE_B:
        return AppColors.commerceBLight;
      case Batch.COMMERCE_C:
        return AppColors.commerceCLight;
    }
  }

  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color, color.withOpacity(0.7)],
      );

  static Batch? fromString(String? s) {
    if (s == null) return null;
    try {
      return Batch.values.firstWhere((b) => b.name == s);
    } catch (_) {
      return null;
    }
  }
}
