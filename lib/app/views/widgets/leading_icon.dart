import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Widget leadingIcon(BuildContext context,
    {required String docType, required String docUrl}) {
  switch (docType) {
    case 'image':
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          File(docUrl),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      );
    case 'video':
      return FutureBuilder<String?>(
        future: _generateVideoThumbnail(docUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                File(snapshot.data!), // Use the generated thumbnail
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            );
          } else if (snapshot.hasError) {
            return const Icon(Icons.broken_image,
                color: Colors.red); // Error state
          } else {
            return const Icon(Icons.videocam,
                color:
                    Colors.blue); // Default icon if no thumbnail is generated
          }
        },
      );
    case 'pdf':
      return Icon(
        Icons.picture_as_pdf,
        color: Theme.of(context).primaryColor,
        size: 40,
      );
    case 'excel':
      return const Icon(
        Icons.table_chart_outlined,
        color: Colors.green,
        size: 40,
      );
    case 'audio':
      return Icon(
        Icons.music_note,
        color: Theme.of(context).primaryColor,
        size: 40,
      );
    default:
      return Icon(
        Icons.description,
        color: Theme.of(context).primaryColor,
        size: 40,
      );
  }
}

Future<String?> _generateVideoThumbnail(String videoUrl) async {
  try {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 50,
      quality: 75,
    );
    return thumbnail;
  } catch (e) {
    return null;
  }
}
