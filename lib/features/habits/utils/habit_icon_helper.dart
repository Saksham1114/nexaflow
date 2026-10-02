import 'package:flutter/material.dart';

class HabitIconHelper {
  static const Map<String, IconData> availableIcons = {
    'fitness': Icons.fitness_center_rounded,
    'book': Icons.menu_book_rounded,
    'water': Icons.water_drop_rounded,
    'meditation': Icons.self_improvement_rounded,
    'code': Icons.code_rounded,
    'sleep': Icons.bedtime_rounded,
    'nutrition': Icons.restaurant_rounded,
    'running': Icons.directions_run_rounded,
    'study': Icons.school_rounded,
    'star': Icons.star_rounded,
    'heart': Icons.favorite_rounded,
    'timer': Icons.timer_rounded,
  };

  static const List<int> presetColors = [
    0xFF6366F1, // Indigo
    0xFF3B82F6, // Blue
    0xFF10B981, // Emerald
    0xFFF59E0B, // Amber
    0xFFEC4899, // Pink
    0xFF8B5CF6, // Purple
    0xFF06B6D4, // Cyan
    0xFFEF4444, // Red
  ];

  static IconData getIcon(String name) {
    return availableIcons[name] ?? Icons.star_rounded;
  }

  static Color getColor(int colorValue) {
    return Color(colorValue);
  }
}
