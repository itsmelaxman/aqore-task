import 'package:aqore_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBottomSheets {
  static Future<T?> showSelection<T>({
    required String title,
    required List<SelectionItem<T>> items,
    T? currentValue,
  }) async {
    return await Get.bottomSheet<T>(
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: .vertical(top: .circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              // Handle bar
              Container(
                margin: .symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.handleBar,
                  borderRadius: .circular(2),
                ),
              ),
              // Title
              Padding(
                padding: .fromLTRB(20, 0, 20, 16),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: .w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      padding: .zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Items
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: .symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item.value == currentValue;
                    return ListTile(
                      leading: item.icon != null
                          ? Icon(
                              item.icon,
                              color: isSelected
                                  ? Get.theme.colorScheme.primary
                                  : Get.theme.colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                            )
                          : null,
                      title: Text(
                        item.label,
                        style: TextStyle(
                          fontWeight: isSelected ? .w600 : .w400,
                          color: isSelected
                              ? Get.theme.colorScheme.primary
                              : Get.theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: item.subtitle != null
                          ? Text(item.subtitle!)
                          : null,
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Get.theme.colorScheme.primary,
                            )
                          : null,
                      onTap: () => Get.back(result: item.value),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class SelectionItem<T> {
  /// Display label.
  final String label;

  /// Item value.
  final T value;

  /// Subtitle text.
  final String? subtitle;

  /// Item icon.
  final IconData? icon;

  SelectionItem({
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
  });
}
