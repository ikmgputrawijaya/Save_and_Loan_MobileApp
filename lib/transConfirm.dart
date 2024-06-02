import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ConfirmTransactionPage extends StatelessWidget {
  const ConfirmTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color.fromARGB(255, 28, 159, 32),
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Transaction Successful',
              style: TextStyle(
                color: Color.fromARGB(255, 28, 159, 32),
                fontFamily: 'Pacifico',
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/detailMember');
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(160, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                foregroundColor: Color.fromARGB(255, 25, 144, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
