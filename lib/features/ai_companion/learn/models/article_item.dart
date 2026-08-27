import 'package:flutter/material.dart';

class ArticleItem {
  final String id;
  final String title;
  final String category;
  final String summary;
  final List<String> keyTakeaways;
  final Color themeColor;
  final IconData icon;

  const ArticleItem({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.keyTakeaways,
    required this.themeColor,
    required this.icon,
  });
}
