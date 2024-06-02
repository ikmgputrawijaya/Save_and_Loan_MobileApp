import 'package:flutter/material.dart';
import 'package:firstapp/api.dart';
import 'package:get_storage/get_storage.dart';

class addTransPage extends StatefulWidget {
  const addTransPage({super.key});

  @override
  State<addTransPage> createState() => _addTransPageState();
}

class _addTransPageState extends State<addTransPage> {
  final nominalTrxController = TextEditingController();
  final jenisTrxController = TextEditingController();

  final _storage = GetStorage();

  int jenis_trx = 1;

  @override
  void dispose() {
    nominalTrxController.dispose();
    jenisTrxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 209, 250),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: const Center(
          child: Text(
            "Add Transaction",
            style: TextStyle(
              color: Color.fromARGB(255, 59, 166, 254),
              fontFamily: 'Pacifico',
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<int>(
                      value: jenis_trx,
                      items: const [
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text("Saldo Awal"),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text("Simpanan"),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text("Penarikan"),
                        ),
                        DropdownMenuItem<int>(
                          value: 4,
                          child: Text("Bunga Simpanan"),
                        ),
                      ],
                      onChanged: (int? value) {
                        if (value != null) {
                          setState(() {
                            jenis_trx = value;
                          });
                        }
                      },
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      dropdownColor: Color.fromARGB(255, 255, 255, 255),
                      underline: Container(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
              formInput('Amount', nominalTrxController),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    addTabungan(
                      _storage.read('anggotaId').toString(),
                      jenis_trx.toString(),
                      nominalTrxController.text.toString(),
                      context,
                    );
                  },
                  child: const Text(
                    "            Confirm Transaction            ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(160, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget formInput(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Center(
      child: SizedBox(
        width: 276,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
            fillColor: Color.fromARGB(255, 255, 255, 255),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ),
    ),
  );
}
