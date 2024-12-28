import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TarotScreen extends StatefulWidget {
  final String name;
  final String age;
  final String birthDate;

  TarotScreen({required this.name, required this.age, required this.birthDate});

  @override
  _TarotScreenState createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  int? selectedCard;

  // Kartlar için görsel listesi
  final List<String> tarotCards = [
    'assets/card1.png',
    'assets/card2.png',
    'assets/card3.png',
    'assets/card4.png'
  ];

  // Kart seçimi yapıldığında yapay zekaya gönderme işlemi
  Future<void> sendToAI(int cardIndex) async {
    var url = Uri.parse('http://127.0.0.1:5000/predict');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'input': cardIndex, // Kart index'ini gönderiyoruz
        'name': widget.name,
        'age': widget.age,
        'birthDate': widget.birthDate,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Yorum'),
          content: Text('Tahmin: ${data['prediction']}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      throw Exception('Yapay zeka hatası');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tarot Kartı Seç")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Seçilen Kart: ${selectedCard != null ? selectedCard! + 1 : 'Yok'}'),
            SizedBox(height: 20),
            // Kartlar görsel olarak gösterilecek
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: tarotCards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCard = index;
                    });
                    sendToAI(index); // Kart seçildiğinde AI'ya gönder
                  },
                  child: Image.asset(tarotCards[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
