import 'package:flutter/material.dart';
import 'package:p2lantransfer/services/profile_tab_service.dart';

class ProfileBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final VoidCallback onRoutinePressed;
  final VoidCallback onSettingsPressed;

  const ProfileBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.onRoutinePressed,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final profileService = ProfileTabService.instance;
    final currentView = profileService.currentView;
    final highlightIndex = profileService.currentTabIndex;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background bar
          Container(
            height: 80,
            child: Row(
              children: [
                // Tab 1
                _buildTabItem(
                  context: context,
                  tabIndex: 0,
                  isSelected:
                      currentView == ProfileView.profile && highlightIndex == 0,
                  onTap: () => onTabChanged(0),
                ),

                // Tab 2
                _buildTabItem(
                  context: context,
                  tabIndex: 1,
                  isSelected:
                      currentView == ProfileView.profile && highlightIndex == 1,
                  onTap: () => onTabChanged(1),
                ),

                // Spacer cho routine button
                const Expanded(flex: 1, child: SizedBox()),

                // Tab 3
                _buildTabItem(
                  context: context,
                  tabIndex: 2,
                  isSelected:
                      currentView == ProfileView.profile && highlightIndex == 2,
                  onTap: () => onTabChanged(2),
                ),

                // Settings tab
                _buildSettingsTab(context,
                    isSelected: currentView == ProfileView.settings),
              ],
            ),
          ),

          // Routine button (floating center)
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 30,
            top: 10,
            child: _buildRoutineButton(context,
                isSelected: currentView == ProfileView.routine),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int tabIndex,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final profileService = ProfileTabService.instance;
    final tabInfo = profileService.getTabDisplayInfo(tabIndex);

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tabInfo['icon'],
                size: 24,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
              const SizedBox(height: 4),
              Text(
                _getTabTitle(context, tabIndex, tabInfo),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineButton(BuildContext context, {bool isSelected = false}) {
    final theme = Theme.of(context);
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onRoutinePressed,
          borderRadius: BorderRadius.circular(30),
          child: Icon(
            Icons.auto_awesome,
            size: 28,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab(BuildContext context, {bool isSelected = false}) {
    final theme = Theme.of(context);
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onSettingsPressed,
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.settings,
                size: 24,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
              const SizedBox(height: 4),
              Text(
                'Settings',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTabTitle(
      BuildContext context, int tabIndex, Map<String, dynamic> tabInfo) {
    if (tabInfo['isDefault']) {
      return 'Profile ${tabIndex + 1}';
    }

    String title = tabInfo['title'] ?? 'Profile ${tabIndex + 1}';
    // Rút gọn title nếu quá dài để fit trên mobile
    if (title.length > 10) {
      title = '${title.substring(0, 7)}...';
    }
    return title;
  }
}
