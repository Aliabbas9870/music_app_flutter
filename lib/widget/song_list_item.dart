import 'package:flutter/material.dart';
import 'package:musicplay/controller/audio_controller.dart';
import 'package:musicplay/model/local_song_model.dart';
import 'package:musicplay/widget/my_button.dart';
import 'package:musicplay/widget/my_container.dart';

class SongListItem extends StatefulWidget {
  final LocalSongModel songs;
  final index;

  const SongListItem({super.key, required this.songs, required this.index});

  @override
  State<SongListItem> createState() => _SongListItemState();
}

class _SongListItemState extends State<SongListItem> {
  String formatSong(int milliseconds) {
    final second = (milliseconds / 60000).floor();
    final mints = ((milliseconds % 60000) / 1000).floor();

    return "$mints:${second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final AudioController audioController = AudioController();
    return ValueListenableBuilder(
        valueListenable: audioController.currentIndex,
        builder: (context, currentIndex, child) {
          return ValueListenableBuilder(
              valueListenable: audioController.isPlay,
              builder: (context, isplay, child) {
                final currentSong = currentIndex = widget.index;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: MyContainer(
                    
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        child: Icon(Icons.music_note_outlined),
                      ),
                      title: Text(widget.songs.title),
                      subtitle: Text(widget.songs.Artist),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatSong(widget.songs.duration),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          MyButton(
                            child: Icon(
                              currentSong && isplay
                                  ? Icons.pause
                                  : Icons.play_circle,
                              color: currentSong && isplay
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            onpress: () {

                               audioController.playSongs(widget.index);
                            },
                            btnbackground: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
