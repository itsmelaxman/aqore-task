import 'package:flutter/material.dart';
import 'package:aqore_app/core/constants/dimensions.dart';
import 'package:aqore_app/core/widgets/gaps.dart';

class CustomMaterialButton extends StatelessWidget {
  /// Callback when pressed.
  final VoidCallback? onTap;

  /// Label text.
  final String label;

  /// Corner radius.
  final double radius;

  /// Button height.
  final double height;

  /// Material icon.
  final IconData? icon;

  /// Custom icon widget (e.g. SVG).
  final Widget? customIcon;

  /// Use filled style when true.
  final bool fillButton;

  /// Disabled flag.
  final bool isDisabled;

  /// Loading flag.
  final bool isLoading;

  const CustomMaterialButton({
    super.key,
    this.onTap,
    required this.label,
    this.radius = AppDimensions.md,
    this.height = 50.0,
    this.icon,
    this.customIcon,
    this.fillButton = true,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isButtonDisabled = isDisabled || isLoading || onTap == null;

    Widget buttonChild;
    if (isLoading) {
      buttonChild = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: fillButton
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
        ),
      );
    } else if (customIcon != null) {
      buttonChild = Row(
        mainAxisSize: .min,
        children: [customIcon!, Gaps.horizontalGapOf(8), Text(label)],
      );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisSize: .min,
        children: [Icon(icon, size: 20), Gaps.horizontalGapOf(8), Text(label)],
      );
    } else {
      buttonChild = Text(label);
    }

    if (fillButton) {
      return SizedBox(
        height: height,
        width: .infinity,
        child: FilledButton(
          onPressed: isButtonDisabled ? null : onTap,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: .circular(radius)),
          ),
          child: buttonChild,
        ),
      );
    }

    return SizedBox(
      height: height,
      width: .infinity,
      child: FilledButton.tonal(
        onPressed: isButtonDisabled ? null : onTap,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: .circular(radius)),
        ),
        child: buttonChild,
      ),
    );
  }
}
