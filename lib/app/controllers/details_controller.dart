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
  var isAudioPlaying = false.obs;
  Rx<bool> isVideoInitialised = false.obs;

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
              videoController.play();
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
    }
  }

  void stopAudio() async {
    await audioPlayer.stop();
    isAudioPlaying.value = false;
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
