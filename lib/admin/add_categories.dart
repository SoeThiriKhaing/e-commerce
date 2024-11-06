import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/widget/support_widget.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({Key? key}) : super(key: key);

  @override
  AddCategoriesState createState() => AddCategoriesState();
}

class AddCategoriesState extends State<AddCategories> {
  final TextEditingController _categoryNameController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    String fileName = DateTime.now().toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child("categories/$fileName");
    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _saveCategory() async {
    if (_imageFile != null && _categoryNameController.text.isNotEmpty) {
      String? imageUrl = await _uploadImage(_imageFile!);
      if (imageUrl != null) {
        await FirebaseFirestore.instance.collection('categories').add({
          'name': _categoryNameController.text,
          'image': imageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Category added successfully")));
        Navigator.pop(context);
      }
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
              onTap: _pickImage,
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
