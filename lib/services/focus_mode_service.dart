import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:p2lantransfer/l10n/app_localizations.dart';

class FocusModeService {
  static const double _zoomInThreshold = 1.2;
  static const double _zoomOutThreshold = 0.8;

  // Debounce mechanism
  static DateTime? _lastGestureTime;
  static const Duration _gestureCooldown = Duration(milliseconds: 500);

  /// Check if the current platform is mobile (iOS or Android)
  static bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  /// Check if the current platform is desktop (Windows, macOS, Linux)
  static bool get isDesktop {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  /// Get the appropriate exit instruction based on platform
  static String getExitInstruction(BuildContext context,
      {required bool isEmbedded}) {
    final l10n = AppLocalizations.of(context)!;

    if (isEmbedded) {
      // When embedded, always use platform-specific instructions
      return isMobile ? l10n.exitFocusModeMobile : l10n.exitFocusModeDesktop;
    } else {
      // When not embedded, focus button is in app bar
      return l10n.exitFocusModeDesktop;
    }
  }

  /// Handle scale gesture for focus mode with debounce
  static void handleScaleGesture({
    required double scale,
    required bool currentFocusMode,
    required VoidCallback onEnterFocusMode,
    required VoidCallback onExitFocusMode,
  }) {
    final now = DateTime.now();

    // Check debounce
    if (_lastGestureTime != null &&
        now.difference(_lastGestureTime!) < _gestureCooldown) {
      return;
    }

    bool shouldTrigger = false;

    if (!currentFocusMode && scale >= _zoomInThreshold) {
      // Zoom in detected - enter focus mode
      shouldTrigger = true;
      onEnterFocusMode();
    } else if (currentFocusMode && scale <= _zoomOutThreshold) {
      // Zoom out detected - exit focus mode
      shouldTrigger = true;
      onExitFocusMode();
    }

    if (shouldTrigger) {
      _lastGestureTime = now;
    }
  }

  /// Show focus mode notification
  static void showFocusModeNotification(
    BuildContext context, {
    required bool isEnabled,
    required String exitInstruction,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final message = isEnabled
        ? l10n.focusModeEnabledMessage(exitInstruction)
        : l10n.focusModeDisabledMessage;

    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isEnabled ? Icons.center_focus_strong : Icons.center_focus_weak,
              color: theme.colorScheme.onInverseSurface,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isEnabled
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
