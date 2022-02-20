import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class SearchCepBloc {
  final _streamController = StreamController<String>.broadcast();

  Sink<String> get searchCep => _streamController.sink; // Entrada
  Stream<Map<String, dynamic>> get viaCep => _streamController.stream.asyncMap(_searchCep); // Saída


  Future<Map<String, dynamic>> _searchCep(cep) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['erro'] == true) {
        throw 'O CEP informado não foi encontrado.';
      }

      return data;
    } else {
      throw 'Informe um CEP válido.';
    }
  }

  void dispose() {
    _streamController.close();
  }
}
