import 'package:flutter/material.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 100, 175),
        title: Text("Focus Pro",style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Image.asset("/assets/images/image.png"),
            )
          ],
        ),
      ),
    );
  }
}