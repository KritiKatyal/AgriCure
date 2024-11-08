import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io'; // For handling files
import 'package:path/path.dart'; // For managing file paths

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Sign up a user
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      throw e;
    }
  }

  // Sign in a user
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      throw e;
    }
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Update user name
  Future<void> updateUserName(String name) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateProfile(displayName: name);
      await user.reload(); // Reload user to get updated info
    }
  }

  // Upload an image to Firebase Storage and get the download URL
  Future<String?> uploadFile(File file) async {
    try {
      // Ensure the file exists
      if (!file.existsSync()) {
        print('Error: File does not exist at path: ${file.path}');
        return null; // Return null if the file doesn't exist
      }
      print('File exists at path: ${file.path}'); // Log file existence

      // Generate a unique file name to avoid conflicts
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
      final Reference ref = _storage.ref().child('uploads/$fileName');
      
      // Log the reference path
      print('Attempting to upload to path: uploads/$fileName');

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Listen to the upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
      });

      // Wait for the upload to complete
      TaskSnapshot completedTask = await uploadTask;

      // Check if the upload was successful
      if (completedTask.state == TaskState.success) {
        // Get the download URL after the upload completes
        String downloadUrl = await ref.getDownloadURL();
        print('File uploaded successfully: $downloadUrl'); // Log the download URL
        return downloadUrl; // Return the download URL
      } else {
        print('Upload failed: ${completedTask.state}');
        return null;
      }

    } catch (e) {
      print('Error occurred while uploading: $e');
      return null; // Return null if an error occurs
    }
  }

  // Save a scan result to Firestore
  Future<void> saveScanResult(String userId, String downloadUrl, String result) async {
    try {
      // Save the scan result to Firestore
      await _firestore.collection('scan_history').add({
        'userId': userId,
        'imageUrl': downloadUrl, // Store the download URL
        'result': result,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Scan result saved successfully.');
    } catch (e) {
      print('Error saving scan result: $e');
      throw e; // Optionally rethrow to handle it in your UI
    }
  }

  // Get scan history for a user
  Future<List<Map<String, dynamic>>> getScanHistory(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('scan_history')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting scan history: $e');
      return [];
    }
  }

  // Sign out a user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}


  // Save a scan result to Firestore//dont change this
//   Future<void> saveScanResult(String userId, String imagePath, String result) async {
//   try {
//     // Upload image to Firebase Storage
//     final ref = FirebaseStorage.instance.ref().child('scan_images/${basename(imagePath)}');
//     await ref.putFile(File(imagePath));
    
//     // Get the download URL
//     final downloadUrl = await ref.getDownloadURL();
    
//     // Save to Firestore
//     await FirebaseFirestore.instance.collection('scan_history').add({
//       'userId': userId,
//       'imageUrl': downloadUrl, // Make sure this is the download URL
//       'result': result,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   } catch (e) {
//     print('Error saving scan result: $e');
//   }
// }
