import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yoga_project/controller/dashboard_controller/yoga_controller.dart';
import 'package:yoga_project/view/detail_screens/yoga_detail_screens/yoga_category_detail.dart';

class YogaWiegthlossWidget extends StatelessWidget {
  const YogaWiegthlossWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Yoga For Weight Loss",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 200,

            child: Consumer<YogaController>(
              builder: (context, diet, child) {
                /// ----------------------------------
                /// ⭐ SHOW SHIMMER WHEN LOADING
                /// ----------------------------------
                if (diet.weightLossYoga.isEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, __) => _shimmerCard(),
                  );
                }

                /// ----------------------------------
                /// ⭐ ACTUAL DATA (CACHED VERSION)
                /// ----------------------------------
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: diet.weightLossYoga.length,
                  itemBuilder: (context, i) {
                    /// ⭐ Reverse index
                    final reversedIndex = diet.weightLossYoga.length - 1 - i;
                    final item = diet.weightLossYoga[reversedIndex];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => YogaCategoryDetail(item: item),
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
                              /// ⭐ Cached Image
                              CachedNetworkImage(
                                imageUrl: item.img ?? '',
                                width: 150,
                                height: double.infinity,
                                fit: BoxFit.cover,

                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),

                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 40,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Tag
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.pink.shade50,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Text(
                                          "Weight Loss",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.pink,
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

  Widget _shimmerCard() {
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
