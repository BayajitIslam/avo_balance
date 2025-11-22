// controllers/shopping_list_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ShoppingListController extends GetxController {
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().obs;
  final RxBool showList = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> shoppingItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // Load initial data (if needed)
  void loadInitialData() {
    // TODO: Load saved dates from local storage if needed
    // final savedStartDate = await LocalStorage.getStartDate();
    // if (savedStartDate != null) startDate.value = savedStartDate;
  }

  // Update Start Date
  void updateStartDate(DateTime date) {
    startDate.value = date;
  }

  // Update End Date
  void updateEndDate(DateTime date) {
    endDate.value = date;
  }

  // Toggle checkbox for shopping item
  void toggleItem(int index) {
    shoppingItems[index]['isChecked'] = !shoppingItems[index]['isChecked'];
    shoppingItems.refresh();
  }

  // Generate Shopping List
  Future<void> generateShoppingList() async {
    if (startDate.value.isAfter(endDate.value)) {
      Get.snackbar(
        'Error',
        'Start date must be before end date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    try {
      isLoading.value = true;

      // TODO: Replace with actual API call
      /*
      final response = await ApiService.generateShoppingList(
        startDate: startDate.value.toIso8601String(),
        endDate: endDate.value.toIso8601String(),
      );
      
      if (response['success']) {
        shoppingItems.value = (response['data'] as List)
            .map((item) => {
                  'name': item['name'],
                  'isChecked': false,
                })
            .toList();
        showList.value = true;
      }
      */

      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      // DUMMY DATA - Replace this with API response
      shoppingItems.value = [
        {'name': 'Tomatoes 4 pcs', 'isChecked': false},
        {'name': 'Tomatoes 4 pcs', 'isChecked': false},
        {'name': 'Tomatoes 4 pcs', 'isChecked': false},
        {'name': 'Tomatoes 4 pcs', 'isChecked': false},
        {'name': 'Chicken Brest -1.2 kg', 'isChecked': false},
        {'name': 'Garlic - 1 head', 'isChecked': false},
        {'name': 'Eggs - 12 pcs', 'isChecked': false},
        {'name': 'Garlic - 1 head', 'isChecked': false},
        {'name': 'Eggs - 12 pcs', 'isChecked': false},
        {'name': 'Garlic - 1 head', 'isChecked': false},
      ];

      showList.value = true;

      Get.snackbar(
        'Success',
        'Shopping list generated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate shopping list: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Export/Share Shopping List
  Future<void> exportList() async {
    try {
      // TODO: Replace with actual API call or sharing functionality
      /*
      final response = await ApiService.exportShoppingList(
        items: shoppingItems,
        startDate: startDate.value.toIso8601String(),
        endDate: endDate.value.toIso8601String(),
      );
      
      if (response['success']) {
        // Share the PDF/CSV file
        await Share.shareFiles([response['filePath']]);
      }
      */

      // Simulate export
      await Future.delayed(Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Shopping list exported successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export shopping list: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Get formatted date range string
  String getDateRangeString() {
    final start = startDate.value;
    final end = endDate.value;
    return '${start.month.toString().padLeft(2, '0')}/${start.day.toString().padLeft(2, '0')} - ${end.month.toString().padLeft(2, '0')}/${end.day.toString().padLeft(2, '0')}';
  }

  // Clear list (if needed)
  void clearList() {
    shoppingItems.clear();
    showList.value = false;
  }
}