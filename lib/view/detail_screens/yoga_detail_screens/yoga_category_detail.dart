import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga_project/modal/yoga_modal/yoga_modal.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YogaCategoryDetail extends StatefulWidget {
  final Yoga item;

  const YogaCategoryDetail({super.key, required this.item});

  @override
  State<YogaCategoryDetail> createState() => _YogaCategoryDetailState();
}

class _YogaCategoryDetailState extends State<YogaCategoryDetail> {
  YoutubePlayerController? _ytController;
  bool isSaved = false;
  @override
  void initState() {
    super.initState();

    String url = widget.item.videoLink ?? "";
    String? videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId != null && videoId.isNotEmpty) {
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }
    checkIfSaved();
  }

  Future<void> checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved_yoga")
        .doc(widget.item.id)
        .get();

    setState(() {
      isSaved = doc.exists;
    });
  }

  Future<void> toggleSave() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved_yoga")
        .doc(widget.item.id);

    if (isSaved) {
      await ref.delete();
      setState(() => isSaved = false);
    } else {
      await ref.set({
        "id": widget.item.id,
        "title": widget.item.title,
        "category": widget.item.category,
        "img": widget.item.img,
        "videoLink": widget.item.videoLink,
        "savedAt": DateTime.now(),
      });
      setState(() => isSaved = true);
    }
  }

  @override
  void dispose() {
    _ytController?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------
              // 🔥 TOP HERO IMAGE WITH GRADIENT + TITLE
              // -------------------------------------------------
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.img ?? "",
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,

                      placeholder: (context, url) => Container(
                        height: 300,
                        color: Colors.grey.shade300,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                            strokeWidth: 2,
                          ),
                        ),
                      ),

                      errorWidget: (context, url, error) => Container(
                        height: 300,
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 35,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 26,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  //save button
                  // SAVE BUTTON (TOP RIGHT)
                  Positioned(
                    top: 35,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      child: IconButton(
                        icon: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: () => toggleSave(), // IMPORTANT!
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 25,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CATEGORY CHIP
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (item.category ?? "").toUpperCase(),
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // TITLE
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            item.title ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // -------------------------------------------------
              // 🔥 YOUTUBE PLAYER (RESPONSIVE)
              // -------------------------------------------------
              if (_ytController != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _ytController!,
                      showVideoProgressIndicator: true,
                    ),
                    onEnterFullScreen: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight,
                      ]);
                    },
                    onExitFullScreen: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                    },
                    builder: (context, player) {
                      return AspectRatio(aspectRatio: 16 / 9, child: player);
                    },
                  ),
                ),

              const SizedBox(height: 25),

              // -------------------------------------------------
              // 💜 DESCRIPTION CARD (MODERN PURPLE)
              // -------------------------------------------------
              _buildDescriptionCard(),

              const SizedBox(height: 25),

              // -------------------------------------------------
              // 🧘 BENEFITS SECTION
              // -------------------------------------------------
              _buildBenefitsSection(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 💜 Description Widget
  // ---------------------------------------------------------
  Widget _buildDescriptionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE1BEE7).withOpacity(0.35),
              const Color(0xFFCE93D8).withOpacity(0.25),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.shade100,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Take a moment to reconnect with your body and mind. "
              "This yoga pose brings balance, improves flexibility, "
              "and helps restore inner calm.",
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.deepPurple.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.favorite,
                  size: 20,
                  color: Colors.deepPurple.shade400,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "“Your body is your temple. Keep it pure and clean for the soul to reside in.”",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // ⭐ BENEFITS SECTION
  // ---------------------------------------------------------
  Widget _buildBenefitsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Benefits",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),

          _benefitTile("Improves flexibility"),
          _benefitTile("Strengthens core muscles"),
          _benefitTile("Enhances balance"),
          _benefitTile("Reduces stress and anxiety"),
          _benefitTile("Boosts energy and mood"),
        ],
      ),
    );
  }

  Widget _benefitTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.deepPurple.shade400, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
