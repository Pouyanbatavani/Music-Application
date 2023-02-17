import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:music_application/controllers/page_manager.dart';
import 'package:music_application/services/audio_handler.dart';
import 'package:music_application/services/playlist_repository.dart';

GetIt getIt=GetIt.instance;
Future setupInitService() async{
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PlayListRepository>(() =>MyPlaylist());
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}