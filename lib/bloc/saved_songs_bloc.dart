import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:piped_music_player/bloc/songs_bloc.dart';
import 'package:piped_music_player/hive_models/save_song.dart';

class LoadSavedSongs extends SongsEvent {}

class SavedSongsLoaded extends SongsState {
  final List<SaveSong> songs;
  SavedSongsLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class SavedSongsBloc extends Bloc<SongsEvent, SongsState> {
  SavedSongsBloc() : super(SongsInitial()) {
    on<LoadSavedSongs>(_onLoadSavedSongs);
  }

  Future<void> _onLoadSavedSongs(
    LoadSavedSongs event,
    Emitter<SongsState> emit,
  ) async {
    emit(SongsLoading());

    try {
      final box = Hive.box<SaveSong>('savedSongs');
      final songs = box.values.toList();
      emit(SavedSongsLoaded(songs));
    } catch (e) {
      emit(SongsError('Ошибка загрузки: $e'));
    }
  }
}
