import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop/widget/support_widget.dart';

class Management extends StatefulWidget {
  const Management({super.key});

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          "Management Data",
          style: AppWidget.boldTextStyle(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Categories'),
            Tab(text: 'All Product Types'),
            Tab(text: 'All Products'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllCategoriesTab(),
          AllProductTypesTab(),
          AllProductsTab(),
        ],
      ),
    );
  }
}

class AllCategoriesTab extends StatelessWidget {
  const AllCategoriesTab({super.key});

  void _updateCategory(BuildContext context, String docId, String currentName) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Category'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('categories')
                    .doc(docId)
                    .update({'name': nameController.text});
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');

    return StreamBuilder(
      stream: categories.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading categories'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return ListTile(
              title: Text(doc['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _updateCategory(context, doc.id, doc['name']),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      categories.doc(doc.id).delete();
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class AllProductTypesTab extends StatelessWidget {
  const AllProductTypesTab({super.key});

  void _updateProductType(
      BuildContext context, String docId, String currentName) {
    final TextEditingController typeController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Product Type'),
          content: TextField(
            controller: typeController,
            decoration: const InputDecoration(labelText: 'Product Type Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('types')
                    .doc(docId)
                    .update({'name': typeController.text});
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference productTypes =
        FirebaseFirestore.instance.collection('types');

    return StreamBuilder(
      stream: productTypes.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading product types'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return ListTile(
              title: Text(doc['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _updateProductType(context, doc.id, doc['name']),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      productTypes.doc(doc.id).delete();
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class AllProductsTab extends StatelessWidget {
  const AllProductsTab({super.key});

  void _updateProduct(BuildContext context, String docId, String currentName,
      double currentPrice) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);
    final TextEditingController priceController =
        TextEditingController(text: currentPrice.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('product')
                    .doc(docId)
                    .update({
                  'Name': nameController.text,
                  'Price':
                      double.tryParse(priceController.text) ?? currentPrice,
                });
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference products =
        FirebaseFirestore.instance.collection('product');

    return StreamBuilder(
      stream: products.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading products'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final price = doc['Price'];
            double priceValue;

            if (price is int) {
              priceValue = price.toDouble();
            } else if (price is String) {
              priceValue = double.tryParse(price) ?? 0.0;
            } else if (price is double) {
              priceValue = price;
            } else {
              priceValue = 0.0; // Fallback for unexpected cases
            }

            return ListTile(
              title: Text(doc['Name']),
              subtitle: Text('Price: \$${priceValue.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _updateProduct(
                      context,
                      doc.id,
                      doc['Name'],
                      priceValue,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      products.doc(doc.id).delete();
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
