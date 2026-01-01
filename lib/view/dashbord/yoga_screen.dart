import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/dashboard_controller/yoga_controller.dart';
import 'package:yoga_project/view/detail_screens/yoga_detail_screens/yoga_category_detail.dart';
import 'package:yoga_project/widgets/yoga_screen_widgets/appbar_yoga.dart';
import 'package:yoga_project/widgets/yoga_screen_widgets/yoga_categoery_widget.dart';
import 'package:yoga_project/widgets/yoga_screen_widgets/yoga_popular_widget.dart';
import 'package:yoga_project/widgets/yoga_screen_widgets/yoga_recommended_widget.dart';
import 'package:yoga_project/widgets/yoga_screen_widgets/yoga_tabbar_widget.dart';
import 'package:yoga_project/widgets/yoga_screen_widgets/yoga_wiegthloss_widget.dart';

class YogaScreen extends StatelessWidget {
  const YogaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<YogaController>(
          builder: (context, yoga, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: AppbarYoga()),

               
                if (yoga.isSearching)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = yoga.searchResults[index];

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.img ?? "",
                            width: 60,
                            height: 60,
                          ),
                        ),
                        title: Text(item.title ?? ""),
                        subtitle: Text(item.category ?? ""),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YogaCategoryDetail(item: item),
                            ),
                          );
                        },
                      );
                    }, childCount: yoga.searchResults.length),
                  )
                // ▼ Normal UI when NOT searching
                else ...[
                  SliverToBoxAdapter(child: SizedBox(height: 15)),
                  SliverToBoxAdapter(child: YogaTabbarWidget()),
                  SliverToBoxAdapter(child: Divider()),
                  SliverToBoxAdapter(child: YogaCategoeryWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: YogaPopularWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: YogaRecommendedWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 25)),
                  SliverToBoxAdapter(child: YogaWiegthlossWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 30)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
