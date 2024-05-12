import 'package:flutter/material.dart';
import 'package:firstapp/api.dart';
import 'package:get_storage/get_storage.dart';

class editMemberPage extends StatefulWidget {
  const editMemberPage({super.key});

  @override
  State<editMemberPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<editMemberPage> {
  final _storage = GetStorage();

  // final nomerIndukController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final tglLahirController = TextEditingController();
  final teleponController = TextEditingController();
  int status_aktif = 1;

  bool isVisible = false;
  bool isVisibleConfirm = false;

  void dispose() {
    // nomerIndukController.dispose();
    namaController.dispose();
    alamatController.dispose();
    tglLahirController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 160, 209, 250),
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
        body: ListView(children: [
          Column(children: [
            formInput(
              'Name',
              namaController,
              _storage.read('anggota_nama'),
            ),
            formInput(
                'Address', alamatController, _storage.read('anggota_alamat')),
            formInput('Date of Birth', tglLahirController,
                _storage.read('anggota_tgl_lahir')),
            formInput('Telephone', teleponController,
                _storage.read('anggota_telepon')),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: DropdownButton<int>(
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
                        teleponController.text,
                        status_aktif,
                        namaController.text,
                        alamatController.text,
                        tglLahirController.text);
                  },
                  child: Text(
                    "Submit",
                  ),
                ))
          ])
        ]));
  }
}

Widget formInput(String label, TextEditingController controller, data) {
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
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  filled: true,
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
              ))));
}
