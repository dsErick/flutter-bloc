import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class SearchCepBloc {
  final _streamController = StreamController<String>.broadcast();

  Sink<String> get searchCep => _streamController.sink;
  // Stream<Map<String, dynamic>> get viaCep => _streamController.stream.asyncMap(_searchCep);
  Stream<SearchCepState> get viaCep => _streamController.stream.switchMap(_searchCep);


  Stream<SearchCepState> _searchCep(cep) async* {
    yield const SearchCepLoading();

    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json'));

      if (response.statusCode != 200) {
        throw const FormatException('Informe um CEP válido.');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['erro'] == true) {
        throw const FormatException('O CEP informado não foi encontrado.');
      }

      yield SearchCepSuccess(data);

    } on FormatException catch (e) {
      yield SearchCepError(e.message);
    } catch (e) {
      yield SearchCepError(e.toString());
    }
  }

  void dispose() {
    _streamController.close();
  }
}


// Possibilidade de fazer inversão de controle, e assim alterar para vários estados
// Contrato responsável pelo estado global
abstract class SearchCepState {}

class SearchCepSuccess implements SearchCepState {
  final Map<String, dynamic> data;

  const SearchCepSuccess(this.data);
}
class SearchCepLoading implements SearchCepState {
  const SearchCepLoading();
}
class SearchCepError implements SearchCepState {
  final String message;

  const SearchCepError(this.message);
}
