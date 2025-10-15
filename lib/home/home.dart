import 'package:flutter/material.dart';
import 'package:todo_app/home/acceuil.dart';
import 'package:todo_app/home/profil.dart';
import 'package:todo_app/home/project.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homePages = [
    AccueilScreen(),
    ProjectScreen(),
    ProfilScreen(),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homePages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int value){
          setState(() {
            currentIndex = value;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Accueil"),
          NavigationDestination(icon: Icon(Icons.folder), label: "Projet"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profil"),
          ]
        ),
      

    );
  }
}