import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'package:aulao_bloc/home/search_cep_state.dart';

class SearchCepBloc {
  SearchCepBloc([http.Client? client]) {
    _client = client ?? http.Client();
  }

  late http.Client _client;


  final _streamController = StreamController<String>.broadcast();

  Sink<String> get sink => _streamController.sink;
  Stream<SearchCepState> get stream => _streamController.stream.switchMap(_searchCep);


  Stream<SearchCepState> _searchCep(cep) async* {
    yield const SearchCepLoading();

    try {
      final response = await _client.get(Uri.parse('https://viacep.com.br/ws/$cep/json'));

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
