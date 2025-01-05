import 'dart:io'; // File işlemleri için gerekli import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ImagePicker import

class KahveFaliScreen extends StatefulWidget {
  @override
  _KahveFaliScreenState createState() => _KahveFaliScreenState();
}

class _KahveFaliScreenState extends State<KahveFaliScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = []; // Seçilen resimleri tutmak için File listesi

  // Resim seçme işlemi
  Future<void> _pickImage() async {
    // Resim seçme işlemi (galeriden)
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    // Eğer kullanıcı resim seçtiyse
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path)); // XFile'dan File'a dönüşüm
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kahve Falı",
            style:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), // Başlık
        backgroundColor: Colors.brown.shade600, // Kahverengi tema
        centerTitle: true, // Başlık ortalanmış
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding artırıldı
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Sol hizalama
          children: [
            // Başlık ve açıklama kısmı
            Text(
              "Kahve falınızı bakmak için aşağıdaki alanları doldurun",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.brown.shade700, // Kahverengi tonları
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Kullanıcıdan ismini ve doğum tarihini alacak alan
            _buildTextField("Adınız", false),
            _buildTextField("Doğum Tarihiniz", false),

            SizedBox(height: 30),

            // Resim seçme butonu
            Center(
              child: ElevatedButton(
                onPressed: _pickImage, // Resim seçme butonu
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                  child: Text("Resim Seç",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600, // Kahverengi buton
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Seçilen resimlerin gösterilmesi
            if (_selectedImages.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Grid'de 3 sütun olacak
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
              ),
            // Seçilen resimler yoksa kullanıcıyı bilgilendiren metin
            if (_selectedImages.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "Henüz bir resim seçmediniz.",
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // TextField oluşturma fonksiyonu
  Widget _buildTextField(String labelText, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color:
                  Colors.brown.shade600), // Etiket rengini kahverengi yapıyoruz
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Yuvarlatılmış köşeler
            borderSide:
                BorderSide(color: Colors.brown.shade400), // Kenarlık rengi
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors
                    .brown.shade600), // Odaklanınca kenarlık rengi değişiyor
          ),
        ),
      ),
    );
  }
}
