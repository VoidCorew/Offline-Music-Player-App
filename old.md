```dart
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
                  MiniPlayer(
                    minHeight: 70,
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                    builder: (height, percentage) {
                      return _buildCustomMiniPlayer(height, percentage);
                    },
                  ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: buildMiniPlayer(),
                // ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
```