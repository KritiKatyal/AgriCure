import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For additional icons

Map<String, dynamic> getDiseaseDescription(String className) {
  Map<String, dynamic> descriptions = {
    // Bitter Gourd diseases
    'Healthy': {
      'description': 'The plant is healthy with no visible issues.',
      'severity': 'None',
      'icon': Icons.check_circle,
      'color': Colors.green,
      'details': {
        'Cause': 'No external factors affecting the plant.',
        'Symptoms': 'No symptoms.',
        'Prevention': 'Continue regular care.',
        'Treatment': 'None required.',
      },
    },
    'H': {
      'description': 'The plant is healthy with no visible issues.',
      'severity': 'None',
      'icon': Icons.check_circle,
      'color': Colors.green,
      'details': {
        'Cause': 'No external factors affecting the plant.',
        'Symptoms': 'No symptoms.',
        'Prevention': 'Continue regular care.',
        'Treatment': 'None required.',
      },
    },
    
    'DM': {
      'description': 'Downy Mildew: A fungal disease affecting the leaves, causing yellow patches on the surface.',
      'severity': 'High',
      'icon': FontAwesomeIcons.biohazard,
      'color': Colors.red,
      'details': {
        'Cause': 'Fungal spores, particularly in humid and wet conditions.',
        'Symptoms': 'Yellow patches on leaves, stunted growth, white mold on leaf undersides.',
        'Prevention': 'Ensure good air circulation, avoid overhead watering, and use fungicide.',
        'Treatment': 'Prune affected areas and apply fungicides.',
      },
    },
    'LS': {
      'description': 'Leaf Spot: Caused by fungi or bacteria, leading to small, dark spots on the leaves.',
      'severity': 'Medium',
      'icon': FontAwesomeIcons.leaf,
      'color': Colors.orange,
      'details': {
        'Cause': 'Fungal or bacterial infection.',
        'Symptoms': 'Small, dark spots that can merge, causing large areas of dead tissue.',
        'Prevention': 'Water plants at the base and use disease-resistant varieties.',
        'Treatment': 'Remove infected leaves and apply fungicides.',
      },
    },
    'JAS': {
      'description': 'Jassid: A leafhopper insect that feeds on plant sap, causing curling and yellowing of leaves.',
      'severity': 'Medium',
      'icon': FontAwesomeIcons.bug,
      'color': Colors.orange,
      'details': {
        'Cause': 'Insect infestation (leafhoppers).',
        'Symptoms': 'Leaf curling, yellowing, and stunted growth.',
        'Prevention': 'Use insecticides or introduce natural predators like ladybugs.',
        'Treatment': 'Spray insecticidal soap or neem oil.',
      },
    },
    'K': {
      'description': 'Potassium Deficiency: Causes yellowing of leaf edges and weak plant structure.',
      'severity': 'Low',
      'icon': FontAwesomeIcons.seedling,
      'color': Colors.yellow,
      'details': {
        'Cause': 'Lack of potassium in the soil.',
        'Symptoms': 'Yellowing of leaf edges, weak stems, and poor root development.',
        'Prevention': 'Use potassium-rich fertilizers.',
        'Treatment': 'Apply potassium-based fertilizers or organic compost.',
      },
    },
    'K Mg': {
      'description': 'Potassium and Magnesium Deficiency: Leads to leaf yellowing and dark spots.',
      'severity': 'Medium',
      'icon': FontAwesomeIcons.leaf,
      'color': Colors.orange,
      'details': {
        'Cause': 'Deficiency of both potassium and magnesium.',
        'Symptoms': 'Yellowing leaves with dark spots.',
        'Prevention': 'Ensure a balanced fertilizer with both potassium and magnesium.',
        'Treatment': 'Apply balanced fertilizer or magnesium supplements.',
      },
    },
    'N': {
      'description': 'Nitrogen Deficiency: Causes pale leaves and reduced plant growth.',
      'severity': 'Medium',
      'icon': FontAwesomeIcons.triangleExclamation,
      'color': Colors.orange,
      'details': {
        'Cause': 'Lack of nitrogen in the soil.',
        'Symptoms': 'Pale, yellowing leaves, especially older ones.',
        'Prevention': 'Use nitrogen-rich fertilizers and compost.',
        'Treatment': 'Apply nitrogen-based fertilizers such as urea or manure.',
      },
    },
    'N K': {
      'description': 'Nitrogen and Potassium Deficiency: Leads to yellowing leaves and weak growth.',
      'severity': 'High',
      'icon': FontAwesomeIcons.circleExclamation,
      'color': Colors.red,
      'details': {
        'Cause': 'Deficiency of both nitrogen and potassium.',
        'Symptoms': 'Widespread yellowing of leaves, poor growth, and weak plant structure.',
        'Prevention': 'Ensure balanced fertilization.',
        'Treatment': 'Apply nitrogen and potassium-rich fertilizers.',
      },
    },
    'N_K': {
      'description': 'Nitrogen and Potassium Deficiency: Leads to yellowing leaves and weak growth.',
      'severity': 'High',
      'icon': FontAwesomeIcons.circleExclamation,
      'color': Colors.red,
      'details': {
        'Cause': 'Deficiency of both nitrogen and potassium.',
        'Symptoms': 'Widespread yellowing of leaves, poor growth, and weak plant structure.',
        'Prevention': 'Ensure balanced fertilization.',
        'Treatment': 'Apply nitrogen and potassium-rich fertilizers.',
      },
    },
    'N Mg': {
      'description': 'Nitrogen and Magnesium Deficiency: Causes yellowing of leaves with brown spots.',
      'severity': 'Low',
      'icon': FontAwesomeIcons.seedling,
      'color': Colors.yellow,
      'details': {
        'Cause': 'Lack of nitrogen and magnesium in the soil.',
        'Symptoms': 'Yellow leaves with brown spots, slow growth.',
        'Prevention': 'Use balanced fertilizers.',
        'Treatment': 'Apply nitrogen-based and magnesium supplements.',
      },
    },
    'N_Mg': {
      'description': 'Nitrogen and Magnesium Deficiency: Causes yellowing of leaves with brown spots.',
      'severity': 'Low',
      'icon': FontAwesomeIcons.seedling,
      'color': Colors.yellow,
      'details': {
        'Cause': 'Lack of nitrogen and magnesium in the soil.',
        'Symptoms': 'Yellow leaves with brown spots, slow growth.',
        'Prevention': 'Use balanced fertilizers.',
        'Treatment': 'Apply nitrogen-based and magnesium supplements.',
      },
    },
    // Tomato diseases
    'LM': {
      'description': 'Leaf Miner: Insect pest that causes white, winding trails on leaves as larvae burrow inside.',
      'severity': 'Medium',
      'icon': FontAwesomeIcons.bug,
      'color': Colors.orange,
      'details': {
        'Cause': 'Larvae of leaf miner insects.',
        'Symptoms': 'White, winding trails on leaves, leaf discoloration.',
        'Prevention': 'Introduce natural predators like wasps or use insecticides.',
        'Treatment': 'Remove affected leaves and apply insecticides.',
      },
    },
    'MIT': {
      'description': 'Mite: Small insect pests that suck plant sap, leading to discolored and distorted leaves.',
      'severity': 'Medium',
      'icon': FontAwesomeIcons.bug,
      'color': Colors.orange,
      'details': {
        'Cause': 'Spider mites or other mite species.',
        'Symptoms': 'Discolored, distorted leaves, webbing on the plant.',
        'Prevention': 'Spray plants with water or use neem oil to discourage mites.',
        'Treatment': 'Use insecticidal soap or chemical miticides.',
      },
    },
    'JAS MIT': {
      'description': 'Jassid and Mite: Combination of pests causing damage through sap feeding, leading to yellowing leaves.',
      'severity': 'High',
      'icon': FontAwesomeIcons.bug,
      'color': Colors.red,
      'details': {
        'Cause': 'Combined infestation of jassids and mites.',
        'Symptoms': 'Yellowing, curling, and distorted leaves.',
        'Prevention': 'Apply neem oil or introduce natural predators.',
        'Treatment': 'Use insecticidal soap or specific miticides for control.',
      },
    },
    'JAS_MIT': {
      'description': 'Jassid and Mite: Combination of pests causing damage through sap feeding, leading to yellowing leaves.',
      'severity': 'High',
      'icon': FontAwesomeIcons.bug,
      'color': Colors.red,
      'details': {
        'Cause': 'Combined infestation of jassids and mites.',
        'Symptoms': 'Yellowing, curling, and distorted leaves.',
        'Prevention': 'Apply neem oil or introduce natural predators.',
        'Treatment': 'Use insecticidal soap or specific miticides for control.',
      },
    },
  };

  return descriptions[className] ?? {
    'description': 'No description available for this class.',
    'severity': 'Unknown',
    'icon': Icons.help_outline,
    'color': Colors.grey,
    'details': {
      'Cause': 'Unknown',
      'Symptoms': 'Unknown',
      'Prevention': 'Unknown',
      'Treatment': 'Unknown',
    },
  };
}


class ResultPage extends StatelessWidget {
  final XFile imageFile;
  final List<dynamic> predictions;

  const ResultPage({super.key, required this.imageFile, required this.predictions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Results'),
        backgroundColor: Colors.green,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double containerHeight = 300;
          final double containerWidth = constraints.maxWidth;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(imageFile.path),
                          fit: BoxFit.cover,
                          height: containerHeight,
                          width: containerWidth,
                        ),
                      ),
                      ..._buildBoundingBoxes(predictions, containerWidth, containerHeight),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Disease Predictions:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  predictions.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            final prediction = predictions[index];
                            final diseaseInfo = getDiseaseDescription(prediction['class']);
                            return _buildPredictionCard(diseaseInfo, prediction);
                          },
                        )
                      : const Center(
                          child: Text(
                            'No predictions made.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Method to build bounding boxes based on predictions
  List<Widget> _buildBoundingBoxes(
      List<dynamic> predictions, double containerWidth, double containerHeight) {
    List<Widget> boxes = [];
    for (var prediction in predictions) {
      final box = prediction['box'];
      if (box is List && box.length == 4) {
        final double imageOriginalWidth = 1280; // Adjust based on your original image size
        final double imageOriginalHeight = 1280; // Adjust based on your original image size

        final double scaleX = containerWidth / imageOriginalWidth;
        final double scaleY = containerHeight / imageOriginalHeight;

        final double x = box[0] * scaleX;
        final double y = box[1] * scaleY;
        final double width = (box[2] - box[0]) * scaleX;
        final double height = (box[3] - box[1]) * scaleY;

        boxes.add(Positioned(
          left: x,
          top: y,
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ));
      }
    }
    return boxes;
  }

  Widget _buildPredictionCard(Map<String, dynamic> diseaseInfo, Map<String, dynamic> prediction) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  diseaseInfo['icon'],
                  size: 50,
                  color: diseaseInfo['color'],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class: ${prediction['class']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Confidence: ${(prediction['confidence'] * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Severity: ${diseaseInfo['severity']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: diseaseInfo['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Description: ${diseaseInfo['description']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildDetailSection(diseaseInfo['details']),
          ],
        ),
      ),
    );
  }

  // Helper widget to display disease details like Cause, Symptoms, Prevention, Treatment
  Widget _buildDetailSection(Map<String, String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _buildDetailRow('Cause', details['Cause']!),
        _buildDetailRow('Symptoms', details['Symptoms']!),
        _buildDetailRow('Prevention', details['Prevention']!),
        _buildDetailRow('Treatment', details['Treatment']!),
      ],
    );
  }

  // Helper method to format each row of the disease details
  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}


