import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core import
import 'package:tarot_app/firebase_options.dart';
import 'package:tarot_app/screens/chat_screen.dart';
import 'package:tarot_app/screens/home_screen.dart'; // HomeScreen location
import 'package:tarot_app/screens/ai_tarot_screen.dart'; // AI Tarot Screen
import 'package:tarot_app/screens/live_tarot_screen.dart'; // Live Tarot Screen
import 'package:tarot_app/screens/kahve_fali_screen.dart'; // Kahve Falı Screen
import 'package:tarot_app/screens/login_screen.dart';
import 'package:tarot_app/screens/messages_screen.dart'; // Messages Screen
import 'package:tarot_app/screens/burc_yorumlari_screen.dart'; // Burç Yorumları Screen
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tarot_app/screens/register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarot_app/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env dosyasını yükleyin
  await dotenv.load(
      fileName: '/Users/can/Desktop/gitAItarot/.env'); // full path

  // API_KEY ve OPENAI_KEY değerleri
  String? apiKey = dotenv.env['API_KEY'];
  String? openAIKey = dotenv.env['OPENAI_KEY'];

  // key checking yapiliyor
  if (apiKey != null) {
    print("API_KEY: $apiKey");
  } else {
    print("API_KEY bulunamadı!");
  }

  if (openAIKey != null) {
    print("OPENAI_KEY: $openAIKey");
  } else {
    print("OPENAI_KEY bulunamadı!");
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // Home screen ilk screen
      home: LoginScreen(),
      routes: {
        '/settings': (context) => SettingsScreen(),
        '/chat': (context) => ChatScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/aiTarot': (context) => AiTarotScreen(),
        '/liveTarot': (context) => LiveTarotScreen(),
        '/kahveFali': (context) => KahveFaliScreen(),
        '/burcYorumlari': (context) => BurcYorumlariScreen(),
        '/messages': (context) => MessagesScreen(),
      },
    );
  }
}

// Firestore referansını al
FirebaseFirestore firestore = FirebaseFirestore.instance;

// Veritabanına veri kaydetme
Future<void> saveFortuneToFirestore(
    String name, String birthDate, String fortune, List<String> images) async {
  try {
    String userId = "uniqueUserId"; // Kullanıcının unique id'si

    await firestore.collection('users').doc(userId).set({
      'name': name,
      'birthDate': birthDate,
      'fortune': fortune,
      'fortuneTime': DateTime.now(), // Yorumun yapıldığı zaman
      'images': images, // Resimlerin yolları veya URL'leri
    });

    Fluttertoast.showToast(
      msg: "Fal yorumu kaydedildi.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Veri kaydedilirken hata oluştu: $e",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

// Kullanıcıları listelemek için StreamBuilder kullanımı
class UsersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          // Veriler yüklenirken gösterilecek widget
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Hata durumu
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          // Veriler geldiğinde listelenmesi
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Veri bulunamadı'));
          }

          // Veriler geldi, listede gösterelim
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['name']), // Kullanıcı adı
                subtitle: Text(user['email']), // Kullanıcı e-posta
              );
            },
          );
        },
      ),
    );
  }
}
