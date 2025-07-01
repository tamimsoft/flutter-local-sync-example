/// Custom exceptions for better error handling
class SyncServiceException implements Exception {
  final String message;
  SyncServiceException(this.message);

  @override
  String toString() => 'SyncServiceException: $message';
}

class SyncTimeoutException extends SyncServiceException {
  SyncTimeoutException(super.message);
}
