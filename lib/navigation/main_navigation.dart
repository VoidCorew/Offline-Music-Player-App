import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:piped_music_player/screens/songs_screen.dart';
import 'package:piped_music_player/screens/library_screen.dart';
import 'package:piped_music_player/services/audio_player_handler.dart';

class MainNavigation extends StatefulWidget {
  // final AudioPlayerHandler audioHandler;
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late final StreamSubscription<bool> _playingSubscription;
  // late final StreamSubscription<PlaybackState> _playingSubscription;
  int _currentScreenIndex = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();
  SongModel? _currentSong;
  bool _isPlaying = false;

  bool _isLoading = false;

  // late final List<Widget> _screens;

  // void playSong(SongModel song) async {
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

  void playSong(SongModel song) async {
    try {
      setState(() {
        _isLoading = true;
        _currentSong = song;
      });

      await _audioPlayer.setFilePath(song.data);
      await _audioPlayer.play();
      // await widget.audioHandler.setAudioSource(song.data);
      // widget.audioHandler.mediaItem.add(
      //   MediaItem(
      //     id: song.data,
      //     title: song.title,
      //     artist: song.artist ?? 'Неизвестный',
      //     artUri: Uri.file(song.album ?? '/assets/images/music.jpg'),
      //   ),
      // );
      // await widget.audioHandler.play();
    } catch (e) {
      debugPrint("Ошибка воспроизведения: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    // setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    super.dispose();
    _playingSubscription.cancel();
    _audioPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();

    // _screens = [
    //   SongsScreen(
    //     audioPlayer: _audioPlayer,
    //     songModel: _currentSong,
    //     isPlaying: _isPlaying,
    //     onSongSelected: playSong,
    //     togglePlayPause: togglePlayPause,
    //   ),
    //   LibraryScreen(),
    // ];

    _playingSubscription = _audioPlayer.playingStream.listen((isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    });
    // _playingSubscription = widget.audioHandler.playbackState.listen((state) {
    //   setState(() {
    //     _isPlaying = state.playing;
    //   });
    // });
  }

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      selectedIcon: Icon(Icons.music_note),
      icon: Icon(Icons.music_note_outlined),
      label: 'Песни',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.library_music),
      icon: Icon(Icons.library_music_outlined),
      label: 'Библиотека',
    ),
  ];

  // final List<BottomNavigationBarItem> _items = const [
  //   BottomNavigationBarItem(
  //     activeIcon: Icon(Icons.home),
  //     icon: Icon(Icons.home_outlined),
  //     label: 'Home',
  //   ),
  //   BottomNavigationBarItem(
  //     activeIcon: Icon(Icons.music_note),
  //     icon: Icon(Icons.music_note_outlined),
  //     label: 'Songs',
  //   ),
  //   BottomNavigationBarItem(
  //     activeIcon: Icon(Icons.library_music),
  //     icon: Icon(Icons.library_music_outlined),
  //     label: 'Library',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      SongsScreen(
        audioPlayer: _audioPlayer,
        // audioHandler: widget.audioHandler,
        songModel: _currentSong,
        isPlaying: _isPlaying,
        onSongSelected: playSong,
        togglePlayPause: togglePlayPause,
      ),
      LibraryScreen(),
    ];

    return Scaffold(
      body: _screens[_currentScreenIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.indigo,
        selectedIndex: _currentScreenIndex,
        destinations: _destinations,
        onDestinationSelected: (index) =>
            setState(() => _currentScreenIndex = index),
      ),
    );
  }
}
