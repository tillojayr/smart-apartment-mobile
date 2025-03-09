import 'package:flutter/material.dart';
import 'package:tes2_project/components/container1.dart';
import 'package:tes2_project/components/container2.dart';
import 'package:tes2_project/components/costumerService.dart';
import 'package:tes2_project/components/dashboard.dart';
import 'package:tes2_project/globals.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  String roomName = roomData['room_number'] ?? '';

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[500],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130), // Adjust the height as needed
          child: Stack(
            children: [
              AppBar(
                backgroundColor: Colors.orange[500],
                automaticallyImplyLeading: false,
                title: Center(
                  child: Text(
                    'Room ' + roomName,
                    style: const TextStyle(
                      color: Colors.white, // Set title text color to black
                      fontSize: 18, // Adjust font size if needed
                      fontWeight: FontWeight.bold, // Optional: Add bold font weight
                    ),
                  ),
                ),
                bottom: const TabBar(
                  labelColor: Colors.white, // Set tab text color to black
                  unselectedLabelColor: Colors.white, // Set unselected tab text color to a darker shade
                  indicatorColor: Colors.white, // Set the indicator color to black
                  tabs: [
                    Tab(
                      child: Text(
                        "Control Center",
                        style: TextStyle(fontSize: 11),
                      ),
                      icon: Icon(Icons.admin_panel_settings),
                    ),
                    Tab(
                      child: Text(
                        "Energy Dashboard",
                        style: TextStyle(fontSize: 11),
                      ),
                      icon: Icon(Icons.price_change),
                    ),
                    Tab(
                      child: Text(
                        "Profile",
                        style: TextStyle(fontSize: 11),
                      ),
                      icon: Icon(Icons.person),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
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
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 1.3,
              children: const [
                Container1(),
                Container2(),
                // Container3(),
                // Container4(),
              ],

            ),
            ),
            const Dashboard(),
            const CostumerService(), // Corrected the typo in the class name
          ],
        ),
      ),
    );
  }
}
