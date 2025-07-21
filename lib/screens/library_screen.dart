import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Библиотека', style: TextStyle(fontFamily: 'Exo2')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMusicCard(
                  context,
                  Icons.heart_broken_rounded,
                  'Избранное',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMusicCard(context, Icons.download, 'Скачанные'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildMusicCard(
  //   BuildContext context,
  //   IconData icon,
  //   String bottomLabel,
  // ) {
  //   return Column(
  //     children: [
  //       AspectRatio(
  //         aspectRatio: 1,
  //         child: Card(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Center(child: Icon(icon)),
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Text(bottomLabel),
  //     ],
  //   );
  // }

  Widget _buildMusicCard(
    BuildContext context,
    IconData icon,
    String bottomLabel,
  ) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double iconSize = constraints.maxWidth * 0.4;
                return Center(child: Icon(icon, size: iconSize));
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(bottomLabel, style: const TextStyle(fontFamily: 'Exo2')),
      ],
    );
  }
}
