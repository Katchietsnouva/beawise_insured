// // lib/app_2/core/constants/url_cosntants.dart
// class InscloudUrls {
//   static const inscloudkey =
//           r'$2y$12$u3AAyPbm9drxDIgt3mMjeusJ/VpRJz75aed/TkEmpYrHwxdy3hEVq',
//       inscloudpasskey = '24D6B5118AE2EEB07D36320B857367',
//       base = 'https://demo.inscloud.net/api',
//       auth = '$base/auth',
//           // sendOtp = '$base/otp/send',
//           // verifyOtp = '$base/otp/verify',
//           // travelSave = '$base/travel/save',
//           // travelProducts = '$base/om/travel/products',
//           // travelQuote = '$base/om/travel/quote',
//           // createReceipt = '$base/payment/receipt/create',
//           // clientPolicies = '$base/client/policies',
//           // clientPolicyItems = '$base/client/policy',
//           registerInsuredUser =
//           '$base/agent/register',
//       logInInsuredUser = '$base/agent/login',
//       verifyOtpInsuredUser = '$base/agent/login/otp/verify',
//       resetOtpRequestInsuredUser = '$base/agent/password/request',
//       resetOtpConfirmInsuredUser = '$base/agent/password/confirm',
//       createClientInsuredUser = '$base/agent/client/create',
//       stkPush = '$base/payment/stk/push';
// }

// class PesapalUrls {
//   static const base = 'https://pay.pesapal.com/v3/api',
//       token = '$base/Auth/RequestToken',
//       submitOrder = '$base/Transactions/SubmitOrderRequest',
//       status = '$base/Transactions/GetTransactionStatus';
// }

// final authUrl = InscloudUrls.auth;
// final pesapalToken = PesapalUrls.token;

// ========
// ========
// ========
// ========

// lib/app_2/core/constants/url_cosntants.dart
class InscloudUrls {
  static const appName = 'Beawise Insured';
  static const applicationId = "com.insured.beawise";
  static const businessNo = '4060615',
          ///
          ///
          // inscloudkey =
          //         r'$2y$12$u3AAyPbm9drxDIgt3mMjeusJ/VpRJz75aed/TkEmpYrHwxdy3hEVq',
          //     inscloudpasskey = '24D6B5118AE2EEB07D36320B857367',
          //     base = 'https://demo.inscloud.net/api',
          inscloudkey =
          r'$2y$12$g6s9dhG60Ta2ODHJRyEeF.nlCgjmxV/NtGBwNmQM9MJsjWQtwb9ba',
      inscloudpasskey = 'E79FB3A9F89ED57BD0563B2E389738',
      base = 'https://beawise.inscloud.net/api',
      auth = '$base/auth',
          // sendOtp = '$base/otp/send',
          // verifyOtp = '$base/otp/verify',
          // travelSave = '$base/travel/save',
          // travelProducts = '$base/om/travel/products',
          // travelQuote = '$base/om/travel/quote',
          // createReceipt = '$base/payment/receipt/create',
          // clientPolicies = '$base/client/policies',
          // clientPolicyItems = '$base/client/policy',
          registerInsuredUser =
          '$base/agent/register',
      logInInsuredUser = '$base/agent/login',
      verifyOtpInsuredUser = '$base/agent/login/otp/verify',
      resetOtpRequestInsuredUser = '$base/agent/password/request',
      resetOtpConfirmInsuredUser = '$base/agent/password/confirm',
      createClientInsuredUser = '$base/agent/client/create',
      stkPush = '$base/payment/stk/push',
      agreements = '$base/agents/agreements';
}

class PesapalUrls {
  static const base = 'https://pay.pesapal.com/v3/api',
      token = '$base/Auth/RequestToken',
      submitOrder = '$base/Transactions/SubmitOrderRequest',
      status = '$base/Transactions/GetTransactionStatus';
}



// // final authUrl = InscloudUrls.auth;
// // final pesapalToken = PesapalUrls.token;



// // $2y$12$g6s9dhG60Ta2ODHJRyEeF.nlCgjmxV/NtGBwNmQM9MJsjWQtwb9ba
// // E79FB3A9F89ED57BD0563B2E389738
// // https://beawise.inscloud.net/