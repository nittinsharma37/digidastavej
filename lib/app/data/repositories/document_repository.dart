import '../models/document_model.dart';
import 'package:hive/hive.dart';

class DocumentRepository {
  final Box<DocumentModel> _documentBox = Hive.box<DocumentModel>('documents');

  List<DocumentModel> getAllDocuments() {
    return _documentBox.values.toList();
  }

  Future<void> addDocument(DocumentModel document) async {
    await _documentBox.add(document);
  }

  Future<void> updateDocument(int index, DocumentModel document) async {
    await _documentBox.putAt(index, document);
  }

  Future<void> deleteDocument(int index) async {
    await _documentBox.deleteAt(index);
  }

  Future<DocumentModel> getDocument(int index) async {
    return _documentBox.getAt(index)!;
  }
}
