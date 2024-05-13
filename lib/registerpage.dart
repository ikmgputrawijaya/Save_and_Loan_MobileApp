import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firstapp/homepage.dart';
import 'package:get_storage/get_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final baseUrl = 'https://mobileapis.manpits.xyz/api';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  void register() async {
    try {
      final _response = await _dio.post(
        '${_apiUrl}/register',
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'confirmpassword': confirmPasswordController.text,
        },
      );
      print(_response.data);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 56, 183, 141)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lets Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF18C591),
                  fontFamily: 'Pacifico',
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 30.0),
              Image.asset(
                'images/regis.png',
                height: 220,
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
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
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  register();
                  Navigator.pushReplacementNamed(context, '/loginpage');
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
