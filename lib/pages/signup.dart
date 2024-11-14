import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shop/pages/bottomnav.dart';
import 'package:shop/pages/login.dart';
import 'package:shop/services/database.dart';
import 'package:shop/services/share_preferences.dart';
import 'package:shop/widget/support_widget.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String? name, email, password;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        name = nameController.text;
        email = emailController.text;
        password = passwordController.text;
      });

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Registered Successfully"),
          ),
        );

        String id = randomAlphaNumeric(10);
        await SharePreferencesHelper.saveUserEmail(emailController.text);
        await SharePreferencesHelper.saveUserId(id);
        await SharePreferencesHelper.saveUserName(nameController.text);
        await SharePreferencesHelper.saveUserImage(
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fprofile_3135715&psig=AOvVaw3eixIB0RQInfB2n3xzWPWN&ust=1730192546363000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCIDD-9DbsIkDFQAAAAAdAAAAABAE");

        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Id": id,
          "Image":
              "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fprofile_3135715&psig=AOvVaw3eixIB0RQInfB2n3xzWPWN&ust=1730192546363000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCIDD-9DbsIkDFQAAAAAdAAAAABAE",
        };
        await DatabaseMethods().addUserDetails(userInfoMap, id);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Password is too weak"),
          ));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Email is already in use"),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Error: ${e.message}"),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("An unexpected error occurred: $e"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("images/loginl.png")),
                const SizedBox(height: 20.0),
                Center(
                  child: Text("Sign Up", style: AppWidget.semiboldTextStyle()),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text(
                    "Please enter the detail below to continue",
                    style: AppWidget.LightTextStyle(),
                  ),
                ),
                const SizedBox(height: 40.0),
                Text("Name", style: AppWidget.semiboldTextStyle()),
                const SizedBox(height: 20.0),
                buildTextField(nameController, "Name", "Name Required"),
                const SizedBox(height: 40.0),
                Text("Email", style: AppWidget.semiboldTextStyle()),
                const SizedBox(height: 20.0),
                buildTextField(emailController, "Email", "Valid email required",
                    email: true),
                const SizedBox(height: 40.0),
                Text("Password", style: AppWidget.semiboldTextStyle()),
                const SizedBox(height: 20.0),
                buildTextField(
                    passwordController, "Password", "Password Required",
                    obscureText: true),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: registration,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: AppWidget.LightTextStyle()),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String hintText, String errorText,
      {bool obscureText = false, bool email = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F9),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        obscureText: obscureText,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return errorText;
          }
          if (email &&
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(val)) {
            return "Enter a valid email";
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}

