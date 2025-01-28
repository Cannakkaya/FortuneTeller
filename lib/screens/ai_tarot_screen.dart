import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'card_choose.dart';

class AiTarotScreen extends StatefulWidget {
  @override
  _AiTarotScreenState createState() => _AiTarotScreenState();
}

class _AiTarotScreenState extends State<AiTarotScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _dobController = TextEditingController(); // Doğum tarihi controller
  String _selectedCards = ""; // Seçilen kartları göstermek için
  String _prediction = ""; // API'den dönen tahmin

  DateTime _selectedDate = DateTime.now();

  // API'den tahmin almak için fonksiyon
  Future<void> fetchPrediction(String userName, String userSurname,
      String userDob, String selectedCards) async {
    final url = Uri.parse('http://localhost:5000/predict'); // Flask API URL'niz
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_input': '$userName $userSurname, $userDob',
        'selected_cards': selectedCards, // Seçilen kartlar
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _prediction = data['prediction']; // API'den dönen yorum
      });
    } else {
      setState(() {
        _prediction = 'Hata oluştu, lütfen tekrar deneyin.';
      });
    }
  }

  // Doğum tarihi seçme fonksiyonu
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${_selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yapay Zeka Tarot Falı"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ad kısmı
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Adınız",
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  _nameController.value = TextEditingValue(
                    text: text[0].toUpperCase() + text.substring(1),
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            // Soyad kısmı
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: "Soyadınız",
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  _surnameController.value = TextEditingValue(
                    text: text[0].toUpperCase() + text.substring(1),
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            // Doğum tarihi seçme kısmı
            TextField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: "Doğum Tarihiniz",
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Kullanıcıya yazdırmayı engelle
              onTap: () => _selectDate(context), // Tarih seçme ekranını aç
            ),
            SizedBox(height: 20),
            // Kart Seç butonu
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _surnameController.text.isNotEmpty &&
                    _dobController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardChooseScreen(
                        onCardsSelected: (selectedCards) {
                          setState(() {
                            _selectedCards = selectedCards.join(', ');
                          });
                        },
                      ),
                    ),
                  );
                } else {
                  setState(() {
                    _prediction = "Lütfen tüm bilgileri doldurun.";
                  });
                }
              },
              child: Text("Kart Seç"),
            ),
            SizedBox(height: 20),
            // Seçilen kartlar
            if (_selectedCards.isNotEmpty)
              Text(
                "Seçilen Kartlar: $_selectedCards",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            // Fal Yorumu Al butonu
            ElevatedButton(
              onPressed: () {
                if (_selectedCards.isNotEmpty) {
                  fetchPrediction(
                    _nameController.text,
                    _surnameController.text,
                    _dobController.text,
                    _selectedCards,
                  );
                } else {
                  setState(() {
                    _prediction = "Lütfen önce kart seçin.";
                  });
                }
              },
              child: Text("Fal Yorumu Al"),
            ),
            SizedBox(height: 20),
            // API'den gelen tahmin
            if (_prediction.isNotEmpty)
              Text(
                "Fal Yorumu: $_prediction",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
