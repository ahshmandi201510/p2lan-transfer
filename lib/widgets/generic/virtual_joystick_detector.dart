import 'dart:async';
import 'package:flutter/material.dart';

/// Defines the behavior of the virtual joystick's position.
enum JoystickMode {
  /// The joystick is fixed at a specific position on the screen.
  fixed,

  /// The joystick appears wherever the user starts dragging.
  dynamic,
}

/// A widget that detects gestures and can function as a configurable virtual joystick.
class VirtualJoystickDetector extends StatefulWidget {
  final Widget child;

  // Generic gesture callbacks (for components like RadialMenu)
  final Function(DragStartDetails) onDragStart;
  final Function(DragUpdateDetails) onDragUpdate;
  final Function(DragEndDetails) onDragEnd;
  final Function(TapUpDetails) onTap;

  // Joystick-specific callback and configuration
  final Function(Offset delta)? onMove;
  final bool continuousUpdate;
  final Duration updateInterval;
  final bool invertX;
  final bool invertY;
  final double sensitivity;

  // Visual joystick properties
  final bool showVisualJoystick;
  final JoystickMode joystickMode;
  final Offset? fixedPosition;
  final double joystickRadius;
  final double thumbRadius;
  final Color baseColor;
  final Color thumbColor;

  const VirtualJoystickDetector({
    super.key,
    required this.child,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
    this.onMove,
    this.continuousUpdate = false,
    this.updateInterval = const Duration(milliseconds: 50),
    this.invertX = false,
    this.invertY = false,
    this.sensitivity = 1.0,
    this.showVisualJoystick = false,
    this.joystickMode = JoystickMode.dynamic,
    this.fixedPosition,
    this.joystickRadius = 60.0,
    this.thumbRadius = 22.0,
    this.baseColor = const Color(0x55000000), // Semi-transparent black
    this.thumbColor = const Color(0xCCFFFFFF), // Semi-transparent white
  });

  @override
  State<VirtualJoystickDetector> createState() =>
      _VirtualJoystickDetectorState();
}

class _VirtualJoystickDetectorState extends State<VirtualJoystickDetector> {
  bool _isDragging = false;
  Offset? _basePosition;
  Offset? _thumbPosition;
  Timer? _joystickTimer;
  Offset _lastJoystickDelta = Offset.zero;

  @override
  void initState() {
    super.initState();
    if (widget.joystickMode == JoystickMode.fixed) {
      _basePosition = widget.fixedPosition;
      _thumbPosition = widget.fixedPosition;
    }
  }

  @override
  void dispose() {
    _joystickTimer?.cancel();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    if (widget.joystickMode == JoystickMode.fixed) {
      if (_basePosition == null) return;
      final distance = (details.localPosition - _basePosition!).distance;
      if (distance > widget.joystickRadius) {
        return;
      }
    }

    widget.onDragStart(details);

    if (widget.onMove != null && widget.continuousUpdate) {
      _joystickTimer?.cancel();
      _joystickTimer = Timer.periodic(widget.updateInterval, (_) {
        if (_isDragging) {
          widget.onMove!(_lastJoystickDelta);
        }
      });
    }

    setState(() {
      _isDragging = true;
      if (widget.joystickMode == JoystickMode.dynamic) {
        _basePosition = details.localPosition;
      }
      _thumbPosition = details.localPosition;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    widget.onDragUpdate(details);

    final localDelta = details.localPosition - _basePosition!;

    if (widget.onMove != null) {
      final normalized = localDelta / widget.joystickRadius;
      final dx = normalized.dx * (widget.invertX ? -1 : 1) * widget.sensitivity;
      final dy = normalized.dy * (widget.invertY ? -1 : 1) * widget.sensitivity;
      _lastJoystickDelta = Offset(dx, dy);

      if (!widget.continuousUpdate) {
        widget.onMove!(_lastJoystickDelta);
      }
    }

    if (widget.showVisualJoystick) {
      setState(() {
        final distance = localDelta.distance;
        if (distance > widget.joystickRadius) {
          _thumbPosition =
              _basePosition! + (localDelta / distance * widget.joystickRadius);
        } else {
          _thumbPosition = details.localPosition;
        }
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    widget.onDragEnd(details);
    _joystickTimer?.cancel();

    setState(() {
      _isDragging = false;
      _lastJoystickDelta = Offset.zero;
      if (widget.joystickMode == JoystickMode.dynamic) {
        _basePosition = null;
        _thumbPosition = null;
      } else {
        _thumbPosition = _basePosition;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isJoystickVisible = widget.showVisualJoystick &&
        (_isDragging || widget.joystickMode == JoystickMode.fixed);

    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onTapUp: widget.onTap,
      behavior: HitTestBehavior.opaque, // Capture gestures within bounds
      child: Stack(
        children: [
          widget.child,
          if (isJoystickVisible && _basePosition != null)
            CustomPaint(
              painter: _JoystickPainter(
                basePosition: _basePosition!,
                thumbPosition: _thumbPosition ?? _basePosition!,
                joystickRadius: widget.joystickRadius,
                thumbRadius: widget.thumbRadius,
                baseColor: widget.baseColor,
                thumbColor: widget.thumbColor,
                borderColor: Colors.black.withValues(alpha: .2),
              ),
              size: Size.infinite,
            ),
        ],
      ),
    );
  }
}

/// Custom painter for the joystick.
class _JoystickPainter extends CustomPainter {
  final Offset basePosition;
  final Offset thumbPosition;
  final double joystickRadius;
  final double thumbRadius;
  final Color baseColor;
  final Color thumbColor;
  final Color borderColor;

  _JoystickPainter({
    required this.basePosition,
    required this.thumbPosition,
    required this.joystickRadius,
    required this.thumbRadius,
    required this.baseColor,
    required this.thumbColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()..color = baseColor;
    final thumbPaint = Paint()..color = thumbColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(basePosition, joystickRadius, basePaint);
    canvas.drawCircle(basePosition, joystickRadius, borderPaint);
    canvas.drawCircle(thumbPosition, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant _JoystickPainter oldDelegate) {
    return oldDelegate.basePosition != basePosition ||
        oldDelegate.thumbPosition != thumbPosition;
  }
}
