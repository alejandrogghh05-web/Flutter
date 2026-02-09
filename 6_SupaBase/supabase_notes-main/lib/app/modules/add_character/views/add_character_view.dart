// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_character_controller.dart';

class AddFavoriteCharacterView extends GetView<AddFavoriteCharacterController> {
  AddFavoriteCharacterView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Favorite Character'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Name Field (Required)
          TextField(
            controller: controller.nameC,
            decoration: const InputDecoration(
              labelText: "Character Name *",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 20),
          
          // Origin Field (Required)
          TextField(
            controller: controller.originC,
            decoration: const InputDecoration(
              labelText: "Origin (Movie, Book, Series, etc.) *",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.movie),
              hintText: "e.g., Harry Potter, Star Wars",
            ),
          ),
          const SizedBox(height: 20),
          
          // Character Type Dropdown
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedCharacterType.value,
            decoration: const InputDecoration(
              labelText: "Character Type",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            items: controller.characterTypes.map((String type) {
              IconData icon;
              Color color;
              
              switch (type) {
                case 'Protagonist':
                  icon = Icons.star;
                  color = Colors.amber;
                  break;
                case 'Antagonist':
                  icon = Icons.dangerous;
                  color = Colors.red;
                  break;
                case 'Supporting':
                  icon = Icons.group;
                  color = Colors.blue;
                  break;
                case 'Anti-hero':
                  icon = Icons.psychology;
                  color = Colors.purple;
                  break;
                case 'Sidekick':
                  icon = Icons.supervisor_account;
                  color = Colors.green;
                  break;
                case 'Mentor':
                  icon = Icons.school;
                  color = Colors.orange;
                  break;
                case 'Love Interest':
                  icon = Icons.favorite;
                  color = Colors.pink;
                  break;
                case 'Comic Relief':
                  icon = Icons.emoji_emotions;
                  color = Colors.teal;
                  break;
                default:
                  icon = Icons.help_outline;
                  color = Colors.grey;
              }
              
              return DropdownMenuItem<String>(
                value: type,
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 10),
                    Text(type),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.selectedCharacterType.value = newValue;
              }
            },
          )),
          const SizedBox(height: 20),
          
          // Description Field (Optional)
          TextField(
            controller: controller.descriptionC,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Description (Optional)",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
              hintText: "What makes this character special?",
            ),
          ),
          const SizedBox(height: 20),
          
          // Notes Field (Optional)
          TextField(
            controller: controller.notesC,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Personal Notes (Optional)",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
              hintText: "Why is this your favorite character?",
            ),
          ),
          const SizedBox(height: 10),
          
          // Required fields note
          const Text(
            "* Required fields",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          
          // Add Button
          Obx(() => ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                bool res = await controller.addFavoriteCharacter();
                if (res == true) {
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Favorite character added successfully!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Please fill in all required fields (Name and Origin)',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    icon: const Icon(Icons.error, color: Colors.white),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              controller.isLoading.isFalse 
                ? "Add Favorite Character" 
                : "Loading...",
              style: const TextStyle(fontSize: 16),
            ),
          ))
        ],
      ),
    );
  }
}