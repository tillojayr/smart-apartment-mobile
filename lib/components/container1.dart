import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';

void main() => runApp(const Container1());

class Container1 extends StatelessWidget {
  const Container1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[500],
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Colors.orange[500]!,
        //     Colors.orange[500]!,
        //   ],
        // ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lightbulb_outlined,
                size: 50,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'Lights',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SwitchExample(),
          ],
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = false;

  List<dynamic> data = [];

  Future<void> fetchData() async {
    final url = Uri.parse(hostName + "api/v1/room/state?room_id=${roomData['id']}");

    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${ownerData['token']}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successful request
        // Decode the JSON string into a Map
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          if (responseData['relay_1'] == 1){
            light = true;
          }
          else{
            light = false;
          }
        });
      } else {
        // Handle error
        final Map<String, dynamic> responseData = json.decode(response.body);
        _showErrorMessage(responseData['message'] ?? responseData['error']);
        print('Failed to load data: ${response.body}');
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
    }
  }

  void _showErrorMessage(String message) {
    // Replace this with your desired error display mechanism (e.g., Snackbar, Dialog, etc.)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _makePostRequest(String state) async {
    Map<String, dynamic> postData = {
      "apartmentId": ownerData['id'].toString(),
      "room_id": roomData['id'].toString(),
      "relay": "a",
      "state": state
    };

    final url = Uri.parse(hostName + "api/v1/room/switch");

    final response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ${ownerData['token']}',
    }, body: postData);

    if (response.statusCode == 200) {

    } else {
      // Handle error
      final Map<String, dynamic> responseData = json.decode(response.body);
      _showErrorMessage(responseData['message'] ?? responseData['error']);
      print('Failed to load data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: light ? Colors.orange.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Transform.scale(
        scale: 1.5,
        child: Switch(
          value: light,
          activeColor: Colors.orange,
          activeTrackColor: Colors.white.withOpacity(0.5),
          inactiveThumbColor: Colors.grey[400],
          inactiveTrackColor: Colors.grey[300],
          onChanged: (bool value) {
            setState(() {
              light = value;
            });
            if (light == true) {
              _makePostRequest('1');
            } else {
              _makePostRequest('0');
            }
          },
        ),
      ),
    );
  }
}
