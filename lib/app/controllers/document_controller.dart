import '../data/models/document_model.dart';
import '../data/repositories/document_repository.dart';
import 'package:get/get.dart';

class DocumentController extends GetxController {
  final DocumentRepository _documentRepository = DocumentRepository();
  RxList<DocumentModel> documents = <DocumentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    documents.value = await _documentRepository.getAllDocuments();
  }

  void addDocument(DocumentModel document) {
    _documentRepository.addDocument(document);
    fetchDocuments();
  }

  void updateDocument(int index, DocumentModel document) {
    _documentRepository.updateDocument(index, document);
    fetchDocuments();
  }

  void deleteDocument(int index) {
    _documentRepository.deleteDocument(index);
    fetchDocuments();
  }
}
