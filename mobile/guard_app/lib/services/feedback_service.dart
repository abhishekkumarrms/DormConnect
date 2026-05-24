import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class FeedbackService {
  final AudioPlayer _player = AudioPlayer();
  bool _disposed = false;

  Future<void> successFeedback() async {
    if (_disposed) return;
    await Future.wait([
      _playBeep(),
      _vibrate([0, 100]),
    ]);
  }

  Future<void> errorFeedback() async {
    if (_disposed) return;
    await Future.wait([
      _vibrate([0, 200, 100, 200]),
    ]);
  }

  Future<void> _playBeep() async {
    try {
      await _player.play(AssetSource('beep.mp3'));
    } catch (_) {}
  }

  Future<void> _vibrate(List<int> pattern) async {
    try {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (!hasVibrator) return;
      if (pattern.length > 2) {
        await Vibration.vibrate(pattern: pattern);
      } else {
        await Vibration.vibrate(duration: pattern.last);
      }
    } catch (_) {}
  }

  void dispose() {
    _disposed = true;
    _player.dispose();
  }
}
