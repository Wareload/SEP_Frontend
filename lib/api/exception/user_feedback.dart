class UserFeedbackException implements Exception {
  String cause;

  UserFeedbackException(this.cause);

  @override
  String toString() {
    return cause;
  }
}
