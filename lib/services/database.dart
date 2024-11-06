import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addAllProducts(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("product")
        .add(userInfoMap);
  }

  Future addProduct(
      Map<String, dynamic> userInfoMap, String categoryname) async {
    return await FirebaseFirestore.instance
        .collection(categoryname)
        .add(userInfoMap);
  }

  updateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(id)
        .update({"Status": "Delivered"});
  }

  Future<Stream<QuerySnapshot>> getProduct(String category) async {
    return await FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future<Stream<QuerySnapshot>> allOrder() async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .where("Status", isEqualTo: "on the way")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .where("Email", isEqualTo: email)
        .where("Status", isEqualTo: "on the way")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllProduct() async {
    return await FirebaseFirestore.instance.collection("products").snapshots();
  }

  Future orderDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .add(userInfoMap);
  }

  Future<QuerySnapshot> search(String updatedname) async {
    return await FirebaseFirestore.instance
        .collection("products")
        .where("SearchKey",
            isEqualTo: updatedname.substring(0, 1).toUpperCase())
        .get();
  }
}
