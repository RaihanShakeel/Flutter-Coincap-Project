import 'dart:convert';

import 'package:coin_cap/models/app_config.dart';
import 'package:coin_cap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import "./pages/home_page.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  GetIt.instance.get<HttpService>().get('coins/bitcoin/');
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  String configContent = await rootBundle.loadString('assets/config/main.json');
  Map configData = jsonDecode(configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(COIN_GECKO_BASE_URL_API: configData["COIN_GECKO_BASE_URL_API"],
    ),
  );
}

void registerHTTPService(){
  GetIt.instance.registerSingleton<HttpService>(
    HttpService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CoinCap',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromRGBO(88, 66, 197, 1.0)
        ),
        home: const HomePage(),
      ),
    );
  }
}
