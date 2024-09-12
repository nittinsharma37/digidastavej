import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digidastavej/app/utils/date_format.dart';
import '../../controllers/document_controller.dart';

class HomeView extends StatelessWidget {
  final DocumentController controller = Get.put(DocumentController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digidastavej'),
        centerTitle: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DocumentSearchDelegate(controller),
              );
            },
          ),
          Obx(() {
            return IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  controller.themeMode.value == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  key: ValueKey(controller.themeMode.value),
                ),
              ),
              onPressed: () => controller.toggleTheme(),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.documents.isEmpty) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).cardTheme.color,
                child: Text(
                  'Check out our new features!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'No documents available. Click "+" to add one.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            await controller.fetchDocuments();
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildUpcomingExpirationsSection(context),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final document = controller.documents[index];
                      return Dismissible(
                        key: ValueKey(document.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            gradient: const LinearGradient(
                              colors: [Colors.redAccent, Colors.red],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
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
                          Get.snackbar(
                            "Deleted",
                            "Document deleted Successfully!",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor:
                                Theme.of(context).snackBarTheme.backgroundColor,
                            colorText: Theme.of(context)
                                .snackBarTheme
                                .contentTextStyle
                                ?.color,
                            borderRadius: 8,
                            margin: const EdgeInsets.all(10),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 8, // Increased elevation
                          color: Theme.of(context).cardTheme.color,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Icon(Icons.description,
                                color: Theme.of(context).primaryColor),
                            title: Text(
                              document.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              'Type: ${document.documentType ?? "Unknown"}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            trailing: Text(
                              document.expiryDate != null
                                  ? 'Expires on: ${formatDate(document.expiryDate.toString())}'
                                  : 'No expiry',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.red),
                            ),
                            onTap: () =>
                                Get.toNamed('/details', arguments: document),
                          ),
                        ),
                      );
                    },
                    childCount: controller.documents.length,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add'),
        elevation: 10,
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            Theme.of(context).floatingActionButtonTheme.foregroundColor,
        tooltip: 'Add New Document',
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
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Delete',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpcomingExpirationsSection(BuildContext context) {
    final upcomingExpirations = controller.documents
        .where((doc) =>
            doc.expiryDate != null &&
            doc.expiryDate!.isAfter(DateTime.now()) &&
            doc.expiryDate!
                .isBefore(DateTime.now().add(const Duration(days: 30))))
        .toList()
      ..sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));

    if (upcomingExpirations.isEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      color: Theme.of(context).cardTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Upcoming Expirations',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: upcomingExpirations.length,
              itemBuilder: (context, index) {
                final document = upcomingExpirations[index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Card(
                    color: _getThemeBasedColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor),
                      title: Text(document.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall),
                      subtitle: Text(
                        'Expires on: ${formatDate(document.expiryDate.toString())}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () => Get.toNamed('/details', arguments: document),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getThemeBasedColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(128) + (isDarkMode ? 0 : 128),
      random.nextInt(128) + (isDarkMode ? 0 : 128),
      random.nextInt(128) + (isDarkMode ? 0 : 128),
      1,
    );
  }
}

class DocumentSearchDelegate extends SearchDelegate<String?> {
  final DocumentController controller;

  DocumentSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query == "") {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = controller.documents
        .where((doc) => doc.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final document = results[index];
        return ListTile(
          title: Text(document.title),
          subtitle: Text('Type: ${document.documentType ?? "Unknown"}'),
          trailing: Text(
            document.expiryDate != null
                ? 'Expires on: ${formatDate(document.expiryDate.toString())}'
                : 'No expiry',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => Get.toNamed('/details', arguments: document),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = controller.documents
        .where((doc) => doc.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final document = suggestions[index];
        return ListTile(
          title: Text(document.title),
          subtitle: Text('Type: ${document.documentType ?? "Unknown"}'),
          trailing: Text(
            document.expiryDate != null
                ? 'Expires on: ${formatDate(document.expiryDate.toString())}'
                : 'No expiry',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => Get.toNamed('/details', arguments: document),
        );
      },
    );
  }
}
