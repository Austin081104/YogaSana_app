import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yoga_project/modal/diet_modal/recommended_diet_modal.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CategoryDietDetail extends StatefulWidget {
  final RecommendedDiet item;

  const CategoryDietDetail({super.key, required this.item});

  @override
  State<CategoryDietDetail> createState() => _CategoryDietDetailState();
}

class _CategoryDietDetailState extends State<CategoryDietDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  YoutubePlayerController? _ytController;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    checkIfSaved();

    _tabController = TabController(length: 3, vsync: this);

    // Convert URL to Video ID
    if (widget.item.videoLink != null) {
      String? videoId = YoutubePlayer.convertUrlToId(widget.item.videoLink!);

      if (videoId != null) {
        _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false),
        );
      }
    }
  }

  Future<void> checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved_diets")
        .doc(widget.item.id)
        .get();

    setState(() => isSaved = snap.exists);
  }

  Future<void> toggleSave() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved_diets")
        .doc(widget.item.id);

    if (isSaved) {
      await docRef.delete();
    } else {
      await docRef.set({...widget.item.toJson(), "savedAt": DateTime.now()});
    }

    setState(() => isSaved = !isSaved);

    
  }

  @override
  void dispose() {
    _ytController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(item.title ?? "", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 28,
            ),
            onPressed: toggleSave,
          ),
        ],
      ),

      body: Column(
        children: [
          if (_ytController != null)
            YoutubePlayer(
              controller: _ytController!,
              showVideoProgressIndicator: true,
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              item.title ?? "",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          TabBar(
            controller: _tabController,
            labelColor: Colors.teal,
            tabs: const [
              Tab(text: "Ingredients"),
              Tab(text: "Instructions"),
              Tab(text: "Nutritions"),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _list(item.ingredients),
                _list(item.instructions),
                _list(item.nutritions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _list(List<String>? items) {
    if (items == null || items.isEmpty) {
      return Center(child: Text("No data available"));
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: items
          .map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text("• $e", style: TextStyle(fontSize: 16)),
            ),
          )
          .toList(),
    );
  }
}
