import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/pages/product_detail.dart';
import 'package:shop/pages/seeall_cat.dart';
import 'package:shop/pages/seeall_product.dart';
import 'package:shop/services/database.dart';
import 'package:shop/services/share_preferences.dart';
import 'package:shop/widget/support_widget.dart';
import 'package:shop/pages/category_product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  List categories = [];
  List categoryNames = [];
  bool isLoading = true;
  void fetchCategories() async {
    try {
      FirebaseFirestore.instance
          .collection("categories")
          .snapshots()
          .listen((snapshot) {
        setState(() {
          categories = snapshot.docs
              .map((doc) =>
                  doc['image'] ?? '') // Use empty string if image is null
              .where(
                  (image) => image.isNotEmpty) // Filter out empty image entries
              .toList();
          categoryNames = snapshot.docs
              .map((doc) => doc['name'] ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
        });
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  TextEditingController searchController = TextEditingController();
  var QueryResultSet = [];
  var tempSearchStore = [];
  void initialSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        QueryResultSet = [];
        tempSearchStore = [];
        search = false;
      });
      return;
    }

    setState(() {
      search = true;
    });

    var capitalizedValue = value.isNotEmpty
        ? value.substring(0, 1).toUpperCase() + value.substring(1)
        : value;

    if (QueryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        setState(() {
          QueryResultSet = docs.docs.map((doc) => doc.data()).toList();
          tempSearchStore = QueryResultSet.where((element) {
            return element["updatedname"].startsWith(capitalizedValue);
          }).toList();
        });
      });
    } else {
      setState(() {
        tempSearchStore = QueryResultSet.where((element) {
          return element["updatedname"].startsWith(capitalizedValue);
        }).toList();
      });
    }
  }

  void setGreetingMessage() {
    final time = DateTime.now().hour;
    if (time < 12) {
      greeting = "Good Morning";
    } else if (time < 16) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good evening";
    }
  }

  String? name, image;
  String greeting = "";
  Future<void> getthesharedpref() async {
    name = await SharePreferencesHelper().getUserName();
    image = await SharePreferencesHelper().getUserImage();
    setState(() {
      isLoading = false;
    });
  }

  ontheload() async {
    await getthesharedpref();
    setGreetingMessage();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "Hey, ${name ?? "Guest"}",
                              style: AppWidget.boldTextStyle(),
                            ),
                      Text(
                        greeting,
                        style: AppWidget.LightTextStyle(),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                        image ?? "https://example.com/default-image.jpg",
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "images/profile.png",
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    initialSearch(value.toUpperCase());
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Products",
                      hintStyle: AppWidget.LightTextStyle(),
                      prefixIcon: search
                          ? GestureDetector(
                              onTap: () {
                                search = false;
                                tempSearchStore = [];
                                QueryResultSet = [];
                                searchController.text = "";
                                setState(() {});
                              },
                              child: Icon(Icons.close))
                          : Icon(
                              Icons.search,
                              color: Colors.black,
                            )),
                ),
              ),
              SizedBox(height: 20.0),
              search
                  ? ListView(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore.map((element) {
                        return buildResultCard(element);
                      }).toList(),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Categories",
                                style: AppWidget.semiboldTextStyle(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to CategoryListPage on "see all" tap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryListPage(
                                        categories: categories,
                                        categoryNames: categoryNames,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "see all",
                                  style: AppWidget.seeAllTextStyle(),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Container(
                              height: 130,
                              padding: EdgeInsets.all(20.0),
                              margin: EdgeInsets.only(right: 20.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFD6F3E),
                                  borderRadius: BorderRadius.circular(10)),
                              width: 90,
                              child: Center(
                                child: Text(
                                  "All",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 120,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: categories.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return CategoryTile(
                                          image: categories[index],
                                          name: categoryNames[index]);
                                    }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "All Products",
                              style: AppWidget.semiboldTextStyle(),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllProduct()));
                              },
                              child: Text(
                                "see all",
                                style: AppWidget.seeAllTextStyle(),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          height: 190,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              ProductTile(
                                  image: "images/headphone.png",
                                  name: "Headphone",
                                  price: "\$100"),
                              ProductTile(
                                  image: "images/laptop.png",
                                  name: "Laptop",
                                  price: "\$300"),
                              ProductTile(
                                  image: "images/a.png",
                                  name: "Earphone",
                                  price: "\$200"),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      image: data["Image"],
                      name: data["Name"],
                      price: data["Price"],
                      detail: data["Detail"],
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                data["Image"],
                height: 70.0,
                width: 70.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              data["Name"],
              style: AppWidget.semiboldTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String image, name;
  final bool isCategoryListPage;
  const CategoryTile({
    super.key,
    required this.image,
    required this.name,
    this.isCategoryListPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProduct(category: name),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 120,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            image.startsWith('http')
                ? Image.network(image, height: 50, width: 50, fit: BoxFit.cover)
                : Image.asset(image, height: 50, width: 50, fit: BoxFit.cover),
            SizedBox(height: 10.0),
            if (!isCategoryListPage) Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String image, name, price;
  ProductTile({required this.image, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          Image.asset(
            image,
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
          Text(name, style: AppWidget.semiboldTextStyle()),
          SizedBox(height: 10.0),
          Row(
            children: [
              Text(
                price,
                style: TextStyle(
                    color: Color(0xFFfd6f3e),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 40.0),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Color(0xFFfd6f3e),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
