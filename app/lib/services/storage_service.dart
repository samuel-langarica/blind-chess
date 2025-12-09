import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _personalBestKey = 'personal_best';

  Future<int> getPersonalBest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_personalBestKey) ?? 0;
  }

  Future<void> savePersonalBest(int best) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_personalBestKey, best);
  }
}
