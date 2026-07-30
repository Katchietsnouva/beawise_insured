// Constant names intentionally mirror the Pesapal env-var names (SCREAMING_CAPS).
// ignore_for_file: constant_identifier_names, file_names

// export const PESAPAL_BASE_URL = "https://pay.pesapal.com/v3/api";

// export const PESAPAL_URLS_CONST = {
//     TOKEN_URL_CONST: `${PESAPAL_BASE_URL}/Auth/RequestToken`,
//     SUBMIT_ORDER_URL_CONST: `${PESAPAL_BASE_URL}/Transactions/SubmitOrderRequest`,
//     STATUS_URL_CONST: `${PESAPAL_BASE_URL}/Transactions/GetTransactionStatus`,
// };

const String PESAPAL_BASE_URL = "https://pay.pesapal.com/v3/api";

class PesapalUrls {
  static const String TOKEN_URL = "$PESAPAL_BASE_URL/Auth/RequestToken";
  static const String SUBMIT_ORDER_URL =
      "$PESAPAL_BASE_URL/Transactions/SubmitOrderRequest";
  static const String STATUS_URL =
      "$PESAPAL_BASE_URL/Transactions/GetTransactionStatus";
}

// will later put in env
const String PESAPAL_CONSUMER_KEY = 'GtcHUHbDf6leb7LUX+RXGAEdc1TDDAj2';
const String PESAPAL_CONSUMER_SECRET = 'Ngh6rXS3Y019VY1TZ/R4AN/VH+4=';
 




// NEXT_PUBLIC_PAYPAL_CLIENT_ID=ASCSz9tyPmLkZfBpwYH4mMznrWT3_h4l8Z47u3wMOB1yLTI28c0xoFDQJ_WBUBjfluiek3c2oVyZfCb_ 
 
// PESAPAL_CONSUMER_KEY=GtcHUHbDf6leb7LUX+RXGAEdc1TDDAj2
// PESAPAL_CONSUMER_SECRET=Ngh6rXS3Y019VY1TZ/R4AN/VH+4=
 

// PESAPAL_NOTIFICATION_ID=276673bf-76fa-45a9-b4b4-dad5d41f4ad5  # i generated this in: src/app/api/pesapal/register-ipn/route.ts 
// NEXT_PUBLIC_SITE_URL=http://localhost:3000   # I changed to https://bizsure-travel-insurance.vercel.app in prod         


 

 
