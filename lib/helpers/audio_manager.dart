import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _bgm = AudioPlayer();
  final AudioSource _source = AudioSource.uri(Uri.parse("asset:///assets/audio/mainmenu.mp3"));
  final AudioPlayer _sfx = AudioPlayer();
  final AudioSource _sfxSource = AudioSource.uri(Uri.parse("asset:///assets/audio/button_sound.mp3"));
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

  AudioPlayer getSFX(){
    return _sfx;
  }

  AudioSource getSFXFile(){
    return _sfxSource;
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

  Future<void> playSoundEffect(AudioSource? sfx) async {
    sfx ??= getSFXFile();
    await getSFX().setAudioSource(sfx);
    getSFX().play();
  }

}