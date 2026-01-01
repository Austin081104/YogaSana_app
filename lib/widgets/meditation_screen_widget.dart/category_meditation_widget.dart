import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yoga_project/controller/dashboard_controller/meditation_controller.dart';
import 'package:yoga_project/view/detail_screens/meditation_detail_screen/category_meditation_detail.dart';

class CategoryMeditationWidget extends StatelessWidget {
  CategoryMeditationWidget({super.key});
  final List<String> categories = ["Sleep", "Relax", "Focus"];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// LEFT SIDE CATEGORIES
        Container(
          width: 70,
          color: Colors.white,
          child: Consumer<MeditationController>(
            builder: (context, controller, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: categories.map((cat) {
                  bool active =
                      controller.selectedCategory == cat.toLowerCase();

                  return InkWell(
                    onTap: () => controller.changeCategory(cat.toLowerCase()),
                    child: Card(
                      elevation: active ? 6 : 2,
                      color: active ? Colors.teal.shade50 : Colors.white,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 5,
                        ),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: active ? Colors.deepPurple : Colors.grey,
                              fontWeight: active
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: active ? 16 : 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        /// RIGHT SIDE CONTENT
        Expanded(
          child: Consumer<MeditationController>(
            builder: (context, controller, _) {
              // SHIMMER LOADING
              if (controller.categoryItems.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (_, __) => _buildShimmerCard(),
                    ),
                  ),
                );
              }

              /// ACTUAL DATA UI
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categoryItems.length,
                    itemBuilder: (context, i) {
                      final item = controller.categoryItems[i];

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoryMeditationDetail(item: item),
                          ),
                        ),

                        child: Container(
                          width: 180,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),

                            child: Stack(
                              children: [
                                /// ⭐ Cached Network Image
                                CachedNetworkImage(
                                  imageUrl: item.img ?? '',
                                  width: 180,
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

                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey.shade300,
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),

                                /// ⭐ FULL GRADIENT OVERLAY (TOP FADE)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.6),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12),

                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// Title
                                        Text(
                                          item.title ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),

                                        SizedBox(height: 6),

                                        /// Category Chip
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
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
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// ⭐ SHIMMER CARD ⭐
  Widget _buildShimmerCard() {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
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
