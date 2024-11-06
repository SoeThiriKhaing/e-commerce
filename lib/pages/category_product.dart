import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop/pages/product_detail.dart';
import 'package:shop/services/database.dart';
import 'package:shop/widget/support_widget.dart';

class CategoryProduct extends StatefulWidget {
  String category;
  CategoryProduct({super.key, required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? CategoryStream;
  getontheload() async {
    CategoryStream = await DatabaseMethods().getProduct(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allProduct() {
    return StreamBuilder(
        stream: CategoryStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      // margin: EdgeInsets.only(left: 40.0),
                      //margin: EdgeInsets.only(right: 20.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: [
                          Image.network(ds["Image"]),
                          Text(
                            ds["Name"],
                            style: AppWidget.semiboldTextStyle(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  ds["Price"],
                                  style: TextStyle(
                                      color: Color(0xFFfd6f3e),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 40.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                                image: ds["Image"],
                                                name: ds["Name"],
                                                price: ds["Price"],
                                                detail: ds["Detail"],
                                              )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20.0),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFfd6f3e),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: allProduct()),
          ],
        ),
      ),
    );
  }
}
