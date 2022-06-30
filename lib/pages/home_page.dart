import 'package:crud_banco/components/card.dart';
import 'package:crud_banco/pages/orcamento/orcamento.dart';
import 'package:crud_banco/pages/produto/home_produto.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  navegarProduto() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProdutoPage(),
      ),
    );
  }

  navegarOrcamento() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OrcamentoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestão financeiro')),
      body: Container(
        child: Column(
          children: [
            CardComponents(nome: 'Orçamento', onchange: navegarOrcamento),
            CardComponents(
                nome: 'Lista Compra Supermercado', onchange: navegarProduto),
          ],
        ),
      ),
    );
  }
}
