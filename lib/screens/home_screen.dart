import 'package:flutter/material.dart';
import 'package:tarot_app/services/api_service.dart';
import 'package:tarot_app/services/api_service.dart';
import 'package:tarot_app/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController inputController = TextEditingController();
  String predictionResult = '';

  void _getPrediction() async {
    final userInput = int.tryParse(inputController.text);
    if (userInput != null) {
      final response = await apiService.predict(userInput);
      setState(() {
        predictionResult = response['prediction'].toString();
      });
    } else {
      setState(() {
        predictionResult = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarot Falı Uygulaması'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: inputController,
              decoration: InputDecoration(labelText: 'Kullanıcı Girdisi'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _getPrediction,
              child: Text('Tahmin Al'),
            ),
            SizedBox(height: 16.0),
            Text(
              predictionResult,
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
