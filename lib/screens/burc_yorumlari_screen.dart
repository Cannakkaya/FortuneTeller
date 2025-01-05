import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BurcYorumlariScreen extends StatefulWidget {
  @override
  _BurcYorumlariScreenState createState() => _BurcYorumlariScreenState();
}

class _BurcYorumlariScreenState extends State<BurcYorumlariScreen> {
  // Burç listesi
  List<String> burclar = [
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

  Map<String, String> burcYorumlari = {}; // Her burç için yorumları saklayacak

  @override
  void initState() {
    super.initState();
    fetchBurcYorumlari(); // Burç yorumlarını çekiyoruz
  }

  Future<void> fetchBurcYorumlari() async {
    try {
      for (String burc in burclar) {
        final response = await http.post(
          Uri.parse("https://aztro.sameerkumar.website/"),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }, // Başlık eklendi
          body: {'sign': burc, 'day': 'today'}, // Eksik parametreler eklendi
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            burcYorumlari[burc] = data['description'] ??
                "Yorum bulunamadı."; // Yorumları saklıyoruz
          });
        } else {
          print("Hata: ${response.statusCode} - ${response.body}");
          setState(() {
            burcYorumlari[burc] = "Yorum yüklenemedi."; // Hata mesajı
          });
        }
      }
    } catch (e) {
      print("İstek sırasında hata oluştu: $e");
      setState(() {
        burcYorumlari = {for (var burc in burclar) burc: "Hata oluştu."};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Günlük Burç Yorumları"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: burcYorumlari.isEmpty
            ? Center(
                child: CircularProgressIndicator(), // Yükleniyor göstergesi
              )
            : ListView.builder(
                itemCount: burclar.length,
                itemBuilder: (context, index) {
                  String burc = burclar[index];
                  String burcAdi = _translateBurc(burc);
                  return _buildBurcYorumu(
                    burcAdi,
                    burcYorumlari[burc] ?? "Yorum yükleniyor...",
                  );
                },
              ),
      ),
    );
  }

  // API'den alınan İngilizce burç isimlerini Türkçeye çevirme
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
      "pisces": "Balık"
    };
    return burcMap[burc] ?? burc;
  }

  // Her burç için yorum widget'ı
  Widget _buildBurcYorumu(String burcAdi, String yorum) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              burcAdi,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              yorum,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
