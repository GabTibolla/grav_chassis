import 'package:flutter/material.dart';
import 'package:grav_chassis/app/core/helpers/upper_case_text_input_formatter.dart';
import 'package:grav_chassis/app/core/widgets/ui/appbarwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as io;
import 'package:url_launcher/url_launcher.dart';

class FontSelectorScreen extends StatefulWidget {
  const FontSelectorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FontSelectorScreenState createState() => _FontSelectorScreenState();
}

class _FontSelectorScreenState extends State<FontSelectorScreen> {
  String? _selectedFont;
  String _searchText = '';
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  // Filtra as fontes conforme a pesquisa
  List<Map<String, String>> get _filteredFontOptions {
    if (_searchText.isEmpty) {
      return _fontOptions;
    } else {
      return _fontOptions.where((font) {
        return font['label']!.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    }
  }

  // Envia o formulário para o servidor
  void _submit() async {
    final text = _textController.text;

    // Verifica se os campos foram digitados/escolhidos
    if (_selectedFont == null || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um texto e selecione uma fonte.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      // Trava o botão de imprimir
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://localhost:8080/render'),
      headers: {'Content-Type': 'application/json'},
      body: io.jsonEncode({'text': text, 'font': _selectedFont}),
    );

    // Verifica a resposta
    if (response.statusCode == 200) {
      await openHtmlFile();
    }

    setState(() {
      // Destrava o botão de imprimir
      _isLoading = false;
    });
  }

  // Faz chamada para o servidor retornar a página criada
  Future<void> openHtmlFile() async {
    String url = 'http://localhost:8080/page';
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: 'Grav Chassis',
        backgroundColor: Colors.teal,
        onChanged: (text) {
          setState(() {
            _searchText = text;
          });
        },
        onSearch: (text) {
          setState(() {
            _searchText = text;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            TextField(
              controller: _textController,
              inputFormatters: [
                UpperCaseTextInputFormatter(), // Aplica a formatação
              ],
              decoration: const InputDecoration(
                labelText: 'Insira o texto',
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                prefixIcon: Icon(Icons.text_fields, color: Colors.teal),
              ),
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Selecione a fonte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: _filteredFontOptions.map((font) {
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: Icon(
                        _selectedFont == font['value'] ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: Colors.teal,
                      ),
                      title: Text(
                        font['label'].toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: _selectedFont == font['value'] ? Colors.teal : Colors.black,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedFont = font['value'];
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Imprimir'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> _fontOptions = [
    {'value': 'mercedes', 'label': 'Mercedes'},
    {'value': 'nacional', 'label': 'Nacional'},
    {'value': 'nacionalantigo', 'label': 'Nacional Antigo'},
    {'value': 'nacionalestreito', 'label': 'Nacional Estreito'},
    {'value': 'mitsubishi', 'label': 'Mitsubishi'},
    {'value': 'mitsubishinacional', 'label': 'Mitsubishi Nacional'},
    {'value': 'celta2002', 'label': 'Celta 2002'},
    {'value': 'corsa2003', 'label': 'Corsa 2003'},
    {'value': 'golfantigo', 'label': 'Golf Antigo'},
    {'value': 'golfaudi', 'label': 'Golf/Audi'},
  ];
}
