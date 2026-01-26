import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aqore_app/core/widgets/gaps.dart';

class AppDialogs {
  // Confirmation Dialog
  static Future<bool> showConfirmation({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    IconData? icon,
  }) async {
    final result = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: .circular(20)),
        child: Padding(
          padding: .all(24),
          child: Column(
            mainAxisSize: .min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: (confirmColor ?? Get.theme.colorScheme.error)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: confirmColor ?? Get.theme.colorScheme.error,
                    size: 32,
                  ),
                ),
                Gaps.verticalGapOf(20),
              ],
              Text(
                title,
                style: Get.textTheme.titleLarge?.copyWith(fontWeight: .w600),
                textAlign: .center,
              ),
              Gaps.verticalGapOf(12),
              Text(
                message,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: .center,
              ),
              Gaps.verticalGapOf(24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        padding: .symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(12),
                        ),
                      ),
                      child: Text(cancelText),
                    ),
                  ),
                  Gaps.horizontalGapOf(12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Get.back(result: true),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            confirmColor ?? Get.theme.colorScheme.error,
                        padding: .symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(12),
                        ),
                      ),
                      child: Text(confirmText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }
}
