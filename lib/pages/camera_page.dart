import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'result_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '/services/firebase_service.dart'; // Your Firebase service file
import 'package:firebase_auth/firebase_auth.dart';

class CameraPage extends StatefulWidget {
  final String plantType; // Accept plant type as a parameter
  const CameraPage({required this.plantType, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _loading = false;
  final FirebaseService _firebaseService = FirebaseService();

  // Method to pick image from either Camera or Gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _loading = true; // Start loading spinner
      });

      try {
        // Log the picked file path
        print('Picked file path: ${_image!.path}');

        // Upload the picked image to Firebase Storage and get the download URL
        String? downloadUrl = await _firebaseService.uploadFile(_image!);

        if (downloadUrl == null || downloadUrl.isEmpty) {
          print('Error: Upload failed, no download URL available');
          throw Exception('Upload failed, no download URL available');
        }

        // Log successful URL retrieval
        print('Download URL received: $downloadUrl');

        // Send image to your prediction server and get predictions
        List<dynamic> predictions = await _sendImageToServer(pickedFile, widget.plantType); // Ensure plantType is valid

        if (predictions.isEmpty) {
          throw Exception("No predictions received from the server.");
        }

        // Get the current user ID from Firebase Authentication
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId != null) {
          String result = predictions.isNotEmpty ? predictions[0].toString() : 'No result';
          await _firebaseService.saveScanResult(userId, downloadUrl, result); // Pass download URL
        }

        // Navigate to the result page with predictions
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(imageFile: pickedFile, predictions: predictions),
          ),
        );
      } catch (e) {
        // Error handling for UI feedback
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      } finally {
        // Stop loading spinner once done
        setState(() {
          _loading = false;
        });
      }
    }
  }



  // Method to send the image to the prediction server
  Future<List<dynamic>> _sendImageToServer(XFile imageFile, String plant) async {
    final uri = Uri.parse('http://192.168.1.10:5000/predict/$plant'); // Replace with your server's URI
    var request = http.MultipartRequest('POST', uri);

    // Attach the image file to the request
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    // Send the request to the server
    final response = await request.send();

    // Handle the server response
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedData = json.decode(responseBody);

      // Check if predictions exist
      if (decodedData.containsKey('predictions')) {
        return decodedData['predictions']; // Return the predictions
      } else {
        throw Exception('No predictions received from the server.');
      }
    } else {
      throw Exception('Failed to get predictions from the server.');
    }
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Capture Image',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.green, 
      foregroundColor: Colors.white, // Customize the app bar color
    ),
    body: Stack(
      children: <Widget>[
        // The gradient background
        _buildBackground(),
        
        // The main content overlays on top of the background
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Display image if available, else show placeholder
                  if (_image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _image!,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey[500],
                      ),
                    ),
                  const SizedBox(height: 30),

                  // Take a photo button with a modern look
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, size: 30),
                    label: const Text(
                      'Take a Photo',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: Colors.green[700], // Use backgroundColor instead of primary
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Choose from gallery button with similar style
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library, size: 30),
                    label: const Text(
                      'Choose from Gallery',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: Colors.blueAccent, // Different color for variety
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Show loading indicator when loading
                   if (_loading)
                      Center(
                            child: LoadingAnimationWidget.progressiveDots(
                              color: Colors.white,
                              // leftDotColor: const Color(0xFF1A1A3F),
                              // rightDotColor: const Color(0xFFEA3799),
                              size: 70,
                            ),
                          ),
                      
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
Widget _buildBackground() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green.shade300, Colors.green],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
}















// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'result_page.dart';
// import '/services/firebase_service.dart'; // Your Firebase service file
// import 'package:firebase_auth/firebase_auth.dart';

// class CameraPage extends StatefulWidget {

  
//   final String plantType; // Accept plant type as a parameter
//   const CameraPage({required this.plantType, Key? key}) : super(key: key);


//   @override
//   _CameraPageState createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   final ImagePicker _picker = ImagePicker();
//   File? _image;
//   bool _loading = false;
//   final FirebaseService _firebaseService = FirebaseService();

//   // Method to pick image from either Camera or Gallery
//   Future<void> _pickImage(ImageSource source) async {
//   final pickedFile = await _picker.pickImage(source: source);

//   if (pickedFile != null) {
//     setState(() {
//       _image = File(pickedFile.path);
//       _loading = true;  // Start loading spinner
//     });

//     try {
//       // Log the picked file path
//       print('Picked file path: ${_image!.path}');

//       // Upload the picked image to Firebase Storage and get the download URL
//       String? downloadUrl = await _firebaseService.uploadFile(_image!);

//       if (downloadUrl == null || downloadUrl.isEmpty) {
//         print('Error: Upload failed, no download URL available');
//         throw Exception('Upload failed, no download URL available');
//       }
 
//       // Log successful URL retrieval
//       print('Download URL received: $downloadUrl');

//       // Send image to your prediction server and get predictions
//       List<dynamic> predictions = await _sendImageToServer(pickedFile, widget.plantType); // Ensure plantType is valid

//       // Get the current user ID from Firebase Authentication
//       final userId = FirebaseAuth.instance.currentUser?.uid;

//       if (userId != null) {
//         String result = predictions.isNotEmpty ? predictions[0].toString() : 'No result';
//         await _firebaseService.saveScanResult(userId, downloadUrl, result);  // Pass download URL
//       }

//       // Navigate to the result page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultPage(imageFile: pickedFile, predictions: predictions),
//         ),
//       );
//     } catch (e) {
//       // Error handling for UI feedback
//       print('Error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading image: $e')),
//       );
//     } finally {
//       // Stop loading spinner once done
//       setState(() {
//         _loading = false;
//       });
//     }
//   }
// }
// // curl -X POST -F "file=@C:\Users\kkrit\Downloads\WhatsApp Image 2024-10-22 at 9.44.30 PM (1).jpeg" http://192.168.1.10:5000/predict/bittergourd

//   // Method to send the image to the prediction server
//   Future<List<dynamic>> _sendImageToServer(XFile imageFile, String plant) async {
//     final uri = Uri.parse('http://192.168.1.10:5000/predict/$plant');  // Replace with your server's URI
//     var request = http.MultipartRequest('POST', uri);

//     // Attach the image file to the request
//     request.files.add(
//       await http.MultipartFile.fromPath('file', imageFile.path),
//     );

//     // Send the request to the server
//     final response = await request.send();

//     // Handle the server response
//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final decodedData = json.decode(responseBody);
//       return decodedData['predictions'];  // Return the predictions
//     } else {
//       throw Exception('Failed to get predictions');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Capture Image'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_image != null)
//               Image.file(_image!),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () => _pickImage(ImageSource.camera),  // Option to take a photo
//               icon: const Icon(Icons.camera_alt),
//               label: const Text('Take a Photo'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () => _pickImage(ImageSource.gallery),  // Option to pick an image from gallery
//               icon: const Icon(Icons.photo_library),
//               label: const Text('Choose from Gallery'),
//             ),
//             if (_loading)
//               const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }


