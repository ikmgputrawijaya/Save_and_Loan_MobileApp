import 'package:flutter/material.dart';
import 'api.dart';
import 'package:get_storage/get_storage.dart';

class createMemberPage extends StatefulWidget {
  const createMemberPage({super.key});

  @override
  State<createMemberPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<createMemberPage> {
  final _storage = GetStorage();
  final nomerIndukController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final ttlController = TextEditingController();
  final teleponController = TextEditingController();
  int status_aktif = 1;

  bool isVisible = false;
  bool isVisibleConfirm = false;

  void dispose() {
    nomerIndukController.dispose();
    namaController.dispose();
    alamatController.dispose();
    ttlController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 209, 250),
      appBar: AppBar(
        title: Text(
          'Add Member',
          style: TextStyle(
            color: Color.fromARGB(255, 59, 166, 254),
            fontFamily: 'Pacifico',
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          SizedBox(
            height: 20,
          ),
          formInput('Registration Number', nomerIndukController),
          formInput('Name', namaController),
          formInput('Address', alamatController),
          formInput('Date of Birth', ttlController),
          formInput('Telephone', teleponController),
          SizedBox(height: 20),
          DropdownButton<int>(
            value: status_aktif,
            items: [
              DropdownMenuItem<int>(
                child: Text("Active"),
                value: 1,
              ),
              DropdownMenuItem<int>(
                child: Text("Non Active"),
                value: 0,
              ),
            ],
            onChanged: (int? value) {
              if (value != null) {
                status_aktif = value;
              }
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              createMember(
                context,
                int.parse(nomerIndukController.text),
                teleponController.text,
                status_aktif,
                namaController.text,
                alamatController.text,
                ttlController.text,
              );
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}

Widget formInput(String label, TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.only(bottom: 20),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Color.fromARGB(255, 255, 255, 255),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
