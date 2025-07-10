import 'package:flutter/material.dart';
import 'package:piped_music_player/screens/home_screen.dart';
import 'package:piped_music_player/screens/library_screen.dart';
import 'package:piped_music_player/screens/songs_scren.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentScreenIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    SongsScren(),
    LibraryScreen(),
  ];
  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Главная',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.music_note),
      icon: Icon(Icons.music_note_outlined),
      label: 'Песни',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.library_music),
      icon: Icon(Icons.library_music_outlined),
      label: 'Библиотека',
    ),
  ];

  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.music_note),
      icon: Icon(Icons.music_note_outlined),
      label: 'Songs',
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.library_music),
      icon: Icon(Icons.library_music_outlined),
      label: 'Library',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentScreenIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.grey,
        selectedIndex: _currentScreenIndex,
        destinations: _destinations,
        onDestinationSelected: (index) =>
            setState(() => _currentScreenIndex = index),
      ),
    );
  }
}
