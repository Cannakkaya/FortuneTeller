import 'package:flutter/material.dart';

class CardChooseScreen extends StatefulWidget {
  final Function(List<String>) onCardsSelected;

  CardChooseScreen({required this.onCardsSelected});

  @override
  _CardChooseScreenState createState() => _CardChooseScreenState();
}

class _CardChooseScreenState extends State<CardChooseScreen> {
  // 76 kartın isim ve görselleri
  final List<Map<String, String>> _cards = List.generate(
    76,
    (index) => {
      'name': 'Kart ${index + 1}',
      'image': 'assets/images/card${index + 1}.png',
    },
  );

  // Kullanıcının seçtiği kartlar
  final List<String> _selectedCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kart Seçimi"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                final isSelected = _selectedCards.contains(card['name']);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCards.remove(card['name']);
                      } else if (_selectedCards.length < 3) {
                        _selectedCards.add(card['name']!);
                      }
                    });
                  },
                  child: Card(
                    elevation: 5,
                    color: isSelected
                        ? Colors.green.withOpacity(0.5)
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          card['image']!,
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(height: 5),
                        Text(
                          card['name']!,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedCards.length == 3
                  ? () {
                      widget.onCardsSelected(_selectedCards);
                      Navigator.pop(context);
                    }
                  : null,
              child: Text("Seçimi Onayla"),
            ),
          ),
        ],
      ),
    );
  }
}
