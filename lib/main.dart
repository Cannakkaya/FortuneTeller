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
  String _selectedCard = "The Fool"; // Varsayılan kart

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
        throw Exception('Failed to get prediction');
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
    // Diğer kartları buraya ekleyebilirsiniz.
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
            // Kart seçimi
            DropdownButton<String>(
              value: _selectedCard,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCard = newValue!;
                });
              },
              items: cards.map<DropdownMenuItem<String>>((String card) {
                return DropdownMenuItem<String>(
                  value: card,
                  child: Text(card),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Tahmin butonu
            ElevatedButton(
              onPressed: () {
                getPrediction(_infoController.text, _selectedCard);
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
