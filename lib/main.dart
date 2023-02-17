
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_application/controllers/page_manager.dart';
import 'package:music_application/screens/home_screen.dart';
import 'package:music_application/screens/main_screen.dart';
import 'package:music_application/services/audio_service.dart';

void main() async{
  await setupInitService();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  AudioPlayer audioPlayer=AudioPlayer();
  PageController controller=PageController(
    initialPage: 0,
  );
  PageManager get pageManager => PageManager();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Ubuntu'),
      home: Scaffold(
          body: PageView(
            controller:controller ,
            scrollDirection: Axis.vertical,
            children: [
              MainScreen(pageManager,controller),
              HomeScreen(controller,pageManager),
            ],
          )),
    );
  }
}


