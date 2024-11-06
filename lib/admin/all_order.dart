import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop/services/database.dart';
import 'package:shop/widget/support_widget.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({super.key});

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  Stream? orderStream;
  getontheload() async {
    orderStream = await DatabaseMethods().allOrder();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrder() {
    return StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
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
                          padding: EdgeInsets.only(
                              left: 20.0, top: 10.0, bottom: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                ds["ProductImage"],
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 20.0),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name: ${ds["Name"] ?? ''}",
                                        style: AppWidget.semiboldTextStyle(),
                                      ),
                                      Text(
                                        "Email: ${ds["Email"] ?? ''}",
                                        style: AppWidget.LightTextStyle(),
                                      ),
                                      Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Product" + ds["Product"],
                                        style: AppWidget.semiboldTextStyle(),
                                      ),
                                      Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "\$" + ds["Price"],
                                        style: AppWidget.seeAllTextStyle(),
                                      ),
                                      SizedBox(height: 20.0),
                                      GestureDetector(
                                        onTap: () async {
                                          await DatabaseMethods()
                                              .updateStatus(ds.id);
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 350,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFfd6f3e),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, bottom: 5.0),
                                              child: Text(
                                                "Done",
                                                style: AppWidget
                                                    .semiboldTextStyle(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Center(
          child: Text(
            "All Orders",
            style: AppWidget.boldTextStyle(),
          ),
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
