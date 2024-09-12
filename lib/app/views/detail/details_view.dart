import 'dart:io';
import 'package:digidastavej/app/controllers/details_controller.dart';
import 'package:digidastavej/app/data/models/document_model.dart';
import 'package:digidastavej/app/utils/date_format.dart';
import 'package:excel/excel.dart' as excelPlugin;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class DetailsView extends StatelessWidget {
  DetailsView({super.key});

  final DetailsController controller = Get.put(DetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.document.value.title)),
        centerTitle: true,
      ),
      body: Obx(() {
        final doc = controller.document.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                title: 'Title: ${doc.title}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              _buildSectionTitle(
                title: 'Description: ${doc.description}',
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              if (doc.expiryDate != null)
                _buildSectionTitle(
                  title:
                      'Expiry Date: ${formatDate(doc.expiryDate.toString())}',
                  style: const TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
              if (doc.filePath != null && doc.filePath!.isNotEmpty)
                _buildFileView(doc, context)
              else
                _buildSectionTitle(
                  title: 'No file selected or file path is empty',
                  style: const TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle({required String title, required TextStyle style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: style,
      ),
    );
  }

  Widget _buildFileView(DocumentModel document, BuildContext context) {
    final DetailsController controller = Get.find();

    switch (document.documentType) {
      case 'pdf':
        return _buildPdfView(document, context);
      case 'excel':
        return _buildExcelView(document, context);
      case 'image':
        return _buildImageView(document);
      case 'video':
        return _buildVideoView(controller, context);
      case 'audio':
        return _buildAudioView(controller);
      default:
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('File type not supported',
              style: TextStyle(color: Colors.red, fontSize: 16)),
        );
    }
  }

  Widget _buildPdfView(DocumentModel document, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 1)
        ],
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: PDFView(
          filePath: document.filePath!,
          autoSpacing: false,
          enableSwipe: true,
          swipeHorizontal: false,
          pageSnap: false,
          pageFling: false,
          onRender: (pages) => debugPrint('PDF Rendered'),
          onError: (error) => debugPrint('Error: $error'),
          onPageError: (page, error) => debugPrint('Page error: $error'),
        ),
      ),
    );
  }

  Widget _buildExcelView(DocumentModel document, BuildContext context) {
    try {
      var bytes = File(document.filePath!).readAsBytesSync();
      var excel = excelPlugin.Excel.decodeBytes(bytes);
      List<TableRow> rows = [];

      for (var table in excel.tables.keys) {
        var tableRows = excel.tables[table]?.rows;
        if (tableRows != null) {
          for (var row in tableRows) {
            rows.add(
              TableRow(
                children: row
                    .map((cell) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(cell?.value?.toString() ?? '',
                              style: const TextStyle(fontSize: 14)),
                        ))
                    .toList(),
              ),
            );
          }
        }
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          children: rows,
        ),
      );
    } catch (e) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Error loading Excel file: $e',
            style: const TextStyle(color: Colors.red, fontSize: 16)),
      );
    }
  }

  Widget _buildImageView(DocumentModel document) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 1)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(File(document.filePath!), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildVideoView(DetailsController controller, BuildContext context) {
    return Obx(() {
      if (controller.isVideoInitialised.value) {
        if (controller.videoController.value.isInitialized) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: controller.videoController.value.size.width,
                      height: controller.videoController.value.size.height,
                      child: AspectRatio(
                        aspectRatio:
                            controller.videoController.value.aspectRatio,
                        child: VideoPlayer(controller.videoController),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                VideoProgressIndicator(
                  controller.videoController,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Colors.blue,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.black12,
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(controller.isVideoPlaying.value
                      ? Icons.pause
                      : Icons.play_arrow),
                  onPressed: () {
                    if (controller.videoController.value.isPlaying) {
                      controller.videoController.pause();
                      controller.isVideoPlaying.value = true;
                    } else {
                      controller.videoController.play();
                      controller.isVideoPlaying.value = false;
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _buildAudioView(DetailsController controller) {
    return Obx(() {
      final isPlaying = controller.isAudioPlaying.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.playAudio();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(isPlaying ? 'Pause Audio' : 'Play Audio'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              controller.stopAudio();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Stop Audio'),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: isPlaying ? controller.audioProgress.value : 0,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ],
      );
    });
  }
}
