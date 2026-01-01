import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_project/modal/yoga_modal/yoga_modal.dart';

class YogaController extends ChangeNotifier {
  YogaController() {
    init();
  }

  String selectedGender = "women";
  String selectedSubCategory = "new";

  /// 🌟 Store EVERYTHING separately for MEN + WOMEN
  Map<String, Map<String, List<Yoga>>> allCategoryYoga = {
    "women": {"new": [], "skilled": [], "pro": []},
    "men": {"new": [], "skilled": [], "pro": []},
  };

  Map<String, List<Yoga>> allPopular = {
    "women": [],
    "men": [],
  };

  Map<String, List<Yoga>> allRecommended = {
    "women": [],
    "men": [],
  };

  Map<String, List<Yoga>> allWeightLoss = {
    "women": [],
    "men": [],
  };

  List<Yoga> categoryYoga = [];
  List<Yoga> popularYoga = [];
  List<Yoga> recommendedYoga = [];
  List<Yoga> weightLossYoga = [];

  List<Yoga> searchResults = [];
  bool isSearching = false;

  // -------------------------------------------------------
  Future<void> init() async {
    final online = await isConnected();

    if (online) {
      await loadOnlineAll();
    } else {
      await loadOfflineAll();
    }

    // Load current gender + sub category instantly
    updateDisplayedLists();

    notifyListeners();
  }

  // -------------------------------------------------------
  Future<bool> isConnected() async {
    final res = await Connectivity().checkConnectivity();
    return !res.contains(ConnectivityResult.none);
  }

  // -------------------------------------------------------
  // LOAD ALL ONLINE
  // -------------------------------------------------------
  Future<void> loadOnlineAll() async {
    await Future.wait([
      loadAllCategoryYoga(),
      loadPopular(),
      loadRecommended(),
      loadWeightLoss(),
    ]);
  }

  // -------------------------------------------------------
  // LOAD ALL CATEGORY YOGA for MEN + WOMEN
  // -------------------------------------------------------
  Future<void> loadAllCategoryYoga() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> genders = ["women", "men"];
    List<String> subs = ["new", "skilled", "pro"];

    for (String g in genders) {
      for (String s in subs) {
        final url =
            "https://mapi.trycatchtech.com/v3/yoga_app/yoga_list_by_categories?category=$g&sub_category=$s";

        final res = await http.get(Uri.parse(url));

        if (res.statusCode == 200) {
          prefs.setString("cache_yoga_${g}_$s", res.body);

          allCategoryYoga[g]![s] =
              Yoga.ofdata(jsonDecode(res.body)).where((y) => y.category == g).toList();
        }
      }
    }
  }

  // -------------------------------------------------------
  // LOAD POPULAR (filter men + women)
  // -------------------------------------------------------
  Future<void> loadPopular() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.get(
          Uri.parse("https://mapi.trycatchtech.com/v3/yoga_app/popular_yoga"));

      if (res.statusCode == 200) {
        prefs.setString("cache_yoga_popular", res.body);
        List<Yoga> raw = Yoga.ofdata(jsonDecode(res.body));

        // Split men & women
        allPopular["women"] = raw.where((y) => y.category == "women").toList();
        allPopular["men"] = raw.where((y) => y.category == "men").toList();
      }
    } catch (_) {}
  }

  // -------------------------------------------------------
  // LOAD RECOMMENDED (filter men + women)
  // -------------------------------------------------------
  Future<void> loadRecommended() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.get(
          Uri.parse("https://mapi.trycatchtech.com/v3/yoga_app/recommended_yoga"));

      if (res.statusCode == 200) {
        prefs.setString("cache_yoga_recommended", res.body);
        List<Yoga> raw = Yoga.ofdata(jsonDecode(res.body));

        allRecommended["women"] =
            raw.where((y) => y.category == "women").toList();
        allRecommended["men"] =
            raw.where((y) => y.category == "men").toList();
      }
    } catch (_) {}
  }

  // -------------------------------------------------------
  // LOAD WEIGHT LOSS (filter men + women)
  // -------------------------------------------------------
  Future<void> loadWeightLoss() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.get(
          Uri.parse("https://mapi.trycatchtech.com/v3/yoga_app/weight_loss_yoga"));

      if (res.statusCode == 200) {
        prefs.setString("cache_yoga_weightloss", res.body);
        List<Yoga> raw = Yoga.ofdata(jsonDecode(res.body));

        allWeightLoss["women"] =
            raw.where((y) => y.category == "women").toList();
        allWeightLoss["men"] =
            raw.where((y) => y.category == "men").toList();
      }
    } catch (_) {}
  }

  // -------------------------------------------------------
  // OFFLINE LOAD
  // -------------------------------------------------------
  Future<void> loadOfflineAll() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> genders = ["women", "men"];
    List<String> subs = ["new", "skilled", "pro"];

    // Category Yoga cache
    for (String g in genders) {
      for (String s in subs) {
        final json = prefs.getString("cache_yoga_${g}_$s");
        if (json != null) {
          allCategoryYoga[g]![s] = Yoga.ofdata(jsonDecode(json));
        }
      }
    }

    // Popular (split manually)
    final popJson = prefs.getString("cache_yoga_popular");
    if (popJson != null) {
      List<Yoga> raw = Yoga.ofdata(jsonDecode(popJson));

      allPopular["women"] = raw.where((y) => y.category == "women").toList();
      allPopular["men"] = raw.where((y) => y.category == "men").toList();
    }

    // Recommended
    final recJson = prefs.getString("cache_yoga_recommended");
    if (recJson != null) {
      List<Yoga> raw = Yoga.ofdata(jsonDecode(recJson));

      allRecommended["women"] =
          raw.where((y) => y.category == "women").toList();
      allRecommended["men"] =
          raw.where((y) => y.category == "men").toList();
    }

    // Weight Loss
    final wlJson = prefs.getString("cache_yoga_weightloss");
    if (wlJson != null) {
      List<Yoga> raw = Yoga.ofdata(jsonDecode(wlJson));

      allWeightLoss["women"] =
          raw.where((y) => y.category == "women").toList();
      allWeightLoss["men"] =
          raw.where((y) => y.category == "men").toList();
    }
  }

  // -------------------------------------------------------
  // UPDATE UI LISTS (no API call)
  // -------------------------------------------------------
  void updateDisplayedLists() {
    categoryYoga =
        allCategoryYoga[selectedGender]?[selectedSubCategory] ?? [];

    popularYoga = allPopular[selectedGender] ?? [];
    recommendedYoga = allRecommended[selectedGender] ?? [];
    weightLossYoga = allWeightLoss[selectedGender] ?? [];
  }

  // -------------------------------------------------------
  // CHANGE GENDER
  // -------------------------------------------------------
  void changeGender(String gender) {
    selectedGender = gender;
    updateDisplayedLists();
    notifyListeners();
  }

  // -------------------------------------------------------
  // CHANGE SUB CATEGORY
  // -------------------------------------------------------
  void changeSubCategory(String sub) {
    selectedSubCategory = sub;
    updateDisplayedLists();
    notifyListeners();
  }

  // -------------------------------------------------------
  // SEARCH
  // -------------------------------------------------------
  void searchYoga(String query) {
    if (query.isEmpty) {
      isSearching = false;
      searchResults = [];
    } else {
      isSearching = true;

      final all = [
        ...categoryYoga,
        ...popularYoga,
        ...recommendedYoga,
        ...weightLossYoga,
      ];

      searchResults = all
          .where((y) => y.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
