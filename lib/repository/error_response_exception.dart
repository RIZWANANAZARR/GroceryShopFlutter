class ErrorResponseException implements Exception{
  final Map<String, dynamic> errorResponseJsonMap;
  final String errorMessage;

  ErrorResponseException(this.errorResponseJsonMap, this.errorMessage);

  String toString() {
    return errorMessage;
  }

}