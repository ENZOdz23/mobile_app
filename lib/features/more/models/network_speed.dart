class NetworkSpeed {
  final double downloadSpeed;
  final double uploadSpeed;
  final bool isLoading;
  final String downloadUnit;
  final String uploadUnit;
  final int progressPercent; // 0-100 for test progress
  final bool isDownloadComplete;
  final bool isUploadComplete;

  NetworkSpeed({
    this.downloadSpeed = 0.0,
    this.uploadSpeed = 0.0,
    this.isLoading = false,
    this.downloadUnit = 'Mbps',
    this.uploadUnit = 'Mbps',
    this.progressPercent = 0,
    this.isDownloadComplete = false,
    this.isUploadComplete = false,
  });

  NetworkSpeed copyWith({
    double? downloadSpeed,
    double? uploadSpeed,
    bool? isLoading,
    String? downloadUnit,
    String? uploadUnit,
    int? progressPercent,
    bool? isDownloadComplete,
    bool? isUploadComplete,
  }) {
    return NetworkSpeed(
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      isLoading: isLoading ?? this.isLoading,
      downloadUnit: downloadUnit ?? this.downloadUnit,
      uploadUnit: uploadUnit ?? this.uploadUnit,
      progressPercent: progressPercent ?? this.progressPercent,
      isDownloadComplete: isDownloadComplete ?? this.isDownloadComplete,
      isUploadComplete: isUploadComplete ?? this.isUploadComplete,
    );
  }

  /// Convert speed to a displayable string
  String getDownloadSpeedDisplay() {
    if (downloadSpeed == 0.0) return '-';
    return '${downloadSpeed.toStringAsFixed(2)} $downloadUnit';
  }

  String getUploadSpeedDisplay() {
    if (uploadSpeed == 0.0) return '-';
    return '${uploadSpeed.toStringAsFixed(2)} $uploadUnit';
  }
}
