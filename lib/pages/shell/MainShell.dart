import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The bottom-tab shell that hosts the five primary destinations
/// (Home / Library / Practice / Community / Profile). Detail screens are
/// pushed on the root navigator so they cover the bottom bar.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  static const _tabs = [
    _TabSpec(icon: Icons.home_outlined, active: Icons.home_rounded, label: 'Home'),
    _TabSpec(icon: Icons.menu_book_outlined, active: Icons.menu_book_rounded, label: 'Library'),
    _TabSpec(icon: Icons.self_improvement_outlined, active: Icons.self_improvement, label: 'Practice'),
    _TabSpec(icon: Icons.groups_outlined, active: Icons.groups_rounded, label: 'Sangha'),
    _TabSpec(icon: Icons.person_outline_rounded, active: Icons.person_rounded, label: 'Profile'),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.page,
          border: Border(top: BorderSide(color: AppColors.surfaceAlt)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _TabButton(
                      spec: _tabs[i],
                      selected: i == navigationShell.currentIndex,
                      onTap: () => _onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  final IconData icon;
  final IconData active;
  final String label;
  const _TabSpec({required this.icon, required this.active, required this.label});
}

class _TabButton extends StatelessWidget {
  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.spec, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.terracotta : AppColors.textFaint;
    return InkResponse(
      onTap: onTap,
      radius: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected ? spec.active : spec.icon, color: color, size: 24),
          const SizedBox(height: 3),
          Text(
            spec.label,
            style: AppTypography.textTheme.labelSmall!.copyWith(
              color: color,
              letterSpacing: 0.3,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
