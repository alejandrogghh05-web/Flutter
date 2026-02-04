import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://yhroykxjloxrubbwafha.supabase.co',
    anonKey: 'sb_publishable_gJ-LLSo-IHPGwuoC-ULHhw_0TWwQ7FA',
  );
  runApp(App());
}