class AppConfig {
  const AppConfig._();

  /// Legacy PHP backend (funName endpoints).
  static const String legacyBase =
      'https://phpstack-1483171-5674853.cloudwaysapps.com/flickyapi/middleWare/requestManager.php';

  /// Public API root for auth / media helpers on the same legacy server.
  static const String apiBase =
      'https://phpstack-1483171-5674853.cloudwaysapps.com/flickyapi';

  /// Alias to the same API root.
  static const String apiRoot = apiBase;

  /// Presign helper hosted on the same legacy server.
  static const String presignBase = '$apiBase/api';

  static const String baseUrl = legacyBase;

  static const String appId = '24';
}
