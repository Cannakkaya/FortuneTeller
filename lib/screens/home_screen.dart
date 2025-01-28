import 'package:flutter/material.dart';
import 'package:tarot_app/screens/ai_tarot_screen.dart'; // AiTarotScreen ekranını import ediyoruz
import 'package:tarot_app/screens/live_tarot_screen.dart'; // LiveTarotScreen ekranını import ediyoruz

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int credits = 50; // Kullanıcının başlangıç kredisi 50 olarak belirlenmiş
  String mailNotification = 'Yeni fal cevabınız var!'; // Mail bildirim mesajı

  // Kredi satın alma işlemi
  void _buyCredits() {
    setState(() {
      credits +=
          10; // Kullanıcı kredi satın alırken, mevcut krediyi 10 artırıyoruz
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kredi başarıyla eklendi!'), // Bildirim mesajı
        duration: Duration(
            seconds: 2), // Bildirimin ne kadar süre görüneceğini belirliyoruz
      ),
    );
  }

  // Mail bildirimi güncelleme
  void _updateMailNotification(String newNotification) {
    setState(() {
      mailNotification = newNotification;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TarotumunBaşındayım'), // Uygulamanın başlığı
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.mail, size: 30), // Mail simgesi
                SizedBox(width: 10),
                Row(
                  children: [
                    // Kullanıcının kredi simgesini ve mevcut kredi miktarını göstermek için
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
                    // Krediyi metin olarak gösteriyoruz
                    Text(
                      '$credits',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/tarot/images/mainscreen1.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0), // Body kısmına padding ekliyoruz
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _buyCredits,
              child: Text("Kredi Satın Al"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridButton(
                    title: "Yapay Zeka ile Tarot Falı",
                    color: Colors.blue,
                    imagePath: 'assets/tarot/images/tarotcardsbg.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AiTarotScreen()),
                      );
                    },
                  ),
                  _buildGridButton(
                    title: "Canlı Tarot Falı",
                    imagePath: 'assets/tarot/images/livetarot.png',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LiveTarotScreen()),
                      );
                    },
                  ),
                  _buildGridButton(
                    title: "Kahve Falı",
                    imagePath: 'assets/tarot/images/coffeefortune.png',
                    color: Colors.brown,
                    onTap: () {
                      Navigator.pushNamed(context, '/kahveFali');
                    },
                  ),
                  _buildGridButton(
                    title: "Günlük Burç Yorumları",
                    imagePath: 'assets/tarot/images/burc.png',
                    color: Colors.deepPurple,
                    onTap: () {
                      Navigator.pushNamed(context, '/burcYorumlari');
                    },
                  ),
                  // Chat Button
                  _buildGridButton(
                    title: "Chat",
                    imagePath:
                        'assets/tarot/images/chat_icon.png', // Ensure you have an appropriate icon
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/chat'); // Navigate to the chat screen
                    },
                  ),
                  // Settings Button (Çark)
                  _buildGridButton(
                    title: "Ayarlar",
                    imagePath:
                        'assets/tarot/images/settings_icon.png', // Çark ikonu
                    color: Colors.blueGrey,
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            AnimatedOpacity(
              opacity: mailNotification.isEmpty ? 0 : 1,
              duration: Duration(milliseconds: 300),
              child: Text(
                mailNotification,
                style: TextStyle(fontSize: 18.0, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton({
    required String title,
    Color? color,
    IconData? icon,
    String? imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: color ?? Colors.grey,
          borderRadius: BorderRadius.circular(20),
          image: imagePath != null
              ? DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 40, color: Colors.white),
            if (imagePath != null)
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(imagePath),
              ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
