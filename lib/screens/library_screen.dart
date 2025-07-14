import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Библиотека', style: TextStyle(fontFamily: 'Exo2')),
      ),
      body: Center(
        child: const Text(
          'Пока в разработке',
          style: TextStyle(fontFamily: 'Huninn'),
        ),
      ),
    );
  }
}
