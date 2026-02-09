import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditTaskController extends GetxController {
  RxBool isLoading = false.obs;
  
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  TextEditingController dueDateC = TextEditingController();
  
  RxString selectedPriority = 'medium'.obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxBool isCompleted = false.obs;
  
  SupabaseClient client = Supabase.instance.client;

  final List<String> priorities = ['low', 'medium', 'high'];

  Future<bool> editTask(int id) async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      isLoading.value = true;
      
      try {
        await client.from("tasks").update({
          "title": titleC.text,
          "description": descC.text,
          "completed": isCompleted.value,
          "due_date": selectedDate.value?.toIso8601String(),
          "priority": selectedPriority.value,
        }).match({"id": id});
        
        return true;
      } catch (e) {
        print('Error editing task: $e');
        return false;
      } finally {
        isLoading.value = false;
      }
    } else {
      return false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      selectedDate.value = picked;
      dueDateC.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  void onClose() {
    titleC.dispose();
    descC.dispose();
    dueDateC.dispose();
    super.onClose();
  }
}