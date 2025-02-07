import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kafka Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KafkaPage(),
    );
  }
}

class KafkaPage extends StatefulWidget {
  const KafkaPage({super.key});

  @override
  _KafkaPageState createState() => _KafkaPageState();
}

class _KafkaPageState extends State<KafkaPage> {
  final TextEditingController _controller = TextEditingController();

  // Функция для отправки сообщения в Kafka через сервер
  Future<void> sendMessageToKafka(String message) async {
    final url = Uri.parse('http://localhost:3000/send');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Message sent to Kafka!'),
        ));
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kafka Flutter App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter message',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  sendMessageToKafka(_controller.text);
                }
              },
              child: Text('Send to Kafka'),
            ),
          ],
        ),
      ),
    );
  }
}
