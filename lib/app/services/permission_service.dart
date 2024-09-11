import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<void> requestPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    _handlePermissionStatus(statuses);
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    _handleSinglePermissionStatus(permission, status);
  }

  Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }

  Future<Map<Permission, PermissionStatus>> checkPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    return statuses;
  }

  void _handlePermissionStatus(Map<Permission, PermissionStatus> statuses) {
    for (var entry in statuses.entries) {
      final permission = entry.key;
      final status = entry.value;

      if (status.isDenied) {
        _showPermissionDeniedDialog(permission);
      } else if (status.isPermanentlyDenied) {
        _showPermissionPermanentlyDeniedDialog(permission);
      } else if (status.isGranted) {
        print('${permission.toString()} is granted.');
      }
    }
  }

  void _handleSinglePermissionStatus(
      Permission permission, PermissionStatus status) {
    if (status.isDenied) {
      _showPermissionDeniedDialog(permission);
    } else if (status.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog(permission);
    } else if (status.isGranted) {
      print('${permission.toString()} is granted.');
    }
  }

  void _showPermissionDeniedDialog(Permission permission) {
    Get.defaultDialog(
      title: 'Permission Required',
      content: Text(
        'The app needs ${permission.toString()} permission to function properly. Please grant the permission in the app settings.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
            openAppSettings(); // Open app settings
          },
          child: Text('Open Settings'),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _showPermissionPermanentlyDeniedDialog(Permission permission) {
    Get.defaultDialog(
      title: 'Permission Permanently Denied',
      content: Text(
        'The app was permanently denied ${permission.toString()} permission. You need to enable this permission from the app settings.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
            openAppSettings(); // Open app settings
          },
          child: Text('Open Settings'),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
