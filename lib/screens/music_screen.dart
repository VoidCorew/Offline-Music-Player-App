import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];

  final PanelController _panelController = PanelController();

  // logic
  SongModel? _currentSong;
  bool _isPlaying = false;

  Future<void> requestPermissionAndLoadSongs() async {
    bool permissionGranted = await _requestMusicPermission();
    if (permissionGranted) {
      List<SongModel> songs = await _audioQuery.querySongs();
      setState(() {
        _songs = songs;
      });
    }
  }

  Future<bool> _requestMusicPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      PermissionStatus status;

      if (sdkInt >= 33) {
        status = await Permission.audio.request();
      } else {
        status = await Permission.storage.request();
      }

      return status.isGranted;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    requestPermissionAndLoadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Песни')),
      body: _songs.isEmpty
          ? const Center(child: Text('Нет песен'))
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120),
                  itemCount: _songs.length,
                  itemBuilder: (context, index) {
                    final song = _songs[index];
                    return ListTile(
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(20),
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset('assets/images/music.jpg'),
                        ),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist ?? 'Неизвестный'),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_vert_rounded),
                      ),
                    );
                  },
                ),

                SlidingUpPanel(
                  controller: _panelController,
                  minHeight: 70,
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  panelBuilder: (ScrollController sc) => _buildFullPlayer(sc),
                  collapsed: _buildMiniPlayer(),
                  parallaxEnabled: true,
                  parallaxOffset: 0.2,
                ),
              ],
            ),
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.music_note, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Сейчас играет песня',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.pause, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFullPlayer(ScrollController sc) {
    return ListView(
      controller: sc,
      children: [
        SizedBox(height: 16),
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(child: Icon(Icons.album, size: 200, color: Colors.white)),
        SizedBox(height: 24),
        Center(
          child: Text(
            "Название трека",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        Center(
          child: Text(
            "Исполнитель",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        SizedBox(height: 24),
        Slider(value: 30, max: 100, onChanged: (value) {}),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.skip_previous), onPressed: () {}),
            IconButton(icon: Icon(Icons.play_arrow), onPressed: () {}),
            IconButton(icon: Icon(Icons.skip_next), onPressed: () {}),
          ],
        ),
      ],
    );
  }
}
