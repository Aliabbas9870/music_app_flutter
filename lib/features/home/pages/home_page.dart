import 'package:flutter/material.dart';
import 'package:musicplay/controller/audio_controller.dart';
import 'package:musicplay/core/theme/app_color.dart';
import 'package:musicplay/widget/my_button.dart';
import 'package:musicplay/widget/song_list_item.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioController audioController = AudioController();
  bool _haspermission = false;
  Future<void> checkPermission() async {
    final permission = await Permission.audio.status;
    if (permission.isGranted) {
      setState(() {
        _haspermission = true;
      });

      await audioController.loadSongs();
    } else {
      final result = await Permission.audio.request();
      setState(() {
        _haspermission = true;
      });
      if (result.isGranted) {
        await audioController.loadSongs();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        actions: [
          MyButton(child: Icon(Icons.favorite,color: AppColor.background,), onpress: () {}),
          SizedBox(
            width: 10,
          ),
          MyButton(child: Icon(Icons.settings,color: AppColor.background,), onpress: () {}),
          SizedBox(
            width: 10,
          ),
        ],
        toolbarHeight: 100,
        leading: MyButton(child: Icon(Icons.person,color: AppColor.background,), onpress: () {}),
        title: RichText(
            text: TextSpan(children: [
          TextSpan(text: "tune",style:TextStyle(color: AppColor.light,fontSize: 30)),
          TextSpan(text: "sync"  ,style:TextStyle(color: AppColor.warning,fontSize: 27)),
        ])),
      ),
      body: ValueListenableBuilder(
          valueListenable: audioController.songs,
          builder: (context, songs, child) {
            if (songs.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.warning,
                  strokeWidth: 9,
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return SongListItem(songs: songs[index], index: index);
                  });
            }
          }),
    );
  }
}
