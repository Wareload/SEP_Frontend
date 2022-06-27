import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moody/widgets/settings.dart';

import 'route/route_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Chivo',
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Settings.blue),
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      title: "Moody",
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RouteGenerator.splash,
    );
  }
}
