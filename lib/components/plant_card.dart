import 'package:flutter/material.dart';
import '../pages/camera_page.dart';

class PlantCard extends StatelessWidget {
  final String imagePath;
  final String plantType; // Add plant type to navigate to the correct CameraPage

  const PlantCard({
    Key? key,
    required this.imagePath,
    required this.plantType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the CameraPage with the appropriate plantType when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(plantType: plantType),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
