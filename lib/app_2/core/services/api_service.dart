// lib/app_2/core/services/api_service.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:http/http.dart' as http;
import 'package:insured/app_2/core/constants/Url_pesapal_constants.dart';
import 'package:insured/app_2/core/constants/url_cosntants.dart';
import 'package:insured/app_2/core/constants/api_responses.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart';
import 'package:insured/app_2/data/models/motor_save_model.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
}

// final apiServiceProvider = Provider<ApiService>((ref) => ApiService(ref));

class ApiService {
  // final Ref _ref;
  // ApiService(this._ref);

  static const String baseUrl = InscloudUrls.base;

  static Future<String> getAuthToken() async {
    final response = await http.post(
      Uri.parse(InscloudUrls.auth),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'inscloudkey': InscloudUrls.inscloudkey,
        'passkey': InscloudUrls.inscloudpasskey,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Authentication failed');
    }
    print("This is the getAuthToken response ${response.body}");

    return data['token'];
  }

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> data,
    String bearerAuthToken,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerAuthToken',
      },
      body: jsonEncode(data),
    );
    print("This is the Register response ${response.body}");
    return _handleResponse(response);
  }

  // Login – returns :
  // { "status": "success","message": "OTP sent to your email.", "otp_expires_in_minutes": 10}
  // Login – requires Bearer token from /auth
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
    String bearerAuthToken,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/login'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerAuthToken',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    print("This is the OTP response ${response.body}");
    return _handleResponse(response);
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(
    String email,
    String otp,
    String bearerAuthToken,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/login/otp/verify'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerAuthToken',
      },
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    print(
      "Here is the response of the verify otp fxn in lib/app_2/core/services/api_service.dart: $response",
    );

    print("Raw response body: ${response.body}");

    try {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print("Full JSON response:");
      print(JsonEncoder.withIndent('  ').convert(responseData));
    } catch (e) {
      print("Failed to decode JSON: $e");
    }
    print("This is the verifyOtp response ${response.body}");
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        // 'Request failed: ${response.statusCode} - ${response.body}',
        '${response.body}',
      );
    }
  }

  // static Map<String, dynamic> _handleResponse(http.Response response) {
  static Map<String, dynamic> _handleResponseProtected(
    http.Response response,
    Ref ref,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("Yo  0");
      return jsonDecode(response.body);
    } else {
      final body = response.body;
      // Check for authentication errors
      if (response.statusCode == 401 ||
          // response.statusCode == 422 ||
          body.contains('Invalid credentials') ||
          body.contains('Unauthenticated') ||
          body.contains('Unauthorized')) {
        // ref.read(authProvider.notifier).logout();
        Future.microtask(() {
          ref.read(authProvider.notifier).logout();
        });
        print("Yo you should have logged out coz of Unauthorized");
        throw AuthenticationException(body);
      }
      print("Yo you should have logged out 2");
      // ref.read(authProvider.notifier).logout();
      throw Exception(body);
    }
  }

  // final response = await ApiService.safeApiCall(
  //   ApiService.getMotorQuote(...),
  //   ref,
  // );

  static Future<T> safeApiCall<T>(Future<T> apiCall, Ref ref) async {
    try {
      return await apiCall;
    } catch (e) {
      if (e is AuthenticationException) {
        // Logout automatically
        ref.read(authProvider.notifier).logout();
        // Re-throw so the caller knows an error occurred (optional)
        throw e;
      }
      rethrow;
    }
  }

  static Future<http.Response> _authenticatedRequest(
    Future<http.Response> Function(String token) requestFn,
  ) async {
    try {
      // Get current token
      String token = await getAuthToken();
      var response = await requestFn(token);

      // If unauthorized, try once with a fresh token
      if (response.statusCode == 401) {
        print('⚠️ Token expired, refreshing...');
        token = await getAuthToken();
        response = await requestFn(token);
      }
      print("This is the _authenticatedRequest response ${response.body}");
      return response;
    } catch (e) {
      print('❌ _authenticatedRequest error: $e');
      rethrow;
    }
  }

  static Future<PasswordResetRequestResponse> requestPasswordReset(
    String email,
  ) async {
    try {
      final response = await _authenticatedRequest((token) async {
        return await http.post(
          Uri.parse(InscloudUrls.resetOtpRequestInsuredUser),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'email': email}),
        );
      });

      final data = jsonDecode(response.body);
      print('📩 Password reset request response: $data');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return PasswordResetRequestResponse.fromJson(data);
      } else {
        throw Exception(jsonEncode(data));
      }
    } catch (e) {
      print('❌ requestPasswordReset error: $e');
      rethrow;
    }
  }

  static Future<PasswordResetConfirmResponse> confirmPasswordReset({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _authenticatedRequest((bearerAuthToken) async {
        return await http.post(
          Uri.parse(InscloudUrls.resetOtpConfirmInsuredUser),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerAuthToken',
          },
          body: jsonEncode({
            'email': email,
            'token': token,
            'password': password,
            'password_confirmation': passwordConfirmation,
          }),
        );
      });

      final data = jsonDecode(response.body);
      print('📩 Password reset confirm response: $data');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return PasswordResetConfirmResponse.fromJson(data);
      } else {
        throw Exception(jsonEncode(data));
      }
    } catch (e) {
      print('❌ confirmPasswordReset error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createClient(
  // Map<String, dynamic> clientData,
  // String token,
  {
    required Map<String, dynamic> clientData,
    required String agentCode,
    required String agentKey,
    required String token,
  }) async {
    print("This has been called in api service createclient");
    final response = await http.post(
      Uri.parse('$baseUrl/agent/client'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
      // body: jsonEncode({'client': clientData}),
      body: jsonEncode(clientData),
    );
    print("In the create CLien Block here is the response${response.body} ");
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getClients({
    required String agentCode,
    required String agentKey,
    required String token,
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    // if (search != null && search.isNotEmpty) {
    //   queryParams['search'] = search;
    // }
    // final uri = Uri.parse('$baseUrl/agent/clients');
    final uri = Uri.parse(
      '$baseUrl/agent/clients',
    ).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
    );
    print("In the getClients Block here is the response${response.body} ");
    return _handleResponse(response);
  }

  // Server-side client search: GET /agent/clients/search?q=<query>
  // Backend matches against name, phone and email.
  static Future<Map<String, dynamic>> searchClients({
    required String agentCode,
    required String agentKey,
    required String token,
    required String query,
    int page = 1,
    int perPage = 15,
  }) async {
    final uri = Uri.parse('$baseUrl/agent/clients/search').replace(
      queryParameters: {
        'q': query,
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
    );
    print(
      "In the searchClients Block ($uri) here is the response${response.body} ",
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateClient({
    required String clientId,
    required Map<String, dynamic> clientData,
    required String agentCode,
    required String agentKey,
    required String token,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/agent/client/$clientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
      body: jsonEncode(clientData),
    );
    print("In the updateClient Block here is the response${response.body} ");

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> deleteClient({
    required String clientId,
    required String agentCode,
    required String agentKey,
    required String token,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/agent/client/$clientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getPolicies({
    required String agentCode,
    required String agentKey,
    required String token,
    required Ref ref,

    int page = 1,
    int perPage = 10,
    int status = 1,
  }) async {
    final uri = Uri.parse('$baseUrl/agent/policies').replace(
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'status': status.toString(),
      },
    );
    print("YOooo retrieving data on uri: $uri");
    final response = await http.get(
      // Uri.parse('$baseUrl/agent/policies'),
      // Uri.parse('$baseUrl/agent/policies?page=$page&per_page=$perPage'),
      // Uri.parse(
      //   '$baseUrl/agent/policies?page=$page&per_page=$perPage&status=0',
      // ),
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },

      // body: jsonEncode({'page': page, 'per_page': perPage}),
    );
    print("YOooo received response body: ${response.body}");
    return _handleResponseProtected(response, ref);
  }

  /// Exports policies as a spreadsheet. Hits the same `/agent/policies`
  /// endpoint with `export=excel`, which streams an .xlsx file (binary) rather
  /// than JSON — so this returns the raw bytes instead of a decoded map.
  static Future<List<int>> exportPolicies({
    required String agentCode,
    required String agentKey,
    required String token,
    int page = 1,
    int perPage = 10,
    int status = 1,
    String export = 'excel',
  }) async {
    final uri = Uri.parse('$baseUrl/agent/policies').replace(
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'status': status.toString(),
        'export': export,
      },
    );
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
    );
    print("exportPolicies($uri) → status ${response.statusCode}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.bodyBytes;
    }
    // Error responses come back as JSON/text, not a spreadsheet.
    throw Exception(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, dynamic>> getPolicyById({
    required String agentCode,
    required String agentKey,
    required String token,
    required int policyId,
  }) async {
    final uri = Uri.parse('$baseUrl/agent/policy/$policyId');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
    );

    print("Yooo this is the getPolicyById link: $uri");
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getStatement({
    required String agentCode,
    required String agentKey,
    required String token,
    required String startDate,
    required String endDate,
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await http.get(
      // Uri.parse('$baseUrl/agent/statement'),
      Uri.parse(
        '$baseUrl/agent/statement'
        '?start_date=$startDate'
        '&end_date=$endDate'
        '&page=$page'
        '&per_page=$perPage',
        // '&status=0',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
      // body: jsonEncode({
      //   'start_date': startDate,
      //   'end_date': endDate,
      //   'page': page,
      //   'per_page': perPage,
      // }),
    );
    print("here is the   getStatement body  response: ${response.body} ");
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getMotorQuote({
    required Ref ref,
    required String agentCode,
    required String agentKey,
    required String token,
    required MotorQuoteRequest request,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/motor/quote'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
      body: jsonEncode(request.toJson()),
    );
    print("This is the get Motor Quote response ${response.body}");
    return _handleResponseProtected(response, ref);
  }

  static Future<Map<String, dynamic>> saveMotorPolicy({
    required String agentCode,
    required String agentKey,
    required String token,
    required MotorSaveRequest request,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/motor/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
      body: jsonEncode(request.toJson()),
    );
    print(
      "This is the saveMotorPolicy(baseUrl/motor/save) response ${response.body}",
    );
    return _handleResponse(response);
  }

  //   PESAPAL_CONSUMER_KEY=GtcHUHbDf6leb7LUX+RXGAEdc1TDDAj2
  // PESAPAL_CONSUMER_SECRET=Ngh6rXS3Y019VY1TZ/R4AN/VH+4=

  // PESAPAL PAYMENT METHODS
  static Future<String?> getPesapalToken() async {
    final response = await http.post(
      Uri.parse('https://pay.pesapal.com/v3/api/Auth/RequestToken'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'consumer_key': PESAPAL_CONSUMER_KEY, // ← Put in constants/env
        'consumer_secret': PESAPAL_CONSUMER_SECRET,
      }),
    );
    final data = jsonDecode(response.body);
    return data['token'];
  }

  static Future<Map<String, dynamic>> submitPesapalOrder({
    required String orderId,
    required double amount,
    required String description,
    required String phone,
    required String email,
    required String callbackUrl,
  }) async {
    final token = await getPesapalToken();
    if (token == null) throw Exception('Failed to get Pesapal token');

    final payload = {
      'id': orderId,
      'currency': 'KES',
      'amount': amount.toStringAsFixed(2),
      'description': description,
      'callback_url': callbackUrl,
      'notification_id': 'YOUR_NOTIFICATION_ID', // from Pesapal dashboard
      'billing_address': {
        'email_address': email,
        'phone_number': phone,
        'country_code': 'KE',
      },
    };

    final response = await http.post(
      Uri.parse(
        'https://pay.pesapal.com/v3/api/Transactions/SubmitOrderRequest',
      ),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getPesapalStatus(
    String orderTrackingId,
  ) async {
    final token = await getPesapalToken();
    final response = await http.get(
      Uri.parse(
        'https://pay.pesapal.com/v3/api/Transactions/GetTransactionStatus?orderTrackingId=$orderTrackingId',
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // static Future<void> _sendStkPush(
  //   BuildContext context,
  //   Map<String, dynamic> paymentData,
  // ) async {
  //   // const baseUrl = "https://demo.inscloud.net/api/stk_push";
  //   const baseUrl = "https://demo.inscloud.net/api/payment/stk/push";

  //   try {
  //     final response = await http.post(
  //       Uri.parse(baseUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(paymentData),
  //     );

  //     print("Here is the response of the stk  ${response.body}");

  //     if (response.statusCode == 200) {
  //       _showMessage(context, 'STK Push sent successfully!');
  //     } else {
  //       _showMessage(context, 'Failed to send payment: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     _showMessage(context, 'Error sending payment: $e');
  //   }
  // }

  static Future<Map<String, dynamic>> uploadPolicyDocument({
    required String token,
    required String agentCode,
    required String agentKey,
    required String documentName,
    required String risknote,
    required String clientNo,
    required String clientKey,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/policy/file/upload'),
    );
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'X-Agent-Code': agentCode,
      'X-Agent-Key': agentKey,
      // 'X-Client-No': clientNo,
      // 'X-Client-Key': clientKey,
    });
    request.fields['document_name'] = documentName;
    request.fields['risknote'] = risknote;
    request.files.add(
      http.MultipartFile.fromBytes(
        'document_file',
        fileBytes,
        filename: fileName,
      ),
    );
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    print('uploadPolicyDocument [$documentName] → ${response.body}');
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> postDmvicDoubleInsurance({
    required String token,
    required String registration,
    required String startDate,
    required String expiringDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/dmvic/double-insurance'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'registration': registration,
        'start_date': startDate,
        'expiring': expiringDate,
      }),
    );
    print(
      "here is the post postDmvicDoubleInsurance response: ${response.body}",
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getInsurers({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/insurers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("here is the get response: ${response.body}");
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> postDmvicStock({
    required String token,
    required int insurerId,
  }) async {
    final body = {'insurer': 29};

    final response = await http.post(
      Uri.parse('$baseUrl/dmvic-stock'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
      // body: body,
    );
    print(
      "here is the post  postDmvicStock response: ${response.body} body was: $body",
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getRenewals({
    required String agentCode,
    required String agentKey,
    required String token,
    required String starting,
    required String ending,
    int page = 1,
    int perPage = 10,
  }) async {
    final uri = Uri.parse('$baseUrl/agent/renewals').replace(
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'starting': starting,
        'ending': ending,
      },
    );
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
      // body: jsonEncode(body),
    );
    print("📦 getRenewals response: ${response.body}");
    print(
      "here is the post  getRenewals body was:${uri} response: ${response.body} ",
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getCertificates({
    required String agentCode,
    required String agentKey,
    required String token,
    required String starting,
    required String ending,
    int perPage = 10,
    int page = 1,
  }) async {
    final uri = Uri.parse('$baseUrl/agent/certificates').replace(
      queryParameters: {
        'starting': starting,
        'ending': ending,
        'per_page': perPage.toString(),
        'page': page.toString(),
      },
    );
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
    );
    print(
      "here is the getCertificates body was:${uri} response: ${response.body} ",
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getDashboard({
    required Ref ref,
    required String agentCode,
    required String agentKey,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/dashboard'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
    );
    print("here is the getDashboard  response:$baseUrl ${response.body} ");
    return _handleResponseProtected(response, ref);
  }

  static Future<Map<String, dynamic>> issueCertificate({
    required String policyId,
    required String agentCode,
    required String agentKey,
    required String token,
  }) async {
    print("payload is : $policyId");
    final response = await http.post(
      Uri.parse('$baseUrl/dmvic/agent'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Agent-Code': agentCode,
        'X-Agent-Key': agentKey,
      },
      body: jsonEncode({'policy_id': policyId}),
    );

    print("📄 issueCertificate response: ${response.body}");

    return _handleResponse(response);
  }
}
