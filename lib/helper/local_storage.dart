import 'package:shared_preferences/shared_preferences.dart';

String usernameLabel = 'username';
String passwordLabel = 'password';

Future<void> setData(String label, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString(label, value);
}

Future<String?> getData(
  String label,
) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? action = prefs.getString(label);

  return action;
}
