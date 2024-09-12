import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:digidastavej/app/data/models/document_model.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class DetailsController extends GetxController {
  final Rx<DocumentModel> document = Rx<DocumentModel>(DocumentModel(
      id: '', title: '', description: '', documentType: '', filePath: ''));

  late VideoPlayerController videoController;
  final AudioPlayer audioPlayer = AudioPlayer();
  Rx<bool> isAudioPlaying = false.obs;
  Rx<bool> isVideoInitialised = false.obs;
  Rx<bool> isVideoPlaying = false.obs;

  // Define the audio progress property
  RxDouble audioProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    final doc = Get.arguments as DocumentModel;
    document.value = doc;
    _initializeMedia();
  }

  void _initializeMedia() async {
    if (document.value.documentType == 'video' &&
        document.value.filePath != null) {
      videoController =
          VideoPlayerController.file(File(document.value.filePath!))
            ..initialize().then((_) {
              isVideoInitialised.value = true;
              update();
              isVideoPlaying.value = true;
              // videoController.play();
            });
    }
  }

  void playAudio() async {
    if (isAudioPlaying.value) {
      await audioPlayer.stop();
      isAudioPlaying.value = false;
    } else {
      await audioPlayer.play(DeviceFileSource(document.value.filePath!));
      isAudioPlaying.value = true;
      var duration = await audioPlayer.getDuration();

      // Listen to audio player's position to update the progress
      audioPlayer.onPositionChanged.listen((Duration position) {
        if (duration != null) {
          audioProgress.value =
              position.inMilliseconds / duration!.inMilliseconds;
        }
      });

      audioPlayer.onDurationChanged.listen((Duration duration) {
        // Handle the duration change
        print('Audio duration: ${duration.inMilliseconds} milliseconds');
      });
    }
  }

  void stopAudio() async {
    await audioPlayer.stop();
    isAudioPlaying.value = false;
    audioProgress.value = 0.0; // Reset progress when audio stops
  }

  @override
  void onClose() {
    if (document.value.documentType == 'video') {
      videoController.dispose();
      isVideoInitialised.value = false;
    }
    audioPlayer.dispose();
    super.onClose();
  }
}
