import "dart:convert";

import "package:http/http.dart" as http;
import "package:logger/logger.dart";

var logger = Logger();

class NetworkHandler {
  String username =
      'CF738D39-C92C-49D7-A751-CDBEA75BDCD8\\68639e84-9f4d-44ac-91d3-d10fcd33b920';
  String password = 'a636f5d5-bc9b-497a-b56e-e984966355f2';
  String gateway = '42ab43209764aaa9289c3fad191657b8';
  String basicAuth = 'Basic ' +
      base64.encode(utf8.encode(
          'CF738D39-C92C-49D7-A751-CDBEA75BDCD8\\68639e84-9f4d-44ac-91d3-d10fcd33b920:a636f5d5-bc9b-497a-b56e-e984966355f2'));

  bool isUpdateAvailable = false;

  Future getVehicleInfo(String url) async {
    print('\n VehicleInfo');
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'authorization': basicAuth},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // logger.i(response.body);
      return json.decode(response.body);
    }
    ;
    // logger.i(response.body);
    logger.i(response.statusCode);
  }

  Future getUpdateInfo(String url) async {
    print('\n STARTINGG get updateinfo');
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'authorization': basicAuth,
        // 'Content-type': 'application/json;charset=UTF-8',
        // 'Accept': 'application/hal+json',
        // 'Authorization': 'GatewayToken 42ab43209764aaa9289c3fad191657b8'
      },
    );
    logger.i(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var anhtai = json.decode(response.body);

      // print(anhtai);
    }
    return json.decode(response.body);
  }

  Future getCurr(String url) async {
    print('\n STARTINGG get updateinfo');
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'authorization': basicAuth,
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/hal+json',
        'Authorization': 'GatewayToken 42ab43209764aaa9289c3fad191657b8'
      },
    );
    logger.i(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var anhtai = json.decode(response.body);
      // print(anhtai);
    }
    return json.decode(response.body);
  }

  Future get(String url) async {
    print('\n STARTINGG Get Version');
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/hal+json',
        'Authorization': 'GatewayToken 42ab43209764aaa9289c3fad191657b8'
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> anhtai = json.decode(response.body);

      return anhtai;
    }
    logger.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    print('\n STARTINGG get normal');
    var response = await http.post(Uri.parse(url),
        // headers: {
        //   'authorization': basicAuth,
        //   'Content-type': 'application/json;charset=UTF-8',
        //   'Accept': 'application/hal+json'
        // },

        headers: <String, String>{
          // 'authorization': basicAuth,
          'Content-type': 'application/json;charset=UTF-8',
          'Accept': 'application/hal+json',
          'Authorization': 'GatewayToken 42ab43209764aaa9289c3fad191657b8'
        },
        body: json.encode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    return response;
  }
}
