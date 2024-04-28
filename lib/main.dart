import 'package:flutter/material.dart';
import 'package:firstapp/homepage.dart';
import 'package:firstapp/loginpage.dart';
import 'package:firstapp/registerpage.dart';
import 'package:firstapp/welcomepage.dart';
import 'package:firstapp/profile.dart';
import 'package:firstapp/member.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/welcomepage': (context) => WelcomePage(),
        '/loginpage': (context) => LoginPage(),
        '/registerpage': (context) => RegisterPage(),
        '/homepage': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/member': (context) => MemberPage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}
