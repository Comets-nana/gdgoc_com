import 'package:flutter/material.dart';
import 'package:gdgoc_com/screen/LoginScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GDGoC.com',
        theme: ThemeData(
          fontFamily: 'Pretendard',
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFFFFF)),
          useMaterial3: true,
        ),
        home: const Loginscreen(),
        routes: {
          '/loginscreen': (context) => Loginscreen(),
        },
    );
  }
}
