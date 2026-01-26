import 'package:aqore_app/app_library.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  /// Label text.
  final String? label;

  /// Title above field.
  final String? title;

  /// Action widget next to title.
  final Widget? action;

  /// Field is required.
  final bool isRequired;

  /// Text controller.
  final TextEditingController controller;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Max lines.
  final int? maxLines;

  /// Read-only field.
  final bool readOnly;

  /// On tap callback.
  final VoidCallback? onTap;

  /// Hint text.
  final String? hint;

  /// Prefix icon (IconData or SVG path).
  final dynamic prefixIcon;

  /// Suffix icon.
  final IconData? suffixIcon;

  /// Suffix icon tap callback.
  final VoidCallback? onSuffixTap;

  /// Obscure text (passwords).
  final bool obscureText;

  /// Text input action.
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    this.label,
    required this.controller,
    this.title,
    this.action,
    this.isRequired = false,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (title != null) ...[
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: .w600,
                        color: context.onSurfaceColor,
                      ),
                    ),
                    if (isRequired) ...[
                      Gaps.horizontalGapOf(4),
                      Text(
                        '*',
                        style: TextStyle(
                          color: context.errorColor,
                          fontSize: 16,
                          fontWeight: .bold,
                        ),
                      ),
                    ],
                    if (!isRequired) ...[
                      Gaps.horizontalGapOf(4),
                      Text(
                        '(Optional)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),
          Gaps.verticalGapOf(8),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: obscureText,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            labelText: title == null ? label : null,
            hintText: hint ?? label,
            filled: true,
            fillColor: AppColors.surface,
            prefixIcon: prefixIcon != null
                ? (prefixIcon is IconData
                      ? Icon(prefixIcon)
                      : Padding(
                          padding: .all(12.0),
                          child: SvgHelper.fromSource(
                            path: prefixIcon as String,
                            height: 20,
                            width: 20,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ))
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(icon: Icon(suffixIcon), onPressed: onSuffixTap)
                : null,
            border: OutlineInputBorder(
              borderRadius: .circular(AppDimensions.md),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: .circular(AppDimensions.md),
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: .circular(AppDimensions.md),
              borderSide: BorderSide(color: context.primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
