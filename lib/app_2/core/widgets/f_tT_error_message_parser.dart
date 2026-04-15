class FTErrorMessageParser {
  static Map<String, dynamic> parse(dynamic errorData) {
    Map<String, List<String>>? errorMap;
    String displayMessage = 'Validation Failed';

    if (errorData is Map<String, dynamic>) {
      displayMessage = errorData['message'] ?? 'Validation Failed';

      if (errorData['errors'] is Map) {
        errorMap = (errorData['errors'] as Map).map(
          (key, value) =>
              MapEntry(key.toString(), List<String>.from(value ?? [])),
        );
      }
    }

    return {'message': displayMessage, 'errors': errorMap};
  }
}

class FTParsedError {
  final String message;
  final Map<String, List<String>>? errors;

  FTParsedError({required this.message, this.errors});
}


// {
//   "message": "Validation Failed",
//   "errors": {
//     "email": ["Email is required"],
//     "password": ["Password must be 8 characters"]
//   }
// }