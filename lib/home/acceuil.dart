import 'package:flutter/material.dart';
import 'package:todo_app/home/project.dart';

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
        backgroundColor: const Color.fromARGB(255, 12, 47, 75),
        title: Text("Focus Pro", style: TextStyle(color: Colors.white)),
      
      ),
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/image.png"),
              ),
            ),

            Text(
              "Bienvenue sur notre Application",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Poppins',
              ),
            ),
            Text("Gérer vos projets et taches en toute simplicité"),
            Container(
              width: 150,
              height: 40,

              color: const Color.fromARGB(255, 12, 47, 75),

              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 12, 47, 75),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectScreen(),));
                },
                child: Text(
                  "Gerer projet",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
