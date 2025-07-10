import 'dart:convert';

import 'package:piped_music_player/models/music.dart';
import 'package:http/http.dart' as http;

class MusicRepository {
  final String baseUrl = "https://pipedapi.kavin.rocks";

  // Future List<Music> fetchMusic({String query = 'lofi'}) async {
  //   final response = await http.get(Uri.parse('$baseUrl/search?q=$query&type=music'));

  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     final items = jsonData['items'];
  //     return items.map((item) => Music(title: , thumbnail: thumbnail, url: url, uploader: uploader))
  //   }
  // }
}
