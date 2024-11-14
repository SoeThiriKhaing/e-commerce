import 'package:flutter/material.dart';
import 'package:shop/admin/add_categories.dart';
import 'package:shop/admin/add_product.dart';
import 'package:shop/admin/add_type.dart';
import 'package:shop/admin/all_order.dart';
import 'package:shop/admin/management.dart';
import 'package:shop/pages/login.dart';
import 'package:shop/widget/support_widget.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Add Categories',
      'icon': Icons.category,
      'page': AddCategories(),
    },
    {
      'title': "Add Type",
      'icon': Icons.type_specimen_outlined,
      'page': AddType(),
    },
    {
      'title': 'Add Product',
      'icon': Icons.add_shopping_cart,
      'page': AddProduct(),
    },
    {
      'title': 'All Orders',
      'icon': Icons.shopping_bag_outlined,
      'page': AllOrder(),
    },
    {
      'title': 'Manage Data',
      'icon': Icons.edit_attributes_outlined,
      'page': Management(),
    },
    {
      'title': 'Log Out',
      'icon': Icons.logout_outlined,
      'page': Login(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xfff2f2f2),
        title: Center(
          child: Text(
            "Home Admin",
            style: AppWidget.boldTextStyle(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
          ),
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            final item = _menuItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item['page']),
                );
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        size: 50.0,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        item['title'],
                        textAlign: TextAlign.center,
                        style: AppWidget.boldTextStyle(),
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
  }
}
