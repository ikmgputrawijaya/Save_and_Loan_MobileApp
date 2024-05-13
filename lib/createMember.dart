import 'package:flutter/material.dart';
import 'api.dart';
import 'package:get_storage/get_storage.dart';

class createMemberPage extends StatefulWidget {
  const createMemberPage({Key? key});

  @override
  State<createMemberPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<createMemberPage> {
  final _storage = GetStorage();
  final noRegController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final birthController = TextEditingController();
  final tlpController = TextEditingController();
  int status_aktif = 1;

  @override
  void dispose() {
    noRegController.dispose();
    nameController.dispose();
    addressController.dispose();
    birthController.dispose();
    tlpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
          formInput('Registration Number', noRegController),
          formInput('Name', nameController),
          formInput('Address', addressController),
          formInput('Date of Birth', birthController),
          formInput('Telephone', tlpController),
          SizedBox(height: 1),
          DropdownButtonFormField<int>(
            value: status_aktif,
            decoration: InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
                setState(() {
                  status_aktif = value;
                });
              }
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              createMember(
                context,
                int.parse(noRegController.text),
                tlpController.text,
                status_aktif,
                nameController.text,
                addressController.text,
                birthController.text,
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
