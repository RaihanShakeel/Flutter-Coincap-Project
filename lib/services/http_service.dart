import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HttpService{
  final Dio dio = Dio();
  AppConfig? appConfig;
  String? baseUrl;
  String? apiKey;

  HttpService()
  :appConfig = GetIt.instance.get<AppConfig>(){
    baseUrl = appConfig!.COIN_GECKO_BASE_URL_API;
  }

  Future<Response?> get(String path) async{
    try{
      String url = "$baseUrl$path";
      Response response = await dio.get(url);
      return response;
    } catch(e){
      print('HttpService: Unable to get the data');
      print(e);
      return null;
    }
  }
}