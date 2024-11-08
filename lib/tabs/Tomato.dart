import 'package:flutter/material.dart';
import '../components/plant_card.dart'; // Updated import for PlantCard

class Tomato extends StatelessWidget {
  const Tomato({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PlantCard(
      imagePath: 'assets/images/tomato.png',
      plantType: 'tomato',
    );
  }
}
