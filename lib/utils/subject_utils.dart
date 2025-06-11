import 'package:flutter/material.dart';

class SubjectUtils {
  static Color getSubjectColor(String subject) {
    switch (subject) {
      case 'Mathematique':
        return const Color(0xFF6F61EF);
      case 'Science':
        return const Color(0xFF39D2C0);
      case 'Literature':
        return const Color(0xFFEE8B60);
      case 'Histoire':
        return const Color(0xFFFF6B95);
      case 'Geographie':
        return const Color(0xFF4ECDC4);
      default:
        return const Color(0xFF6F61EF);
    }
  }

  static IconData getSubjectIcon(String subject) {
    switch (subject) {
      case 'Mathematique':
        return Icons.calculate;
      case 'Science':
        return Icons.science;
      case 'Literature':
        return Icons.menu_book;
      case 'Histoire':
        return Icons.account_balance;
      case 'Geographie':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return Colors.green;
      case 'moyen':
        return Colors.orange;
      case 'difficile':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static Color getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
