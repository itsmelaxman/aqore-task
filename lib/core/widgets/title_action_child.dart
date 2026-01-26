import 'package:flutter/material.dart';

class TitleActionChild extends StatelessWidget {
  /// Title text.
  final String title;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Title padding.
  final EdgeInsets? titlePadding;

  /// Child widget.
  final Widget child;

  /// Subtitle text.
  final String? subTitle;

  /// Subtitle text style.
  final TextStyle? subTitleStyle;

  /// Custom widget.
  final Widget? widget;

  /// Column alignment.
  final CrossAxisAlignment? alignment;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Action widget.
  final Widget? action;

  /// On tap callback.
  final Function? onTap;

  const TitleActionChild({
    super.key,
    this.textAlign,
    required this.title,
    this.widget,
    this.alignment,
    this.titleStyle,
    this.titlePadding,
    this.subTitle,
    this.subTitleStyle,
    this.action,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .infinity,
      child: Column(
        crossAxisAlignment: alignment ?? .start,
        children: [
          Padding(
            padding: titlePadding ?? .zero,
            child: Row(
              children: [
                Text(title, textAlign: textAlign, style: titleStyle),
                const Spacer(),
                action ?? const SizedBox(),
                Container(
                  child:
                      widget ??
                      InkWell(
                        onTap: () => onTap,
                        child: Text(
                          subTitle ?? '',
                          textAlign: textAlign,
                          style: subTitleStyle,
                        ),
                      ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
