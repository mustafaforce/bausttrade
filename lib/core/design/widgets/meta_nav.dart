import 'package:flutter/material.dart';
import '../meta_colors.dart';
import '../meta_radius.dart';
import '../meta_spacing.dart';
import '../meta_typography.dart';
import 'meta_buttons.dart';

class MetaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? bottom;
  final bool showBack;

  const MetaAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: MetaTypography.subtitleLg),
      centerTitle: true,
      elevation: 0,
      backgroundColor: MetaColors.canvas,
      foregroundColor: MetaColors.inkDeep,
      surfaceTintColor: MetaColors.canvas,
      leading: showBack
          ? MetaIconCircularButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: bottom!,
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom != null ? 56 : 0),
      );
}

class MetaPromoBanner extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  const MetaPromoBanner({
    super.key,
    required this.message,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: MetaSpacing.xl,
        vertical: MetaSpacing.md,
      ),
      color: backgroundColor ?? MetaColors.inkDeep,
      child: Text(
        message,
        style: MetaTypography.bodySmBold.copyWith(
          color: textColor ?? MetaColors.canvas,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class MetaDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? avatarUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMyListingsTap;
  final VoidCallback? onMessagesTap;
  final VoidCallback? onLogoutTap;

  const MetaDrawer({
    super.key,
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.onProfileTap,
    this.onMyListingsTap,
    this.onMessagesTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: MetaColors.canvas),
            child: InkWell(
              onTap: onProfileTap,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: MetaColors.surfaceSoft,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl!)
                        : null,
                    child: avatarUrl == null
                        ? Text(
                            (userName?.substring(0, 1).toUpperCase() ?? 'U'),
                            style: MetaTypography.headingSm.copyWith(
                              color: MetaColors.ink,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: MetaSpacing.md),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName ?? 'User',
                          style: MetaTypography.subtitleLg,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userEmail ?? '',
                          style: MetaTypography.bodySm.copyWith(
                            color: MetaColors.steel,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _DrawerItem(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: onProfileTap,
          ),
          _DrawerItem(
            icon: Icons.inventory_2_outlined,
            label: 'My Listings',
            onTap: onMyListingsTap,
          ),
          _DrawerItem(
            icon: Icons.message_outlined,
            label: 'Messages',
            onTap: onMessagesTap,
          ),
          const Divider(color: MetaColors.hairlineSoft),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Logout',
            onTap: onLogoutTap,
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: MetaColors.ink),
      title: Text(label, style: MetaTypography.bodyMd),
      onTap: onTap,
    );
  }
}
