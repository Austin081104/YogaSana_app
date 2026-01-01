import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yoga_project/controller/dashboard_controller/diet_controller.dart';
import 'package:yoga_project/view/detail_screens/diet_detail_screens/category_diet_detail.dart';

class PopularDietWidget extends StatelessWidget {
  const PopularDietWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Popular recipes",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 200,

            child: Consumer<DietController>(
              builder: (context, diet, child) {
                /// ----------------------------------
                /// ⭐ SHOW SHIMMER WHEN LOADING
                /// ----------------------------------
                if (diet.populardata.isEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, __) => _shimmerCard(),
                  );
                }

                /// ----------------------------------
                /// ⭐ ACTUAL DATA
                /// ----------------------------------
                /// ----------------------------------
                /// ⭐ ACTUAL DATA (with CachedNetworkImage)
                /// ----------------------------------
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: diet.populardata.length,
                  itemBuilder: (context, i) {
                    /// ⭐ Reverse index
                    final reversedIndex = diet.populardata.length - 1 - i;
                    final item = diet.populardata[reversedIndex];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryDietDetail(item: item),
                          ),
                        );
                      },

                      child: Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),

                          child: Stack(
                            children: [
                              /// ⭐ Cached Network Image
                              CachedNetworkImage(
                                imageUrl: item.img ?? "",
                                fit: BoxFit.cover,
                                width: 150,
                                height: double.infinity,

                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.pink,
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

                              /// ⭐ Gradient + Text Overlay
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
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
                                          "Popular",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 4),

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

  /// -------------------------------------------------------------
  /// ⭐ SHIMMER CARD PLACEHOLDER (150×200 with rounded corners)
  /// -------------------------------------------------------------
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
