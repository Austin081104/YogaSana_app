import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yoga_project/controller/dashboard_controller/yoga_controller.dart';
import 'package:yoga_project/view/detail_screens/yoga_detail_screens/yoga_category_detail.dart';

class YogaRecommendedWidget extends StatelessWidget {
  const YogaRecommendedWidget({super.key});

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
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),

          SizedBox(
            height: 180,

            /// ⭐ Consumer
            child: Consumer<YogaController>(
              builder: (context, yoga, child) {
                /// ----------------------------------------------------
                /// ⭐ SHIMMER WHEN LOADING
                /// ----------------------------------------------------
                if (yoga.recommendedYoga.isEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, __) => _shimmerCard(),
                  );
                }

                /// ----------------------------------------------------
                /// ⭐ REAL DATA (With Cache)
                /// ----------------------------------------------------
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: yoga.recommendedYoga.length,
                  itemBuilder: (context, i) {
                    final item = yoga.recommendedYoga[i];

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
                        width: 130,
                        margin: EdgeInsets.only(right: 12),
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
                                width: 130,
                                height: double.infinity,
                                fit: BoxFit.cover,

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
                                      /// Tag label
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.pink.shade50,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          "Must Try",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 4),

                                      /// Title text
                                      Text(
                                        item.title ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
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
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
