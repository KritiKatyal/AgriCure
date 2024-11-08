
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _scanHistory = [];

  @override
  void initState() {
    super.initState();
    _loadScanHistory();
  }

  Future<void> _loadScanHistory() async {
    final userId = _firebaseService.getCurrentUser()?.uid; // Get the current user ID
    if (userId != null) {
      final history = await _firebaseService.getScanHistory(userId);
      setState(() {
        _scanHistory = history; // Update the state with scan history
      });
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan History'),
//       ),
//       body: _scanHistory.isEmpty
//           ? const Center(child: Text('No scan history found.'))
//           : ListView.builder(
//               itemCount: _scanHistory.length,
//               itemBuilder: (context, index) {
//                 final scan = _scanHistory[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Card(
//                     elevation: 4,
//                     child: ListTile(
//                       leading: SizedBox(
//                         width: 50, // Set a fixed width for the leading widget
//                         child: Image.network(
//                           scan['imageUrl'], // Use imageUrl from the scan history
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Icon(Icons.error); // Show error icon if image fails to load
//                           },
//                         ),
//                       ),
//                       title: Text('Result: ${scan['result']}'),
//                       subtitle: Text('Date: ${scan['createdAt']}'),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Scan History',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      backgroundColor: Colors.green[800],
    ),
    body: _scanHistory.isEmpty
        ? const Center(
            child: Text(
              'No scan history found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: _scanHistory.length,
            itemBuilder: (context, index) {
              final scan = _scanHistory[index];
              final formattedResult = _formatResult(scan['result']);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                scan['imageUrl'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, size: 40, color: Colors.redAccent);
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Disease Detected',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    formattedResult,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Date: ${_formatDate(scan['createdAt'])}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
  );
}
}
// Helper function to format the date
String _formatDate(dynamic date) {
  DateTime dateTime;

  if (date is Timestamp) {
    dateTime = date.toDate();
  } else if (date is String) {
    dateTime = DateTime.parse(date);
  } else {
    return '';
  }

  return '${dateTime.day}-${dateTime.month}-${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}

// Helper function to format result details
String _formatResult(dynamic result) {
  if (result is Map) {
    final className = result['class'] ?? 'Unknown';
    final confidence = (result['confidence'] ?? 0) * 100;
    return '$className with ${confidence.toStringAsFixed(1)}% confidence';
  } else if (result is List) {
    return result.map((r) => _formatResult(r)).join(', ');
  } else {
    return result.toString();
  }
}
