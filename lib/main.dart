import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as io;
import 'package:url_launcher/url_launcher.dart';

import 'server.dart' as server;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicia o servidor
  server.main();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FontSelectorScreen(),
    );
  }
}

class FontSelectorScreen extends StatefulWidget {
  const FontSelectorScreen({super.key});

  @override
  _FontSelectorScreenState createState() => _FontSelectorScreenState();
}

class _FontSelectorScreenState extends State<FontSelectorScreen> {
  String? _selectedFont;
  final TextEditingController _textController = TextEditingController();

  void _submit() async {
    final text = _textController.text;
    if (_selectedFont == null || text.isEmpty) return;

    final response = await http.post(
      Uri.parse('http://localhost:8080/render'),
      headers: {'Content-Type': 'application/json'},
      body: io.jsonEncode({'text': text, 'font': _selectedFont}),
    );

    if (response.statusCode == 200) {
      openHtmlFile();
    } else {
      // Handle error
      print('Failed to generate HTML: ${response.statusCode}');
    }
  }

  Future<void> openHtmlFile() async {
    String url = 'http://localhost:8080/page';

    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Font')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Radio<String>(
                value: 'mercedes',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Mercedes'),
              Radio<String>(
                value: 'nacional',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Nacional'),
              Radio<String>(
                value: 'nacionalestreito',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Nacional Estreito'),
              Radio<String>(
                value: 'mitsubishi',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Mitsubishi'),
              Radio<String>(
                value: 'mitsubishinacional',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Mitsubishi Nacional'),
              Radio<String>(
                value: 'captiva',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Captiva'),
              Radio<String>(
                value: 'celta2002',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Celta 2002'),
              Radio<String>(
                value: 'corsa2003',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Corsa 2003'),
              Radio<String>(
                value: 'golfantigo',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Golf Antigo'),
              Radio<String>(
                value: 'golfaudi',
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value;
                  });
                },
              ),
              const Text('Golf/Audi'),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Enter Text'),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Generate and Open HTML'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
