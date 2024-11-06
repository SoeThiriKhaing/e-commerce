import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop/services/database.dart';
import 'package:shop/services/share_preferences.dart';
import 'package:shop/widget/support_widget.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;
  Stream? orderStream;

  // Retrieve the user's email from shared preferences
  Future<void> getthesharedpref() async {
    email = await SharePreferencesHelper().getUserEmail();
  }

  // Load data only once on widget initialization
  Future<void> getontheload() async {
    await getthesharedpref();
    if (email != null) {
      // Fetch only "on the way" orders
      orderStream = await DatabaseMethods().getOrders(email!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getontheload(); // Initialize data loading on startup
  }

  // Display the orders using a StreamBuilder
  Widget allOrder() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
          return Center(child: Text("No orders currently on the way."));
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        ds["ProductImage"],
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 30.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds["Product"],
                            style: AppWidget.semiboldTextStyle(),
                          ),
                          Text(
                            "\$${ds["Price"]}",
                            style: AppWidget.seeAllTextStyle(),
                          ),
                          Text(
                            "Status: ${ds["Status"]}",
                            style: AppWidget.seeAllTextStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        title: Text(
          "Current Orders",
          style: AppWidget.boldTextStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(child: allOrder()),
          ],
        ),
      ),
    );
  }
}
