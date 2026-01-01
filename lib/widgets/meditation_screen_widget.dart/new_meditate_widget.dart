import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yoga_project/controller/dashboard_controller/meditation_controller.dart';
import 'package:yoga_project/view/detail_screens/meditation_detail_screen/category_meditation_detail.dart';

class NewMeditateWidget extends StatelessWidget {
  const NewMeditateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Meditation",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),

          SizedBox(
            height: 200,

            /// 👉 Consumer
            child: Consumer<MeditationController>(
              builder: (context, meditation, child) {
                /// ----------------------------------------------------
                /// ⭐ SHIMMER WHEN LOADING
                /// ----------------------------------------------------
                if (meditation.newMeditation.isEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, __) => _shimmerCard(),
                  );
                }

                /// ----------------------------------------------------
                /// ⭐ ACTUAL DATA
                /// ----------------------------------------------------
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: meditation.newMeditation.length,
                  itemBuilder: (context, i) {
                    final item = meditation.newMeditation[i];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoryMeditationDetail(item: item),
                          ),
                        );
                      },

                      child: Container(
                        width: 260,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: Stack(
                            children: [
                              /// ⭐ Cached Image
                              CachedNetworkImage(
                                imageUrl: item.img ?? '',
                                width: 260,
                                height: double.infinity,
                                fit: BoxFit.cover,

                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.deepPurple,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),

                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                              /// ⭐ Bottom Gradient Overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.6),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Category Chip
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          item.category ?? "",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.deepPurpleAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 8),

                                      /// Title
                                      Text(
                                        item.title ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerCard() {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
