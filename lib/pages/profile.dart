import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shop/pages/onboarding.dart';
import 'package:shop/services/auth.dart';
import 'package:shop/services/database.dart';
import 'package:shop/services/share_preferences.dart';
import 'package:shop/widget/support_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    getOnLoadData();
  }

  Future<void> getSharedPrefData() async {
    name = await SharePreferencesHelper.getUserName();
    email = await SharePreferencesHelper.getUserEmail();
    image = await SharePreferencesHelper.getUserImage();
    setState(() {});
  }

  Future<void> getOnLoadData() async {
    await getSharedPrefData();

    if (email != null) {
      Stream<QuerySnapshot> userStream =
          await DatabaseMethods().getUser(email!);
      userStream.listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var userData = snapshot.docs[0].data() as Map<String, dynamic>;
          setState(() {
            name = userData['Name'] ?? name;
            image = userData['Image'] ?? image;
            print(
              name,
            );
            print(image);
            print(email);
          });
        }
      });
    }
  }

  Future<void> getImage() async {
    try {
      var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
        });
        await uploadImage();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage != null && email != null) {
      try {
        String imageId = randomAlphaNumeric(10);
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("ProfileImages")
            .child(imageId);
        UploadTask uploadTask = firebaseStorageRef.putFile(selectedImage!);
        String downloadUrl = await (await uploadTask).ref.getDownloadURL();

        // Save in Firestore and SharedPreferences
        await SharePreferencesHelper.saveUserImage(downloadUrl);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(email)
            .update({'Image': downloadUrl});

        setState(() {
          image = downloadUrl;
        });
                 
                 
        print('Image uploaded successfully.');
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      print('No image selected or email is null.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: Text(
          "Profile",
          style: AppWidget.boldTextStyle(),
        ),
      ),
      backgroundColor: const Color(0xfff2f2f2),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          GestureDetector(
            onTap: getImage,
            child: Center(
              child: ClipOval(
                child: image != null && image!.isNotEmpty
                    ? Image.network(
                        image!,
                        height: 90.0,
                        width: 90.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.account_circle, size: 90),
                      )
                    : const Icon(Icons.account_circle, size: 90),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          buildInfoCard(
            icon: Icons.person,
            label: "Name",
            value: name ?? "Loading...",
          ),
          const SizedBox(height: 20.0),
          buildInfoCard(
            icon: Icons.email,
            label: "Email",
            value: email ?? "Loading...",
          ),
          const SizedBox(height: 20.0),
          buildActionCard(
            icon: Icons.logout,
            label: "Logout",
            onTap: () async {
              try {
                await AuthMethods().SignOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Onboarding()),
                );
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          ),
          const SizedBox(height: 20),
          buildActionCard(
            icon: Icons.delete,
            label: "Delete Account",
            onTap: () async {
              try {
                await AuthMethods().deleteuser();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Onboarding()),
                );
              } catch (e) {
                print('Error deleting account: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        elevation: 3.0,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Icon(icon, size: 35.0),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppWidget.LightTextStyle()),
                  Text(value, style: AppWidget.semiboldTextStyle()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          elevation: 3.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Icon(icon, size: 35.0),
                const SizedBox(width: 20.0),
                Text(label, style: AppWidget.semiboldTextStyle()),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
