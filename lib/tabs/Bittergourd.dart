import 'package:flutter/material.dart';
import '../components/plant_card.dart'; // Updated import for PlantCard

class Bittergourd extends StatelessWidget {
  const Bittergourd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PlantCard(
      imagePath: 'assets/images/bittergourd.jpg',
      plantType: 'bittergourd',
    );
  }
}
