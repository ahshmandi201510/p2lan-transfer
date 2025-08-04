import 'package:flutter/material.dart';

/// A generic draggable floating action button for mobile layouts.
/// Supports custom icon, tooltip, initial position, edge padding, and snap behavior.
class DraggableFloatingActionButton extends StatefulWidget {
  /// Factory: left edge, minimal config
  factory DraggableFloatingActionButton.left({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
    double edgePadding = 8,
    double size = 40,
  }) {
    return DraggableFloatingActionButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      initialOffset: Offset(edgePadding, 200),
      size: size,
      edgePadding: edgePadding,
      snapThreshold: 40,
      snapToEdge: true,
      enableSnapTopBottom: false,
    );
  }

  /// Factory: right edge, minimal config
  factory DraggableFloatingActionButton.right({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
    double edgePadding = 8,
    double size = 40,
  }) {
    return DraggableFloatingActionButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      initialOffset: Offset(99999, 200), // will snap to right edge
      size: size,
      edgePadding: edgePadding,
      snapThreshold: 40,
      snapToEdge: true,
      enableSnapTopBottom: false,
    );
  }
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Offset? initialOffset;
  final double size;
  final double edgePadding;
  final double snapThreshold;
  final Color? backgroundColor;
  final Color? draggingColor;
  final Color? foregroundColor;
  final bool snapToEdge;
  final bool enableSnapTopBottom;

  /// Factory: minimal config, just icon and onPressed
  factory DraggableFloatingActionButton.minimal({
    required IconData icon,
    VoidCallback? onPressed,
    Offset? initialOffset,
  }) {
    return DraggableFloatingActionButton(
      icon: icon,
      onPressed: onPressed,
      initialOffset: initialOffset,
      size: 40,
      edgePadding: 8,
      snapThreshold: 40,
      snapToEdge: true,
      enableSnapTopBottom: false,
    );
  }

  /// Factory: recommended config for most use cases
  factory DraggableFloatingActionButton.recommended({
    required IconData icon,
    String? tooltip,
    VoidCallback? onPressed,
    Offset? initialOffset,
  }) {
    return DraggableFloatingActionButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: onPressed,
      initialOffset: initialOffset,
      size: 56,
      edgePadding: 16,
      snapThreshold: 50,
      snapToEdge: true,
      enableSnapTopBottom: true,
    );
  }

  const DraggableFloatingActionButton({
    Key? key,
    required this.icon,
    this.tooltip,
    this.onPressed,
    this.initialOffset,
    this.size = 56,
    this.edgePadding = 16,
    this.snapThreshold = 50,
    this.backgroundColor,
    this.draggingColor,
    this.foregroundColor,
    this.snapToEdge = true,
    this.enableSnapTopBottom = true,
  }) : super(key: key);

  @override
  State<DraggableFloatingActionButton> createState() =>
      _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  Offset _fabOffset = const Offset(-1, -1);
  Size? _screenSize;
  bool _isDragging = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentScreenSize = MediaQuery.of(context).size;
      if (_screenSize == null || _screenSize != currentScreenSize) {
        setState(() {
          _screenSize = currentScreenSize;
          if (_fabOffset.dx < 0 || _fabOffset.dy < 0) {
            _fabOffset = widget.initialOffset ??
                Offset(
                  _screenSize!.width - widget.size - widget.edgePadding,
                  _screenSize!.height - widget.size - 100,
                );
          } else {
            _fabOffset = Offset(
              _fabOffset.dx.clamp(0, _screenSize!.width - widget.size),
              _fabOffset.dy.clamp(0, _screenSize!.height - widget.size - 80),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_screenSize == null) return const SizedBox.shrink();
    return Positioned(
      left: _fabOffset.dx,
      top: _fabOffset.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) {
          if (!_isDragging) {
            setState(() {
              _isDragging = true;
            });
          }
        },
        onPanUpdate: (details) {
          final double newX = _fabOffset.dx + details.delta.dx;
          final double newY = _fabOffset.dy + details.delta.dy;
          final minX = widget.edgePadding;
          final maxX = _screenSize!.width - widget.size - widget.edgePadding;
          final minY = widget.edgePadding + 80;
          final maxY = _screenSize!.height - widget.size - 100;
          final Offset newOffset = Offset(
            newX.clamp(minX, maxX),
            newY.clamp(minY, maxY),
          );
          if (newOffset != _fabOffset) {
            setState(() {
              _fabOffset = newOffset;
            });
          }
        },
        onPanEnd: (details) {
          if (_isDragging) {
            setState(() {
              _isDragging = false;
              if (widget.snapToEdge) {
                _fabOffset = _calculateSnapPosition(_fabOffset);
              }
            });
          }
        },
        child: FloatingActionButton.small(
          onPressed: _isDragging ? null : widget.onPressed,
          tooltip: _isDragging ? 'Drag to move' : widget.tooltip,
          // backgroundColor: _isDragging
          //     ? (widget.draggingColor ??
          //         Theme.of(context).colorScheme.primary.withValues(alpha: .7))
          //     : (widget.backgroundColor ??
          //         Theme.of(context).colorScheme.surfaceTint),
          // foregroundColor: widget.foregroundColor ??
          //     (_isDragging
          //         ? Theme.of(context).colorScheme.onSurface
          //         : Theme.of(context).colorScheme.onPrimary),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isDragging
                ? Icon(Icons.open_with,
                    key: const ValueKey('dragging'),
                    color: Theme.of(context).colorScheme.onPrimary)
                : Icon(widget.icon,
                    key: const ValueKey('main'),
                    color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }

  Offset _calculateSnapPosition(Offset dragEndOffset) {
    if (_screenSize == null) return dragEndOffset;
    final double screenWidth = _screenSize!.width;
    final double screenHeight = _screenSize!.height;
    double centerX = dragEndOffset.dx + widget.size / 2;
    double centerY = dragEndOffset.dy + widget.size / 2;
    final double minX = widget.edgePadding;
    final double maxX = screenWidth - widget.size - widget.edgePadding;
    final double minY = widget.edgePadding + 80;
    final double maxY = screenHeight - widget.size - 100;
    double finalX = centerX - widget.size / 2;
    double finalY = centerY - widget.size / 2;
    if (widget.snapToEdge) {
      if (centerX < screenWidth / 3) {
        finalX = minX;
      } else if (centerX > screenWidth * 2 / 3) {
        finalX = maxX;
      }
      if (widget.enableSnapTopBottom) {
        finalY = finalY.clamp(minY, maxY);
        if (finalY < minY + widget.snapThreshold) {
          finalY = minY;
        } else if (finalY > maxY - widget.snapThreshold) {
          finalY = maxY;
        }
      }
    }
    return Offset(finalX, finalY);
  }
}
