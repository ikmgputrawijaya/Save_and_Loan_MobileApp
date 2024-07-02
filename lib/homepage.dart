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
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  int _selectedIndex = 0;
  final TextEditingController _percentController = TextEditingController();
  String _currentInterest = 'Loading...';
  List<Map<String, dynamic>> _interestHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeInterest();
    _fetchInterestHistory();
  }

  Future<void> _initializeInterest() async {
    String res = await getActiveInterest();
    if (mounted) {
      setState(() {
        _currentInterest = res.isEmpty ? "None" : res;
      });
    }
  }

  Future<String> getActiveInterest() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      final activeBunga = response.data['data']?['activebunga'];
      final persen = activeBunga?['persen'];
      return persen?.toString() ?? "";
    } catch (e) {
      print("Error: $e");
      return "";
    }
  }

  Future<List<Map<String, dynamic>>> getInterestHistory() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      print("Response data: ${response.data}");

      final settingBungas = response.data['data']?['settingbungas'];
      if (settingBungas is List) {
        return List<Map<String, dynamic>>.from(settingBungas);
      }
      return [];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<void> _fetchInterestHistory() async {
    List<Map<String, dynamic>> history = await getInterestHistory();
    if (mounted) {
      setState(() {
        _interestHistory = history;
      });
    }
  }

  Future<void> addActiveInterest(String percent) async {
    try {
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        data: {'persen': percent, 'isaktif': '1'},
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      print("Response Data: ${response.data}");

      Navigator.pushReplacementNamed(context, '/homepage');
    } catch (e) {
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
    await addActiveInterest(_percentController.text);
    await _initializeInterest();
    await _fetchInterestHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 160, 209, 250),
      appBar: AppBar(
        title: const Text(
          'Interest',
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
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
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
                  const SizedBox(height: 15),
                  TextField(
                    controller: _percentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Interest Percentage',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Ubah nilai sesuai keinginan Anda
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
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
                    child: const Text(
                      'Add Interest',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.black,
                    height: 1,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Interest History:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _interestHistory.length,
                    itemBuilder: (context, index) {
                      final item = _interestHistory[index];
                      Color textColor =
                          item['isaktif'] == 1 ? Colors.green : Colors.red;
                      IconData iconData = item['isaktif'] == 1
                          ? Icons.check_circle
                          : Icons.cancel;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        child: Card(
                          elevation: 1,
                          child: ListTile(
                            title: Text(
                              'Interest: ${item['persen']}%',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Status: ${item['isaktif'] == 1 ? 'Active' : 'Inactive'}',
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                            trailing: Icon(
                              iconData,
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    },
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
