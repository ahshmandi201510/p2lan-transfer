import 'package:flutter/material.dart';
import 'package:p2lantransfer/l10n/app_localizations.dart';
import 'package:p2lantransfer/services/profile_tab_service.dart';

class ProfileSection extends StatelessWidget {
  final Function(Widget, String, {String? parentCategory, IconData? icon})?
      onToolSelected;
  final VoidCallback? onRoutinePressed;
  final VoidCallback? onSettingsPressed;

  const ProfileSection({
    super.key,
    this.onToolSelected,
    this.onRoutinePressed,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            'Profile Tabs',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // Dòng đầu tiên: 3 Profile Tabs
          Row(
            children: [
              for (int i = 0; i < 3; i++) ...[
                Expanded(
                  child: _buildProfileTabWidget(context, i),
                ),
                if (i < 2) const SizedBox(width: 8),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // Dòng thứ hai: Routine + Settings
          Row(
            children: [
              // Routine Widget
              Expanded(
                child: _buildRoutineWidget(context),
              ),

              const SizedBox(width: 8),

              // Settings Widget
              Expanded(
                child: _buildSettingsWidget(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTabWidget(BuildContext context, int tabIndex) {
    final theme = Theme.of(context);
    final profileService = ProfileTabService.instance;
    final tabInfo = profileService.getTabDisplayInfo(tabIndex);
    final isSelected = profileService.currentView == ProfileView.profile &&
        profileService.currentTabIndex == tabIndex;
    return _buildTabContainer(
      context: context,
      icon: tabInfo['icon'],
      label: _getTabTitle(tabIndex, tabInfo),
      isSelected: isSelected,
      iconColor: tabInfo['isDefault']
          ? theme.colorScheme.outline
          : tabInfo['iconColor'],
      onTap: () => _handleTabTap(context, tabIndex),
    );
  }

  Widget _buildRoutineWidget(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profileService = ProfileTabService.instance;
    final isSelected = profileService.currentView == ProfileView.routine;
    return _buildTabContainer(
      context: context,
      icon: Icons.auto_awesome,
      label: l10n.routine,
      isSelected: isSelected,
      iconColor: theme.colorScheme.outline,
      onTap: () {
        if (!isSelected) onRoutinePressed?.call();
      },
    );
  }

  Widget _buildSettingsWidget(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profileService = ProfileTabService.instance;
    final isSelected = profileService.currentView == ProfileView.settings;
    return _buildTabContainer(
      context: context,
      icon: Icons.settings,
      label: l10n.settings,
      isSelected: isSelected,
      iconColor: theme.colorScheme.outline,
      onTap: () {
        if (!isSelected) onSettingsPressed?.call();
      },
    );
  }

  Widget _buildTabContainer({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? theme.colorScheme.primary : iconColor,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTabTap(BuildContext context, int tabIndex) {
    final profileService = ProfileTabService.instance;
    // Chỉ chuyển tab nếu chưa phải tab này hoặc chưa ở profile view
    if (profileService.currentView != ProfileView.profile ||
        profileService.currentTabIndex != tabIndex) {
      profileService.setCurrentTab(tabIndex);
    } else if (profileService.currentTabIndex == tabIndex &&
        !profileService.isTabOnToolSelection(tabIndex)) {
      profileService.resetTab(tabIndex);
      onToolSelected?.call(Container(), 'Select Tool');
    }
  }

  String _getTabTitle(int tabIndex, Map<String, dynamic> tabInfo) {
    if (tabInfo['isDefault']) {
      return 'Profile ${tabIndex + 1}';
    }

    String title = tabInfo['title'] ?? 'Profile ${tabIndex + 1}';
    // Rút gọn title nếu quá dài
    if (title.length > 8) {
      title = '${title.substring(0, 5)}...';
    }
    return title;
  }
}
