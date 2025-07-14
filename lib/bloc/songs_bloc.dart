import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class SongsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSongs extends SongsEvent {}

abstract class SongsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SongsInitial extends SongsState {}

class SongsLoading extends SongsState {}

class SongsLoaded extends SongsState {
  final List<SongModel> songs;

  SongsLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class SongsError extends SongsState {
  final String message;

  SongsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  final OnAudioQuery _audioQuery;

  SongsBloc(this._audioQuery) : super(SongsInitial()) {
    on<LoadSongs>(_onLoadSongs);
  }

  Future<void> _onLoadSongs(LoadSongs event, Emitter<SongsState> emit) async {
    if (state is SongsLoaded) return;

    emit(SongsLoading());

    try {
      // final status = await _requestPermission();

      // if (!status) {
      //   emit(SongsError('Нет разрешения на доступ к музыке'));
      //   return;
      // }

      final songs = await _audioQuery.querySongs();
      emit(SongsLoaded(songs));
    } catch (e) {
      emit(SongsError(e.toString()));
    }
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) return true;

    final result = await Permission.storage.request();
    return result.isGranted;
  }
}
