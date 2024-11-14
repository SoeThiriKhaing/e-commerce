import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:shop/services/database.dart';
import 'package:shop/widget/support_widget.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key});

  @override
  AddCategoriesState createState() => AddCategoriesState();
}

class AddCategoriesState extends State<AddCategories> {
  final TextEditingController _categoryNameController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();

  Future getImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageFile = File(image.path);
    }
    setState(() {});
  }

  Future<void> _saveCategory() async {
    if (_imageFile != null && _categoryNameController.text != "") {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("BlocImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(_imageFile!);
      var downloadUrl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addCategory = {
        "name": _categoryNameController.text,
        "image": downloadUrl,
      };
      await DatabaseMethods()
          .addCategories(addCategory, _categoryNameController.text)
          .then((value) async {
        await DatabaseMethods().addAllCategories(addCategory);
        _imageFile = null;
        _categoryNameController.text = "";

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text("Category added successfully")));
      });
    }
  }

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
          "Add Categories",
          style: AppWidget.boldTextStyle(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: getImage,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(75),
                ),
                child: _imageFile == null
                    ? Icon(Icons.camera_alt_outlined,
                        size: 50, color: Colors.grey)
                    : ClipOval(
                        child: Image.file(_imageFile!, fit: BoxFit.cover)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10.0)),
              child: TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                    labelText: "Category Name", border: InputBorder.none),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFfd6f3e)),
                onPressed: _saveCategory,
                child: Text(
                  "Add Category",
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
