import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SoundPoolUtil {

  static final SoundPoolUtil _singleton = SoundPoolUtil._internal();

  factory SoundPoolUtil() {
    return _singleton;
  }

  SoundPoolUtil._internal();

  late Soundpool pool;
  SoundpoolOptions _soundpoolOptions = SoundpoolOptions();

  int? _alarmSoundStreamId;
  int _cheeringStreamId = -1;
  bool isInitized = false;

  Soundpool get _soundpool => pool;

  void initState() {
    if (isInitized){
      return;
    }
    pool = Soundpool.fromOptions(options: SoundpoolOptions());

    _loadSounds();
    isInitized = true;
  }

  void _loadSounds() {
    // _soundId = _loadSound();
    _cheeringId = loadCheering();
  }


  double _volume = 1.0;
  double _rate = 1.0;
  late Future<int> _soundId;
  late Future<int> _cheeringId;

  Future<int> loadSound() async {
    var asset = await rootBundle.load("sounds/do-you-like-it.wav");
    // var asset = await rootBundle.load("sounds/barcodebeep.ogg");

    return await _soundpool.load(asset);
  }

  Future<int> loadCheering() async {
    var asset = await rootBundle.load("assets/sounds/barcodebeep.ogg");

    return await _soundpool.load(asset);
    // return await _soundpool.loadUri(_cheeringUrl);
  }

  Future<void> playSound() async {
    var _alarmSound = await _soundId;
    _alarmSoundStreamId = await _soundpool.play(_alarmSound);
  }

  Future<void> pauseSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool.pause(_alarmSoundStreamId!);
    }
  }

  Future<void> stopSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool.stop(_alarmSoundStreamId!);
    }
  }

  Future<void> playCheering() async {
    var _sound = await _cheeringId;
    _cheeringStreamId = await _soundpool.play(
      _sound,
      rate: _rate,

    );
  }

  Future<void> updateCheeringRate() async {
    if (_cheeringStreamId > 0) {
      await _soundpool.setRate(
          streamId: _cheeringStreamId, playbackRate: _rate);
    }
  }

  Future<void> updateVolume(newVolume) async {
    // if (_alarmSound >= 0){
    var _cheeringSound = await _cheeringId;
    _soundpool.setVolume(soundId: _cheeringSound, volume: newVolume);
    // }
  }
}
