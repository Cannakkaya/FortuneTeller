import 'package:flutter/material.dart';
import 'package:tarot_app/screens/home_screen.dart'; // HomeScreen's location
import 'package:tarot_app/screens/ai_tarot_screen.dart'; // AI Tarot Screen
import 'package:tarot_app/screens/live_tarot_screen.dart'; // Live Tarot Screen
import 'package:tarot_app/screens/kahve_fali_screen.dart'; // Kahve Falı Screen
import 'package:tarot_app/screens/messages_screen.dart'; // Messages Screen
import 'package:tarot_app/screens/burc_yorumlari_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarot Fortune Teller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Home screen will be the first screen
      home: HomeScreen(),
      routes: {
        '/aiTarot': (context) => AiTarotScreen(),
        '/liveTarot': (context) => LiveTarotScreen(),
        '/kahveFali': (context) => KahveFaliScreen(),
        '/burcYorumlari': (context) => BurcYorumlariScreen(),
        '/messages': (context) => MessagesScreen(),
      },
    );
  }
}
