import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchAllDevices() async {
  String uri = "https://us-central1-fir-api-2ab96.cloudfunctions.net/app/api/devices";
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    return items.toList();
  } else {
    throw Exception("Failed to fetch data");
  }
}

Future<bool> renameDevice(String deviceId, String deviceNewId) async {
  print(deviceId);
  print(deviceNewId);
  String uri = "https://us-central1-fir-api-2ab96.cloudfunctions.net/app/api/rename/${deviceId}/${deviceNewId}";
  var response = await http.put(uri);

  if (response.statusCode == 200) {
    return true;
  }
  return false;
}