import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  // TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  Color get primaryColor => colorScheme.primary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get secondaryColor => colorScheme.secondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;
  Color get outlineColor => colorScheme.outline;
  Color get errorColor => colorScheme.error;
  Color get errorColorContainer => colorScheme.errorContainer;  
  Color get onErrorContainer => colorScheme.onErrorContainer;
  
  Color get surfaceColor => colorScheme.surface;
  Color get onSurfaceColor => colorScheme.onSurface;
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;
  Color get surfaceColorHighest => colorScheme.surfaceContainerHighest;
}
