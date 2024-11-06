import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shop/services/constant.dart';
import 'package:shop/services/database.dart';
import 'package:shop/services/share_preferences.dart';
import 'package:shop/widget/support_widget.dart';

class ProductDetail extends StatefulWidget {
  final String image, name, price, detail;

  const ProductDetail({
    required this.image,
    required this.name,
    required this.price,
    required this.detail,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, email, image;
  getthesharedpref() async {
    name = await SharePreferencesHelper().getUserName();
    email = await SharePreferencesHelper().getUserEmail();
    image = await SharePreferencesHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: Container(
        padding: const EdgeInsets.only(top: 60.0, left: 10.0),
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Image.network(
                    widget.image,
                    height: 400,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20.0)),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: AppWidget.boldTextStyle(),
                        ),
                        Text(
                          widget.price,
                          style: AppWidget.seeAllTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Details",
                      style: AppWidget.semiboldTextStyle(),
                    ),
                    const SizedBox(height: 10.0),
                    Text(widget.detail),
                    const SizedBox(height: 90.0),
                    GestureDetector(
                      onTap: () {
                        makePayment(widget.price);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFfd6f3e),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Text(
                            "Buy Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent?['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: "Adam",
            ),
          )
          .then((value) {});
      displayPaymentSheet();
    } catch (e, s) {
      print("Exception: $e\n$s");
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Map<String, dynamic> orderInfoMap = {
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email": email,
          "Image": image,
          "ProductImage": widget.image,
          "Status": "on the way",
        };
        await DatabaseMethods().orderDetails(orderInfoMap);
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    Text("Payment Successful"),
                  ],
                ),
              ],
            ),
          ),
        );
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Error: $error\n$stackTrace");
      });
    } on StripeException catch (e) {
      print("Stripe Exception: $e");
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Payment Cancelled"),
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card', // Corrected format
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey', // Replace with your secret key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Error charging user: ${e.toString()}");
      rethrow;
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }
}
