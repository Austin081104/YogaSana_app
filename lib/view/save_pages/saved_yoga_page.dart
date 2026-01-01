import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yoga_project/modal/yoga_modal/yoga_modal.dart';
import 'package:yoga_project/view/detail_screens/yoga_detail_screens/yoga_category_detail.dart';

class SavedYogaPage extends StatelessWidget {
  const SavedYogaPage({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Yoga",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink,
        elevation: 0,
         leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("saved_yoga")
            .orderBy("savedAt", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Saved Yoga Yet",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          final yogaList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: yogaList.length,
            itemBuilder: (context, index) {
              final data = yogaList[index].data();
              final yoga = Yoga.fromJson(data);

              return _savedYogaCard(context, yoga);
            },
          );
        },
      ),
    );
  }

  // ------------------- CARD UI -------------------
  Widget _savedYogaCard(BuildContext context, Yoga item) {
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
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                item.img ?? "",
                height: 110,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // TITLE + CATEGORY
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? "No Title",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.category ?? "",
                      style: TextStyle(
                        color: Colors.deepPurple.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // DELETE BUTTON
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                String uid = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .collection("saved_yoga")
                    .doc(item.id)
                    .delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
