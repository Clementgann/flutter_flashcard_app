import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static Future<void> saveProgress(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastIndex', index);
  }

  static Future<int> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('lastIndex') ?? 0;
  }
}
