import 'package:flutter/material.dart';

enum DifficultyLevel {
  a1('A1', 'Başlangıç', Color(0xFF4CAF50)), // Green
  a2('A2', 'Temel', Color(0xFF8BC34A)), // Light Green
  b1('B1', 'Orta', Color(0xFFFFC107)), // Amber
  b2('B2', 'Orta-İleri', Color(0xFFFF9800)), // Orange
  c1('C1', 'İleri', Color(0xFFFF5722)), // Deep Orange
  c2('C2', 'Uzman', Color(0xFFF44336)); // Red

  final String code;
  final String displayName;
  final Color color;

  const DifficultyLevel(this.code, this.displayName, this.color);

  static DifficultyLevel fromString(String code) {
    return DifficultyLevel.values.firstWhere(
      (e) => e.code == code,
      orElse: () => DifficultyLevel.b1,
    );
  }
}
