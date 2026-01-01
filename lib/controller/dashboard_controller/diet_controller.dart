import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_project/modal/diet_modal/recommended_diet_modal.dart';

class DietController extends ChangeNotifier {
  DietController() {
    init();
  }

  TextEditingController searchController = TextEditingController();
  List<RecommendedDiet> searchResults = [];

  List<RecommendedDiet> ofrecommenddata = [];
  List<RecommendedDiet> youMustTrydata = [];
  List<RecommendedDiet> populardata = [];

  // store ALL categories here
  Map<String, List<RecommendedDiet>> allCategories = {
    "breakfast": [],
    "lunch": [],
    "dinner": [],
  };

  List<RecommendedDiet> categoryItems = [];
  String selectedCategory = "breakfast";

  // ------------------------------------------------
  // INITIAL SETUP
  // ------------------------------------------------
  Future<void> init() async {
    final online = await isConnected();

    if (online) {
      await loadOnline();
    } else {
      await loadOffline();
    }

    // set default category instantly
    categoryItems = allCategories[selectedCategory] ?? [];

    notifyListeners();
  }

  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  // ------------------------------------------------
  // ONLINE DATA FETCH (ALL CATEGORY ENDPOINTS)
  // ------------------------------------------------
  Future<void> loadOnline() async {
    await Future.wait([
      loadRecommended(),
      loadMustTry(),
      loadPopular(),
      loadAllCategoriesOnline(),
    ]);
  }

  Future<void> loadAllCategoriesOnline() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> categories = ["breakfast", "lunch", "dinner"];

    for (String cat in categories) {
      final url =
          "https://mapi.trycatchtech.com/v3/yoga_app/diet_list_by_categories?category=$cat";

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        prefs.setString("CategoryData_$cat", res.body);
        allCategories[cat] = RecommendedDiet.ofdata(jsonDecode(res.body));
      }
    }
  }

  // ------------------------------------------------
  // OFFLINE DATA LOAD
  // ------------------------------------------------
  Future<void> loadOffline() async {
    final prefs = await SharedPreferences.getInstance();

    // Recommended
    final r = prefs.getString("recommendediet");
    if (r != null) ofrecommenddata = RecommendedDiet.ofdata(jsonDecode(r));

    // Must Try
    final m = prefs.getString("YouMustrydiet");
    if (m != null) youMustTrydata = RecommendedDiet.ofdata(jsonDecode(m));

    // Popular
    final p = prefs.getString("populardiet");
    if (p != null) populardata = RecommendedDiet.ofdata(jsonDecode(p));

    // Category caching
    for (String cat in ["breakfast", "lunch", "dinner"]) {
      final json = prefs.getString("CategoryData_$cat");
      if (json != null) {
        allCategories[cat] = RecommendedDiet.ofdata(jsonDecode(json));
      }
    }
  }

  // ------------------------------------------------
  // CATEGORY CHANGE - INSTANT (NO API CALL)
  // ------------------------------------------------
  void changeCategory(String cat) {
    selectedCategory = cat;
    categoryItems = allCategories[cat] ?? [];
    notifyListeners();
  }

  // ------------------------------------------------
  // INDIVIDUAL API CALLS
  // ------------------------------------------------
  Future<void> loadRecommended() async {
    final res = await http.get(Uri.parse(
        "https://mapi.trycatchtech.com/v3/yoga_app/recommended_diet"));

    if (res.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("recommendediet", res.body);
      ofrecommenddata = RecommendedDiet.ofdata(jsonDecode(res.body));
    }
  }

  Future<void> loadMustTry() async {
    final res = await http.get(Uri.parse(
        "https://mapi.trycatchtech.com/v3/yoga_app/you_must_try_diet"));

    if (res.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("YouMustrydiet", res.body);
      youMustTrydata = RecommendedDiet.ofdata(jsonDecode(res.body));
    }
  }

  Future<void> loadPopular() async {
    final res = await http.get(
        Uri.parse("https://mapi.trycatchtech.com/v3/yoga_app/popular_diet"));

    if (res.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("populardiet", res.body);
      populardata = RecommendedDiet.ofdata(jsonDecode(res.body));
    }
  }

  // ------------------------------------------------
  // SEARCH
  // ------------------------------------------------
  void searchDiet(String query) {
    if (query.isEmpty) {
      searchResults = [];
    } else {
      searchResults = [
        ...ofrecommenddata,
        ...youMustTrydata,
        ...populardata,
        ...categoryItems,
      ].where((diet) {
        final t = diet.title?.toLowerCase() ?? "";
        final c = diet.category?.toLowerCase() ?? "";
        return t.contains(query.toLowerCase()) ||
            c.contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}
