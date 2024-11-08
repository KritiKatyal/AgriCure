import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTabBar extends StatefulWidget {
  final List tabOptions;
  final VoidCallback onTapBittergourd;  // Callbacks for plant selection
  final VoidCallback onTapTomato;

  const MyTabBar({
    Key? key,
    required this.tabOptions,
    required this.onTapBittergourd,
    required this.onTapTomato,
  }) : super(key: key);

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initializing the TabController with length 2 (for Bittergourd and Tomato)
    _tabController = TabController(length: 2, vsync: this);

    // Adding listener to update UI when tab changes
    _tabController.addListener(() {
      setState(() {});  // Rebuild to update the tab color dynamically
    });
  }

  @override
  void dispose() {
    _tabController.dispose();  // Properly disposing the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,  // Bind the TabController to the TabBar
          indicatorColor: _tabController.index == 0
              ? const Color.fromARGB(255, 50, 131, 56) // Green for Bittergourd
              : const Color.fromARGB(255, 199, 73, 64), // Red for Tomato
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: const Color.fromARGB(255, 132, 132, 132),
          labelStyle: GoogleFonts.bebasNeue(
            fontSize: 32,
            color: _tabController.index == 0
                ? const Color.fromARGB(255, 50, 131, 56) // Green for Bittergourd
                : const Color.fromARGB(255, 199, 73, 64), // Red for Tomato
          ),
          tabs: [
            Tab(
              child: GestureDetector(
                onTap: widget.onTapBittergourd,
                child: Text(widget.tabOptions[0][0]),
              ),
            ),
            Tab(
              child: GestureDetector(
                onTap: widget.onTapTomato,
                child: Text(widget.tabOptions[1][0]),
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,  // Bind the TabController to the TabBarView
            children: [
              widget.tabOptions[0][1], // Bittergourd tab content
              widget.tabOptions[1][1], // Tomato tab content
            ],
          ),
        ),
      ],
    );
  }
}
