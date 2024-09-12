
import 'package:hive/hive.dart';

part 'document_model.g.dart'; // Required for Hive type adapter generation

@HiveType(typeId: 0)
class DocumentModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? filePath;

  @HiveField(4)
  final String? documentType;

  @HiveField(5)
  final DateTime? expiryDate;

  @HiveField(6)
  final String? thumbnailPath;

  DocumentModel({
    required this.title,
    required this.id,
    required this.description,
    this.filePath,
    this.documentType,
    this.expiryDate,
    this.thumbnailPath,
  });
}
