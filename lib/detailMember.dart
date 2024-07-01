import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firstapp/api.dart';
import 'package:intl/intl.dart';

class DetailMemberPage extends StatefulWidget {
  const DetailMemberPage({Key? key}) : super(key: key);

  @override
  State<DetailMemberPage> createState() => _DetailMemberState();
}

class _DetailMemberState extends State<DetailMemberPage> {
  final _storage = GetStorage();
  late Future<Map<String, dynamic>> memberFuture;

  @override
  void initState() {
    super.initState();
    getSaldo(_storage.read('anggotaId'));
    memberFuture = getMemberDetails();
  }

  Future<Map<String, dynamic>> getMemberDetails() async {
    var saldo = _storage.read('saldo_${_storage.read('anggotaId')}');

    if (saldo == null) {
      await getSaldo(_storage.read('anggotaId'));
      saldo = _storage.read('saldo_${_storage.read('anggotaId')}');
    }

    return {
      'name': _storage.read('anggota_nama') ?? '',
      'address': _storage.read('anggota_alamat') ?? '',
      'birthDate': _storage.read('anggota_tgl_lahir') ?? '',
      'telephone': _storage.read('anggota_telepon') ?? '',
      'statusAktif': _storage.read('anggota_status_aktif') ?? 1,
      'saldo': saldo ?? 0,
    };
  }

  String formatCurrency(int amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 209, 250),
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          iconSize: 30,
          onPressed: () {
            Navigator.pushNamed(context, '/member');
          },
        ),
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
            icon: const Icon(Icons.add_card_rounded,
                color: Color.fromARGB(255, 0, 0, 0)),
            iconSize: 30,
            onPressed: () {
              Navigator.pushNamed(context, '/addTrans');
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: memberFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final memberData = snapshot.data!;
            return ListView(
              children: [
                Column(
                  children: [
                    detailDisplay('Name', memberData['name']),
                    detailDisplay('Address', memberData['address']),
                    detailDisplay('Date of Birth', memberData['birthDate']),
                    detailDisplay('Telephone', memberData['telephone']),
                    detailDisplay(
                        'Status',
                        memberData['statusAktif'] == 1
                            ? 'Active'
                            : 'Non Active'),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                              formatCurrency(memberData['saldo']),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
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
                                  iconColor = Colors.black;
                                  break;
                                case 2:
                                  iconData = Icons.arrow_circle_up;
                                  iconColor = Colors.green;
                                  break;
                                case 3:
                                  iconData = Icons.arrow_circle_down;
                                  iconColor = Colors.red;
                                  break;
                                case 5:
                                  iconData = Icons.arrow_circle_up;
                                  iconColor = Colors.green;
                                  break;
                                case 6:
                                  iconData = Icons.arrow_circle_down;
                                  iconColor = Colors.red;
                                  break;
                                default:
                                  iconData = Icons.attach_money;
                                  iconColor = Colors.yellow;
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
                                    title: () {
                                      int trxId =
                                          _storage.read('trx_id_${index + 1}');
                                      switch (trxId) {
                                        case 1:
                                          return Text('Saldo Awal');
                                        case 2:
                                          return Text("Simpanan");
                                        case 3:
                                          return Text("Penarikan");
                                        case 5:
                                          return Text("Koreksi Penambahan");
                                        case 6:
                                          return Text("Koreksi Pengurangan");
                                        default:
                                          return Text(
                                              "Transaksi Tidak Dikenal");
                                      }
                                    }(),
                                    subtitle: Text(
                                      'Rp ${_storage.read('trx_nominal_${index + 1}')}',
                                    ),
                                    trailing: Text(
                                      '${_storage.read('trx_tanggal_${index + 1}')}',
                                    ),
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
            );
          }
        },
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
