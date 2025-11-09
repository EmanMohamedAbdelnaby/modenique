import 'package:flutter/material.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceInputWidget extends StatefulWidget {
  final Function(String recognizedText) onTextRecognized;

  const VoiceInputWidget({Key? key, required this.onTextRecognized})
      : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  Future<void> _requestMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
  }

  void _listen() async {
    if (!_isListening) {
      await _requestMicPermission();

      bool available = await _speech.initialize(
        onStatus: (val) => print('🟢 onStatus: $val'),
        onError: (val) => print('🔴 onError: $val'),
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (result) {
            final text = result.recognizedWords;
            widget.onTextRecognized(text);

            if (result.finalResult) {
              setState(() => _isListening = false);
            }
          },
        );
      } else {
        print(" Speech recognition not available");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isListening
            ? Colors.redAccent.withOpacity(0.2)
            : Colors.transparent,
      ),
      child: IconButton(
        icon: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          color: _isListening ? Colors.redAccent : AppColors.primaryColor,
          size: 28,
        ),
        onPressed: _listen,
      ),
    );
  }
}
