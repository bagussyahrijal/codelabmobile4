import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  final SpeechToText _speech = SpeechToText();

  var isListening = false.obs;
  var text = "".obs;

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech status: $status"),
      onError: (error) => print("Speech error: $error"),
    );

    if (!available) {
      print("Speech recognition not available.");
    }
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void startListening() async {
    await checkMicrophonePermission();
    if (await Permission.microphone.isGranted) {
      isListening.value = true;
      _speech.listen(
        onResult: (result) {
          text.value = result.recognizedWords;
          print("Recognized words: ${result.recognizedWords}");
        },
      );
    } else {
      print("Microphone permission denied.");
    }
  }

  void stopListening() async {
    isListening.value = false;
    _speech.stop();
    print("Listening stopped.");
  }
}
