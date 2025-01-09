import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BurcYorumlariScreen extends StatefulWidget {
  @override
  _BurcYorumlariScreenState createState() => _BurcYorumlariScreenState();
}

class _BurcYorumlariScreenState extends State<BurcYorumlariScreen> {
  // API anahtarınız ve temel URL
  final String apiKey = '38631292e8mshe03f500a696dd8bp12e82ajsnd77c89903a72';
  final String baseUrl = 'https://horoscope-astrology.p.rapidapi.com/horoscope';

  // Burç listesi (İngilizce adları)
  final List<String> burclar = [
    "aries",
    "taurus",
    "gemini",
    "cancer",
    "leo",
    "virgo",
    "libra",
    "scorpio",
    "sagittarius",
    "capricorn",
    "aquarius",
    "pisces"
  ];

  // Burç yorumları
  Map<String, String> burcYorumlari = {};

  @override
  void initState() {
    super.initState();
    fetchHoroscopeData();
  }

  // Burç yorumlarını çeken asenkron fonksiyon
  Future<void> fetchHoroscopeData() async {
    for (String burc in burclar) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl?day=today&sunsign=$burc'),
          headers: {
            'x-rapidapi-key': apiKey,
            'x-rapidapi-host': 'horoscope-astrology.p.rapidapi.com',
          },
        );

        // API yanıtını kontrol etme
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final String yorum = data['horoscope'] ?? "Yorum alınamadı.";

          // State'i güncelleme
          setState(() {
            burcYorumlari[burc] = yorum;
          });
        } else {
          print('Hata: ${response.statusCode} - ${response.body}');
          setState(() {
            burcYorumlari[burc] = "Yorum alınamadı.";
          });
        }
      } catch (e) {
        print('Hata oluştu: $e');
        setState(() {
          burcYorumlari[burc] = "Yorum alınamadı.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Günlük Burç Yorumları"),
      ),
      body: burcYorumlari.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: burclar.length,
              itemBuilder: (context, index) {
                String burc = burclar[index];
                String burcAdi = _translateBurc(burc);
                String yorum = burcYorumlari[burc] ?? "Yorum yükleniyor...";
                return _buildBurcCard(burcAdi, yorum);
              },
            ),
    );
  }

  // Burçların Türkçe isimlerini çeviren fonksiyon
  String _translateBurc(String burc) {
    Map<String, String> burcMap = {
      "aries": "Koç",
      "taurus": "Boğa",
      "gemini": "İkizler",
      "cancer": "Yengeç",
      "leo": "Aslan",
      "virgo": "Başak",
      "libra": "Terazi",
      "scorpio": "Akrep",
      "sagittarius": "Yay",
      "capricorn": "Oğlak",
      "aquarius": "Kova",
      "pisces": "Balık",
    };
    return burcMap[burc] ?? burc;
  }

  // Burçları ve yorumları ekrana yazdıran Card widget'ı
  Widget _buildBurcCard(String burcAdi, String yorum) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              burcAdi,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              yorum,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}
