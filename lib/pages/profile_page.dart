import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import 'auth_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService _firebaseService = FirebaseService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _user = _firebaseService.getCurrentUser();
    });
  }

  void _logout() async {
    await _firebaseService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  void _editName() async {
    String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String name = _user?.displayName ?? '';
        return AlertDialog(
          title: const Text('Edit Name', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: const InputDecoration(hintText: "Enter your new name"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(name); // Return the new name
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Just close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      await _firebaseService.updateUserName(newName); // Update name in Firebase
      _loadUserData(); // Reload user data to reflect changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background-blur.png'),
                fit: BoxFit.cover, // Make the image cover the whole screen
              ),
            ),
          ),

          // Profile Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image with Placeholder
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Placeholder image
                  ),
                  const SizedBox(height: 20),

                  // User's name
                  Text(
                    _user?.displayName ?? "No Name",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White color to contrast against the background
                    ),
                  ),

                  // User's email
                  const SizedBox(height: 5),
                  Text(
                    _user?.email ?? "No Email",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Change color of email to white
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Buttons (Edit Profile, Settings, Invite a Friend, Help, Logout)
                  Expanded(
                    child: ListView(
                      children: [
                        _buildProfileOptionButton(Icons.person, "Edit Profile", _editName),
                        _buildProfileOptionButton(Icons.settings, "Settings", () {}),
                        _buildProfileOptionButton(Icons.group_add, "Invite a Friend", () {}),
                        _buildProfileOptionButton(Icons.help, "Help", () {}),
                        _buildProfileOptionButton(Icons.logout, "Logout", _logout),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a reusable profile option button with rounded corners
  Widget _buildProfileOptionButton(IconData icon, String label, VoidCallback onTap) {
    return Container(
      height: 70, // Set the height of the button
      width: double.infinity, // Make the button cover the entire width
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Slightly transparent background
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(label, style: const TextStyle(color: Colors.black)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20), // Reduce padding
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/firebase_service.dart';
// import 'auth_page.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final FirebaseService _firebaseService = FirebaseService();
//   User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   void _loadUserData() {
//     setState(() {
//       _user = _firebaseService.getCurrentUser();
//     });
//   }

//   void _logout() async {
//     await _firebaseService.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const AuthPage()),
//     );
//   }

//   void _editName() async {
//     String? newName = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         String name = _user?.displayName ?? '';
//         return AlertDialog(
//           title: const Text('Edit Name'),
//           content: TextField(
//             onChanged: (value) {
//               name = value;
//             },
//             decoration: const InputDecoration(hintText: "Enter your new name"),
//             autofocus: true,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(name); // Return the new name
//               },
//               child: const Text('Save'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Just close the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );

//     if (newName != null && newName.isNotEmpty) {
//       await _firebaseService.updateUserName(newName); // Update name in Firebase
//       _loadUserData(); // Reload user data to reflect changes
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: const Text('Profile'),
//         centerTitle: true,
//       ),
//       body: _user == null
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Profile Image 
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // User's name
//                   Text(
//                     _user!.displayName ?? "No Name",
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   // User's email
//                   const SizedBox(height: 5),
//                   Text(
//                     _user!.email ?? "No Email",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // Edit profile button
//                   ListTile(
//                     leading: const Icon(Icons.person),
//                     title: const Text("Edit profile"),
//                     onTap: _editName,
//                   ),

//                   // Settings button
//                   ListTile(
//                     leading: const Icon(Icons.settings),
//                     title: const Text("Settings"),
//                     onTap: () {
//                       // Navigate to Settings page (dummy)
//                     },
//                   ),

//                   // Invite a friend button
//                   ListTile(
//                     leading: const Icon(Icons.group_add),
//                     title: const Text("Invite a friend"),
//                     onTap: () {
//                       // Navigate to invite friend functionality (dummy)
//                     },
//                   ),

//                   // Help button
//                   ListTile(
//                     leading: const Icon(Icons.help),
//                     title: const Text("Help"),
//                     onTap: () {
//                       // Navigate to Help page (dummy)
//                     },
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
