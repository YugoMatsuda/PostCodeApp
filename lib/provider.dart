import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:post_code_api_app/data/postal_code.dart';

StateProvider<String> postalCodeProvider = StateProvider((ref) => '');
FutureProvider<PostalCode> apiProvider = FutureProvider((ref) async {
  final postalCode = ref.watch(postalCodeProvider.state).state;

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
});

FutureProviderFamily<PostalCode, String> apiFamilyProvider = FutureProvider.family<PostalCode, String> ((ref, postalCode) async {
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
});