import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firstapp/api.dart';

class DetailMemberPage extends StatefulWidget {
  const DetailMemberPage({Key? key}) : super(key: key);

  @override
  State<DetailMemberPage> createState() => _DetailMemberState();
}

class _DetailMemberState extends State<DetailMemberPage> {
  final _storage = GetStorage();

  late String name;
  late String address;
  late String birthDate;
  late String telephone;
  late int statusAktif;

  @override
  void initState() {
    super.initState();
    // Initialize values with stored values
    name = _storage.read('anggota_nama') ?? '';
    address = _storage.read('anggota_alamat') ?? '';
    birthDate = _storage.read('anggota_tgl_lahir') ?? '';
    telephone = _storage.read('anggota_telepon') ?? '';
    statusAktif = _storage.read('anggota_status_aktif') ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 209, 250),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 17.0),
          child: Text(
            'Detail Member',
            style: TextStyle(
              color: Color.fromARGB(255, 59, 166, 254),
              fontFamily: 'Pacifico',
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_card_rounded),
            iconSize: 30,
            onPressed: () {
              Navigator.pushNamed(context, '/addTrans');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              detailDisplay('Name', name),
              detailDisplay('Address', address),
              detailDisplay('Date of Birth', birthDate),
              detailDisplay('Telephone', telephone),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        statusAktif == 1 ? 'Active' : 'Non Active',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saldo (Rp)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '${_storage.read('saldo_${_storage.read('anggotaId')}')}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  "History of Transaction",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 15),
              FutureBuilder(
                future: getRiwayat(_storage.read('anggotaId')),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    int index = _storage.read('banyak_riwayat');

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: index,
                      itemBuilder: (context, index) {
                        Color iconColor;
                        IconData iconData;

                        // Menentukan ikon dan warna ikon berdasarkan jenis transaksi
                        switch (_storage.read('trx_id_${index + 1}')) {
                          case 1:
                            iconData = Icons.account_balance_wallet;
                            iconColor = Colors
                                .black; // Atur warna ikon sesuai kebutuhan
                            break;
                          case 2:
                            iconData = Icons.arrow_circle_up;
                            iconColor = Colors
                                .green; // Atur warna ikon sesuai kebutuhan
                            break;
                          case 3:
                            iconData = Icons.arrow_circle_down;
                            iconColor =
                                Colors.red; // Atur warna ikon sesuai kebutuhan
                            break;
                          default:
                            iconData = Icons.attach_money;
                            iconColor = Colors
                                .yellow; // Atur warna ikon sesuai kebutuhan
                            break;
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: Icon(
                                iconData,
                                color: iconColor,
                              ),
                              title: _storage.read('trx_id_${index + 1}') == 1
                                  ? Text('Saldo Awal')
                                  : _storage.read('trx_id_${index + 1}') == 2
                                      ? Text("Simpanan")
                                      : _storage.read('trx_id_${index + 1}') ==
                                              3
                                          ? Text("Penarikan")
                                          : Text("Bunga Simpanan"),
                              subtitle: Text(
                                  'Rp ${_storage.read('trx_nominal_${index + 1}')}'),
                              trailing: Text(
                                  '${_storage.read('trx_tanggal_${index + 1}')}'),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget detailDisplay(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
