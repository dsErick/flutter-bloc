import 'package:flutter/material.dart';

import 'package:aulao_bloc/home/search_cep_bloc.dart';
import 'package:aulao_bloc/home/search_cep_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCepBloc = SearchCepBloc();
  final _cepController = TextEditingController();

  @override
  void dispose() {
    _cepController.dispose();
    _searchCepBloc.dispose();
    super.dispose();
  }

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
              controller: _cepController,
              keyboardType: TextInputType.number,
              onSubmitted: (cep) => _searchCepBloc.sink.add(cep),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('CEP'),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => _searchCepBloc.sink.add(_cepController.text),
              child: const Text('Pesquisar'),
            ),
            const SizedBox(height: 24),

            StreamBuilder(
              stream: _searchCepBloc.stream,
              builder: viaCepBuilder,
            ),
          ],
        ),
      ),
    );
  }

  Widget viaCepBuilder(BuildContext context, AsyncSnapshot<SearchCepState> snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }

    final SearchCepState state = snapshot.data!;

    if (state is SearchCepError) {
      return Text(state.message, style: TextStyle(fontSize: 16, color: Colors.red[700]));
    }

    if (state is SearchCepLoading) {
      return const CircularProgressIndicator();
    }


    final viaCep = (state as SearchCepSuccess).data;

    return SizedBox(
      width: double.infinity,
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.headline6,
          children: <InlineSpan>[
            TextSpan(text: [null, ''].contains(viaCep['logradouro']) ? '' : "${viaCep['logradouro']}, "),
            TextSpan(text: "${viaCep['cep']}.\n"),
            TextSpan(text: "${viaCep['localidade']} - ${viaCep['uf']}."),
          ],
        ),
      ),
    );
  }
}
