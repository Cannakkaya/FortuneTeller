import 'package:flutter/material.dart';
import 'package:tarot_app/screens/home_screen.dart'; // HomeScreen'in tanımlandığı dosya
import 'package:tarot_app/screens/ai_tarot_screen.dart'; // AI Tarot Screen dosyası
import 'package:tarot_app/screens/live_tarot_screen.dart'; // Live Tarot Screen dosyası
import 'package:tarot_app/screens/messages_screen.dart'; // Messages Screen dosyası

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
      // Uygulamanın ana ekranı HomeScreen
      home: HomeScreen(),
      routes: {
        '/aiTarot': (context) => AiTarotScreen(),
        '/liveTarot': (context) => LiveTarotScreen(),
        '/messages': (context) => MessagesScreen(),
      },
    );
  }
}
