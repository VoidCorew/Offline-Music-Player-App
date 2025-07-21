import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'save_song.g.dart';

@HiveType(typeId: 0)
class SaveSong extends HiveObject {
  @HiveField(0)
  final List<Uint8List?> artwork;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String thumbnail;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String uploader;

  SaveSong({
    required this.artwork,
    required this.title,
    required this.thumbnail,
    required this.url,
    required this.uploader,
  });
}
