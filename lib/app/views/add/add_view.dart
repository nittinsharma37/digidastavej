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
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
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
                  _buildTextField(
                    controller: controller.titleController,
                    labelText: 'Title',
                    validator: (value) =>
                        value!.isEmpty ? 'Title is required' : null,
                  ),
                  _buildTextField(
                    controller: controller.descriptionController,
                    labelText: 'Description',
                    validator: (value) =>
                        value!.isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Attach Files:',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _buildActionButtons(context),
                  const SizedBox(height: 16),
                  if (controller.filePath.value.isNotEmpty)
                    Text(
                      'Selected file: ${controller.filePath.value}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildDateField(context),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.saveDocument,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Save Document',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (controller.isRecording.value ||
                      controller.isVideoRecording.value)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        ElevatedButton.icon(
          onPressed: controller.pickFile,
          icon: const Icon(Icons.attach_file),
          label: const Text('Attach File'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        ElevatedButton.icon(
          onPressed: controller.captureImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Capture Image'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        ElevatedButton.icon(
          onPressed: controller.recordVideo,
          icon: const Icon(Icons.videocam),
          label: const Text('Record Video'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        ElevatedButton.icon(
          onPressed: controller.recordAudio,
          icon: Icon(controller.isRecording.value ? Icons.stop : Icons.mic),
          label: Text(
              controller.isRecording.value ? 'Stop Audio' : 'Record Audio'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: controller.expiryDateController,
      decoration: InputDecoration(
        labelText: 'Expiry Date',
        hintText: 'Select Expiry Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }
}
