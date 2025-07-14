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
import 'package:piped_music_player/providers/theme_provider.dart';
import 'package:piped_music_player/screens/full_player_screen.dart';
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

  List<SongModel> _songs = [];

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
      context.read<SongsBloc>().add(LoadSongs());
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // Future<void> playSong(SongModel song) async {
  //   try {
  //     setState(() {
  //       _currentSong = song;
  //     });
  //     await _audioPlayer.setFilePath(song.data);
  //     await _audioPlayer.play();
  //   } catch (e) {
  //     debugPrint("Ошибка воспроизведения: $e");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    requestStoragePermission();

    // _playingSubscription = _audioPlayer.playingStream.listen((isPlaying) {
    //   setState(() {
    //     _isPlaying = isPlaying;
    //   });
    // });
    // context.read<SongsBloc>().add(LoadSongs());
    // widget.audioPlayer.playingStream.listen((isPlaying) {
    //   setState(() {
    //     isPlaying = isPlaying;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // _playingSubscription?.cancel();
    // widget.audioPlayer.dispose();
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
      body: BlocBuilder<SongsBloc, SongsState>(
        builder: (context, state) {
          debugPrint('Текущее состояние: $state');

          if (state is SongsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SongsError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is SongsLoaded) {
            final songs = state.songs;
            debugPrint('Количество треков: ${songs.length}');
            for (final s in songs) {
              debugPrint('→ ${s.title}, путь: ${s.data}');
            }

            if (songs.isEmpty) {
              return const Center(
                child: Text(
                  'На устройстве нет песен',
                  style: TextStyle(fontFamily: 'Huninn'),
                ),
              );
            }

            return Stack(
              children: [
                AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: widget.songModel != null ? 80 : 0,
                    ),
                    itemCount: songs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final song = songs[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  label: 'Add to Playlist',
                                  onPressed: (context) {},
                                  icon: Icons.playlist_add_rounded,
                                ),
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  label: 'Delete',
                                  onPressed: (context) {},
                                  icon: Icons.delete_rounded,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                artworkBorder: BorderRadius.circular(10),
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                  child: Image.asset(
                                    'assets/images/music.jpg',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                song.title,
                                style: TextStyle(fontFamily: 'Huninn'),
                              ),
                              subtitle: Text(
                                song.artist ?? 'Неизвестный исполнитель',
                                style: TextStyle(fontFamily: 'Huninn'),
                              ),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_vert_rounded),
                              ),
                              onTap: () => widget.onSongSelected(song),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.songModel != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildMiniPlayer(),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildMiniPlayer() {
    final currentTheme = Provider.of<ThemeProvider>(context);
    if (widget.songModel == null) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: OpenContainer(
        // openColor: Theme.of(context).colorScheme.onSurface,
        // closedColor: Theme.of(context).colorScheme.onSurface,
        // transitionDuration: const Duration(milliseconds: 500),
        closedColor: Colors.transparent,
        openColor: Theme.of(context).scaffoldBackgroundColor,
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, action) => FullPlayerScreen(
          song: widget.songModel!,
          audioPlayer: widget.audioPlayer,
          // audioHandler: widget.audioHandler,
        ),
        closedElevation: 0,
        openElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        closedBuilder: (context, openContainer) {
          return GestureDetector(
            onTap: openContainer,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: currentTheme.isDark ? Colors.black : Colors.white70,
                // border: Border(top: BorderSide(color: Colors.black26)),
              ),
              child: Row(
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
            ),
          );
        },
      ),
    );
  }
}
