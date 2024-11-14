import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shop/services/database.dart';
import 'package:shop/widget/support_widget.dart';

class AddType extends StatefulWidget {
  const AddType({super.key});

  @override
  State<AddType> createState() => _AddTypeState();
}

class _AddTypeState extends State<AddType> {
  final TextEditingController typeController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();

  Future getImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageFile = File(image.path);
    }
    setState(() {});
  }

  Future<void> _saveProductType() async {
    if (_imageFile != null && typeController.text != "") {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("BlocImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(_imageFile!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      String firstletter = typeController.text.substring(0, 1).toUpperCase();
      Map<String, dynamic> addProductTypedata = {
        "name": typeController.text,
        "image": downloadUrl,
        "searchKey": firstletter,
        "updatedName": typeController.text.toUpperCase(),
        "category": selectedCategory,
      };
      await DatabaseMethods()
          .addType(addProductTypedata, selectedCategory!)
          .then((value) async {
        await DatabaseMethods().addAllProductsType(addProductTypedata);
        _imageFile = null;
        typeController.text = "";

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text("Product Type has been uploaded successfully")));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  String? selectedCategory;
  List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          "Add Product Type",
          style: AppWidget.boldTextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            children: [
              Text(
                "Upload The Product Image",
                style: AppWidget.LightTextStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              _imageFile == null
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                    ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Type",
                style: AppWidget.LightTextStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextFormField(
                  controller: typeController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Category",
                style: AppWidget.LightTextStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: categories
                          .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item,
                                  style: AppWidget.semiboldTextStyle())))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            selectedCategory = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: Text("Select Category"),
                      iconSize: 30,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: selectedCategory,
                    ),
                  )),
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFfd6f3e)),
                    onPressed: () {
                      _saveProductType();
                    },
                    child: Text(
                      "Add Product Type",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    )),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
