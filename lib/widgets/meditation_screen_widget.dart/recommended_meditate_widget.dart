import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yoga_project/controller/dashboard_controller/meditation_controller.dart';
import 'package:yoga_project/view/detail_screens/meditation_detail_screen/category_meditation_detail.dart';

class RecommendedMeditateWidget extends StatelessWidget {
  const RecommendedMeditateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommended For You",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 200,

            child: Consumer<MeditationController>(
              builder: (context, meditation, child) {
                /// ----------------------------------
                /// ⭐ SHOW SHIMMER WHEN LOADING
                /// ----------------------------------
                if (meditation.recommendedMeditation.isEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, __) => _shimmerCardp(),
                  );
                }
/// ----------------------------------
/// ⭐ ACTUAL DATA
/// ----------------------------------
return ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: meditation.recommendedMeditation.length,
  itemBuilder: (context, i) {
    final item = meditation.recommendedMeditation[i];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryMeditationDetail(item: item),
          ),
        );
      },

      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),

          child: Stack(
            children: [
              /// ⭐ Cached Network Image
              CachedNetworkImage(
                imageUrl: item.img ?? '',
                width: 150,
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

              /// ⭐ Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Calm Mind",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// Title
                      Text(
                        item.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
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

  Widget _shimmerCardp() {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,

        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
