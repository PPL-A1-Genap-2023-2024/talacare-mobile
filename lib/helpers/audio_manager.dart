import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _bgm = AudioPlayer();
  final AudioSource _source = AudioSource.uri(Uri.parse("asset:///assets/audio/bgm_game.mp3"));
  bool _pauseStatus = false;

  factory AudioManager.getInstance() {
    return _instance;
  }

  AudioManager._internal() {
    _initialize();
  }

  AudioPlayer getPlayer(){
    return _bgm;
  }

  AudioSource getSong(){
    return _source;
  }

  Future<void> _initialize() async {
    await getPlayer().setLoopMode(LoopMode.one);
    await getPlayer().setAudioSource(getSong());
  }

  void playBackgroundMusic() async {
    if (_pauseStatus){
      getPlayer().play();
      _pauseStatus = false;
    } else {
      if (!getPlayer().playing) {
        getPlayer().play();
      }
    }
  }

  void stopBackgroundMusic() {
    getPlayer().stop();
    getPlayer().seek(Duration.zero);
  }

  void pauseBackgroundMusic() {
    getPlayer().pause();
    _pauseStatus = true;
  }
}