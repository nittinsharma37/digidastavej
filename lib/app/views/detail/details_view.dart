import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:digidastavej/app/controllers/details_controller.dart';
import 'package:digidastavej/app/data/models/document_model.dart';
import 'package:digidastavej/app/utils/date_format.dart';
import 'package:digidastavej/app/utils/format_duration.dart';
import 'package:digidastavej/app/utils/light_theme.dart';
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
        return _buildAudioView(controller, context);
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Row(
                children: [
                  Text("File : ${document.documentType!.toUpperCase()}"),
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(
                    Icons.picture_as_pdf,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
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
        ],
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

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Row(
                children: [
                  Text("File : ${document.documentType!.toUpperCase()}"),
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(
                    Icons.table_chart_outlined,
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              children: rows,
            ),
          ),
        ],
      );
    } catch (e) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Row(
                children: [
                  Text("File : ${document.documentType!.toUpperCase()}"),
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(
                    Icons.table_chart_outlined,
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error loading Excel file: $e',
                style: const TextStyle(color: Colors.red, fontSize: 16)),
          )
        ],
      );
    }
  }

  Widget _buildImageView(DocumentModel document) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Row(
              children: [
                Text("File : ${document.documentType!.toUpperCase()}"),
                const SizedBox(
                  width: 12,
                ),
                const Icon(
                  Icons.image,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
        Container(
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
        ),
      ],
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Row(
                      children: [
                        Text(
                            "File : ${controller.document.value.documentType!.toUpperCase()}"),
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(
                          Icons.videocam,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Chewie(
                      controller: controller.chewieController,
                    ),
                  ),
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

  Widget _buildAudioView(DetailsController controller, BuildContext context) {
    return Obx(() {
      final isPlaying = controller.isAudioPlaying.value;
      final currentPosition = controller.audioCurrentPosition.value;
      final totalDuration = controller.audioTotalDuration.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                      "File : ${controller.document.value.documentType!.toUpperCase()}"),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.music_note,
            size: 100,
            color: LightTheme.theme.primaryColor,
          ),
          ElevatedButton(
            onPressed: () {
              if (isPlaying) {
                controller.pauseAudio(); // New method for pausing
              } else {
                controller.playAudio();
              }
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
          // Progress Bar
          LinearProgressIndicator(
            value: totalDuration.inMilliseconds > 0
                ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
                : 0,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 8),
          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(currentPosition)),
              Text(formatTime(totalDuration)),
            ],
          ),
        ],
      );
    });
  }
}
