import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_notes/app/data/models/notes_model.dart';
import 'package:supabase_notes/app/data/models/tasks_model.dart';
import 'package:supabase_notes/app/data/models/favorite_characters_model.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  
  RxList<Notes> allNotes = List<Notes>.empty(growable: true).obs;
  RxList<Tasks> allTasks = List<Tasks>.empty(growable: true).obs;
  RxList<FavoriteCharacters> allCharacters = List<FavoriteCharacters>.empty(growable: true).obs;

  Future<void> getAllNotes() async {
    try {
      List res = await client
          .from("notes")
          .select()
          .match({"user_id": await getUserId()})
          .order('created_at', ascending: false);
      allNotes.value = Notes.fromJsonList(res);
    } catch (e) {
      print("Error getting notes: $e");
    }
  }

  Future<void> getAllTasks() async {
    try {
      List res = await client
          .from("tasks")
          .select()
          .match({"user_id": await getUserId()})
          .order('created_at', ascending: false);
      allTasks.value = Tasks.fromJsonList(res);
    } catch (e) {
      print("Error getting tasks: $e");
    }
  }

  Future<void> getAllCharacters() async {
    try {
      List res = await client
          .from("favorite_characters")
          .select()
          .match({"user_id": await getUserId()});
      allCharacters.value = FavoriteCharacters.fromJsonList(res);
    } catch (e) {
      print("Error getting characters: $e");
    }
  }

  Future<int> getUserId() async {
    List<dynamic> res = await client
        .from("users")
        .select("id")
        .match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    return user["id"];
  }

  Future<void> deleteNote(int id) async {
    try {
      await client.from("notes").delete().match({"id": id});
      await getAllNotes();
      Get.snackbar(
        'Success',
        'Note deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await client.from("tasks").delete().match({"id": id});
      await getAllTasks();
      Get.snackbar(
        'Success',
        'Task deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  Future<void> deleteCharacter(int id) async {
    try {
      await client.from("favorite_characters").delete().match({"id": id});
      await getAllCharacters();
      Get.snackbar(
        'Success',
        'Character deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("Error deleting character: $e");
    }
  }

  Future<void> toggleTaskComplete(int id, bool currentStatus) async {
    try {
      await client
          .from("tasks")
          .update({"completed": !currentStatus})
          .match({"id": id});
      await getAllTasks();
    } catch (e) {
      print("Error updating task: $e");
    }
  }
}