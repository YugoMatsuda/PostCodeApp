import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:post_code_api_app/data/postal_code.dart';

class Logic {
  Future<PostalCode> getPostalCode(String postalCode) async {
    if (postalCode.length != 7) {
      throw Exception('postalCode must be 7 characters');
    }

    final upper = postalCode.substring(0, 3);
    final lower = postalCode.substring(3);

    final apiUrl = 'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';

    final apiUri = Uri.parse(apiUrl);
    http.Response resp = await http.get(apiUri);

    if(resp.statusCode != 200) {
      throw Exception('not found');
    }

    var jsonData = json.decode(resp.body);

    return PostalCode.fromJson(jsonData);
  }



  bool willProceed(String postalcode) {
    return postalcode.length == 7;
  }
}
