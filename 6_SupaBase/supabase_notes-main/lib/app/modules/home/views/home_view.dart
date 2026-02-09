import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getAllNotes();
          await controller.getAllTasks();
          await controller.getAllCharacters();
        },
        child: ListView(
          children: [
            // Sección de NOTES
            _buildNotesSection(),
            const Divider(thickness: 2, height: 2),
            
            // Sección de TASKS
            _buildTasksSection(),
            const Divider(thickness: 2, height: 2),
            
            // Sección de FAVORITE CHARACTERS
            _buildCharactersSection(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addFavoriteCharacter',
            onPressed: () => Get.toNamed(Routes.ADD_CHARACTER),
            tooltip: 'Add Favorite Character',
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addTask',
            onPressed: () => Get.toNamed(Routes.ADD_TASK),
            tooltip: 'Add Task',
            child: const Icon(Icons.task_alt),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addNote',
            onPressed: () => Get.toNamed(Routes.ADD_NOTE),
            tooltip: 'Add Note',
            child: const Icon(Icons.note_add),
          ),
        ],
      ),
    );
  }

  // ==================== NOTES SECTION ====================
  Widget _buildNotesSection() {
    return FutureBuilder(
      future: controller.getAllNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Obx(() => ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.note, color: Colors.blue, size: 30),
              title: Text(
                'NOTES (${controller.allNotes.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              children: controller.allNotes.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No notes yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    ]
                  : controller.allNotes.map((note) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          onTap: () => Get.toNamed(
                            Routes.EDIT_NOTE,
                            arguments: note,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              "${note.id}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            note.title ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            note.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            onPressed: () async =>
                                await controller.deleteNote(note.id!),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      );
                    }).toList(),
            ));
      },
    );
  }

  // ==================== TASKS SECTION ====================
  Widget _buildTasksSection() {
    return FutureBuilder(
      future: controller.getAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Obx(() => ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.task_alt, color: Colors.green, size: 30),
              title: Text(
                'TASKS (${controller.allTasks.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              children: controller.allTasks.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No tasks yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    ]
                  : controller.allTasks.map((task) {
                      Color priorityColor = task.priority == 'high'
                          ? Colors.red
                          : task.priority == 'medium'
                              ? Colors.orange
                              : Colors.green;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          onTap: () => Get.toNamed(
                            Routes.EDIT_TASK,
                            arguments: task,
                          ),
                          leading: Checkbox(
                            value: task.completed ?? false,
                            onChanged: (value) => controller.toggleTaskComplete(
                                task.id!, task.completed ?? false),
                          ),
                          title: Text(
                            task.title ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: task.completed == true
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.completed == true
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.description ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.flag, size: 16, color: priorityColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    task.priority ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: priorityColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (task.dueDate != null) ...[
                                    const SizedBox(width: 12),
                                    const Icon(Icons.calendar_today,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      task.dueDate!.split('T')[0],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async =>
                                await controller.deleteTask(task.id!),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      );
                    }).toList(),
            ));
      },
    );
  }

  // ==================== CHARACTERS SECTION ====================
  Widget _buildCharactersSection() {
    return FutureBuilder(
      future: controller.getAllCharacters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Obx(() => ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.people, color: Colors.purple, size: 30),
              title: Text(
                'FAVORITE CHARACTERS (${controller.allCharacters.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              children: controller.allCharacters.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No favorite characters yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    ]
                  : controller.allCharacters.map((character) {
                      IconData typeIcon;
                      Color typeColor;

                      switch (character.characterType) {
                        case 'Protagonist':
                          typeIcon = Icons.star;
                          typeColor = Colors.amber;
                          break;
                        case 'Antagonist':
                          typeIcon = Icons.dangerous;
                          typeColor = Colors.red;
                          break;
                        case 'Supporting':
                          typeIcon = Icons.group;
                          typeColor = Colors.blue;
                          break;
                        case 'Anti-hero':
                          typeIcon = Icons.psychology;
                          typeColor = Colors.purple;
                          break;
                        case 'Sidekick':
                          typeIcon = Icons.supervisor_account;
                          typeColor = Colors.green;
                          break;
                        case 'Mentor':
                          typeIcon = Icons.school;
                          typeColor = Colors.orange;
                          break;
                        case 'Love Interest':
                          typeIcon = Icons.favorite;
                          typeColor = Colors.pink;
                          break;
                        case 'Comic Relief':
                          typeIcon = Icons.emoji_emotions;
                          typeColor = Colors.teal;
                          break;
                        default:
                          typeIcon = Icons.person;
                          typeColor = Colors.grey;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          onTap: () => Get.toNamed(
                            Routes.EDIT_CHARACTER,
                            arguments: character,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: typeColor,
                            child: Icon(typeIcon, color: Colors.white, size: 24),
                          ),
                          title: Text(
                            character.name ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From: ${character.origin ?? ''}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(typeIcon, size: 16, color: typeColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    character.characterType ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: typeColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (character.description != null &&
                                  character.description!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  character.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async =>
                                await controller.deleteCharacter(character.id!),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      );
                    }).toList(),
            ));
      },
    );
  }
}