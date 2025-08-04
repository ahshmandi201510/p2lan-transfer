// models/info_models.dart
import 'package:flutter/material.dart';

// Model cho toàn bộ trang thông tin
class InfoPage {
  final String title;
  final String overview;
  final List<InfoSection> sections;

  InfoPage(
      {required this.title, required this.overview, required this.sections});
}

// Model cho một section (ví dụ: "Tính năng chính")
class InfoSection {
  final String title;
  final IconData icon;
  final Color color;
  final List<InfoItem> items;

  InfoSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}

// Lớp cơ sở cho các loại item khác nhau
abstract class InfoItem {}

// Item có icon tùy chỉnh, title, description
class FeatureInfoItem extends InfoItem {
  final IconData icon;
  final String title;
  final String description;
  FeatureInfoItem(
      {required this.icon, required this.title, required this.description});
}

// Item có icon là shape màu, title, description
class ColoredShapeInfoItem extends InfoItem {
  final String shape; // 'circle', 'square'
  final Color color;
  final String title;
  final String description;
  ColoredShapeInfoItem(
      {required this.shape,
      required this.color,
      required this.title,
      required this.description});
}

// Item tiêu đề phụ
class SubSectionTitleInfoItem extends InfoItem {
  final String title;
  final Color color;
  SubSectionTitleInfoItem({required this.title, required this.color});
}

// Item dạng nút liên kết
class LinkButtonInfoItem extends InfoItem {
  final String text;
  final String url; // URL để mở khi nhấn nút
  LinkButtonInfoItem({required this.text, required this.url});
}

// Item dạng danh sách
class UnorderListItem extends InfoItem {
  final String content;
  UnorderListItem({required this.content});
}

// Item dạng biểu thức toán học
class MathExpressionItem extends InfoItem {
  final String expression;
  MathExpressionItem({required this.expression});
}

// Item dạng bước
class StepInfoItem extends InfoItem {
  final int step;
  final String title;
  final String description;
  StepInfoItem(
      {required this.step, required this.title, required this.description});
}

// Item dạng sub-section
class PlainSubSectionInfoItem extends InfoItem {
  final String title;
  final String? description;
  PlainSubSectionInfoItem({required this.title, this.description});
}

// Item văn bản đơn giản
class ParagraphInfoItem extends InfoItem {
  final String text;
  ParagraphInfoItem({required this.text});
}

// Item đòng trống để cách điệu hiển thị
class BlankLineInfoItem extends InfoItem {
  final int spaceCount;
  BlankLineInfoItem({this.spaceCount = 1});
}

// Item phân cách
class DividerInfoItem extends InfoItem {
  DividerInfoItem();
}
