import 'package:flutter/material.dart';

import '../data/models/document_model.dart';
import '../data/repositories/document_repository.dart';
import 'package:get/get.dart';

class DocumentController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  final DocumentRepository _documentRepository = DocumentRepository();
  RxList<DocumentModel> documents = <DocumentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> fetchDocuments() async {
    documents.value = _documentRepository.getAllDocuments();
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
