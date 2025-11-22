// controllers/tracking_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/features/main_screen/models/notification_model.dart';

class TrackingController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  // Load notifications
  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;

      // TODO: Replace with API call
      /*
      final response = await ApiService.getNotifications();
      notifications.value = (response['data'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList();
      */

      // DUMMY DATA - Remove this when API is ready
      await Future.delayed(Duration(seconds: 1));

      notifications.value = [
        NotificationModel(
          id: '1',
          title: 'Breakfast',
          message: 'It\'s breakfast time. Did you complete your breakfast?',
          time: '2h ago',
          icon: '🥞',
        ),
        NotificationModel(
          id: '2',
          title: 'Breakfast',
          message: 'It\'s breakfast time. Did you complete your breakfast?',
          time: '2h ago',
          icon: '🥞',
        ),
        NotificationModel(
          id: '3',
          title: 'Breakfast',
          message: 'It\'s breakfast time. Did you complete your breakfast?',
          time: '2h ago',
          icon: '🥞',
        ),
        NotificationModel(
          id: '4',
          title: 'Breakfast',
          message: 'It\'s breakfast time. Did you complete your breakfast?',
          time: '2h ago',
          icon: '🥞',
          isResponded: true,
          responseType: 'yes',
        ),
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load notifications: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Respond to notification
  Future<void> respondToNotification(String notificationId, bool isYes) async {
    try {
      // TODO: Replace with API call
      /*
      await ApiService.respondToNotification(
        notificationId: notificationId,
        response: isYes ? 'yes' : 'no',
      );
      */

      // Update local state
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          title: notifications[index].title,
          message: notifications[index].message,
          time: notifications[index].time,
          icon: notifications[index].icon,
          isResponded: true,
          responseType: isYes ? 'yes' : 'no',
        );
        notifications.refresh();

        Get.snackbar(
          'Success',
          'Response recorded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to record response: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      // TODO: Replace with API call
      /*
      await ApiService.deleteNotification(notificationId);
      */

      notifications.removeWhere((n) => n.id == notificationId);

      Get.snackbar(
        'Deleted',
        'Notification deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete notification: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Show notification options
  void showNotificationOptions(String notificationId) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red),
              title: Text('Delete'),
              onTap: () {
                Get.back();
                deleteNotification(notificationId);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_off_outlined),
              title: Text('Mute notifications'),
              onTap: () {
                Get.back();
                // TODO: Implement mute
              },
            ),
          ],
        ),
      ),
    );
  }
}
