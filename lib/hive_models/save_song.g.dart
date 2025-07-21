// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_song.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveSongAdapter extends TypeAdapter<SaveSong> {
  @override
  final int typeId = 0;

  @override
  SaveSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveSong(
      artwork: (fields[0] as List).cast<Uint8List?>(),
      title: fields[1] as String,
      thumbnail: fields[2] as String,
      url: fields[3] as String,
      uploader: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SaveSong obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.artwork)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnail)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.uploader);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
