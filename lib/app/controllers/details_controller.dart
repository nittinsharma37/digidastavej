import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:digidastavej/app/data/models/document_model.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class DetailsController extends GetxController {
  final Rx<DocumentModel> document = Rx<DocumentModel>(DocumentModel(
      id: '', title: '', description: '', documentType: '', filePath: ''));

  late VideoPlayerController videoController;
  Rx<bool> isVideoInitialised = false.obs;
  Rx<bool> isVideoPlaying = false.obs;
  late ChewieController chewieController;

  final AudioPlayer audioPlayer = AudioPlayer();
  Rx<bool> isAudioPlaying = false.obs;
  RxDouble audioProgress = 0.0.obs;
  Rx<Duration> audioCurrentPosition = Duration.zero.obs;
  Rx<Duration> audioTotalDuration = Duration.zero.obs;

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
              chewieController = ChewieController(
                videoPlayerController: videoController,
                aspectRatio: videoController.value.aspectRatio,
                autoPlay: false,
                looping: false,
                showControls: true,
                allowFullScreen: true,
              );
              update();
            });
    }
  }

  void playAudio() async {
    if (!isAudioPlaying.value) {
      await audioPlayer.play(DeviceFileSource(document.value.filePath!));
      isAudioPlaying.value = true;

      audioTotalDuration.value =
          await audioPlayer.getDuration() ?? Duration.zero;

      audioPlayer.onPositionChanged.listen((Duration position) {
        audioCurrentPosition.value = position;
        audioProgress.value =
            position.inMilliseconds / audioTotalDuration.value.inMilliseconds;
      });

      audioPlayer.onPlayerComplete.listen((_) {
        isAudioPlaying.value = false;
        audioCurrentPosition.value = Duration.zero;
        audioProgress.value = 0.0;
      });
    }
  }

  void pauseAudio() async {
    await audioPlayer.pause();
    isAudioPlaying.value = false;
  }

  void stopAudio() async {
    await audioPlayer.stop();
    isAudioPlaying.value = false;
    audioCurrentPosition.value = Duration.zero;
    audioProgress.value = 0.0;
  }

  @override
  void onClose() {
    if (document.value.documentType == 'video') {
      videoController.dispose();
      isVideoInitialised.value = false;
      chewieController.dispose();
    }

    audioPlayer.dispose();
    super.onClose();
  }
}
