import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_application/controllers/page_manager.dart';

class MainScreen extends StatelessWidget {
  const MainScreen(this._pageManager, this.pageController, {Key? key})
      : super(key: key);

  final PageController pageController;
  final PageManager _pageManager;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      Container(
        height: 80.0,
        width: double.infinity,
        color: Colors.grey,
        child: const Center(
          child: Text(
            'Playlist',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      Expanded(
        child: ValueListenableBuilder(
          valueListenable: _pageManager.playlistNotifier,
          builder: (context, List<MediaItem> song, child) {
            if(song.isEmpty){return Container();}
            else{
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: song.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    child: ListTile(
                      tileColor: Colors.grey.shade200,
                      title: Text(song[index].title),
                      subtitle: Text(song[index].artist??''),
                      onTap: () {
                        pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds:300),
                            curve: Curves.easeInOut);
                        _pageManager.playFromPlaylist(index);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
          ValueListenableBuilder(
        valueListenable: _pageManager.currentSongDetailNotifier,
        builder: (context, MediaItem  audio, _) {
          if(audio.id=='1'){return Container();}
          else{
          return Container(
            color: Colors.grey.shade300,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                  radius: 45,
                  backgroundImage:NetworkImage(audio.artUri.toString())),
              title: Text(audio.title),
              subtitle: Text(audio.artist??''),
              trailing:Padding(
                padding: const EdgeInsets.only(right: 20.0),
                  child: ValueListenableBuilder(
                      valueListenable: _pageManager.buttonNotifier,
                      builder: (context, ButtonState value, _) {
                        switch (value) {
                          case ButtonState.loading:
                            return const SizedBox(width: 30,height: 30,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Colors.black),
                              ),
                            );
                          case ButtonState.playing:
                            return IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: _pageManager.pause,
                              icon: const Icon(Icons.pause_circle_outline_rounded,
                                  color: Colors.black, size: 40),
                            );
                          case ButtonState.paused:
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.black,
                                size: 40,
                              ),
                              onPressed: _pageManager.play,
                            );
                        }
                      },
                  ),
              ),
            ));
          }
        },
      )
    ],
    ),
    );
  }
}
