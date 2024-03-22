import 'package:flutter/material.dart';

import 'package:newsapi/settings_screen.dart';
import 'package:newsapi/homescreen.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          // home: HomeScreen(),
          home: Wrapper(),
        ),
      );
}

class Wrapper extends StatefulWidget {
 
  const Wrapper({super.key,});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int index = 0;
  List<Widget> widgets = [
    const HomeScreen(),
    const FavoriteScreen(
      
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
