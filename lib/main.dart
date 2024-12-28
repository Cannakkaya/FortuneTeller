import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      home: TarotPredictionScreen(),
    );
  }
}

class TarotPredictionScreen extends StatefulWidget {
  @override
  _TarotPredictionScreenState createState() => _TarotPredictionScreenState();
}

class _TarotPredictionScreenState extends State<TarotPredictionScreen> {
  final TextEditingController _infoController = TextEditingController();
  String _prediction = "";
  String _selectedCard = ""; // Varsayılan kart yok

  // Flask API'ye veri gönderme
  Future<void> getPrediction(String userInput, String selectedCard) async {
    final url =
        Uri.parse('http://127.0.0.1:5000/predict'); // Flask API endpoint

    try {
      final response = await http.post(url,
          body: json.encode({
            'user_input': userInput,
            'selected_card': selectedCard,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _prediction = data['prediction'];
        });
      } else {
        setState(() {
          _prediction = 'Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _prediction = 'Error: $error';
      });
    }
  }

  // Kartlar listesi
  List<String> cards = [
    'The Fool',
    'The Magician',
    'The High Priestess',
    'The Empress',
    'The Emperor',
    'The Hierophant',
    'The Lovers',
    'The Chariot',
    'Strength',
    'The Hermit',
    'Wheel of Fortune',
    'Justice',
    'The Hanged Man',
    'Death',
    'Temperance',
    'The Devil',
    'The Tower',
    'The Star',
    'The Moon',
    'The Sun',
    'Judgement',
    'The World',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tarot Prediction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kullanıcı bilgisi girişi
            TextField(
              controller: _infoController,
              decoration: InputDecoration(labelText: "Enter your information"),
            ),
            SizedBox(height: 20),

            // Kartlar Animasyonu - Kapalı Kartlar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: cards.map((card) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCard = card; // Kart seçildiğinde kaydedilir
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: _selectedCard == card
                        ? Container(
                            key: ValueKey(card),
                            height: 150,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/${card}.png'), // Kartın açılmış halini göster
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            key: ValueKey(card),
                            height: 150,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Tahmin butonu
            ElevatedButton(
              onPressed: () {
                if (_infoController.text.isNotEmpty &&
                    _selectedCard.isNotEmpty) {
                  getPrediction(_infoController.text, _selectedCard);
                } else {
                  setState(() {
                    _prediction =
                        "Please fill in your information and select a card!";
                  });
                }
              },
              child: Text("Get Prediction"),
            ),
            SizedBox(height: 20),
            // Sonuç
            Text("Prediction: $_prediction"),
          ],
        ),
      ),
    );
  }
}
