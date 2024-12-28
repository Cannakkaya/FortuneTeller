import 'package:flutter/material.dart';
import 'package:tarot_app/screens/tarot_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Yap")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Adınız'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Yaşınız'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: birthDateController,
              decoration:
                  InputDecoration(labelText: 'Doğum Tarihiniz (yyyy-mm-dd)'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String age = ageController.text;
                String birthDate = birthDateController.text;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TarotScreen(name: name, age: age, birthDate: birthDate),
                  ),
                );
              },
              child: Text('Tarot Baktır'),
            ),
          ],
        ),
      ),
    );
  }
}
