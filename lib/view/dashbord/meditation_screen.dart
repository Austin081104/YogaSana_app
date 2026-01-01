import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_project/controller/dashboard_controller/meditation_controller.dart';
import 'package:yoga_project/view/detail_screens/meditation_detail_screen/category_meditation_detail.dart';
import 'package:yoga_project/widgets/meditation_screen_widget.dart/appbar_meditate.dart';
import 'package:yoga_project/widgets/meditation_screen_widget.dart/category_meditation_widget.dart';
import 'package:yoga_project/widgets/meditation_screen_widget.dart/new_meditate_widget.dart';
import 'package:yoga_project/widgets/meditation_screen_widget.dart/recommended_meditate_widget.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<MeditationController>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: AppbarMeditate()),

                // 🔍 SEARCH RESULTS
                if (provider.isSearching)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = provider.searchResults[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.img ?? "",
                            width: 55,
                            height: 55,
                          ),
                        ),
                        title: Text(item.title ?? ""),
                        subtitle: Text(item.category ?? ""),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryMeditationDetail(item: item),
                            ),
                          );
                        },
                      );
                    }, childCount: provider.searchResults.length),
                  )
                else ...[
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: CategoryMeditationWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: NewMeditateWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 25)),
                  SliverToBoxAdapter(child: RecommendedMeditateWidget()),
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
