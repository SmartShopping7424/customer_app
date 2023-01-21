import 'dart:convert';
import 'package:customer_app/config/setting.dart';
import 'package:http/http.dart' as http;
import '../../utils/localstorage.dart';

final base_url = AppSettings.base_url;

class CustomerAPI {
//  function to get customer data
  static getData(String mobile) async {
    var token = await LocalStorage.getLocalStorage('token');
    Map<String, String> qParams = {
      'mobile': mobile,
    };
    final url =
        Uri.parse(base_url + "/customer").replace(queryParameters: qParams);

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": 'Bearer ' + token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Error in getData api ::: $e");
      return e;
    }
  }

  //  function to update user data
  static updateData(payload) async {
    var token = await LocalStorage.getLocalStorage('token');
    final url = Uri.parse(base_url + "/customer");

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
      print("Error in updateData api ::: $e");
      return e;
    }
  }

  //  function to get shop with location
  static fetchShop(payload) async {
    var token = await LocalStorage.getLocalStorage('token');
    final url = Uri.parse(base_url + "/customer/location");

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
      print("Error in fetchShop api ::: $e");
      return e;
    }
  }

  //  function to get cart data
  static fetchCart(mobile, shopId) async {
    var token = await LocalStorage.getLocalStorage('token');
    Map<String, String> qParams = {'mobile': mobile, 'shop_id': shopId};
    final url = Uri.parse(base_url + "/customer/cart")
        .replace(queryParameters: qParams);

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": 'Bearer ' + token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Error in fetchCart api ::: $e");
      return e;
    }
  }

  //  function to update cart data
  static updateCart(payload) async {
    var token = await LocalStorage.getLocalStorage('token');
    final url = Uri.parse(base_url + "/customer/cart");

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
      print("Error in updateCart api ::: $e");
      return e;
    }
  }
}
