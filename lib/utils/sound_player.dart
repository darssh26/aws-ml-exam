import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class SoundPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }

  void playSound(String sound) async {
    // Try to load audio from a source and catch any errors.
    try {
      await _player.setAsset("assets/sounds/$sound");

      _player.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  void dispose() {
    _player.dispose();
  }

  void stopSound() async {
    //await audioPlayer.stopPlayer();
  }

  void playHappySound() {
    playSound("rightSound.mp3");
  }

  void playSadSound() {
    playSound("wrongSound.mp3");
  }
}
