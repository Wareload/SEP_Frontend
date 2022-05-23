import 'api_backend.dart';

class Api{

  Api._();

  static late ApiBackend api;

  static Future<void> setApi() async {
    api = await ApiBackend.instance();
  }


}