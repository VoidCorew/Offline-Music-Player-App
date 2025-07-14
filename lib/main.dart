import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:piped_music_player/bloc/songs_bloc.dart';
import 'package:piped_music_player/navigation/main_navigation.dart';
import 'package:piped_music_player/providers/theme_provider.dart';
import 'package:piped_music_player/services/audio_player_handler.dart';
import 'package:provider/provider.dart';

// late final AudioPlayerHandler _audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');

  final audioQuery = OnAudioQuery();

  // _audioHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.naresh.music',
  //     androidNotificationChannelName: 'Music Playback',
  //     androidNotificationOngoing: true,
  //   ),
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // BlocProvider(create: (_) => SongsBloc(audioQuery)..add(LoadSongs())),
        BlocProvider(create: (_) => SongsBloc(audioQuery)),
      ],
      child: MusicPlayerApp(),
    ),
  );
}

class MusicPlayerApp extends StatelessWidget {
  // final AudioPlayerHandler audioHandler;
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.currentTheme,
      home: MainNavigation(),
    );
  }
}
