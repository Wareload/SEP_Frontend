class UserFeedbackException implements Exception {
  String cause;

  ///constructor
  UserFeedbackException(this.cause);

  @override
  String toString() {
    return cause;
  }
}
