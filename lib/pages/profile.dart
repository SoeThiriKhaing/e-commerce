import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shop/pages/onboarding.dart';
import 'package:shop/services/auth.dart';
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
    getSharedPrefData();
  }

  Future<void> getSharedPrefData() async {
    name = await SharePreferencesHelper().getUserName();
    email = await SharePreferencesHelper().getUserEmail();
    image = await SharePreferencesHelper().getUserImage();
    setState(() {});
  }

  Future<void> getImage() async {
    var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);
      await uploadImage();
      setState(() {});
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage != null) {
      String imageId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("ProfileImages").child(imageId);
      UploadTask uploadTask = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      await SharePreferencesHelper().saveUserImage(downloadUrl);
      image = downloadUrl;
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
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                GestureDetector(
                  onTap: getImage,
                  child: Center(
                    child: ClipOval(
                      child: selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              height: 90.0,
                              width: 90.0,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              image!,
                              height: 90.0,
                              width: 90.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.account_circle, size: 90),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                buildInfoCard(
                  icon: Icons.person,
                  label: "Name",
                  value: name!,
                ),
                const SizedBox(height: 20.0),
                buildInfoCard(
                  icon: Icons.email,
                  label: "Email",
                  value: email!,
                ),
                const SizedBox(height: 20.0),
                buildActionCard(
                  icon: Icons.logout,
                  label: "Logout",
                  onTap: () async {
                    await AuthMethods().SignOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Onboarding()));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                buildActionCard(
                  icon: Icons.delete,
                  label: "Delete Account",
                  onTap: () async {
                    await AuthMethods().deleteuser();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Onboarding()));
                  },
                ),
              ],
            ),
    );
  }

  Widget buildInfoCard(
      {required IconData icon, required String label, required String value}) {
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
