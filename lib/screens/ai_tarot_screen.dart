import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiTarotScreen extends StatefulWidget {
  @override
  _AiTarotScreenState createState() => _AiTarotScreenState();
}

class _AiTarotScreenState extends State<AiTarotScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _dobController = TextEditingController(); // Doğum tarihi controller
  String _selectedCard = "";
  String _prediction = "";

  DateTime _selectedDate = DateTime.now();

  // Kart görselleri ve isimleri (bu örnekte 3 kart var)
  final List<Map<String, String>> _cards = [
    {'name': 'Kart 1', 'image': 'assets/images/card1.png'},
    {'name': 'Kart 2', 'image': 'assets/images/card2.png'},
    {'name': 'Kart 3', 'image': 'assets/images/card3.png'},
    // Diğer kartlar
  ];

  // API'den tahmin almak için fonksiyon
  Future<void> fetchPrediction(String userName, String userSurname,
      String userDob, String selectedCard) async {
    final url = Uri.parse('http://localhost:5000/predict'); // Flask API URL'niz
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_input':
              '$userName $userSurname, $userDob', // Kullanıcı adı, soyadı ve doğum tarihi
          'selected_card': selectedCard, // Seçilen kart
        }));

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
        _dobController.text = "${_selectedDate.toLocal()}"
            .split(' ')[0]; // Tarihi uygun formatta göster
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
                // İlk harfi büyük yapmak
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
                // İlk harfi büyük yapmak
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
                  // Kart seçme ekranına yönlendir
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardSelectionScreen(
                        onCardSelected: (card) {
                          setState(() {
                            _selectedCard = card;
                          });
                          Navigator.pop(context);
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
            // API'den gelen tahmin
            Text(
              _prediction,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class CardSelectionScreen extends StatelessWidget {
  final Function(String) onCardSelected;

  CardSelectionScreen({required this.onCardSelected});

  final List<Map<String, String>> _cards = [
    {'name': 'Kart 1', 'image': 'assets/images/card1.png'},
    {'name': 'Kart 2', 'image': 'assets/images/card2.png'},
    {'name': 'Kart 3', 'image': 'assets/images/card3.png'},
    // Diğer kartlar
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kart Seçimi"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onCardSelected(_cards[index]['name']!);
            },
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _cards[index]['image']!,
                    height: 80,
                    width: 80,
                  ),
                  SizedBox(height: 5),
                  Text(
                    _cards[index]['name']!,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
