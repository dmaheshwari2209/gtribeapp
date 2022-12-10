import 'package:dio/dio.dart';

const serverLink2 = 'http://3.110.144.68:3000/api';
const serverLink1 = 'https://e1bd-14-97-1-234.ngrok.io/api';

class GameApi {
  static final _instance = GameApi._();

  GameApi._();
  factory GameApi() {
    return _instance;
  }

  Future<dynamic> startGame() async {
    print('HELLO BRO');
    const body = {
      'username': 'rishabh',
      'gamename': 'tower-game',
      'scoreData': {
        "lostLives": 0,
      },
    };
    try {
      final response =
          await Dio().post('$serverLink1/userGame/start', data: body);
      print('HEHE $response');
      // Uri url =
      //     Uri.https('https://e1bd-14-97-1-234.ngrok.io/api/userGame/start', '');
      // final response = await http.post(url, body: body);
      return response;
    } catch (err) {}
  }

  Future<dynamic> viewGame(String viewername, String playername) async {
    print('VIEW API');

    var body = {
      'playername': playername,
      'gamename': 'tower-game',
      'viewername': viewername,
      // "questionId": ''
    };
    try {
      final response =
          await Dio().post('$serverLink1/userGame/view', data: body);
      print('VIEW $response');
      return response;
    } catch (err) {}
  }

  Future<dynamic> getStreams() async {
    try {
      print('!!!!!!!!!!!');
      final response = await Dio().get('$serverLink1/userGame/getStreams');
      print('VIEW $response');
      return response;
    } catch (err) {}
  }
}
