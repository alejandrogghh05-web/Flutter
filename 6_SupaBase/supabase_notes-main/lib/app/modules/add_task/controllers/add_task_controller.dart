import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTaskController extends GetxController {
  RxBool isLoading = false.obs;
  
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  TextEditingController dueDateC = TextEditingController();
  
  RxString selectedPriority = 'medium'.obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  
  SupabaseClient client = Supabase.instance.client;

  final List<String> priorities = ['low', 'medium', 'high'];

  Future<bool> addTask() async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      isLoading.value = true;
      
      try {
        List<dynamic> res = await client
            .from("users")
            .select("id")
            .match({"uid": client.auth.currentUser!.id});
            
        Map<String, dynamic> user = (res).first as Map<String, dynamic>;
        int id = user["id"];
        
        await client.from("tasks").insert({
          "user_id": id,
          "title": titleC.text,
          "description": descC.text,
          "completed": false,
          "due_date": selectedDate.value?.toIso8601String(),
          "priority": selectedPriority.value,
          "created_at": DateTime.now().toIso8601String(),
        });
        
        return true;
      } catch (e) {
        print('Error adding task: $e');
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