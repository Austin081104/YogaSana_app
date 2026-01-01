import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yoga_project/controller/dashboard_controller/yoga_controller.dart';
import 'package:yoga_project/view/detail_screens/yoga_detail_screens/yoga_category_detail.dart';

class YogaCategoeryWidget extends StatelessWidget {
   YogaCategoeryWidget({super.key});
 final List<String> categories = ["New", "Skilled", "Pro"];
  @override
  Widget build(BuildContext context) {
    return Row(
                children: [
                  /// LEFT SIDE CATEGORIES
                  Container(
                    width: 70,
                    color: Colors.white,
                    child: Consumer<YogaController>(
                      builder: (context, controller, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: categories.map((cat) {
                            bool active =
                                controller.selectedSubCategory ==
                                cat.toLowerCase();

                            return InkWell(
                              onTap: () => controller.changeSubCategory(
                                cat.toLowerCase(),
                              ),
                              child: Card(
                                elevation: active ? 6 : 2,
                                color: active
                                    ? Colors.teal.shade50
                                    : Colors.white,
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
                                        color: active
                                            ? Colors.pinkAccent
                                            : Colors.grey,
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
                    child: Consumer<YogaController>(
                      builder: (context, controller, _) {
                        // SHIMMER LOADING
                        if (controller.categoryYoga.isEmpty) {
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
      itemCount: controller.categoryYoga.length,
      itemBuilder: (context, i) {
        final item = controller.categoryYoga[i];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => YogaCategoryDetail(item: item),
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
                          color: Colors.pink,
                          strokeWidth: 2,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Sub-category chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.subCategory ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 6),

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