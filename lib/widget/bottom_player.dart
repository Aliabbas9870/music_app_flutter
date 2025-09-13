import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:musicplay/controller/audio_controller.dart';
import 'package:musicplay/widget/my_button.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController();

    return ValueListenableBuilder(
        valueListenable: audioController.currentIndex,
        builder: (context, currentIndex, _) {
          final currentSong = audioController.currentSong;
          if (currentSong == null) return const SizedBox.shrink();
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.amber,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(4, 4), blurRadius: 3, spreadRadius: 1),
                    BoxShadow(
                        offset: Offset(-4, -4), blurRadius: 3, spreadRadius: 1)
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30,
                    child: Marquee(
                      text: currentSong.title.toString().split('/').last,
                      startPadding: 20,
                      velocity: 10,
                      blankSpace: 40,
                    ),
                  ),
                  StreamBuilder<Duration>(
                      stream: audioController.audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = audioController.audioPlayer.duration ??
                            Duration.zero;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProgressBar(
                            progress: position,
                            total: duration,
                            thumbColor: Colors.purple,
                            barHeight: 3,
                            thumbRadius: 6,
                            timeLabelLocation: TimeLabelLocation.none,
                            onSeek: (duration) {
                              audioController.audioPlayer.seek(duration);
                            },
                          ),
                        );
                      }),
                  Row(
                    children: [
                      SizedBox(
                        child: Lottie.asset(
                          'animation/splash.json',
                          width: 400,
                          height: 400,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: SizedBox()),
                      Row(
                        children: [
                          MyButton(
                              child: Icon(Icons.skip_previous),
                              onpress: audioController.previousSong,
                              btnbackground: Colors.transparent),
                          SizedBox(
                            width: 14,
                          ),
                          StreamBuilder(
                              stream:
                                  audioController.audioPlayer.playerStateStream,
                              builder: (context, snapshot) {
                                final playerState = snapshot.data;
                                final processingState =
                                    playerState?.processingState;
                                final player = playerState?.playing;
                                if (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering) {
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          Colors.deepPurple),
                                    ),
                                  );
                                }
                                return MyButton(
                                    child: Icon(player == true
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                    onpress: audioController.pauseSong,
                                    btnbackground: Colors.black38);
                              }),
                          SizedBox(
                            width: 20,
                          ),
                          MyButton(
                              child: Icon(Icons.skip_next),
                              onpress: audioController.nextSong,
                              btnbackground: Colors.amber)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
