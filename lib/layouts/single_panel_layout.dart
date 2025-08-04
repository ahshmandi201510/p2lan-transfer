import 'package:flutter/material.dart';

/// A simple layout with a unified AppBar and single content panel
/// Designed for tools that don't need complex multi-panel layouts
class SinglePanelLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool isEmbedded;

  const SinglePanelLayout(
      {super.key,
      required this.title,
      required this.child,
      this.actions,
      this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    if (isEmbedded) {
      return child;
    }

    // Build unified actions including info button
    final allActions = <Widget>[];

    if (actions != null) {
      allActions.addAll(actions!);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: allActions.isNotEmpty ? allActions : null,
      ),
      body: child,
    );
  }
}
