import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  late FlutterTts _flutterTts;
  bool _isAvailable = true;

  TtsService._internal() {
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      _isAvailable = false;
      if (kDebugMode) {
        print('TTS not available on this platform: $e');
      }
    }
  }

  Future<void> speak(String text) async {
    if (!_isAvailable || text.isEmpty) return;

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      if (kDebugMode) {
        print('TTS speak error: $e');
      }
    }
  }

  Future<void> stop() async {
    if (!_isAvailable) return;

    try {
      await _flutterTts.stop();
    } catch (e) {
      if (kDebugMode) {
        print('TTS stop error: $e');
      }
    }
  }
}
