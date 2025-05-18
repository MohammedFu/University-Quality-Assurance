class ApiClass {
  static const String localhostIP = 'http://10.0.2.2';

  static String getEndpoint(String endpoint) {
    return '$localhostIP/$endpoint';
  }
}
