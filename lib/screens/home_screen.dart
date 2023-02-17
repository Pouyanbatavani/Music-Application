import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:music_application/controllers/page_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.controller,this._pageManager, {Key? key})
      : super(key: key);

  final PageController controller;
  final PageManager _pageManager;
  late Size size;


  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: ValueListenableBuilder(
              valueListenable: _pageManager.currentSongDetailNotifier,
              builder: (context, MediaItem value, child) {
                if(value.id=='-1'){return Container();}
                else{
                  String image = value.artUri.toString();
                  return Image.network(
                    image,
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.grey[700]?.withOpacity(0.6),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                controller.animateToPage(
                                  0,
                                  duration: const Duration(microseconds: 500),
                                  curve: Curves.easeOut,
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.white,
                              )),
                          const Text(
                            'Now Playing',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_horiz_outlined,
                                size: 30,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // const CircleAvatar(
                    //   radius: 172,
                    //   backgroundColor: Colors.white60,
                    //   child: //برای قالب دور سیرکل
                    ValueListenableBuilder(
                      valueListenable: _pageManager.currentSongDetailNotifier,
                      builder: (context, MediaItem value, child) {
                        if(value.id=='-1'){return Container();}
                        else{
                        String image = value.artUri.toString();
                        return CircleAvatar(
                          radius: 170,
                          backgroundImage: NetworkImage(image),
                        );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable:
                          _pageManager.currentSongDetailNotifier,
                          builder: (context, MediaItem value, child) {
                            String title = value.title;
                            String artist = value.artist??'';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artist,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    )),
                              ],
                            );
                          },
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ValueListenableBuilder<ProgressBarState>(
                        valueListenable: _pageManager.progressNotifier,
                        builder: (context, value, _) {
                          return ProgressBar(
                            progress: value.current,
                            total: value.total,
                            buffered: value.buffered,
                            // value: 20,
                            // onChanged: (value) {},
                            // max: 166,
                            thumbColor: Colors.white,
                            progressBarColor: Colors.orangeAccent,
                            baseBarColor: Colors.grey,
                            thumbGlowColor:
                            Colors.orangeAccent.withOpacity(0.25),
                            timeLabelTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            onSeek: _pageManager.seek,
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //دکمه تکرار با سوییچ و کیس
                        ValueListenableBuilder(
                          valueListenable: _pageManager.repeatStateNotifier,
                          builder: (context,repeatState value, child) {
                         switch(value){
                           case repeatState.off:
                             return IconButton(
                               icon:const Icon(Icons.repeat,size: 35,),
                               color: Colors.white,
                               padding: EdgeInsets.zero,
                               onPressed:_pageManager.onRepeatPressed,
                             );
                           case repeatState.one:
                             return IconButton(
                               icon:const Icon(Icons.repeat_one_rounded,size: 35,),
                               color: Colors.white,
                               padding: EdgeInsets.zero,
                               onPressed:_pageManager.onRepeatPressed,
                             );
                           case repeatState.all:
                             return IconButton(
                               icon:const Icon(Icons.repeat_on_rounded,size: 35,),
                               color: Colors.white,
                               padding: EdgeInsets.zero,
                               onPressed:_pageManager.onRepeatPressed,
                             );
                         }
                          },),
                        ValueListenableBuilder(
                          valueListenable: _pageManager.isFirstSongNotifier,
                          builder: (context, bool value, child) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.skip_previous_rounded, size: 35,),
                              color: Colors.white,
                              onPressed: value ? null : _pageManager
                                  .onPreviousPressed,
                            );
                          },),
                        Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orangeAccent.withOpacity(0.9),
                                    const Color(0xCCF5D081)
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                )),
                            child: ValueListenableBuilder<ButtonState>(
                                valueListenable: _pageManager.buttonNotifier,
                                builder: (context, ButtonState value, _) {
                                  switch (value) {
                                    case ButtonState.loading:
                                      return const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ),
                                      );
                                    case ButtonState.playing:
                                      return IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _pageManager.pause,
                                        icon: const Icon(Icons.pause,
                                            color: Colors.white, size: 40),
                                      );
                                    case ButtonState.paused:
                                      return IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        onPressed: _pageManager.play,
                                      );
                                  }
                                })),
                        ValueListenableBuilder(
                            valueListenable: _pageManager.isLastSongNotifier,
                            builder: (context, bool value, child) {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.skip_next_rounded, size: 35,),
                                color: Colors.white,
                                onPressed: value ? null : _pageManager
                                    .onNextPressed,
                              );
                            }),
                        ValueListenableBuilder(valueListenable: _pageManager.volumeStateNotifier,
                            builder:(context,double value, child) {
                          if(value==0) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.volume_off_rounded, size: 35,),
                              color: Colors.white,
                              onPressed: _pageManager.onVolumePressed,
                            );
                          }
                          else{
                              return IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.volume_up_rounded,size: 35,),
                                color: Colors.white,
                                onPressed: _pageManager.onVolumePressed,
                              );
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
