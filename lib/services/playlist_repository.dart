abstract class PlayListRepository{
  Future<List<Map<String,String>>> fetchMyPlaylist();
}
class MyPlaylist extends PlayListRepository{
  @override
  Future<List<Map<String, String>>> fetchMyPlaylist() async{
    const song1 =
        'https://ts10.tarafdari.com/contents/user568385/content-sound/08_because.mp3';
    const song2 =
        'https://ts1.tarafdari.com/contents/user299049/content-sound/the_beatles_-_black_albumdedication_to_george_harrison_-_let_it_be_mp3clan.com_.mp3';
    const song3 =
        'https://ts1.tarafdari.com/contents/user360184/content-sound/beatles_-_yesterday.mp3';
    const song4 =
        'https://ts5.tarafdari.com/contents/user568385/content-sound/289_-_the_beatles_-_cant_buy_me_love.mp3';
    const song5 =
        'https://ts12.tarafdari.com/contents/user767191/content-sound/she_s_leaving_home_the_beatles.mp3';
  return [
    {
      'id':'0',
      'title': 'Because',
      'artist': 'The Beatles',
      'artUri':'http://res.cloudinary.com/ybmedia/image/upload/c_crop,h_1000,w_1000,x_0,y_0/c_scale,f_auto,q_auto,w_700/v1/m/0/6/065fe874298662a7127bb961c226e8219b5ba730/05AbbeyRoad.jpg',
      'url':song1,
    },
    {
    'id':'1',
    'title': 'Let it be',
    'artist': 'The Beatles',
      'artUri':'https://upload.wikimedia.org/wikipedia/en/2/25/LetItBe.jpg',
    'url':song2,
    },
    {
    'id':'2',
    'title': 'Yesterday',
    'artist': 'The Beatles',
    'artUri':'https://m.media-amazon.com/images/M/MV5BMjM3ZTg0NWYtMDZlYy00OTkyLWIwNmUtYTQxZDIwMWNmYTczXkEyXkFqcGdeQW1pYnJ5YW50._V1_.jpg',
    'url':song3,
    },
    {
    'id':'3',
    'title': 'Cant buy me love',
    'artist': 'The Beatles',
    'artUri':'https://cdn.vox-cdn.com/thumbor/saYmfG9Dytmje1SMolEA2gSDmLA=/1400x788/filters:format(jpeg)/cdn.vox-cdn.com/uploads/chorus_asset/file/23086685/beatles_getback_disney_ringer.jpeg',
    'url':song4,
    },
    {
    'id':'4',
    'title': "She's leaving home",
    'artist': 'The Beatles',
    'artUri':'https://www.ndr.de/wellenord/beatles10_v-contentgross.jpg',
    'url':song5,

    },
  ];
  }

}