import 'package:flutter/material.dart';
import 'package:firstapp/api.dart';
import 'package:get_storage/get_storage.dart';

class editMemberPage extends StatefulWidget {
  const editMemberPage({Key? key});

  @override
  State<editMemberPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<editMemberPage> {
  final _storage = GetStorage();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final birthController = TextEditingController();
  final tlpController = TextEditingController();
  int status_aktif = 1;

  @override
  void dispose() {
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
          'Edit Member',
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
        children: [
          Column(
            children: [
              formInput('Name', nameController, _storage.read('anggota_nama')),
              formInput('Address', addressController,
                  _storage.read('anggota_alamat')),
              formInput('Date of Birth', birthController,
                  _storage.read('anggota_tgl_lahir')),
              formInput(
                  'Telephone', tlpController, _storage.read('anggota_telepon')),
              Padding(
                padding: EdgeInsets.all(20),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
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
                      setState(() {
                        status_aktif = value;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    editMember(
                      context,
                      _storage.read('anggotaId'),
                      _storage.read('anggota_nomor_induk'),
                      tlpController.text,
                      status_aktif,
                      nameController.text,
                      addressController.text,
                      birthController.text,
                    );
                  },
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget formInput(String label, TextEditingController controller, String data) {
  controller.text = data;
  return Padding(
    padding: EdgeInsets.only(top: 20),
    child: Center(
      child: SizedBox(
        width: 330,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
            filled: true,
            fillColor: Color.fromARGB(255, 255, 255, 255),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blueGrey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          onChanged: (value) {
            print(controller.text);
          },
        ),
      ),
    ),
  );
}
