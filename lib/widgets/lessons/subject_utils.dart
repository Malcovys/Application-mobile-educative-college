import 'package:flutter/material.dart';

Color getSubjectColor(String subject) {
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

IconData getSubjectIcon(String subject) {
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

Color getDifficultyColor(String difficulty) {
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
