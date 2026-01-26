/// [Svg] Source
enum SvgSourceType { asset, network }

/// Data [Fetch] Status
enum DataFetchStatus {
  initial,
  loading,
  success,
  error,
  empty;

  bool get isInitial => this == .initial;
  bool get isLoading => this == .loading;
  bool get isSuccess => this == .success;
  bool get isError => this == .error;
  bool get isEmpty => this == .empty;
}

/// [Order] Status Enum
enum OrderStatus {
  pending,
  processed;

  String get displayName => switch (this) {
    .pending => 'Pending',
    .processed => 'Processed',
  };

  static OrderStatus fromString(String status) {
    return .values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => .pending,
    );
  }
}
