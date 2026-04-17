import 'dart:convert';

class ParsedError {
  final String message;
  final Map<String, dynamic>? errors;

  ParsedError({required this.message, this.errors});
}

class ErrorParser {
  /// Parses raw error strings/Exceptions into a structured ParsedError object.
  static ParsedError fromRaw(dynamic error) {
    String raw = error.toString();

    try {
      // 1. Find the first occurrence of '{' to locate the JSON body
      int jsonStartIndex = raw.indexOf('{');

      if (jsonStartIndex != -1) {
        String jsonPart = raw.substring(jsonStartIndex);
        final Map<String, dynamic> decoded = jsonDecode(jsonPart);

        // return ParsedError(
        //   message: decoded['message'] ?? "Validation Failed",
        //   errors: decoded['errors'] is Map<String, dynamic>
        //       ? decoded['errors']
        //       : null,
        // );

        final rawErrors = decoded['errors'];

        Map<String, dynamic>? parsedErrors;

        if (rawErrors is Map<String, dynamic>) {
          // Standard Laravel validation errors: {"field": ["msg"]}
          parsedErrors = rawErrors;
        } else if (rawErrors is String && rawErrors.isNotEmpty) {
          // Plain string error: "No record found"
          parsedErrors = {
            'detail': [rawErrors],
          };
        } else if (rawErrors is List) {
          // Array of error strings
          parsedErrors = {'errors': rawErrors};
        }

        return ParsedError(
          message: decoded['message'] ?? 'Validation Failed',
          errors: parsedErrors,
        );
      }
    } catch (e) {
      // If JSON parsing fails, move to fallback
    }

    // 2. Fallback: Clean up standard Exception strings
    String cleanMsg = raw
        .replaceAll('Exception:', '')
        .replaceAll('exception:', '')
        .trim();
    return ParsedError(
      message: cleanMsg.isEmpty ? "An unexpected error occurred" : cleanMsg,
    );
  }

  static ParsedError fromDynamic(dynamic error) {
    if (error == null) {
      return ParsedError(message: "An error occurred");
    }
    if (error is Map<String, dynamic>) {
      // Already a parsed response – extract message & errors
      String message = error['message'] ?? 'Validation Failed';
      Map<String, dynamic>? errors;
      if (error['errors'] is Map) {
        errors = (error['errors'] as Map).map(
          (key, value) => MapEntry(
            key.toString(),
            value is List ? List<String>.from(value) : [value.toString()],
          ),
        );
      }
      return ParsedError(message: message, errors: errors);
    }
    // Fallback to raw string parsing
    return fromRaw(error);
  }
}

// Exception: {"message":"Validation failed.","errors":{"vehicles.0.yom":["The vehicles.0.yom field must be 4 digits.","The vehicles.0.yom field must be between 1900 and 2026."]}}

// {
//   "message": "Validation failed.",
//   "errors": {
//     "vehicles.0.yom": [
//       "The vehicles.0.yom field must be 4 digits.",
//       "The vehicles.0.yom field must be between 1900 and 2026."
//     ]
//   }

class ParsedError_2 {
  final String message;
  final Map<String, List<String>>? errors;

  ParsedError_2({required this.message, this.errors});
}

class ErrorParser_2 {
  /// Parses error data from API responses.
  ///
  /// Accepts either:
  /// - A `Map<String, dynamic>` like `{"message": "...", "errors": {...}}`
  /// - A JSON `String` that decodes to such a map
  /// - Any other value (treated as plain message)
  static ParsedError parse(dynamic errorData) {
    // Default fallback
    String message = 'An error occurred';
    Map<String, List<String>>? errors;

    // If it's already a map
    if (errorData is Map<String, dynamic>) {
      message = errorData['message']?.toString() ?? message;
      final rawErrors = errorData['errors'];
      if (rawErrors is Map) {
        errors = _normalizeErrors(rawErrors);
      }
    }
    // If it's a string, try to decode JSON
    else if (errorData is String) {
      try {
        final decoded = jsonDecode(errorData);
        if (decoded is Map<String, dynamic>) {
          message = decoded['message']?.toString() ?? message;
          final rawErrors = decoded['errors'];
          if (rawErrors is Map) {
            errors = _normalizeErrors(rawErrors);
          }
        } else {
          message = errorData;
        }
      } catch (_) {
        message = errorData;
      }
    }
    // Anything else (null, number, etc.)
    else if (errorData != null) {
      message = errorData.toString();
    }

    return ParsedError(message: message, errors: errors);
  }

  static Map<String, List<String>> _normalizeErrors(
    Map<dynamic, dynamic> rawErrors,
  ) {
    return rawErrors.map((key, value) {
      final List<String> errorList;
      if (value is List) {
        errorList = value.map((e) => e.toString()).toList();
      } else {
        errorList = [value.toString()];
      }
      return MapEntry(key.toString(), errorList);
    });
  }
}
