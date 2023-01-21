import 'dart:convert';
import 'package:customer_app/config/setting.dart';
import 'package:http/http.dart' as http;

final base_url = AppSettings.base_url;

class LoginAPI {
//  function to check mobile against customer
  static checkMobile(String mobile, String mode) async {
    final url = Uri.parse(base_url + "/mobile");
    final payload = {"mobile": mobile, "mode": mode};

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Error in checkMobile api ::: $e");
      return e;
    }
  }

  //  function to check otp against mobile number
  static checkOtp(String mobile, String otp, String mode) async {
    final url = Uri.parse(base_url + "/otp");
    final payload = {"mobile": mobile, "otp": otp, "mode": mode};

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Error in checkOtp api ::: $e");
      return e;
    }
  }
}
