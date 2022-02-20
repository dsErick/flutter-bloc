import 'package:flutter/material.dart';

import 'package:aulao_bloc/home/search_cep_bloc.dart';

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
              onSubmitted: (cep) => _searchCepBloc.searchCep.add(cep),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('CEP'),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => _searchCepBloc.searchCep.add(_cepController.text),
              child: const Text('Pesquisar'),
            ),
            const SizedBox(height: 16),

            StreamBuilder(
              stream: _searchCepBloc.viaCep,
              builder: viaCepBuilder,
            ),
          ],
        ),
      ),
    );
  }

  Widget viaCepBuilder(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.hasError) {
      return Text(
        '${snapshot.error}',
        style: TextStyle(fontSize: 16, color: Colors.red[700]),
      );
    }

    if (!snapshot.hasData) {
      return Container();
    }

    // if (snapshot.connectionState == ConnectionState.waiting) {
    //   return const CircularProgressIndicator();
    // }

    final viaCep = snapshot.data!;

    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.headline6,
        children: <InlineSpan>[
          TextSpan(text: [null, ''].contains(viaCep['logradouro']) ? '' : "${viaCep['logradouro']}, "),
          TextSpan(text: "${viaCep['localidade']}, ${viaCep['uf']}."),
        ],
      ),
    );
  }
}
