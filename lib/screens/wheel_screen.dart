import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class WheelScreen extends StatefulWidget {
  @override
  _WheelScreenState createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  final _controller = StreamController<int>(); // Çarkı kontrol etmek için

  final List<String> _rewards = [
    "10 Kredi",
    "50 Kredi",
    "20 Kredi",
    "Boş!",
    "30 Kredi",
    "100 Kredi"
  ]; // Çark ödülleri

  @override
  void dispose() {
    _controller.close(); // Bellek sızıntısını önlemek için kapatıyoruz
    super.dispose();
  }

  void _spinWheel() {
    final random =
        Random().nextInt(_rewards.length); // Rastgele bir ödül seçiliyor
    _controller.add(random); // Çark döndürülüyor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Çarkı Döndür"), // Üst başlık
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FortuneWheel(
              selected: _controller.stream, // Seçilen ödülü kontrol ediyoruz
              items: _rewards
                  .map((reward) => FortuneItem(
                        child: Text(
                          reward,
                          style: TextStyle(fontSize: 18),
                        ),
                      ))
                  .toList(),
              physics: CircularPanPhysics(
                duration: Duration(seconds: 5), // Çarkın dönme süresi
                curve: Curves.easeOut, // Dönüş hızı eğrisi
              ),
              onAnimationEnd: () {
                // Son seçilen değeri dinliyoruz
                _controller.stream.listen((selectedIndex) {
                  final selected = _rewards[selectedIndex];
                  _showRewardDialog(selected);
                });
              },
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _spinWheel,
            child: Text("Çarkı Döndür"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  // Ödül kazandığında bir diyalog göstermek
  void _showRewardDialog(String reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tebrikler!"),
        content: Text("Kazandığınız ödül: $reward"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Diyaloğu kapatıyoruz
            },
            child: Text("Tamam"),
          ),
        ],
      ),
    );
  }
}
