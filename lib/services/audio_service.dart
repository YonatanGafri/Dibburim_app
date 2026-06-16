import 'package:audioplayers/audioplayers.dart';
import '../config/constants.dart';

/// Manages ambient background audio and completion chime playback.
class AudioService {
  final AudioPlayer _ambientPlayer = AudioPlayer();
  final AudioPlayer _chimePlayer = AudioPlayer();
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  /// Play the ambient background sound on loop at low volume.
  Future<void> playAmbient() async {
    try {
      await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
      await _ambientPlayer.setVolume(0.3);
      await _ambientPlayer.play(AssetSource(AppConstants.ambientAudioPath));
    } catch (e) {
      // Audio file may not exist yet — fail silently for MVP.
    }
  }

  /// Stop the ambient background sound.
  Future<void> stopAmbient() async {
    await _ambientPlayer.stop();
  }

  /// Toggle mute/unmute for the ambient player.
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _ambientPlayer.setVolume(_isMuted ? 0.0 : 0.3);
  }

  /// Play the completion chime sound once.
  Future<void> playChime() async {
    try {
      await _chimePlayer.setVolume(0.5);
      await _chimePlayer.play(AssetSource(AppConstants.chimeAudioPath));
    } catch (e) {
      // Audio file may not exist yet — fail silently for MVP.
    }
  }

  /// Clean up audio resources.
  Future<void> dispose() async {
    await _ambientPlayer.dispose();
    await _chimePlayer.dispose();
  }
}
