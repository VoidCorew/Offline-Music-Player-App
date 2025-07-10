import 'package:flutter/material.dart';

class SongsScren extends StatelessWidget {
  const SongsScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Песни')),
      body: Center(child: const Text('Песни')),
    );
  }
}
