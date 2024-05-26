import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'homepage.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Email and password cannot be empty');
      return;
    }

    try {
      final _response = await _dio.post(
        '$_apiUrl/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      print(_response.data);
      _storage.write('token', _response.data['data']['token']);
      Navigator.pushReplacementNamed(context, '/homepage');
    } on DioError catch (e) {
      if (e.response != null && e.response?.statusCode == 401) {
        _showErrorDialog('Incorrect email or password');
      } else {
        _showErrorDialog('There is an error. Please try again.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 50, 132, 255)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lets Log in',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 59, 166, 254),
                  fontFamily: 'Pacifico',
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 30.0),
              Image.asset(
                'images/auth.jpg',
                height: 285,
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
