import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tes2_project/globals.dart';

class CostumerService extends StatefulWidget {
  const CostumerService({super.key});

  @override
  State<CostumerService> createState() => _CostumerServiceState();
}

class _CostumerServiceState extends State<CostumerService> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> fetchReminderTime() async {
    try {
      final url = Uri.parse(hostName + "api/v1/room/reminder-time/${roomData['id']}");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${ownerData['token']}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String reminderTime = responseData['reminder_time'] ?? '';

        if (reminderTime.isNotEmpty) {
          final timeParts = reminderTime.split(':');
          if (timeParts.length == 2) {
            final hour = int.tryParse(timeParts[0]);
            final minute = int.tryParse(timeParts[1]);

            if (hour != null && minute != null) {
              setState(() {
                _selectedTime = TimeOfDay(hour: hour, minute: minute);
              });
            }
          }
        }
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _showErrorMessage(responseData['message'] ?? responseData['error']);
        print('Failed to load reminder time: ${response.body}');
      }
    } catch (e) {
      _showErrorMessage('Failed to load reminder time: $e');
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReminderTime();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: Colors.orange,
              dialHandColor: Colors.orange,
              dialBackgroundColor: Colors.grey.shade100,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTime() async {
    try {
      // Format time as HH:mm for API
      final formattedTime = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      
      Map<String, dynamic> postData = {
        "apartmentId": ownerData['id'].toString(),
        "room_id": roomData['id'].toString(),
        "reminder_time": formattedTime,
      };

      final url = Uri.parse(hostName + "api/v1/room/reminder-time");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${ownerData['token']}',
        },
        body: postData,
      );

      if (response.statusCode == 200) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reminder time saved: ${_selectedTime.format(context)}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.orange[300],
            ),
          );
        }
      } else {
        // Handle error
        final Map<String, dynamic> responseData = json.decode(response.body);
        _showErrorMessage(responseData['message'] ?? responseData['error']);
        print('Failed to save time: ${response.body}');
      }
    } catch (e) {
      // Handle exception
      _showErrorMessage('Failed to save time: $e');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.white,
            Colors.blue.shade50,
          ],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      spreadRadius: 8,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 80,
                      color: Colors.orange[500],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Reminder Time',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[500],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _selectedTime.format(context),
                            style: TextStyle(
                              fontSize: 32,  // Reduced from 40
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[500],
                            ),
                          ),
                          const SizedBox(height: 15),  // Reduced from 20
                          ElevatedButton.icon(
                            onPressed: () => _selectTime(context),
                            icon: const Icon(Icons.access_time, size: 20),  // Reduced from 24
                            label: Text(
                              'Change Time',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white
                              ),  // Reduced from 18
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[500],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 20),
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _saveTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[500],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
