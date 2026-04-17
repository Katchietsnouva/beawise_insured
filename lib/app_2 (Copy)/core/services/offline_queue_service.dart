import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insured/app_2/data/models/offline_action_model.dart';

class OfflineQueueService {
  static const String _key = 'offline_actions';

  Future<List<OfflineAction>> getActions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => OfflineAction.fromJson(e)).toList();
  }

  Future<void> saveActions(List<OfflineAction> actions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(actions.map((a) => a.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<void> addAction(OfflineAction action) async {
    final actions = await getActions();
    actions.add(action);
    await saveActions(actions);
  }

  Future<void> updateAction(OfflineAction updated) async {
    final actions = await getActions();
    final index = actions.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      actions[index] = updated;
      await saveActions(actions);
    }
  }

  Future<void> removeAction(String id) async {
    final actions = await getActions();
    actions.removeWhere((a) => a.id == id);
    await saveActions(actions);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
