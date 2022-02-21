import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'search_cep_state.dart';

class SearchCepBloc extends Bloc<String, SearchCepState> {
  final http.Client httpClient;

  SearchCepBloc({ required this.httpClient }) : super (const SearchCepEmpty()) {
    on<String>(_searchCep);
  }

  Future<void> _searchCep(String cep, Emitter<SearchCepState> emit) async {
    emit(const SearchCepLoading());

    try {
      final response = await httpClient.get(Uri.parse('https://viacep.com.br/ws/$cep/json'));

      if (response.statusCode != 200) {
        throw const FormatException('Informe um CEP válido.');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['erro'] == true) {
        throw const FormatException('O CEP informado não foi encontrado.');
      }

      emit(SearchCepSuccess(data));
    } on FormatException catch (e) {
      emit(SearchCepError(e.message));
    } catch (e) {
      emit(SearchCepError(e.toString()));
    }
  }
}
