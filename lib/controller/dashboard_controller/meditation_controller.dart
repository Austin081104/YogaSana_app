import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_project/modal/meditation_modal/meditation_modal.dart';

class MeditationController extends ChangeNotifier {
  MeditationController() {
    init();
  }

  List<Meditation> newMeditation = [];
  List<Meditation> recommendedMeditation = [];

  // ---------- UI category → API category mapping ----------
  Map<String, String> apiCategoryMap = {
    "sleep": "sleep",
    "relax": "relax",   
    "focus": "focus",
  };

  // ---------- store ALL categories here ----------
  Map<String, List<Meditation>> allCategories = {
    "sleep": [],
    "relax": [],
    "focus": [],
  };

  List<Meditation> categoryItems = [];
  List<Meditation> searchResults = [];
  bool isSearching = false;

  String selectedCategory = "sleep";

  // ------------------------------------------------
  // INIT
  // ------------------------------------------------
  Future<void> init() async {
    final online = await isConnected();

    if (online) {
      await loadOnline();
    } else {
      await loadOffline();
    }

    // Default category items
    categoryItems = allCategories[selectedCategory] ?? [];

    notifyListeners();
  }

  // ------------------------------------------------
  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  // ------------------------------------------------
  // LOAD ALL ONLINE
  // ------------------------------------------------
  Future<void> loadOnline() async {
    await Future.wait([
      loadNewMeditation(),
      loadRecommendedMeditation(),
      loadAllCategoryMeditation(),
    ]);
  }

  // ---------- LOAD ALL CATEGORY MEDITATION AT ONCE ----------
  Future<void> loadAllCategoryMeditation() async {
    final prefs = await SharedPreferences.getInstance();

    for (String uiCategory in ["sleep", "relax", "focus"]) {
      final apiCategory = apiCategoryMap[uiCategory] ?? uiCategory;

      final url =
          "https://mapi.trycatchtech.com/v3/yoga_app/meditation_list_by_categories?category=$apiCategory";

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        prefs.setString("cache_meditation_$uiCategory", res.body);
        allCategories[uiCategory] =
            Meditation.ofdata(jsonDecode(res.body));
      }
    }
  }

  // ------------------------------------------------
  // OFFLINE LOAD
  // ------------------------------------------------
  Future<void> loadOffline() async {
    final prefs = await SharedPreferences.getInstance();

    // New meditation
    final newJson = prefs.getString("cache_new_meditation");
    if (newJson != null) {
      newMeditation = Meditation.ofdata(jsonDecode(newJson));
    }

    // Recommended meditation
    final recJson = prefs.getString("cache_recommended_meditation");
    if (recJson != null) {
      recommendedMeditation = Meditation.ofdata(jsonDecode(recJson));
    }

    // Load cached category data
    for (String cat in ["sleep", "relax", "focus"]) {
      final json = prefs.getString("cache_meditation_$cat");
      if (json != null) {
        allCategories[cat] = Meditation.ofdata(jsonDecode(json));
      }
    }
  }

  // ------------------------------------------------
  // NEW MEDITATION
  // ------------------------------------------------
  Future<void> loadNewMeditation() async {
    try {
      final res = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/yoga_app/new_meditation"));

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("cache_new_meditation", res.body);

        newMeditation = Meditation.ofdata(jsonDecode(res.body));
      }
    } catch (e) {
      print("NEW MEDITATION ERROR: $e");
    }
  }

  // ------------------------------------------------
  // RECOMMENDED MEDITATION
  // ------------------------------------------------
  Future<void> loadRecommendedMeditation() async {
    try {
      final res = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/yoga_app/recommended_meditation"));

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("cache_recommended_meditation", res.body);

        recommendedMeditation = Meditation.ofdata(jsonDecode(res.body));
      }
    } catch (e) {
      print("RECOMMENDED MEDITATION ERROR: $e");
    }
  }

  // ------------------------------------------------
  // CHANGE CATEGORY — INSTANT (NO API CALL)
  // ------------------------------------------------
  void changeCategory(String cat) {
    selectedCategory = cat;
    categoryItems = allCategories[cat] ?? [];
    notifyListeners();
  }

  // ------------------------------------------------
  // SEARCH
  // ------------------------------------------------
  void searchMeditation(String query) {
    if (query.isEmpty) {
      isSearching = false;
      searchResults = [];
    } else {
      isSearching = true;

      searchResults = [
        ...newMeditation,
        ...recommendedMeditation,
        ...categoryItems,
      ].where((item) {
        final title = item.title?.toLowerCase() ?? "";
        return title.contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}
