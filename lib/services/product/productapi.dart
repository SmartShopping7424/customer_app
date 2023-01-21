import 'dart:convert';
import 'package:customer_app/config/setting.dart';
import 'package:http/http.dart' as http;
import '../../utils/localstorage.dart';

final base_url = AppSettings.base_url;

class ProductAPI {
  //  function to fetch scan product data
  static scanProductData(payload) async {
    var token = await LocalStorage.getLocalStorage('token');
    final url = Uri.parse(base_url + "/customer/scan");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": 'Bearer ' + token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Error in scanProductData api ::: $e");
      return e;
    }
  }
}
