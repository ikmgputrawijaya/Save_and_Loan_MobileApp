import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:firstapp/profile.dart';
import 'package:firstapp/member.dart';
import 'package:firstapp/api.dart';

final _storage = GetStorage();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  int _selectedIndex = 0;
  final TextEditingController _percentController = TextEditingController();
  String _currentInterest = 'Loading...';

  @override
  void initState() {
    super.initState();
    _initializeInterest();
  }

  Future<void> _initializeInterest() async {
    String res = await getActiveInterest(context);
    if (mounted) {
      setState(() {
        _currentInterest = res.isEmpty ? "None" : res;
      });
    }
  }

  Future<String> getActiveInterest(BuildContext context) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      // Debugging: Tampilkan respons API
      print("Response data: ${response.data}");

      // Pastikan data ada dan akses dengan aman menggunakan null-aware operator
      final activeBunga = response.data['data']?['activebunga'];
      final persen = activeBunga?['persen'];
      return persen?.toString() ?? "";
    } catch (e) {
      // Debugging: Tampilkan kesalahan
      print("Error: $e");
      return "";
    }
  }

  Future<void> addActiveInterest(BuildContext context, String percent) async {
    try {
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        data: {'persen': percent, 'isaktif': '1'},
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      // Debugging: Tampilkan respons API
      print("Response Data: ${response.data}");

      // Asumsi sukses selalu berhasil, karena tidak ada validasi
      Navigator.pushReplacementNamed(context, '/homepage');
    } catch (e) {
      // Debugging: Tampilkan kesalahan
      print("Error: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MemberPage()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    });
  }

  Future<void> _updateInterest() async {
    await addActiveInterest(context, _percentController.text);
    await _initializeInterest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 160, 209, 250),
      appBar: AppBar(
        title: const Text(
          'Hello',
          style: TextStyle(
            color: Color.fromARGB(255, 59, 166, 254),
            fontFamily: 'Pacifico',
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 39,
              color: Color.fromARGB(255, 138, 138, 138),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Active Interest:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$_currentInterest%',
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _percentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interest Percentage',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 222, 242, 255),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateInterest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'Add Interest',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.percent_rounded, size: 40, color: Colors.blue),
            label: 'Interest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 40),
            label: 'Member List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, size: 45),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 138, 138, 138),
        unselectedItemColor: const Color.fromARGB(255, 138, 138, 138),
        onTap: _onItemTapped,
      ),
    );
  }
}
