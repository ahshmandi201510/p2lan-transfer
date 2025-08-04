// Thêm vào đầu file profile_tab.dart hoặc tạo file riêng
import 'package:flutter/material.dart';

class IconDataHelper {
  static IconData getConstantIconData(int codePoint) {
    switch (codePoint) {
      case 0xe047: // Icons.apps
        return Icons.apps;
      case 0xe0e4: // Icons.description
        return Icons.description;
      case 0xe1cb: // Icons.casino
        return Icons.casino;
      case 0xe8d4: // Icons.swap_horiz
        return Icons.swap_horiz;
      case 0xe1ae: // Icons.calculate
        return Icons.calculate;
      case 0xe80d: // Icons.share
        return Icons.share;
      case 0xe87c: // Icons.extension
        return Icons.extension;
      case 0xe5d2: // Icons.center_focus_strong
        return Icons.center_focus_strong;
      case 0xe5d3: // Icons.credit_card
        return Icons.credit_card;
      case 0xe8e5: // Icons.trending_up
        return Icons.trending_up;
      case 0xe429: // Icons.tune
        return Icons.tune;
      case 0xe25d: // Icons.drag_handle
        return Icons.drag_handle;
      case 0xe8ee: // Icons.view_agenda
        return Icons.view_agenda;
      case 0xe161: // Icons.save
        return Icons.save;
      default:
        return Icons.apps; // fallback
    }
  }
}
