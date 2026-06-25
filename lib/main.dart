import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore POC")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('test')
            .doc('hello')
            .snapshots(),
        builder: (context, snapshot) {
          // ✅ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Error
          if (snapshot.hasError) {
            return Center(
              child: Text("Error:\n${snapshot.error}"),
            );
          }

          // ✅ No data
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(
              child: Text("No data found"),
            );
          }

          // ✅ Extract data safely
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final message = data['msg'] ?? "Field 'msg' not found";

          // ✅ Display
          return Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: 24),
            ),
          );
        },
      ),
    );
  }
}