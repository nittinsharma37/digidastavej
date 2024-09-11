import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../controllers/details_controller.dart';
import '../../data/models/document_model.dart';

class DetailsView extends StatelessWidget {
  DetailsView({super.key});

  final DetailsController controller = Get.put(DetailsController());

  @override
  Widget build(BuildContext context) {
    print(controller.document.value.title);
    print(controller.document.value.documentType);
    print(controller.document.value.filePath);
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.document.value.title)),
      ),
      body: Obx(() {
        final doc = controller.document.value;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Title: ${doc.title}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Description: ${doc.description ?? "No description"}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              if (doc.expiryDate != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Expiry Date: ${doc.expiryDate}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              if (doc.filePath != null && doc.filePath!.isNotEmpty)
                _buildFileView(doc)
              else
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No file selected or file path is empty'),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFileView(DocumentModel document) {
    final DetailsController controller = Get.find();

    switch (document.documentType) {
      case 'pdf':
        return SizedBox(
          height: 300,
          child: PDFView(
            filePath: document.filePath!,
            autoSpacing: false,
            enableSwipe: true,
            swipeHorizontal: true,
            pageSnap: true,
            pageFling: true,
            onRender: (_pages) => print('PDF Rendered'),
            onError: (error) => print('Error: $error'),
            onPageError: (page, error) => print('Page error: $error'),
          ),
        );
      case 'image':
        return Image.file(File(document.filePath!));
      case 'video':
        return Obx(() {
          final controller = Get.find<DetailsController>();
          // print(controller.videoController.value.isInitialized);
          if (controller.isVideoInitialised.value) {
            if (controller.videoController.value.isInitialized) {
              return AspectRatio(
                aspectRatio: controller.videoController.value.aspectRatio,
                child: VideoPlayer(controller.videoController),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
      case 'audio':
        return Obx(() {
          final isPlaying = controller.isAudioPlaying.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.playAudio();
                },
                child: Text(isPlaying ? 'Pause Audio' : 'Play Audio'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.stopAudio();
                },
                child: const Text('Stop Audio'),
              ),
            ],
          );
        });
      default:
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('File type not supported',
              style: TextStyle(color: Colors.red)),
        );
    }
  }
}
