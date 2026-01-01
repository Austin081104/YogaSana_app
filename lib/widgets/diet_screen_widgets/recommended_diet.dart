import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yoga_project/controller/dashboard_controller/diet_controller.dart';
import 'package:yoga_project/view/detail_screens/diet_detail_screens/category_diet_detail.dart';

class RecommendedDietWiget extends StatelessWidget {
  const RecommendedDietWiget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommended For You",
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
            child: Consumer<DietController>(
              builder: (context, diet, child) {
                /// ----------------------------------------------------
                /// ⭐ SHIMMER WHEN LOADING
                /// ----------------------------------------------------
                if (diet.ofrecommenddata.isEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, __) => _shimmerCard(),
                  );
                }

                /// ----------------------------------------------------
                /// ⭐ ACTUAL DATA (with CachedNetworkImage)
                /// ----------------------------------------------------
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: diet.ofrecommenddata.length,
                  itemBuilder: (context, i) {
                    final item = diet.ofrecommenddata[i];

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
                                imageUrl: item.img ?? "",
                                fit: BoxFit.cover,
                                width: 260,
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
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                              /// ⭐ Gradient + Content Overlay
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
                                  padding: const EdgeInsets.all(12),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// ⭐ Category Chip
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
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      /// ⭐ Title
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

  /// ----------------------------------------------------------------------
  /// ⭐ SHIMMER PLACEHOLDER SAME SIZE AS REAL CARD (260 × 200)
  /// ----------------------------------------------------------------------
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
