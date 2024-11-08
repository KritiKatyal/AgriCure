import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'package:process_run/shell.dart'; // Import process_run for backend start

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Start the backend when the app launches
  // await _initializeBackend();

  runApp(const AgriCureApp());
}

// Function to initialize backend
// Future<void> _initializeBackend() async {
//   const String backendUrl = 'http://localhost:5000/health'; // Backend health check endpoint

//   try {
//     // Check if the backend is already running
//     final response = await HttpClient().getUrl(Uri.parse(backendUrl));
//     await response.close();
//     print('Backend is already running.');
//   } catch (e) {
//     print('Backend not running. Starting the backend...');

//     // Start the backend using a shell command (e.g., python server)
//     final shell = Shell();
//     try {
//       await shell.run('python C:/Users/kkrit/OneDrive/Desktop/firebaseapp/backend_server/app.py'); // Update with actual path
//       print('Backend started successfully.');
//     } catch (e) {
//       print('Failed to start backend: $e');
//     }
//   }
// }

class AgriCureApp extends StatelessWidget {
  const AgriCureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriCure',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.lightGreen,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return const AuthPage();  // User is not logged in
            }
            return const HomePage();  // User is logged in
          }
          return const Center(child: CircularProgressIndicator());  // Loading state
        },
      ),
    );
  }
}
