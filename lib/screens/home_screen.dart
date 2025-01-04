import 'package:flutter/material.dart';
import 'package:tarot_app/screens/ai_tarot_screen.dart';
import 'package:tarot_app/screens/live_tarot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int credits = 50; // Başlangıç kredisi
  String mailNotification = 'Yeni fal cevabınız var!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarot Falı Uygulaması'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.mail, size: 30),
                SizedBox(width: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.yellow,
                      child: Icon(
                        Icons.attach_money,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '$credits',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  credits += 10; // Kredi arttırma
                });
              },
              child: Text("Kredi Satın Al"),
            ),
            SizedBox(height: 30),
            // Tarot Falı Baktır Butonu
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AiTarotScreen()),
                );
              },
              child: Container(
                height: 60, // Buton yüksekliği
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/tarot/images/tarotai.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8), // Köşe yuvarlama
                ),
                alignment: Alignment.center, // Metni ortalar
                child: Text(
                  "Yapay Zeka ile Tarot Falı Baktır",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LiveTarotScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              icon: Icon(Icons.live_tv, size: 30),
              label: Text("Canlı Tarot Falı Baktır"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KahveFaliScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor:
                    const Color.fromARGB(255, 250, 249, 249), // Kahverengi tema
              ),
              icon: Icon(Icons.coffee, size: 30),
              label: Text("Kahve Falı Baktır"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BurcYorumlariScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor:
                    const Color.fromARGB(255, 255, 255, 255), // Mor tema
              ),
              icon: Icon(Icons.star, size: 30),
              label: Text("Günlük Burç Yorumları"),
            ),
            SizedBox(height: 20),
            Text(
              mailNotification,
              style: TextStyle(fontSize: 18.0, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

// Yapay Zeka Tarot ekranı
class YapayZekaTarotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tarot Falı')),
      body: Center(
        child: Text('Yapay Zeka Tarot Falı Baktırma Ekranı'),
      ),
    );
  }
}

// Canlı Tarot ekranı
class CanliTarotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canlı Tarot Falı')),
      body: Center(
        child: Text('Canlı Tarot Falı Baktırma Ekranı'),
      ),
    );
  }
}

// Kahve Falı Ekranı
class KahveFaliScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kahve Falı')),
      body: Center(
        child: Text('Kahve Falı Baktırma Ekranı'),
      ),
    );
  }
}

// Burç Yorumları Ekranı
class BurcYorumlariScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Günlük Burç Yorumları')),
      body: Center(
        child: Text('Burç Yorumları Ekranı'),
      ),
    );
  }
}
