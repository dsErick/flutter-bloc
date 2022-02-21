import 'package:aulao_bloc/home/bloc/search_cep_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  final httpMock = MockClient((request) async {
    final url = request.url.toString();
    String data = '';
    int statusCode = 200;

    if (url.contains('success')) {
      data = '{"logradouro":"Logradouro Teste"}';
    } else if (url.contains('error')) {
      data = '{"erro":true}';
    } else if (url.contains('failure')) {
      statusCode = 400;
    }

    return Response(data, statusCode);
  });

  group('SearchCepBlock', () {
    blocTest<SearchCepBloc, SearchCepState>(
      'é retornado um SearchCepError quando a response é inválida',
      build: () => SearchCepBloc(httpClient: httpMock),
      act: (block) => block.add('failure'),
      expect: () => [
        isA<SearchCepLoading>(),
        const SearchCepError('Informe um CEP válido.'),
      ],
    );

    blocTest<SearchCepBloc, SearchCepState>(
      'é retornado um SearchCepError quando é informado um CEP, contúdo a response do ViaCep possui um erro',
      build: () => SearchCepBloc(httpClient: httpMock),
      act: (block) => block.add('error'),
      expect: () => [
        isA<SearchCepLoading>(),
        const SearchCepError('O CEP informado não foi encontrado.'),
      ],
    );

    blocTest<SearchCepBloc, SearchCepState>(
      'é retornado um SearchCepSuccess quando é informado um CEP válido',
      build: () => SearchCepBloc(httpClient: httpMock),
      act: (block) => block.add('success'),
      expect: () => [
        isA<SearchCepLoading>(),
        const SearchCepSuccess({'logradouro': 'Logradouro Teste'})
      ],
    );
  });
}
