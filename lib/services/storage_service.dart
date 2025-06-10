// ignore_for_file: unused_field

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static const String _lessonsKey = 'lessons';
  static const String _exercisesKey = 'exercises';
  static const String _examsKey = 'exams';
  static const String _progressKey = 'progress';
  static const String _userKey = 'user';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic save method
  static Future<bool> saveData(String key, dynamic data) async {
    try {
      final jsonString = jsonEncode(data);
      return await _prefs!.setString(key, jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving data for key $key: $e');
      }
      return false;
    }
  }

  // Generic load method
  static T? loadData<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        return fromJson(jsonData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading data for key $key: $e');
      }
    }
    return null;
  }

  // Load list data
  static List<T> loadListData<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading list data for key $key: $e');
      }
    }
    return [];
  }

  // Save list data
  static Future<bool> saveListData<T>(String key, List<T> data) async {
    try {
      final jsonList = data.map((item) => (item as dynamic).toJson()).toList();
      return await saveData(key, jsonList);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving list data for key $key: $e');
      }
      return false;
    }
  }

  // Specific methods for app data
  static Future<bool> saveLessons(List<dynamic> lessons) async {
    return await saveData(_lessonsKey, lessons);
  }

  static List<Map<String, dynamic>> loadLessons() {
    try {
      final jsonString = _prefs!.getString(_lessonsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading lessons: $e');
      }
    }
    return [];
  }

  static Future<bool> saveExercises(List<dynamic> exercises) async {
    return await saveData(_exercisesKey, exercises);
  }

  static List<Map<String, dynamic>> loadExercises() {
    try {
      final jsonString = _prefs!.getString(_exercisesKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading exercises: $e');
      }
    }
    return [];
  }

  static Future<bool> saveExams(List<dynamic> exams) async {
    return await saveData(_examsKey, exams);
  }

  static List<Map<String, dynamic>> loadExams() {
    try {
      final jsonString = _prefs!.getString(_examsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading exams: $e');
      }
    }
    return [];
  }

  static Future<bool> saveProgress(Map<String, dynamic> progress) async {
    return await saveData(_progressKey, progress);
  }

  static Map<String, dynamic>? loadProgress() {
    try {
      final jsonString = _prefs!.getString(_progressKey);
      if (jsonString != null) {
        return jsonDecode(jsonString);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading progress: $e');
      }
    }
    return null;
  }

  // Clear all data
  static Future<bool> clearAll() async {
    try {
      return await _prefs!.clear();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing all data: $e');
      }
      return false;
    }
  }

  // Remove specific key
  static Future<bool> remove(String key) async {
    try {
      return await _prefs!.remove(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error removing key $key: $e');
      }
      return false;
    }
  }
}
