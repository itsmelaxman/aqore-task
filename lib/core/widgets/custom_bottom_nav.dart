import 'package:flutter/material.dart';

import '../../app_library.dart';

class CustomBottomNav extends StatelessWidget {
  /// Current selected index.
  final int currentIndex;

  /// Navigation items.
  final List<BottomNavItem> items;

  /// On item tap callback.
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.sm,
            vertical: AppDimensions.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _buildNavItem(context, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index) {
    final item = items[index];
    final isSelected = currentIndex == index;
    final color = context.primaryColor;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(AppDimensions.md),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgHelper.fromSource(
                path: item.icon,
                height: 26,
                width: 26,
                color: isSelected ? color : color.withValues(alpha: 0.4),
              ),
              Gaps.verticalGapOf(4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? color : color.withValues(alpha: 0.4),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom Navigation Item model
class BottomNavItem {
  /// Icon path.
  final String icon;

  /// Label text.
  final String label;

  const BottomNavItem({required this.icon, required this.label});
}
