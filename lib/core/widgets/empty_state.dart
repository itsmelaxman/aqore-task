import 'package:flutter/material.dart';

import '../../app_library.dart';

class EmptyState extends StatelessWidget {
  /// Message text.
  final String message;

  /// Icon above message.
  final IconData? icon;

  /// SVG icon path.
  final String? iconPath;

  /// Action button label.
  final String? actionLabel;

  /// Action button callback.
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.message,
    this.icon,
    this.iconPath,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: .all(AppDimensions.lg),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            if (iconPath != null)
              SvgHelper.fromSource(path: iconPath!, height: 120, width: 120)
            else if (icon != null)
              Icon(icon, size: 64, color: context.outlineColor),
            Gaps.verticalGapOf(AppDimensions.lg),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: context.outlineColor),
              textAlign: .center,
            ),
            if (actionLabel != null && onAction != null) ...[
              Gaps.verticalGapOf(AppDimensions.xl),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
