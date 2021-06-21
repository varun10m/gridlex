import 'dart:convert';

import 'package:gridlex_assessment/Home/Model/HealthCareInformation.dart';
import 'package:http/http.dart' as http;

class HttpSource {
  static HttpSource? _instance;

  static HttpSource? getInstance() {
    if (_instance == null) _instance = new HttpSource();
    return _instance;
  }

  Future<Map<String, dynamic>> sendDataToServer(
      HealthCareInformation medicalFormModel) async {
    try {
      Uri uri = Uri.parse(
          "https://us-central1-assesstment-2b188.cloudfunctions.net/formDetaisl-sendSingleFormToServer");
      var headers = getHeaders();

      final response = await makeUrlCall(uri, headers, medicalFormModel);
      print('response for sendDataToServer ' + response.body);
      if (response.statusCode == 200) {
        return getEncodedMap(jsonDecode(response.body));
      } else {
        print('error occurred');
        return getErrorResponse();
      }
    } catch (e) {
      print("error for sendDataToServer = $e");

      return getErrorResponse();
    }
  }

  Future<Map<String, dynamic>> sendTotalDataToServer(
      List<dynamic> listToSendToServer) async {
    try {
      Uri uri = Uri.parse(
          "https://us-central1-assesstment-2b188.cloudfunctions.net/formDetaisl-sendMultipleDataToServer");
      var headers = getHeaders();

      final response = await http.post(uri,
          headers: headers, body: jsonEncode(listToSendToServer));
      print('response for sendTotalDataToServer ' + response.body);
      if (response.statusCode == 200) {
        return getEncodedMap(jsonDecode(response.body));
      } else {
        print('error occurred');
        return getErrorResponse();
      }
    } catch (e) {
      print("error for sendDataToServer = $e");
      return getErrorResponse();
    }
  }

  Map<String, dynamic> getEncodedMap(Map<dynamic, dynamic> temp) {
    Map<String, dynamic> data = new Map();
    temp.forEach((key, value) {
      data[key.toString()] = value;
    });
    return jsonDecode(jsonEncode(data));
  }

  Future<http.Response> makeUrlCall(Uri uri, Map<String, String> headers,
      HealthCareInformation medicalFormModel) {
    return http.post(uri,
        headers: headers, body: jsonEncode(medicalFormModel.toJson()));
  }

  Map<String, String> getHeaders() => {'Content-Type': 'application/json'};

  Map<String, dynamic> getErrorResponse() {
    return {
      "isSuccess": false,
      "message": "Error occurred Please try again later"
    };
  }
}
