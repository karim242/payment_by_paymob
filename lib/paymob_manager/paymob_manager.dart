import 'package:dio/dio.dart';
import 'package:payment_by_paymob/constant.dart';

class PaymobManager {
  Future<String> getPaymentKey(int amount, String currency) async {
    //get authenticationToken
    try {
  String authenticationToken = await _getAuthenticationToken();
  
  // get order id
  int orderId = await _getOrderId(
      amount: (100 * amount).toString(),
      currency: currency,
      authenticationToken: authenticationToken);
  
  // get payment key
  String paymentKey = await _getPaymentKey(
    authenticationToken: authenticationToken,
    amount: (100 * amount).toString(),
    currency: currency,
    orderId: orderId.toString(),
  );
  return paymentKey;
} on Exception catch (e) {
    print(e.toString());
      throw Exception();
}
  }

  Future<String> _getAuthenticationToken() async {
    final Response response =
        await Dio().post("https://accept.paymob.com/api/auth/tokens", data: {
      "api_key": ApiKeysConstants.apiKeys,
    });
    return response.data["token"];
  }

  Future<int> _getOrderId(
      {required String amount,
      required String currency,
      required String authenticationToken}) async {
    final Response response = await Dio()
        .post("https://accept.paymob.com/api/ecommerce/orders", data: {
      "auth_token": authenticationToken,
      "delivery_needed": "false",
      "amount_cents": amount,
      "currency": currency,
      "items": []
    });
    return response.data["id"];
  }

  Future<String> _getPaymentKey(
      {required String authenticationToken,
      required String amount,
      required String currency,
      required String orderId}) async {
    final Response response = await Dio()
        .post("https://accept.paymob.com/api/acceptance/payment_keys", data: {
      //ALL OF THEM ARE REQIERD
      "expiration": 3600,

      "auth_token": authenticationToken, //From First Api
      "order_id": orderId, //From Second Api  >>(STRING)<<
      "integration_id":
          ApiKeysConstants.integrationId, //Integration Id Of The Payment Method

      "amount_cents": amount,
      "currency": currency,

      "billing_data": {
        //Have To Be Values
        "first_name": "Clifford",
        "last_name": "Nicolas",
        "email": "claudette09@exa.com",
        "phone_number": "+86(8)9135210487",

        //Can Set "NA"
        "apartment": "NA",
        "floor": "NA",
        "street": "NA",
        "building": "NA",
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "state": "NA"
      },
    });
    return response.data["token"];
  }
}
