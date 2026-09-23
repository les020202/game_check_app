import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/game_template.dart';
import '../models/game_type.dart';

class GameTemplateService {
  List<GameTemplate>? _cache;

  Future<List<GameTemplate>> getAllTemplates() async {
    if (_cache != null) return _cache!;
    final jsonString = await rootBundle.loadString(
      'assets/presets/game_templates.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    _cache = jsonList
        .map((e) => GameTemplate.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  Future<List<GameTemplate>> getTemplatesByTypes(Set<GameType> types) async {
    final all = await getAllTemplates();
    return all.where((t) => types.contains(t.gameType)).toList();
  }

  Future<GameTemplate?> findByName(String gameName) async {
    final all = await getAllTemplates();
    try {
      return all.firstWhere((t) => t.gameName == gameName);
    } catch (_) {
      return null;
    }
  }
}