import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUser(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .snapshots();
  }

  Future addAllProducts(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("product")
        .add(userInfoMap);
  }

  Future addAllProductsType(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("types")
        .add(userInfoMap);
  }

  Future addProduct(Map<String, dynamic> userInfoMap, String product) async {
    return await FirebaseFirestore.instance
        .collection(product)
        .add(userInfoMap);
  }

  Future addType(Map<String, dynamic> userInfoMap, String categoryname) async {
    return await FirebaseFirestore.instance
        .collection(categoryname)
        .add(userInfoMap);
  }

  Future addCategories(
      Map<String, dynamic> userInfoMap, String category) async {
    return await FirebaseFirestore.instance
        .collection(category)
        .add(userInfoMap);
  }

  Future addAllCategories(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("categories")
        .add(userInfoMap);
  }

  Future addProductType(
      Map<String, dynamic> userInfoMap, String producttypename) async {
    return await FirebaseFirestore.instance
        .collection(producttypename)
        .add(userInfoMap);
  }

  updateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(id)
        .update({"Status": "Delivered"});
  }

  Future<Stream<QuerySnapshot>> getProduct(String type) async {
    return await FirebaseFirestore.instance.collection(type).snapshots();
  }

  Future<Stream<QuerySnapshot>> getProductType(
      String category) async {
    return FirebaseFirestore.instance
        .collection("types")
        .where("category", isEqualTo: category)
        .snapshots();
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
