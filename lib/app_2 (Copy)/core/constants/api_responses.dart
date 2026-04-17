class ApiResponse {
  final String status;
  final String? message;
  final Map<String, dynamic>? errors;
  final dynamic data;

  ApiResponse({required this.status, this.message, this.errors, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? 'error',
      message: json['message'],
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'])
          : null,
      data: json['data'],
    );
  }

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';
}

class PasswordResetRequestResponse {
  final String status;
  final String? message;

  PasswordResetRequestResponse({required this.status, this.message});

  factory PasswordResetRequestResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetRequestResponse(
      status: json['status'] ?? 'error',
      message: json['message'],
    );
  }
}

class PasswordResetConfirmResponse {
  final String status;
  final String? message;
  final Map<String, dynamic>? errors;

  PasswordResetConfirmResponse({
    required this.status,
    this.message,
    this.errors,
  });

  factory PasswordResetConfirmResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetConfirmResponse(
      status: json['status'] ?? 'error',
      message: json['message'],
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'])
          : null,
    );
  }
}
