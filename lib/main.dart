import 'package:flutter/material.dart';
import 'package:simple/bubble_bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pages = [
    Container(
      child: Center(
        child: Text('Página 1'),
      ),
    ),
    Container(
      child: Center(
        child: Text('Página 2'),
      ),
    ),
    Container(
      child: Center(
        child: Text('Página 3'),
      ),
    ),
    Container(
      child: Center(
        child: Text('Página 4'),
      ),
    ),
    Container(
      child: Center(
        child: Text('Página 5'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(),
      ),
      extendBody: true,
      appBar: AppBar(
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Inicio'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BubbleBottomNavBar(
        selectedIconColor: Colors.black,
        iconColor: Colors.black87,
        backgroundColor: Colors.white,
        bottomIconsPadding: 10,
        animationDuration: Duration(milliseconds: 800),
        height: 90,
        items: <BubbleNavBarItem>[
          BubbleNavBarItem(
            transitionColor: Colors.blue.shade50,
            icon: const Icon(
              Icons.home_outlined,
              size: 24,
            ),
            selectedIcon: const Icon(
              Icons.home,
              size: 30,
            ),
          ),
          BubbleNavBarItem(
            transitionColor: Colors.green.shade50,
            icon: const Icon(
              Icons.bookmark_border,
              size: 24,
            ),
            selectedIcon: const Icon(
              Icons.bookmark,
              size: 30,
            ),
          ),
          BubbleNavBarItem(
            icon: const Icon(
              Icons.favorite_border,
              size: 24,
            ),
            selectedIcon: const Icon(
              Icons.favorite,
              size: 30,
            ),
          ),
          BubbleNavBarItem(
            transitionColor: Colors.orange.shade50,
            icon: const Icon(
              Icons.person_outline,
              size: 24,
            ),
            selectedIcon: const Icon(
              Icons.person,
              size: 30,
            ),
          ),
          BubbleNavBarItem(
            transitionColor: Colors.purple.shade50,
            icon: const Icon(
              Icons.center_focus_strong_outlined,
              size: 24,
            ),
            selectedIcon: const Icon(
              Icons.center_focus_strong,
              size: 30,
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
