import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Circular back button used across detail screens in the redesign.
class CircleBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const CircleBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.surfaceAlt)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap ??
            () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(Icons.chevron_left_rounded, color: AppColors.ink, size: 26),
        ),
      ),
    );
  }
}

/// A header with a circular back button, serif title and optional script subtitle.
class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBack;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          if (showBack) ...[const CircleBackButton(), const SizedBox(width: 14)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.textTheme.displaySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: AppScript.familyFor(subtitle!),
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

/// Scaffold with the cream page background and a redesign [AppHeader].
class AppScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBack;
  final Widget body;
  final Widget? bottom; // e.g. a progress bar under the header
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.actions = const [],
    this.showBack = true,
    this.bottom,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(title: title, subtitle: subtitle, actions: actions, showBack: showBack),
            if (bottom != null) bottom!,
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
