import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SongsProvider extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> _songs = [];
  List<SongModel> get songs => _songs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadSongs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // final status = await Permission.storage.request();
      // if (!status.isGranted) {
      //   throw Exception('Нет разрешения на доступ к музыке');
      // }

      bool hasPermission = await _audioQuery.permissionsStatus();
      if (!hasPermission) {
        hasPermission = await _audioQuery.permissionsRequest();
      }
      if (!hasPermission) {
        throw Exception('Нет разрешения на доступ к музыке');
      }

      _songs = await _audioQuery.querySongs();
      debugPrint('Найдено треков: ${_songs.length}');
    } catch (e) {
      _error = e.toString();
      debugPrint('Ошибка loadSongs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
