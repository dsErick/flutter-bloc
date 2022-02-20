import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cepController = TextEditingController();
  Map<String, dynamic> viaCep = {};
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEP'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              onSubmitted: (cep) => _searchCep(cep),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('CEP'),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => _searchCep(cepController.text),
              child: const Text('Pesquisar'),
            ),
            const SizedBox(height: 16),

            if (viaCep.isNotEmpty) Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.headline6,
                children: <InlineSpan>[
                  TextSpan(text: [null, ''].contains(viaCep['logradouro']) ? '' : "${viaCep['logradouro']}, "),
                  TextSpan(text: "${viaCep['localidade']}, ${viaCep['uf']}."),
                ],
              ),
            ),

            if (isLoading) const CircularProgressIndicator(),
            if (error.isNotEmpty) Text(
              error,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchCep(cep) async {
    setState(() {
      viaCep = {};
      error = '';
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['erro'] == true) {
        error = 'O CEP informado não foi encontrado.';
      } else {
        viaCep = data;
      }
    } else {
      error = 'Informe um CEP válido.';
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }
}