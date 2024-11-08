import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../pages/camera_page.dart'; // Import the CameraPage

class MyAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onSearchTap;

  MyAppBar({
    Key? key,
    required this.onSearchTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.bebasNeue(
                fontSize: 52,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showSearchDialog(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: Icon(
                Icons.search,
                size: 36,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show the search dialog
  void _showSearchDialog(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search for a Plant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Enter plant name (e.g., Bittergourd, Tomato)',
                ),
                
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Set text color to white
            ),
                onPressed: () {
                  String plantName = _searchController.text.toLowerCase().trim();

                  // Close the dialog before processing
                  Navigator.pop(context);

                  if (plantName == 'bittergourd' || plantName == 'tomato') {
                    // Navigate to Camera based on plant type
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPage(plantType: plantName),
                      ),
                    );
                  } else {
                    // Show message for unavailable plants
                    _showUnavailableDialog(context);
                  }
                },
                child: const Text('Search'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show dialog when the plant is not available
  void _showUnavailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text('This plant is not available for scanning yet.'),
          
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
