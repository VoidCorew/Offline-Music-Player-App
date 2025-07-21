import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piped_music_player/bloc/songs_bloc.dart';
import 'package:piped_music_player/providers/songs_provider.dart';
import 'package:piped_music_player/providers/theme_provider.dart';
import 'package:piped_music_player/screens/full_player_screen.dart';
import 'package:piped_music_player/widgets/mini_player.dart';
import 'package:provider/provider.dart';

class SongsScreen extends StatefulWidget {
  final AudioPlayer audioPlayer;
  // final AudioHandler audioHandler;
  final SongModel? songModel;
  final bool isPlaying;
  final Function(SongModel) onSongSelected;
  final VoidCallback togglePlayPause;

  const SongsScreen({
    super.key,
    required this.audioPlayer,
    // required this.audioHandler,
    required this.songModel,
    required this.isPlaying,
    required this.onSongSelected,
    required this.togglePlayPause,
  });

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // List<SongModel> _songs = [];

  Future<void> requestStoragePermission() async {
    if (!Platform.isAndroid) return;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    PermissionStatus status;

    if (sdkInt >= 33) {
      status = await Permission.audio.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestStoragePermission();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMode = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Песни', style: TextStyle(fontFamily: 'Exo2')),
        actions: [
          IconButton(
            onPressed: () {
              currentMode.toggleTheme();
            },
            icon: Icon(
              currentMode.isDark
                  ? Icons.wb_sunny_rounded
                  : Icons.nightlight_round,
            ),
          ),
        ],
      ),
      body: Consumer<SongsProvider>(
        builder: (context, songsProvider, __) {
          if (songsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (songsProvider.error != null) {
            return Center(child: Text('Ошибка: ${songsProvider.error}'));
          }
          if (songsProvider.songs.isEmpty) {
            return const Center(child: Text('Песен нет'));
          }

          return Padding(
            padding: EdgeInsets.only(bottom: widget.songModel != null ? 80 : 0),
            child: ListView.builder(
              itemCount: songsProvider.songs.length,
              itemBuilder: (context, index) {
                final song = songsProvider.songs[index];
                return ListTile(
                  title: Text(song.title),
                  subtitle: Text(song.artist ?? 'Неизвестный'),
                  onTap: () => widget.onSongSelected(song),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomMiniPlayer(double height, double percentage) {
    final isExpanded = percentage > 0.5;
    final theme = Provider.of<ThemeProvider>(context);

    if (widget.songModel == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isExpanded) ...[
            Row(
              children: [
                ClipOval(
                  child: QueryArtworkWidget(
                    id: widget.songModel!.id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    artworkHeight: 45,
                    artworkWidth: 45,
                    nullArtworkWidget: Image.asset(
                      'assets/images/music.jpg',
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songModel!.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'Huninn',
                        ),
                      ),
                      Text(
                        widget.songModel!.artist ?? 'Неизвестный автор',
                        style: const TextStyle(fontFamily: 'Huninn'),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.togglePlayPause,
                  icon: Icon(
                    widget.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                ),
              ],
            ),
          ] else ...[
            // Полноэкранный плеер при раскрытии
            Center(
              child: Column(
                children: [
                  QueryArtworkWidget(
                    id: widget.songModel!.id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    artworkHeight: 200,
                    artworkWidth: 200,
                    nullArtworkWidget: Image.asset(
                      'assets/images/music.jpg',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.songModel!.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Huninn',
                    ),
                  ),
                  Text(
                    widget.songModel!.artist ?? 'Неизвестный автор',
                    style: const TextStyle(fontFamily: 'Huninn'),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: widget.togglePlayPause,
                    iconSize: 60,
                    icon: Icon(
                      widget.isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
