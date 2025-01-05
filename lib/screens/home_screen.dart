import 'package:flutter/material.dart';
import 'package:tarot_app/screens/ai_tarot_screen.dart'; // AiTarotScreen ekranını import ediyoruz
import 'package:tarot_app/screens/live_tarot_screen.dart'; // LiveTarotScreen ekranını import ediyoruz

// HomeScreen, StatefulWidget olduğu için kullanıcı etkileşimine göre değişebilir
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int credits = 50; // Kullanıcının başlangıç kredisi 50 olarak belirlenmiş
  String mailNotification = 'Yeni fal cevabınız var!'; // Mail bildirim mesajı

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
            image: AssetImage(
                'assets/tarot/images/mainscreen1.png'), // Arka plan resmi
            fit: BoxFit.cover, // Resmin tüm ekrana yayılmasını sağlıyoruz
          ),
        ),
        padding: EdgeInsets.all(16.0), // Body kısmına padding ekliyoruz
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Kolonları tam genişlikte yapıyoruz
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  credits +=
                      10; // Kullanıcı kredi satın alırken, mevcut krediyi 10 artırıyoruz
                });
              },
              child: Text("Kredi Satın Al"), // Kredi satın alma butonu
            ),
            SizedBox(height: 20), // Buton ve grid arasında boşluk
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Grid'deki her satırda 2 buton olacak
                crossAxisSpacing: 10, // Butonlar arasındaki yatay boşluk
                mainAxisSpacing: 10, // Butonlar arasındaki dikey boşluk
                children: [
                  // Yapay Zeka ile Tarot Falı butonunu oluşturuyoruz
                  _buildGridButton(
                    title: "Yapay Zeka ile Tarot Falı",
                    color: Colors.blue,
                    imagePath:
                        'assets/tarot/images/tarotcardsbg.png', // Resmin yolu
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/aiTarot'); // AiTarot ekranına geçiş
                    },
                  ),
                  // Canlı Tarot Falı butonunu oluşturuyoruz
                  _buildGridButton(
                    title: "Canlı Tarot Falı",
                    imagePath: 'assets/tarot/images/livetarot.png',
                    color: Colors.green,
                    // icon: Icons.live_tv, // Simge ikonu
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/liveTarot'); // LiveTarot ekranına geçiş
                    },
                  ),
                  // Kahve Falı butonunu oluşturuyoruz
                  _buildGridButton(
                    title: "Kahve Falı",
                    imagePath:
                        'assets/tarot/images/coffeefortune.png', // Resmin yolu
                    color: Colors.brown,
                    // icon: Icons.coffee, // Simge ikonu
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/kahveFali'); // KahveFali ekranına geçiş
                    },
                  ),
                  // Günlük Burç Yorumları butonunu oluşturuyoruz
                  _buildGridButton(
                    title: "Günlük Burç Yorumları",
                    imagePath: 'assets/tarot/images/burc.png',
                    color: Colors.deepPurple,
                    // icon: Icons.star, // Simge ikonu
                    onTap: () {
                      Navigator.pushNamed(context,
                          '/burcYorumlari'); // BurcYorumlari ekranına geçiş
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Alt kısmındaki metin için boşluk
            // Kullanıcıya yeni fal cevabı olduğunu bildiren metin
            Text(
              mailNotification,
              style: TextStyle(fontSize: 18.0, color: Colors.red),
              textAlign: TextAlign.center, // Mesajı ortalayarak yazıyoruz
            ),
          ],
        ),
      ),
    );
  }

  // Grid içerisindeki her buton için özel bir widget oluşturuyoruz
  Widget _buildGridButton({
    required String title, // Buton başlığı
    Color? color, // Butonun arka plan rengi
    IconData? icon, // Buton ikonu
    String? imagePath, // Resim yolu
    required VoidCallback onTap, // Buton tıklama işlemi
  }) {
    return GestureDetector(
      onTap: onTap, // Butona tıklama işlemi
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.grey, // Arka plan rengini belirliyoruz
          borderRadius:
              BorderRadius.circular(10), // Butonun köşelerini yuvarlatıyoruz
          image: imagePath != null
              ? DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover, // Resmi butona uygun şekilde kaplatıyoruz
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Buton içeriğini ortalıyoruz
          children: [
            if (icon != null)
              Icon(icon,
                  size: 40, color: Colors.white), // İkon varsa gösteriyoruz
            if (imagePath != null)
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(imagePath), // Resim varsa gösteriyoruz
              ),
            SizedBox(
                height:
                    10), // Buton başlığı ile diğer içerik arasına boşluk ekliyoruz
            // Buton başlığını gösteriyoruz
            Text(
              title,
              style: TextStyle(
                color: Colors.white, // Başlık rengini beyaz yapıyoruz
                fontSize: 16, // Başlık font boyutunu belirliyoruz
              ),
              textAlign: TextAlign.center, // Başlık metnini ortalıyoruz
            ),
          ],
        ),
      ),
    );
  }
}
