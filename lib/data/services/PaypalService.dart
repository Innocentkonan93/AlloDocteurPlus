import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'dart:convert' as convert;

class PaypalService {
  String domaine = "https://api-m.sandbox.paypal.com";
  String clientId = "AUYqeuzC5yle05UIIRgGACCojXz25QuKsN6wsKlN2wj7xcdrsxvMypj7jE138X6lmWrdjOkObCZ5cEBF";
  String secret = "EIlSV8wiUvwMkVNUBFm6EhnFxcuxWezgJ2AkKdJdarrUr70SGRvdLyQ0GAThy-yRMP2McYjorVlrtl3K";

  Future<String>  getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
          Uri.parse("$domaine/v1/oauth/token?grant_type=client_credentials"));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> createPaypalPayment(
      transaction, accessToken) async {
    try {
      var response =
          await http.post(Uri.parse("$domaine/v1/payements/payment"), headers: {
        "content-type": "application/json",
        "Authorization": "Bearer" + accessToken,
      });

      final body = convert.jsonDecode(response.body);
if (response.body.isNotEmpty) {
       print( convert.jsonEncode(convert.jsonDecode(response.body)));
      }
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];
          String executeUrl = "";
          String approvalUrl = "";

          final item = links.firstWhere(
              (element) => element["rel"] == "approval_url",
              orElse: () => null);

          if (item != null) {
            approvalUrl = item["href"];
          }
          final item2 = links.firstWhere(
              (element) => element["rel"] == "execute",
              orElse: () => null);

          if (item != null) {
            executeUrl = item2["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        throw Exception(0);
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> executePayment(url, payerId, accesToken) async {
    try {
      var response = await http.post(
        url,
        body: convert.jsonEncode(
          {"payer_id": payerId},
        ),
        headers: {
          "content-type":"application/json",
          "Authorization" : "Bearer" + accesToken
        }
      );
      final body = convert.jsonDecode(response.body);
      if(response.statusCode == 200){
        return body["id"];
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }
}
