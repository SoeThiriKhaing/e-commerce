import 'package:flutter/material.dart';
import 'package:shop/pages/signup.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecefe8),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            top: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/headphone.png"),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Explore\nTheBest\nProducts",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0),
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        //shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
