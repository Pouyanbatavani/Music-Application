import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_application/services/audio_service.dart';
import 'package:music_application/services/playlist_repository.dart';

class PageManager {
  final _audioHandler = getIt<AudioHandler>();

  // final AudioPlayer _audioPlayer;
  final progressNotifier = ValueNotifier<ProgressBarState>(ProgressBarState(
      current: Duration.zero, buffered: Duration.zero, total: Duration.zero));
  final buttonNotifier = ValueNotifier(ButtonState.paused);
  final currentSongDetailNotifier =
      ValueNotifier<MediaItem>(const MediaItem(id: '-1', title: ''));
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final repeatStateNotifier = RepeatStateNotifier();
  final volumeStateNotifier = ValueNotifier<double>(1);
  late ConcatenatingAudioSource _playlist;

  PageManager() {
    _init();
  }

  void _init() {
    _loadPlayList();
    _listenChangeInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentSong();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    // _setInitialPlayList();
    // _listenChangePlayerState();
    // _listenChangePositionStream();
    // _listenChangeBufferedPositionStream();
    // _listenChangeTotalDurationStream();
    // _listenSequenceState();
  }

  Future _loadPlayList() async {
    final songRepository = getIt<PlayListRepository>();
    final playList = await songRepository.fetchMyPlaylist();
    final mediaItems = playList
        .map(
          (song) => MediaItem(
            id: song['id'] ?? '-1',
            title: song['title'] ?? '',
            artist: song['artist'] ?? '',
            artUri: Uri.parse(song['artUri'] ?? ''),
            extras: {'url': song['url']},
          ),
        )
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  _listenChangeInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        return;
      }
      final newList = playlist.map((item) => item).toList();
      playlistNotifier.value = newList;
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      }
    });
  }

  _listenToCurrentSong() {
    final playList = _audioHandler.queue.value;
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongDetailNotifier.value =
          mediaItem ?? const MediaItem(id: '-1', title: '');
      if (playList.isEmpty || mediaItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } else {
        isFirstSongNotifier.value = playList.first == mediaItem;
        isLastSongNotifier.value = playList.last == mediaItem;
      }
    });
  }

  _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total);
    });
  }

  _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playBackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: playBackState.bufferedPosition,
          total: oldState.total);
    });
  }

    _listenToTotalDuration() {
      _audioHandler.mediaItem.listen((mediaItem) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: mediaItem!.duration ?? Duration.zero,
        );
      });
    }

  // void _setInitialPlayList() async {
  //   // const prefix = 'assets/images';
  //   // final song1 = Uri.parse(
  //   //     'https://ts10.tarafdari.com/contents/user568385/content-sound/08_because.mp3');
  //   // final song2 = Uri.parse(
  //   //     'https://ts1.tarafdari.com/contents/user299049/content-sound/the_beatles_-_black_albumdedication_to_george_harrison_-_let_it_be_mp3clan.com_.mp3');
  //   // final song3 = Uri.parse(
  //   //     'https://ts1.tarafdari.com/contents/user360184/content-sound/beatles_-_yesterday.mp3');
  //   // final song4 = Uri.parse(
  //   //     'https://ts5.tarafdari.com/contents/user568385/content-sound/289_-_the_beatles_-_cant_buy_me_love.mp3');
  //   // final song5 = Uri.parse(
  //   //     'https://ts12.tarafdari.com/contents/user767191/content-sound/she_s_leaving_home_the_beatles.mp3');
  //   // _playlist = ConcatenatingAudioSource(children: [
  //   //   AudioSource.uri(
  //   //     song1,
  //   //     tag: AudioMetaData(
  //   //         title: 'Because',
  //   //         artist: 'The Beatles',
  //   //         imageAddress: '$prefix/AbbeyRoad.jpg'),
  //   //   ),
  //   //   AudioSource.uri(
  //   //     song2,
  //   //     tag: AudioMetaData(
  //   //         title: 'Let it be',
  //   //         artist: 'The Beatles',
  //   //         imageAddress: '$prefix/beatles.jpg'),
  //   //   ),
  //   //   AudioSource.uri(
  //   //     song3,
  //   //     tag: AudioMetaData(
  //   //         title: 'Yesterday',
  //   //         artist: 'The Beatles',
  //   //         imageAddress: '$prefix/the-beatles-yesterday-parlophone-2.jpg'),
  //   //   ),
  //   //   AudioSource.uri(
  //   //     song4,
  //   //     tag: AudioMetaData(
  //   //         title: 'Cant buy me love',
  //   //         artist: 'The Beatles',
  //   //         imageAddress: '$prefix/beatles-cant.jpg'),
  //   //   ),
  //   //   AudioSource.uri(
  //   //     song5,
  //   //     tag: AudioMetaData(
  //   //         title: "She's leaving home",
  //   //         artist: 'The Beatles',
  //   //         imageAddress: '$prefix/beatles-sheisleavinghome.jpg'),
  //   //   ),
  //   // ]);
  //   if (_audioPlayer.bufferedPosition == Duration.zero) {
  //     await _audioPlayer.setAudioSource(_playlist);
  //   }
  // }
  //
  // void _listenChangePlayerState() {
  //   _audioPlayer.playerStateStream.listen((playerState) {
  //     final playing = playerState.playing;
  //     final processingState = playerState.processingState;
  //     if (processingState == ProcessingState.loading ||
  //         processingState == ProcessingState.buffering) {
  //       buttonNotifier.value = ButtonState.loading;
  //     } else if (!playing) {
  //       buttonNotifier.value = ButtonState.paused;
  //     } else if (processingState == ProcessingState.completed) {
  //       _audioPlayer.stop();
  //     } else {
  //       buttonNotifier.value = ButtonState.playing;
  //     }
  //   });
  // }
  //
  // void _listenChangePositionStream() {
  //   _audioPlayer.positionStream.listen((position) {
  //     final oldState = progressNotifier.value;
  //     progressNotifier.value = ProgressBarState(
  //         current: position,
  //         buffered: oldState.buffered,
  //         total: oldState.total);
  //   });
  // }
  //
  // void _listenChangeBufferedPositionStream() {
  //   _audioPlayer.bufferedPositionStream.listen((position) {
  //     final oldState = progressNotifier.value;
  //     progressNotifier.value = ProgressBarState(
  //         current: oldState.current, buffered: position, total: oldState.total);
  //   });
  // }
  //
  // void _listenChangeTotalDurationStream() {
  //   _audioPlayer.durationStream.listen((position) {
  //     final oldState = progressNotifier.value;
  //     progressNotifier.value = ProgressBarState(
  //         current: oldState.current,
  //         buffered: oldState.buffered,
  //         total: position ?? Duration.zero);
  //   });
  // }
  //
  // void _listenSequenceState() {
  //   _audioPlayer.sequenceStateStream.listen((sequenceState) {
  //     if (sequenceState == null) {
  //       return;
  //     }
  //     //update current song detail
  //     final currentItem = sequenceState.currentSource;
  //     final song = currentItem!.tag as AudioMetaData;
  //     currentSongDetailNotifier.value = song;
  //
  //     //update playlist
  //     final playlist = sequenceState.effectiveSequence;
  //     final title = playlist.map((song) {
  //       return song.tag as AudioMetaData;
  //     }).toList();
  //     playlistNotifier.value = title;
  //
  //     // UPDATE previous and next button
  //     if (playlist.isEmpty || currentItem == null) {
  //       isFirstSongNotifier.value = true;
  //       isLastSongNotifier.value = true;
  //     } else {
  //       isFirstSongNotifier.value = playlist.first == currentItem;
  //       isLastSongNotifier.value = playlist.last == currentItem;
  //     }
  //     if (_audioPlayer.volume != 0) {
  //       volumeStateNotifier.value = 1;
  //     } else {
  //       volumeStateNotifier.value = 0;
  //     }
  //   });
  // }

  void play() {
    _audioHandler.play();
  }

  void pause() {
    _audioHandler.pause();
  }

  void seek(position) {
    _audioHandler.seek(position);
  }

  void playFromPlaylist(int index) {
    _audioHandler.skipToQueueItem(index);
  }

  void onPreviousPressed() {
    _audioHandler.skipToPrevious();
  }

  void onNextPressed() {
    _audioHandler.skipToNext();
  }

  void onRepeatPressed() {
    repeatStateNotifier.nextState();
    switch (repeatStateNotifier.value) {
      case repeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case repeatState.one:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case repeatState.all:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  //Volume
  void onVolumePressed() {
    if (volumeStateNotifier.value != 0) {
      _audioHandler.androidSetRemoteVolume(0);
      volumeStateNotifier.value = 0;
    } else {
      _audioHandler.androidSetRemoteVolume(1);
      volumeStateNotifier.value = 1;
    }
  }
}

// class AudioMetaData {
//   final String title;
//   final String artist;
//   final String imageAddress;
//
//   AudioMetaData(
//       {required this.title, required this.artist, required this.imageAddress});
// }

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(
      {required this.current, required this.buffered, required this.total});
}

enum ButtonState { paused, playing, loading }

enum repeatState { one, all, off }

class RepeatStateNotifier extends ValueNotifier<repeatState> {
  RepeatStateNotifier() : super(_initialValue);
  static const _initialValue = repeatState.off;

  void nextState() {
    var next = (value.index + 1) % repeatState.values.length;
    value = repeatState.values[next];
  }
}
