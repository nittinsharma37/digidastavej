import '../../controllers/document_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final DocumentController controller = Get.put(DocumentController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digidastavej'),
      ),
      body: Obx(() {
        if (controller.documents.isEmpty) {
          return const Center(
            child: Text(
              'No documents available. Click "+" to add one.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            await controller.fetchDocuments();
          },
          child: ListView.builder(
            itemCount: controller.documents.length,
            itemBuilder: (context, index) {
              final document = controller.documents[index];
              return Dismissible(
                key: ValueKey(document.id), // Ensure unique key for each item
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    return await _confirmDelete(context);
                  }
                  return false;
                },
                onDismissed: (direction) {
                  controller.deleteDocument(index);
                  Get.snackbar("Deleted", "Document deleted Successfully!",
                      snackPosition: SnackPosition.BOTTOM);
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: 1.0,
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        document.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Type: ${document.documentType ?? "Unknown"}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Text(
                        document.expiryDate != null
                            ? 'Expires on: ${document.expiryDate}'
                            : 'No expiry',
                        style: const TextStyle(color: Colors.red),
                      ),
                      onTap: () => Get.toNamed('/details', arguments: document),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add'), // Navigate to the Add Screen
        elevation: 8,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this document?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
