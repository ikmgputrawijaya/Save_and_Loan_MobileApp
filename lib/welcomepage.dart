import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'registerpage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to Plesir',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 133, 255),
                  fontFamily: 'Pacifico',
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 5.0),
              Image.asset('images/logo.png'),
              Text(
                'Lets start your holiday journey!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 59, 166, 254)),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 96, 215, 100)),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
