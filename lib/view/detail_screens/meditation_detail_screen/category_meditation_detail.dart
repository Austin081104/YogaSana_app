import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga_project/modal/meditation_modal/meditation_modal.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CategoryMeditationDetail extends StatefulWidget {
  final Meditation item;

  const CategoryMeditationDetail({super.key, required this.item});

  @override
  State<CategoryMeditationDetail> createState() =>
      _CategoryMeditationDetailState();
}

class _CategoryMeditationDetailState extends State<CategoryMeditationDetail> {
  YoutubePlayerController? _ytController;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();

    /// Convert URL → Video ID safely
    String url = widget.item.videoLink ?? "";
    String? videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId != null && videoId.isNotEmpty) {
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
        ),
      );
    }
    checkIfSaved();
  }

  checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved_meditation")
        .doc(widget.item.id)
        .get();

    setState(() {
      isSaved = doc.exists;
    });
  }

  saveMeditation() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("saved_meditation")
        .doc(widget.item.id);

    if (isSaved) {
      // DELETE
      await ref.delete();
      setState(() => isSaved = false);
    } else {
      // SAVE
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

    /// Reset orientation on exit
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
            children: [
              // -----------------------------------------------------
              // 🔥 HEADER IMAGE WITH GRADIENT + TITLE
              // -----------------------------------------------------
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
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
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
                        onPressed: () => saveMeditation(), // IMPORTANT!
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            item.category?.toUpperCase() ?? "",
                            style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            item.title ?? "",
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // -----------------------------------------------------
              // 🔥 RESPONSIVE YOUTUBE PLAYER
              // -----------------------------------------------------
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
                      return AspectRatio(
                        aspectRatio: 16 / 9, // responsive
                        child: player,
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              // -----------------------------------------------------
              // 💜 PURPLE DESCRIPTION CARD
              // -----------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFB388FF).withOpacity(0.25),
                        const Color(0xFFD1C4E9).withOpacity(0.30),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.shade100.withOpacity(0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Take a moment to relax and reconnect with yourself. "
                        "This guided meditation helps quiet your thoughts, "
                        "ease stress, and bring inner peace.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.deepPurple.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: Colors.purple.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "“A calm mind brings inner strength and self-confidence.”",
                              style: TextStyle(
                                color: Colors.purple.shade700,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
