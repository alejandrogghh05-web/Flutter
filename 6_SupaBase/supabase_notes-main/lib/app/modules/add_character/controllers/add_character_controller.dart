import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddFavoriteCharacterController extends GetxController {
  RxBool isLoading = false.obs;
  
  TextEditingController nameC = TextEditingController();
  TextEditingController originC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController notesC = TextEditingController();
  
  RxString selectedCharacterType = 'Protagonist'.obs;
  
  SupabaseClient client = Supabase.instance.client;

  final List<String> characterTypes = [
    'Protagonist',
    'Antagonist',
    'Supporting',
    'Anti-hero',
    'Sidekick',
    'Mentor',
    'Love Interest',
    'Comic Relief',
    'Other'
  ];

  Future<bool> addFavoriteCharacter() async {
    if (nameC.text.isNotEmpty && originC.text.isNotEmpty) {
      isLoading.value = true;
      
      try {
        List<dynamic> res = await client
            .from("users")
            .select("id")
            .match({"uid": client.auth.currentUser!.id});
            
        Map<String, dynamic> user = (res).first as Map<String, dynamic>;
        int id = user["id"];
        
        await client.from("favorite_characters").insert({
          "user_id": id,
          "name": nameC.text,
          "origin": originC.text,
          "character_type": selectedCharacterType.value,
          "description": descriptionC.text.isNotEmpty ? descriptionC.text : null,
          "notes": notesC.text.isNotEmpty ? notesC.text : null,
        });
        
        return true;
      } catch (e) {
        print('Error adding favorite character: $e');
        return false;
      } finally {
        isLoading.value = false;
      }
    } else {
      return false;
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    originC.dispose();
    descriptionC.dispose();
    notesC.dispose();
    super.onClose();
  }
}