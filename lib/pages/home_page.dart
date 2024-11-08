import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '/services/firebase_service.dart';
import '../services/scan_data_service.dart';
import 'camera_page.dart';
import 'profile_page.dart';
import 'results_page.dart';
import '../components/my_tabbar.dart';
import '../util/glass_box.dart';
import '../components/my_appbar.dart';
import '../components/my_bottombar.dart';
import '../theme/const.dart';
import '../tabs/Bittergourd.dart';
import '../tabs/tomato.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBottomIndex = 0;

  void _handleIndexChanged(int? index) {
  setState(() {
    _currentBottomIndex = index!;
  });

  // Navigation based on the selected index in the bottom navigation bar
  if (index == 1) {
    _showPlantSelectionDialog();
  } else if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsPage()),
    );
  } else if (index == 3) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }
}


  // Show a dialog to select plant type
  void _showPlantSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Plant Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Bittergourd'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCamera('bittergourd');
                },
              ),
              ListTile(
                title: const Text('Tomato'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCamera('tomato');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Navigate to CameraPage based on plant type
  void _navigateToCamera(String plantType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(plantType: plantType),
      ),
    );
  }

  // Carousel for health tips
  Widget _buildTipsCarousel() {
    final List<String> tips = [
      "Water your plants early in the morning to minimize evaporation.",
      "Regularly check for pests and diseases.",
      "Prune damaged leaves to prevent disease spread.",
      "Use organic fertilizers for healthier plants.",
    ];

    final List<String> images = [
      'assets/images/tip1.png',
      'assets/images/tip2.png',
      'assets/images/tip3.png',
      'assets/images/tip4.png',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 130.0,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        itemCount: tips.length,
        itemBuilder: (context, index, realIdx) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(images[index]),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tips[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Floating action button for quick camera access
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(Icons.camera_alt),
      onPressed: _showPlantSelectionDialog,
    );
  }

  // Background gradient
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 165, 210, 117), Colors.white],
          //Color.fromARGB(255, 165, 210, 117)
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  // Display recent scans from Firestore
//   Widget _buildRecentScans() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Text(
//           "Recent Scans",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//       StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('scans')
//             .orderBy('timestamp', descending: true)
//             .limit(3) // Get the 3 latest scans
//             .snapshots(),
//         builder: (context, snapshot) {
//           // Handle loading state
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // Handle error in query
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           // Handle empty data (firestore might be empty)
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No recent scans available"));
//           }

//           // Check the content of the snapshot
//           var scans = snapshot.data!.docs;
//           print("Snapshot contains ${scans.length} scans.");

//           // Return the ListView with data
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: scans.length,
//             itemBuilder: (context, index) {
//               var scanData = scans[index].data() as Map<String, dynamic>;

//               return ListTile(
//                 leading: const Icon(Icons.image, color: Colors.green),
//                 title: Text("Scan ${index + 1} - ${scanData['plantType'] ?? 'Unknown Plant'}"),
//                 subtitle: Row(
//                   children: [
//                     Text("Result: ${scanData['result'] ?? 'Unknown'}"),
//                     const SizedBox(width: 10),
//                     CircularProgressIndicator(
//                       value: (scanData['confidence'] ?? 0.0).toDouble(),
//                       color: Colors.green,
//                       strokeWidth: 2,
//                     ),
//                   ],
//                 ),
//                 onTap: () {
//                   // Update scan data in ScanDataService
//                   ScanDataService().updateScanData(scanData);

//                   // Navigate to ResultsPage
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const ResultsPage()),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     ],
//   );
// }
  // Recent scans with progress indicator
  Widget _buildRecentScans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Recent Scans", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3, // Display last 3 scans
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.image, color: Colors.green),
              title: Text("Scan ${index + 1} - Tomato Leaf"),
              subtitle: Row(
                children: [
                  Text("Result: N_K"),
                  SizedBox(width: 10),
                  CircularProgressIndicator(
                    value: 0.75, // Customizable based on data
                    color: Colors.green,
                    strokeWidth: 2,
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultsPage()),
                );
              },
            );
          },
        ),
      ],
    );
  }



  // Welcome banner
  Widget _buildWelcomeBanner() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Rounded corners for a sleek look
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 165, 210, 117), Colors.green.shade700], // Background gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow for a floating effect
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/app_logo_png.png', // Path to your image in assets
                width: 30, // Adjust the size as needed
                height: 30,
              ),
              SizedBox(width: 8),
              Text(
                "Welcome to AgriCure!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text to contrast with background
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Scan your plants to detect any signs of disease early and keep them healthy.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70, // Lighter color for the description
              height: 1.5, // Line height for better readability
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.local_florist, // Add an additional icon for more personality
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                "Healthy plants, Healthy future!",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          _buildBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            bottomNavigationBar: GlassBox(
              child: MyBottomBar(
                index: _currentBottomIndex,
                onTap: _handleIndexChanged,
              ),
            ),
            floatingActionButton: _buildFloatingActionButton(),
            body: ListView(
              children: [
                
                MyAppBar(
                  title: 'Explore Plants',
                  onSearchTap: () {},
                ),
                _buildTipsCarousel(),
                SizedBox(
                  height: 600,
                  child: MyTabBar(
                    tabOptions: [
                      ["Bittergourd", const Bittergourd()],
                      ["Tomato", const Tomato()],
                    ],
                    onTapBittergourd: () => _navigateToCamera('bittergourd'),
                    onTapTomato: () => _navigateToCamera('tomato'),
                  ),
                ),
                _buildRecentScans(),
                _buildWelcomeBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
