import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:piped_music_player/providers/theme_provider.dart';
import 'package:piped_music_player/utils/constants.dart';
import 'package:piped_music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

class FullPlayerScreen extends StatefulWidget {
  final SongModel song;
  final AudioPlayer audioPlayer;
  // final AudioHandler audioHandler;
  const FullPlayerScreen({
    super.key,
    required this.song,
    required this.audioPlayer,
    // required this.audioHandler,
  });

  @override
  State<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends State<FullPlayerScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late Future<Uint8List?> _artworkFuture;

  @override
  void initState() {
    super.initState();
    _artworkFuture = _audioQuery.queryArtwork(
      widget.song.id,
      ArtworkType.AUDIO,
    );
  }

  @override
  Widget build(BuildContext context) {
    // bool isPlaying = widget.audioPlayer.playing;
    final currentTheme = Provider.of<ThemeProvider>(context);
    final sizes = SizeConfig(context);

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, asyncSnapshot) {
            final state = asyncSnapshot.data;
            final isPlaying = state?.playing ?? false;

            if (state == null) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    // const SizedBox(height: 8),
                    // Container(
                    //   width: 40,
                    //   height: 5,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey[400],
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    // ),
                    // const SizedBox(height: 12),
                    FutureBuilder(
                      future: _artworkFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: sizes.imageWidth,
                            width: sizes.imageWidth,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(
                              snapshot.data!,
                              height: sizes.imageWidth,
                              width: sizes.imageWidth,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/music.jpg',
                              height: sizes.imageWidth,
                              width: sizes.imageWidth,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder<Duration>(
                    stream: widget.audioPlayer.positionStream,
                    // stream:
                    //     (widget.audioHandler as dynamic).player.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final total =
                          widget.audioPlayer.duration ?? Duration.zero;
                      // final total =
                      //     (widget.audioHandler as dynamic).player.duration ??
                      //     Duration.zero;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.song.title, style: trackName),
                          Text(widget.song.artist!, style: artistName),
                          const SizedBox(height: 20),
                          Slider(
                            value:
                                position.inMilliseconds.toDouble().clamp(
                                      0,
                                      total.inMilliseconds.toDouble(),
                                    )
                                    as double,
                            max: total.inMilliseconds.toDouble() > 0
                                ? total.inMilliseconds.toDouble()
                                : 1.0,
                            onChanged: (value) {
                              widget.audioPlayer.seek(
                                Duration(milliseconds: value.toInt()),
                              );
                              // widget.audioHandler.seek(
                              //   Duration(milliseconds: value.toInt()),
                              // );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDuration(position),
                                  style: TextStyle(fontFamily: 'Huninn'),
                                ),
                                Text(
                                  formatDuration(total),
                                  style: TextStyle(fontFamily: 'Huninn'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.shuffle_rounded),
                              ),
                              IconButton(
                                iconSize: sizes.skipButtonsWidth,
                                onPressed: () {},
                                icon: Icon(Icons.skip_previous_rounded),
                              ),
                              const SizedBox(width: 15),
                              Material(
                                shape: isPlaying
                                    ? RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )
                                    : const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  // borderRadius: isPlaying
                                  //     ? BorderRadius.circular(20)
                                  //     : null,
                                  // customBorder: isPlaying
                                  //     ? RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(20),
                                  //       )
                                  //     : const CircleBorder(),
                                  onTap: () {
                                    if (isPlaying) {
                                      setState(() {
                                        widget.audioPlayer.pause();
                                      });
                                      // widget.audioHandler.pause();
                                    } else {
                                      setState(() {
                                        widget.audioPlayer.play();
                                      });
                                      // widget.audioHandler.play();
                                    }
                                  },
                                  child: Container(
                                    width: sizes.playButtonWidth,
                                    height: sizes.playButtonWidth,
                                    decoration: BoxDecoration(
                                      color: currentTheme.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      shape: BoxShape.circle,
                                      // shape: isPlaying
                                      //     ? BoxShape.rectangle
                                      //     : BoxShape.circle,
                                      // borderRadius: isPlaying
                                      //     ? BorderRadius.circular(20)
                                      //     : null,
                                    ),
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      color: currentTheme.isDark
                                          ? Colors.black
                                          : Colors.white,
                                      size: sizes.playButtonIconWidth,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              IconButton(
                                iconSize: sizes.skipButtonsWidth,
                                onPressed: () {},
                                icon: Icon(Icons.skip_next_rounded),
                              ),

                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.repeat_rounded),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
