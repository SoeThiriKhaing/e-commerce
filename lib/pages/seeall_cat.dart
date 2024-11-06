import 'package:flutter/material.dart';
import 'package:shop/pages/home.dart';

class CategoryListPage extends StatefulWidget {
  final List categories;
  final List categoryNames;

  const CategoryListPage({
    super.key,
    required this.categories,
    required this.categoryNames,
  });

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                child: CategoryTile(
                  image: widget.categories[index],

                  name: widget.categoryNames[index],
                  isCategoryListPage: true, // Hides the arrow_forward icon
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          );
        },
      ),
    );
  }
}
