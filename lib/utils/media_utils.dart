import 'dart:io';

import 'package:flutter/material.dart';

class MediaUtils {
  static void openImageInFullscreen(
      {required BuildContext context, required String filePath}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: Center(
              child: Image.file(
                File(filePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
