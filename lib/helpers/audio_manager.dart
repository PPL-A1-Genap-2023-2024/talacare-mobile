import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _bgm = AudioPlayer();
  final AudioSource _bgmSource = AudioSource.uri(Uri.parse("asset:///assets/audio/main_menu.mp3"));

  final AudioPlayer _sfx = AudioPlayer();
  final AudioSource _sfxSource = AudioSource.uri(Uri.parse("asset:///assets/audio/button_sound.mp3"));
  bool _pauseStatus = false;

  factory AudioManager.getInstance() {
    return _instance;
  }

  AudioManager._internal() {
    _initialize();
  }

  AudioPlayer getBGM(){
    return _bgm;
  }

  AudioSource getBGMSong(){
    return _bgmSource;
  }

  AudioPlayer getSFX(){
    return _sfx;
  }

  AudioSource getSFXFile(){
    return _sfxSource;
  }

  Future<void> _initialize() async {
    getBGM().setVolume(0.7);
    await getBGM().setLoopMode(LoopMode.one);
    await getBGM().setAudioSource(getBGMSong());
  }

  void playBackgroundMusic() async {
    if (_pauseStatus){
      getBGM().play();
      _pauseStatus = false;
    } else {
      if (!getBGM().playing) {
        getBGM().play();
      }
    }
  }

  void stopBackgroundMusic() {
    getBGM().stop();
    getBGM().seek(Duration.zero);
  }

  void pauseBackgroundMusic() {
    getBGM().pause();
    _pauseStatus = true;
  }

  Future<void> playSoundEffect([AudioSource? sfx]) async {
    sfx ??= getSFXFile();
    await getSFX().setAudioSource(sfx);
    getSFX().play();
  }
}