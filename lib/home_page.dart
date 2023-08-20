import 'package:flutter/material.dart';
import 'package:temp_login_with_local_auth/login_page.dart';

import 'helper/local_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  Future<void> getUsername() async {
    String? savedUserName = await getData(usernameLabel);
    setState(() {
      username = savedUserName!;
    });
  }

  @override
  void initState() {
    getUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('WELCOME'),
          ),
          const SizedBox(height: 20,),
          Center(
            child: Text('username: $username'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false);
        },
        child: const Icon(Icons.logout,color: Colors.white,),
      ),
    );
  }
}
