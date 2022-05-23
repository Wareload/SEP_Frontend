class InvalidPermissionException implements Exception {
  String cause;

  ///constructor
  InvalidPermissionException(this.cause);

  @override
  String toString() {
    return cause;
  }
}
