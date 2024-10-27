import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categories = [
    "images/a.png",
    "images/headphone.png",
    "images/laptop.png"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hey Kuuki",
                      style: AppWidget.boldTextStyle(),
                    ),
                    Text(
                      "Good Morning",
                      style: AppWidget.LightTextStyle(),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "images/jennie.jpg",
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: AppWidget.LightTextStyle(),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: AppWidget.semiboldTextStyle(),
                ),
                Text(
                  "see all",
                  style: AppWidget.seeAllTextStyle(),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
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
                          return CategoryTile(image: categories[index]);
                        }),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Products",
                  style: AppWidget.semiboldTextStyle(),
                ),
                Text(
                  "see all",
                  style: AppWidget.seeAllTextStyle(),
                )
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 190,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    // margin: EdgeInsets.only(left: 40.0),
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: [
                        Image.asset(
                          "images/headphone.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Headphone",
                          style: AppWidget.semiboldTextStyle(),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "\$100",
                              style: TextStyle(
                                  color: Color(0xFFfd6f3e),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFfd6f3e),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: [
                        Image.asset(
                          "images/laptop.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Laptop",
                          style: AppWidget.semiboldTextStyle(),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "\$300",
                              style: TextStyle(
                                  color: Color(0xFFfd6f3e),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFfd6f3e),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: [
                        Image.asset(
                          "images/a.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Earphone",
                          style: AppWidget.semiboldTextStyle(),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "\$200",
                              style: TextStyle(
                                  color: Color(0xFFfd6f3e),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFfd6f3e),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image;
  CategoryTile({required this.image});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        height: 120,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
