import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 16, 16, 92),
      child: const SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Row(
                children: [Icon(Icons.search), Icon(Icons.notifications)],
              )
            ],
          ),
        ),
      ),
    );
  }
}
