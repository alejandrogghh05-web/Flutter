// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_task_controller.dart';
// import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';

class AddTaskView extends GetView<AddTaskController> {
  // HomeController homeC = Get.find(); // Si tienes un TasksController en home

  AddTaskView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
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
            decoration: const InputDecoration(
              labelText: "Due Date",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
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
          const SizedBox(height: 25),
          
          // Add Button
          Obx(() => ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                bool res = await controller.addTask();
                if (res == true) {
                  // await homeC.getAllTasks(); // Si tienes este método
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Task added successfully',
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
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              controller.isLoading.isFalse ? "Add Task" : "Loading...",
              style: const TextStyle(fontSize: 16),
            ),
          ))
        ],
      ),
    );
  }
}