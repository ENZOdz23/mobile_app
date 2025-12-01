class NetworkSpeed {
  final double downloadSpeed;
  final double uploadSpeed;
  final bool isLoading;

  NetworkSpeed({
    this.downloadSpeed = 0.0,
    this.uploadSpeed = 0.0,
    this.isLoading = false,
  });

  NetworkSpeed copyWith({
    double? downloadSpeed,
    double? uploadSpeed,
    bool? isLoading,
  }) {
    return NetworkSpeed(
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
