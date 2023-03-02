import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceCommand extends StatefulWidget {
  const VoiceCommand({Key? key}) : super(key: key);

  @override
  State<VoiceCommand> createState() => _VoiceCommandState();
}

class _VoiceCommandState extends State<VoiceCommand> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool toggle = false;
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent[700],
        title: Text(
          "DC Motor Control App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Text(
              "Press The Button To Talk!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blueAccent[700],
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: double.infinity,
              child: IconButton(
                  constraints: BoxConstraints(
                    minHeight: 150,
                  ),
                  onPressed: () {
                    if (_isListening) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                    setState((() {
                      toggle = !toggle;
                    }));
                  },
                  icon: toggle
                      ? FaIcon(
                          FontAwesomeIcons.microphone,
                          size: 80,
                          color: Colors.blueAccent[700],
                        )
                      : FaIcon(
                          FontAwesomeIcons.microphoneSlash,
                          size: 80,
                          color: Colors.blueAccent[700],
                        )),
            ),
          ],
        ),
      ),
    );
  }

  void _startListening() async {
    if (_isListening) {
      bool available = await _speech.initialize(onStatus: (status) {
        print('status: $status');
      }, onError: (error) {
        print('error: $error');
      });

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            _text = result.recognizedWords;
            _sendCommand(_text);
          }),
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _sendCommand(String command) async {
    List<int> bytes = command.codeUnits;
  }
}
