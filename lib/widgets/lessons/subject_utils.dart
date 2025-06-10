import 'package:flutter/material.dart';

Color getSubjectColor(String subject) {
  switch (subject) {
    case 'Mathematics':
      return const Color(0xFF6F61EF);
    case 'Science':
      return const Color(0xFF39D2C0);
    case 'Literature':
      return const Color(0xFFEE8B60);
    case 'History':
      return const Color(0xFFFF6B95);
    case 'Geography':
      return const Color(0xFF4ECDC4);
    default:
      return const Color(0xFF6F61EF);
  }
}

IconData getSubjectIcon(String subject) {
  switch (subject) {
    case 'Mathematics':
      return Icons.calculate;
    case 'Science':
      return Icons.science;
    case 'Literature':
      return Icons.menu_book;
    case 'History':
      return Icons.account_balance;
    case 'Geography':
      return Icons.public;
    default:
      return Icons.school;
  }
}

Color getDifficultyColor(String difficulty) {
  switch (difficulty.toLowerCase()) {
    case 'easy':
      return Colors.green;
    case 'medium':
      return Colors.orange;
    case 'hard':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
