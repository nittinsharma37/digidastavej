import '../../controllers/add_controller.dart';
import '../../controllers/document_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddView extends StatelessWidget {
  final AddController controller = Get.put(AddController());
  final DocumentController documentController = Get.find<DocumentController>();

  AddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Document'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                        value!.isEmpty ? 'Title is required' : null,
                  ),
                  TextFormField(
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) =>
                        value!.isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Attach Files:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.pickFile,
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Attach File'),
                      ),
                      ElevatedButton.icon(
                        onPressed: controller.captureImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Capture Image'),
                      ),
                      ElevatedButton.icon(
                        onPressed: controller.recordVideo,
                        icon: const Icon(Icons.videocam),
                        label: const Text('Record Video'),
                      ),
                      ElevatedButton.icon(
                        onPressed: controller.recordAudio,
                        icon: Icon(controller.isRecording.value
                            ? Icons.stop
                            : Icons.mic),
                        label: Text(controller.isRecording.value
                            ? 'Stop Audio'
                            : 'Record Audio'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (controller.filePath.value.isNotEmpty)
                    Text(
                      'Selected file: ${controller.filePath.value}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  TextFormField(
                    readOnly: true,
                    controller: controller.expiryDateController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'Select Expiry Date',
                    ),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        controller.expiryDateController.text =
                            selectedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                  ),
                  // TextFormField(
                  //   controller: controller.typeController,
                  //   decoration:
                  //       const InputDecoration(labelText: 'Document Type'),
                  // ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.saveDocument,
                    child: const Text('Save Document'),
                  ),
                  const SizedBox(height: 20),
                  if (controller.isRecording.value)
                    const CircularProgressIndicator(),
                  if (controller.isVideoRecording.value)
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
