class AppSettingsEntity {
  final String minAndroidVersion;
  final String minIosVersion;
  final String storeUrlAndroid;
  final String storeUrlIos;
  final bool forceUpdate;

  const AppSettingsEntity({
    required this.minAndroidVersion,
    required this.minIosVersion,
    required this.storeUrlAndroid,
    required this.storeUrlIos,
    required this.forceUpdate,
  });

  factory AppSettingsEntity.fromJson(Map<String, dynamic> json) {
    return AppSettingsEntity(
      minAndroidVersion: json['minAndroidVersion'] as String? ?? '1.0.0',
      minIosVersion: json['minIosVersion'] as String? ?? '1.0.0',
      storeUrlAndroid: json['storeUrlAndroid'] as String? ?? '',
      storeUrlIos: json['storeUrlIos'] as String? ?? '',
      forceUpdate: json['forceUpdate'] as bool? ?? false,
    );
  }

  /// Compares the current version with the minimum required version.
  /// Returns true if the current version is strictly less than the minimum.
  bool isOutdated(String currentVersion, bool isIos) {
    if (forceUpdate) return true;
    
    final minVersionStr = isIos ? minIosVersion : minAndroidVersion;
    
    final currentParts = currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final minParts = minVersionStr.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (var i = 0; i < 3; i++) {
      final c = i < currentParts.length ? currentParts[i] : 0;
      final m = i < minParts.length ? minParts[i] : 0;
      if (c < m) return true;
      if (c > m) return false;
    }
    
    return false;
  }
}
