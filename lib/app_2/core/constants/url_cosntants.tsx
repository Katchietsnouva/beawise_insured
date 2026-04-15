// src/app/url_cosntants.tsx
export const INSCLOUD_KEY_CONST = '$2y$12$u3AAyPbm9drxDIgt3mMjeusJ/VpRJz75aed/TkEmpYrHwxdy3hEVq';
export const PASSKEY_CONST = '24D6B5118AE2EEB07D36320B857367';


export const API_BASE_URL_CONST = 'https://demo.inscloud.net/api';

export const INSCLOUD_API_URLS_CONST = {
    INSCLOUD_AUTH_URL_CONST: `${API_BASE_URL_CONST}/auth`,
    INSCLOUD_SEND_OTP_URL_CONST: `${API_BASE_URL_CONST}/otp/send`,
    INSCLOUD_VERIFY_OTP_URL_CONST: `${API_BASE_URL_CONST}/otp/verify`,
    // INSCLOUD_TRAVEL_URL_CONST: `${API_BASE_URL_CONST}/travel`,
    INSCLOUD_TRAVEL_URL_CONST: `${API_BASE_URL_CONST}/travel/save`,
    INSCLOUD_GET_TRAVEL_PRODUCTS_URL_CONST: `${API_BASE_URL_CONST}/om/travel/products`,
    INSCLOUD_GET_TRAVEL_QUOTE_URL_CONST: `${API_BASE_URL_CONST}/om/travel/quote`,
    INSCLOUD_CREATE_RECEIPT_URL_CONST: `${API_BASE_URL_CONST}/payment/receipt/create`,

    INSCLOUD_CLIENT_POLICIES_URL_CONST: `${API_BASE_URL_CONST}/client/policies`,
    // INSCLOUD_CLIENT_POLICIES_ITEMS_URL_CONST: `${API_BASE_URL_CONST}/client/policy/16`,
    INSCLOUD_CLIENT_POLICIES_ITEMS_URL_CONST: `${API_BASE_URL_CONST}/client/policy`,

};



export const PESAPAL_BASE_URL = "https://pay.pesapal.com/v3/api";

export const PESAPAL_URLS_CONST = {
    TOKEN_URL_CONST: `${PESAPAL_BASE_URL}/Auth/RequestToken`,
    SUBMIT_ORDER_URL_CONST: `${PESAPAL_BASE_URL}/Transactions/SubmitOrderRequest`,
    STATUS_URL_CONST: `${PESAPAL_BASE_URL}/Transactions/GetTransactionStatus`,
};
