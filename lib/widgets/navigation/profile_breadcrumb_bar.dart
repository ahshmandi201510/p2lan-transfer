import 'package:flutter/material.dart';
import 'package:p2lantransfer/services/profile_breadcrumb_service.dart';

/// Widget breadcrumb navigation cho Profile Tab system
class ProfileBreadcrumbBar extends StatelessWidget {
  final EdgeInsets padding;

  const ProfileBreadcrumbBar({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProfileBreadcrumbService.instance,
      builder: (context, child) {
        final breadcrumbs =
            ProfileBreadcrumbService.instance.getCurrentBreadcrumbs();

        if (breadcrumbs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Back button
              if (ProfileBreadcrumbService.instance.canGoBack())
                IconButton(
                  onPressed: () =>
                      ProfileBreadcrumbService.instance.popBreadcrumb(),
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 20,
                  padding: const EdgeInsets.all(4),
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                  tooltip: 'Back',
                ),

              // Breadcrumb trail
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _buildBreadcrumbItems(context, breadcrumbs),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBreadcrumbItems(
      BuildContext context, List<ProfileBreadcrumbItem> breadcrumbs) {
    final theme = Theme.of(context);
    final items = <Widget>[];

    for (int i = 0; i < breadcrumbs.length; i++) {
      final item = breadcrumbs[i];
      final isLast = i == breadcrumbs.length - 1;

      // Breadcrumb item
      items.add(
        InkWell(
          onTap: isLast
              ? null
              : () => ProfileBreadcrumbService.instance.navigateToBreadcrumb(i),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 16,
                    color: isLast
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  _truncateTitle(item.title),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isLast
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Separator
      if (!isLast) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        );
      }
    }

    return items;
  }

  String _truncateTitle(String title) {
    if (title.length <= 25) return title;
    return '${title.substring(0, 22)}...';
  }
}
