import 'package:digidastavej/app/controllers/document_controller.dart';
import 'package:digidastavej/app/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/document_model.dart';
import '../data/repositories/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';

class AddController extends GetxController {
  final DocumentRepository _documentRepository = DocumentRepository();
  final PermissionsService _permissionsService = PermissionsService();

  final ImagePicker _imagePicker = ImagePicker();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final expiryDateController = TextEditingController();
  final filePath = ''.obs;
  final Rx<File?> _file = Rx<File?>(null);
  final RxString _fileType = ''.obs;
  final RxBool isRecording = false.obs;
  final RxBool isVideoRecording = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initAudioRecorder();
    _requestPermissions();
  }

  Future<void> _initAudioRecorder() async {
    await _audioRecorder.openRecorder();
  }

  Future<void> _requestPermissions() async {
    await _permissionsService.requestPermissions();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi', 'pdf']);
    if (result != null) {
      filePath.value = result.files.single.path ?? '';
      _file.value = File(filePath.value);
      _fileType.value = result.files.single.extension ?? '';
    }
  }

  Future<void> captureImage() async {
    final status = await _permissionsService.checkPermission(Permission.camera);
    if (status.isGranted) {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        filePath.value = pickedFile.path;
        _file.value = File(filePath.value);
        _fileType.value = 'image';
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please grant camera permission to capture images.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> recordVideo() async {
    final status = await _permissionsService.checkPermission(Permission.camera);
    if (status.isGranted) {
      isVideoRecording.value = true;
      final pickedFile =
          await _imagePicker.pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        filePath.value = pickedFile.path;
        _file.value = File(filePath.value);
        _fileType.value = 'video';
      }
      isVideoRecording.value = false;
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please grant camera permission to record videos.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> recordAudio() async {
    final status =
        await _permissionsService.checkPermission(Permission.microphone);
    if (status.isGranted) {
      if (isRecording.value) {
        final path = await _audioRecorder.stopRecorder();
        if (path != null) {
          filePath.value = path;
          _file.value = File(filePath.value);
          _fileType.value = 'audio';
          isRecording.value = false;
        }
      } else {
        await _audioRecorder.startRecorder(
          codec: Codec.aacADTS,
          toFile: 'audio_${DateTime.now().millisecondsSinceEpoch}.aac',
        );
        isRecording.value = true;
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please grant microphone permission to record audio.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String getFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      case 'mp4':
      case 'mov':
      case 'avi':
        return 'video';
      case 'pdf':
        return 'pdf';
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'flac':
        return 'audio';
      default:
        return 'unknown';
    }
  }

  void saveDocument() {
    if (formKey.currentState?.validate() ?? false) {
      debugPrint("document type : $filePath");

      String documentType =
          filePath.value != "" ? getFileType(filePath.value) : "";

      final document = DocumentModel(
        id: UniqueKey().toString(),
        title: titleController.text,
        description: descriptionController.text,
        documentType: documentType,
        expiryDate: expiryDateController.text.isNotEmpty
            ? DateTime.parse(expiryDateController.text)
            : null,
        filePath: filePath.value,
      );
      _documentRepository.addDocument(document);
      Get.back();
      Get.find<DocumentController>().fetchDocuments();
      Get.snackbar(
        'Success!',
        'Docuement added Successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _audioRecorder.closeRecorder();
    super.onClose();
  }
}
