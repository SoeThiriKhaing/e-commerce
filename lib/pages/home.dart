import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/pages/product_detail.dart';
import 'package:shop/pages/product_type.dart';
import 'package:shop/pages/seeall_cat.dart';
import 'package:shop/services/share_preferences.dart';
import 'package:shop/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearchActive = false;
  List<dynamic> categories = [];
  List<String> categoryNames = [];
  List<Map<String, dynamic>> queryResultSet = [];
  List<Map<String, dynamic>> tempSearchStore = [];
  bool isLoading = true;
  String greeting = "";
  String? name, image;

  final TextEditingController searchController = TextEditingController();

  final List<String> carouselImages = [
    'images/adv2.jpg',
    'images/adv3.jpg',
    'images/adv4.jpg',
    'images/adv5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchUserPreferences();
    setGreetingMessage();
    fetchCategories();
  }

  Future<void> fetchUserPreferences() async {
    name = await SharePreferencesHelper.getUserName();
    image = await SharePreferencesHelper.getUserImage();
    setState(() => isLoading = false);
  }

  void setGreetingMessage() {
    final time = DateTime.now().hour;
    if (time < 12) {
      greeting = "Good Morning";
    } else if (time < 16) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }
  }

  void fetchCategories() {
    FirebaseFirestore.instance.collection("categories").snapshots().listen(
      (snapshot) {
        setState(() {
          categories = snapshot.docs
              .map((doc) => doc['image'] as String? ?? '')
              .where((image) => image.isNotEmpty)
              .toList();
          categoryNames = snapshot.docs
              .map((doc) => doc['name'] as String? ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
        });
      },
    );
  }

  void performSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      setState(() {
        isSearchActive = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    setState(() => isSearchActive = true);

    final capitalizedQuery = query[0].toUpperCase() + query.substring(1);

    FirebaseFirestore.instance
        .collection('product')
        .where('Name', isGreaterThanOrEqualTo: capitalizedQuery)
        .where('Name',
            isLessThan: '${capitalizedQuery}z') // Handles partial match
        .get()
        .then((QuerySnapshot snapshot) {
      final results = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        queryResultSet = results;
        tempSearchStore = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              const SizedBox(height: 30),
              buildSearchBar(),
              const SizedBox(height: 40),
              if (!isSearchActive)
                buildCarouselSlider(), // Added carousel slider here
              const SizedBox(height: 50),
              if (isSearchActive) buildSearchResults() else buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? const CircularProgressIndicator()
                : Text("Hey, $name", style: AppWidget.boldTextStyle()),
            Text(greeting, style: AppWidget.LightTextStyle()),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            image ?? "images/profile.png",
            height: 70,
            width: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("images/profile.png", height: 70, width: 70);
            },
          ),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: searchController,
        onChanged: performSearch,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search Products",
          prefixIcon: Icon(isSearchActive ? Icons.close : Icons.search,
              color: Colors.black),
        ),
      ),
    );
  }

  Widget buildSearchResults() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tempSearchStore.length,
      itemBuilder: (context, index) {
        final item = tempSearchStore[index];
        return buildResultCard(item);
      },
    );
  }

  Widget buildCarouselSlider() {
    return CarouselSlider(
      items: carouselImages.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }

  Widget buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader("Categories", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryListPage(
                      categories: categories, categoryNames: categoryNames)));
        }),
        SizedBox(
          height: 40,
        ),
        buildCategoryList(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppWidget.semiboldTextStyle()),
        GestureDetector(
          onTap: onSeeAll,
          child: Text("see all", style: AppWidget.seeAllTextStyle()),
        ),
      ],
    );
  }

  Widget buildCategoryList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final categoryName = categoryNames[index];
          return CategoryTile(
            image: categories[index],
            name: categoryName,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductType(category: categoryName,),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildResultCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              image: data["Image"],
              name: data["Name"],
              price: data["Price"].toString(),
              detail: data["Detail"],
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: Image.network(data["Image"], fit: BoxFit.cover),
          title:
              Text(data["Name"], style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("\$${data["Price"]}"),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String image, name;
  final VoidCallback onTap; // Added callback for navigation
  final bool isCategoryListPage;

  const CategoryTile({
    Key? key,
    required this.image,
    required this.name,
    required this.onTap, // Accept the callback
    this.isCategoryListPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the callback
      child: Container(
        width: isCategoryListPage ? 150 : 100,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image,
                  height: isCategoryListPage ? 150 : 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
