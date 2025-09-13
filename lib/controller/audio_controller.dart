import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplay/model/local_song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioController {
  static final AudioController instance = AudioController._instance();

  factory AudioController() => instance;
  AudioController._instance() {
    _setupAudioPlayer();
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final ValueNotifier<bool> isPlay = ValueNotifier<bool>(false);
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(-1);
  final ValueNotifier<List<LocalSongModel>> songs =
      ValueNotifier<List<LocalSongModel>>([]);

  /// Get the currently playing song (if valid index)
  LocalSongModel? get currentSong =>
      currentIndex.value != -1 && currentIndex.value < songs.value.length
          ? songs.value[currentIndex.value]
          : null;

  /// Setup audio player listeners
  void _setupAudioPlayer() {
    audioPlayer.playerStateStream.listen((playerState) {
      isPlay.value = playerState.playing;

      if (playerState.processingState == ProcessingState.completed) {
        if (currentIndex.value < songs.value.length - 1) {
          playSongs(currentIndex.value + 1); // go to next song
        } else {
          currentIndex.value = -1;
          isPlay.value = false;
        }
      }
    });

    audioPlayer.positionStream.listen((_) {
      isPlay.notifyListeners();
    });
  }

  /// Load songs from device
  Future<void> loadSongs() async {
    final fetchSong = await onAudioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    songs.value = fetchSong
        .map((s) => LocalSongModel(
              id: s.id,
              url: s.uri ?? "",
              title: s.title,
              Artist: s.artist ?? "Unknown",
              AlbumArt: s.album ?? "",
              duration: s.duration ?? 0,
            ))
        .toList();
  }

  /// Play song by index
  Future<void> playSongs(int index) async {
    if (index < 0 || index >= songs.value.length) return;

    try {
      if (currentIndex.value == index && isPlay.value) {
        await pauseSong();
        return;
      }

      currentIndex.value = index;
      final song = songs.value[index];

      await audioPlayer.stop();
      await audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(song.url)),
        preload: true,
      );
      await audioPlayer.play();
      isPlay.value = true;
    } catch (e) {
      print("❌ Error while playing: $e");
    }
  }

  /// Pause song
  Future<void> pauseSong() async {
    await audioPlayer.pause();
    isPlay.value = false;
  }

  /// Resume song
  Future<void> resumeSong() async {
    await audioPlayer.play();
    isPlay.value = true;
  }

  /// Toggle play / pause
  void togglePlayPause() async {
    if (currentIndex.value == -1) return;
    try {
      if (isPlay.value) {
        await pauseSong();
      } else {
        await resumeSong();
      }
    } catch (e) {
      print("❌ Error in toggle: $e");
    }
  }

  Future<void> nextSong() async {
    if (currentIndex.value < songs.value.length - 1) {
      await playSongs(currentIndex.value + 1);
    }
  }


   Future<void> previousSong() async {
    if (currentIndex.value <  0) {
      await playSongs(currentIndex.value -1);
    }
  }

  void dispose(){
   audioPlayer.dispose();
    }
}
