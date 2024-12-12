import 'package:elibrary/common/constants/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AppConfigService {
  static Future<bool> checkServerConnection() async {
    try {
      final response = await http.get(Uri.parse(Constants.baseApiServer));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> showServerErrorDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Error'),
          content: const Text('Unable to connect to the server. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(Duration.zero, () {
                  SystemNavigator.pop();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
