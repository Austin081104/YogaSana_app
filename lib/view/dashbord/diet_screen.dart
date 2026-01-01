import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/dashboard_controller/diet_controller.dart';
import 'package:yoga_project/view/detail_screens/diet_detail_screens/category_diet_detail.dart';
import 'package:yoga_project/widgets/diet_screen_widgets/appbar_diet.dart';
import 'package:yoga_project/widgets/diet_screen_widgets/category_diet.dart';
import 'package:yoga_project/widgets/diet_screen_widgets/popular_diet_widget.dart';
import 'package:yoga_project/widgets/diet_screen_widgets/recommended_diet.dart';
import 'package:yoga_project/widgets/diet_screen_widgets/youmustry_diet_widget.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Consumer<DietController>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                /// ------------------ APP BAR WITH SEARCH ------------------
                SliverToBoxAdapter(child: AppbarDiet()),

                /// SHOW SEARCH RESULTS IF USER IS TYPING
                if (provider.searchResults.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = provider.searchResults[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryDietDetail(item: item),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.img ?? "",
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(item.title ?? ""),
                            subtitle: Text(item.category ?? ""),
                          ),
                        ),
                      );
                    }, childCount: provider.searchResults.length),
                  ),

                /// If searching → hide normal UI
                if (provider.searchResults.isEmpty) ...[
                  SliverToBoxAdapter(child: SizedBox(height: 20)),

                  /// CATEGORY ROW
                  SliverToBoxAdapter(child: CategoryDietWidget()),

                  /// RECOMMENDED ROW
                  SliverToBoxAdapter(child: RecommendedDietWiget()),
                  SliverToBoxAdapter(child: SizedBox(height: 25)),

                  /// YOU MUST TRY ROW
                  SliverToBoxAdapter(child: YoumustryDietWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 25)),

                  /// POPULAR ROW
                  SliverToBoxAdapter(child: PopularDietWidget()),
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
