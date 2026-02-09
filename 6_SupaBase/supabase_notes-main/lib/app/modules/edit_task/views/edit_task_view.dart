// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/tasks_model.dart';
import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';

import '../controllers/edit_task_controller.dart';

class EditTaskView extends GetView<EditTaskController> {
  Tasks task = Get.arguments;
  HomeController homeC = Get.find();

  EditTaskView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Pre-cargar los datos de la tarea
    controller.titleC.text = task.title ?? '';
    controller.descC.text = task.description ?? '';
    controller.selectedPriority.value = task.priority ?? 'medium';
    controller.isCompleted.value = task.completed ?? false;
    
    // Pre-cargar fecha si existe
    if (task.dueDate != null) {
      try {
        controller.selectedDate.value = DateTime.parse(task.dueDate!);
        DateTime date = controller.selectedDate.value!;
        controller.dueDateC.text = "${date.day}/${date.month}/${date.year}";
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Title Field
          TextField(
            controller: controller.titleC,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          
          // Description Field
          TextField(
            controller: controller.descC,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          
          // Due Date Field
          TextField(
            controller: controller.dueDateC,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Due Date",
              border: const OutlineInputBorder(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.selectedDate.value = null;
                      controller.dueDateC.clear();
                    },
                  ),
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            onTap: () => controller.selectDate(context),
          ),
          const SizedBox(height: 20),
          
          // Priority Dropdown
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedPriority.value,
            decoration: const InputDecoration(
              labelText: "Priority",
              border: OutlineInputBorder(),
            ),
            items: controller.priorities.map((String priority) {
              return DropdownMenuItem<String>(
                value: priority,
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: priority == 'high'
                          ? Colors.red
                          : priority == 'medium'
                              ? Colors.orange
                              : Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(priority.capitalize!),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.selectedPriority.value = newValue;
              }
            },
          )),
          const SizedBox(height: 20),
          
          // Completed Checkbox
          Obx(() => CheckboxListTile(
            title: const Text('Mark as completed'),
            value: controller.isCompleted.value,
            onChanged: (bool? value) {
              if (value != null) {
                controller.isCompleted.value = value;
              }
            },
            controlAffinity: ListTileControlAffinity.leading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.grey),
            ),
          )),
          const SizedBox(height: 25),
          
          // Update Button
          Obx(() => ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                bool res = await controller.editTask(task.id!);
                if (res == true) {
                  await homeC.getAllTasks();
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Task updated successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Please fill in all required fields',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
                controller.isLoading.value = false;
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              controller.isLoading.isFalse ? "Update Task" : "Loading...",
              style: const TextStyle(fontSize: 16),
            ),
          ))
        ],
      ),
    );
  }
}