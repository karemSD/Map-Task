class LocationServiceException implements Exception {
  final String message;

  LocationServiceException({required this.message});
}

class LocationPermissionException implements Exception {
  final String message;

  LocationPermissionException({required this.message});
}
