import 'package:flutter/material.dart';

class MyBottomBar extends StatelessWidget {
  final int index;
  final Function(int?) onTap;
  const MyBottomBar({
    Key? key,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
      selectedItemColor: Colors.green[800], // Match the theme color
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.transparent,
      showSelectedLabels: true, // Show labels for navigation clarity
      showUnselectedLabels: false,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Camera'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Results'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
