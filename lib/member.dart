import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firstapp/api.dart';
import 'package:firstapp/createMember.dart';

final _storage = GetStorage();

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 209, 250),
      appBar: AppBar(
        title: Text(
          'Member List',
          style: TextStyle(
            color: Color.fromARGB(255, 59, 166, 254),
            fontFamily: 'Pacifico',
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 34,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/createMember');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getAnggota(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            int index = _storage.read('banyak_anggota');
            return Container(
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: index,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                        leading: Icon(
                          Icons.person,
                          size: 40,
                        ),
                        title: Text('${_storage.read('nama_${index + 1}')}'),
                        subtitle:
                            Text('${_storage.read('telepon_${index + 1}')}'),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'Edit',
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'Delete',
                            ),
                            PopupMenuItem(
                              child: Text('Detail'),
                              value: 'Detail',
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'Edit') {
                              getEditAnggotaDetail(
                                  context, _storage.read('id_${index + 1}'));
                            } else if (value == 'Delete') {
                              deleteAnggota(
                                  context, _storage.read('id_${index + 1}'));
                            } else if (value == 'Detail') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('close'),
                                      ),
                                    ],
                                    title: Text('Detail Anggota'),
                                    contentPadding: EdgeInsets.all(20.0),
                                    content: Column(
                                      children: [
                                        Text(
                                            'Nama: ${_storage.read('nama_${index + 1}')}'),
                                        Text(
                                            'Nomor Induk: ${_storage.read('nomor_induk_${index + 1}')}'),
                                        Text(
                                            'Telepon: ${_storage.read('telepon_${index + 1}')}'),
                                        Text(
                                            'Status Aktif: ${_storage.read('status_aktif_${index + 1}')}'),
                                        Text(
                                            'Alamat: ${_storage.read('alamat_${index + 1}')}'),
                                        Text(
                                            'Tanggal Lahir: ${_storage.read('tgl_lahir_${index + 1}')}'),
                                      ],
                                    )),
                              );
                            }
                          },
                        )),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
