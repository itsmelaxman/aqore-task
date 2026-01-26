import 'package:flutter/material.dart';
import '../../app_library.dart';

class StatusHandler extends StatelessWidget {
  /// Current status.
  final DataFetchStatus status;

  /// Success builder.
  final Widget Function() successBuilder;

  /// Empty state title.
  final String? emptyTitle;

  /// Empty/error message.
  final String? emptyMessage;

  /// Empty/error illustration path.
  final String? emptyIllustration;

  /// Empty state action label.
  final String? actionLabel;

  /// Empty state action callback.
  final VoidCallback? onAction;

  /// Has data flag.
  final bool hasData;

  /// Enable pull-to-refresh flag.
  final bool enablePullToRefresh;

  /// Refresh callback.
  final VoidCallback? onRefresh;

  const StatusHandler({
    super.key,
    required this.status,
    required this.successBuilder,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyIllustration,
    this.actionLabel,
    this.onAction,
    this.hasData = true,
    this.enablePullToRefresh = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Handle data fetch status
    switch (status) {
      case DataFetchStatus.initial:
      case DataFetchStatus.loading:
        return const LoadingIndicator();

      case DataFetchStatus.error:
        return _buildEmptyWidget(
          title: 'Something went wrong',
          message: emptyMessage ?? 'Unable to load data. Please try again.',
          illustration: emptyIllustration,
        );

      case DataFetchStatus.empty:
      case DataFetchStatus.success:
        if (!hasData) {
          return _buildEmptyWidget(
            title: emptyTitle ?? 'Nothing here yet',
            message: emptyMessage ?? 'Get started by adding your first item.',
            illustration: emptyIllustration,
          );
        }

        // if pull-to-refresh is enabled
        if (enablePullToRefresh && onRefresh != null) {
          return RefreshIndicator(
            onRefresh: () async {
              onRefresh?.call();
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: successBuilder(),
          );
        }

        return successBuilder();
    }
  }

  Widget _buildEmptyWidget({
    required String title,
    required String message,
    String? illustration,
  }) {
    final content = EmptyState(
      message: '$title\n$message',
      iconPath: illustration,
      actionLabel: actionLabel,
      onAction: onAction,
    );

    // if pull-to-refresh is enabled
    if (enablePullToRefresh && onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async {
          onRefresh?.call();
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(height: 500, child: content),
        ),
      );
    }

    return content;
  }
}
