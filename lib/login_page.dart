import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:temp_login_with_local_auth/helper/local_storage.dart';
import 'package:temp_login_with_local_auth/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'local login with fingerprint',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            _fingerprintCall(context);
                          },
                          icon: const Icon(Icons.fingerprint))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Switch(
                    value: isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  const Text('Save Data for Use Fingerprint')
                ],
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 0.4)
                        : const Text('Login'),
                    onPressed: () {
                      if (nameController.text != '' &&
                          passwordController.text != '') {
                        if (!loading) {
                          setState(() {
                            loading = true;
                          });

                          saveLoginData();
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (Route<dynamic> route) => false);
                          });
                        }
                      }
                    },
                  )),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    'You can enter any value then next time login you can use fingerprint auth to login with the same values as entered',
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
            ],
          )),
    );
  }

  Future<void> _fingerprintCall(BuildContext context) async {
    String? savedUserName = await getData(usernameLabel);
    String? savedPassword = await getData(passwordLabel);

    if (savedPassword == null || savedUserName == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Not Set Data Yet!"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 500),
      ));
    } else {
      bool authenticated = false;
      try {
        authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } on PlatformException catch (e) {
        print(e);
        return;
      }
      if (!mounted) {
        return;
      }

      if (authenticated) {
        print(savedUserName);
        print(savedPassword);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);
      }
    }
  }

  Future<void> saveLoginData() async {
    await setData(usernameLabel, nameController.text);
    await setData(passwordLabel, passwordController.text);
  }
}
