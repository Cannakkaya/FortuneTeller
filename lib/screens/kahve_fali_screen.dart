import 'dart:io'; // File işlemleri için gerekli import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON işleme için gerekli import

class KahveFaliScreen extends StatefulWidget {
  @override
  _KahveFaliScreenState createState() => _KahveFaliScreenState();
}

class _KahveFaliScreenState extends State<KahveFaliScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  List<File> _selectedImages = [];
  bool _isSending = false;

  // Resim seçme işlemi
  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      Fluttertoast.showToast(
        msg: "En fazla 3 resim seçebilirsiniz!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  // OpenAI API'ye fal gönderme işlemi
  Future<String> _getFortuneFromAI(String name, String birthDate) async {
    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
            "API anahtarı bulunamadı. Lütfen .env dosyasını kontrol edin.");
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          "model": "text-davinci-003", // OpenAI'nin GPT-3 modelini kullanıyoruz
          "prompt":
              "Kullanıcı adı: $name, Doğum tarihi: $birthDate. Bu kişi için bir kahve falı yorumu yap.",
          "max_tokens": 100,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['text'].trim(); // Fal yorumu
      } else {
        throw Exception(
            'API isteği başarısız oldu. Hata: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('OpenAI API isteği sırasında bir hata oluştu: $e');
    }
  }

  // Fal gönderme işlemi
  Future<void> _sendData() async {
    if (_nameController.text.isEmpty || _birthDateController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Lütfen tüm alanları doldurun!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_selectedImages.length < 3) {
      Fluttertoast.showToast(
        msg: "Lütfen 3 resim seçin!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // OpenAI API'ye fal isteği gönderiyoruz
      String fortune = await _getFortuneFromAI(
          _nameController.text, _birthDateController.text);

      // Fal yorumu geldiğinde
      Fluttertoast.showToast(
        msg: "Kahve falınız: $fortune",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      setState(() {
        _selectedImages.clear();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Hata: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  // Doğum tarihi formatlama
  void _formatBirthDate(String value) {
    if (value.length == 2 || value.length == 5) {
      if (!_birthDateController.text.endsWith('.')) {
        _birthDateController.text = value + '.';
        _birthDateController.selection = TextSelection.fromPosition(
          TextPosition(offset: _birthDateController.text.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kahve Falı",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown.shade600,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kahve falınızı bakmak için aşağıdaki alanları doldurun",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.brown.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              labelText: "Adınız",
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _nameController.text =
                      value[0].toUpperCase() + value.substring(1);
                  _nameController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _nameController.text.length),
                  );
                }
              },
            ),
            _buildTextField(
              controller: _birthDateController,
              labelText: "Doğum Tarihiniz (GG.AA.YYYY)",
              keyboardType: TextInputType.number,
              onChanged: _formatBirthDate,
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                  child: Text(
                    "Resim Seç",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildImagePreview(),
            SizedBox(height: 20),
            if (_isSending)
              Center(child: CircularProgressIndicator())
            else
              Center(
                child: ElevatedButton(
                  onPressed: _sendData,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 15.0),
                    child: Text(
                      "Gönder",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // TextField oluşturma fonksiyonu
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.brown.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Resim önizleme fonksiyonu
  Widget _buildImagePreview() {
    if (_selectedImages.isNotEmpty) {
      return Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _selectedImages.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImages[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: Text(
            "Henüz resim seçmediniz.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
