import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinService {
  static Future<bool> join(HMSSDK hmssdk) async {
    String roomId = "63938863ea4ced3e87594a9a";
    Uri endPoint = Uri.parse(
        "https://prod-in2.100ms.live/hmsapi/gtribe.app.100ms.live/api/token");
    http.Response response = await http.post(endPoint,
        body: {'user_id': "divy22", 'room_id': roomId, 'role': "viewer"});
    var body = json.decode(response.body);
    if (body == null || body['token'] == null) {
      return false;
    }
    HMSConfig config = HMSConfig(authToken: body['token'], userName: "divy22");
    await hmssdk.join(config: config);
    return true;
  }
}
