import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CriarOrcamento extends StatefulWidget {
  const CriarOrcamento({Key? key}) : super(key: key);

  @override
  State<CriarOrcamento> createState() => _CriarOrcamentoState();
}

class _CriarOrcamentoState extends State<CriarOrcamento> {
  final _formKey = GlobalKey<FormState>();

  var nome = "";
  var valor = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nomeController = TextEditingController();
  final valorController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomeController.dispose();
    valorController.dispose();

    super.dispose();
  }

  clearText() {
    nomeController.clear();
    valorController.clear();
  }

  // Adding Student
  CollectionReference orcamento =
      FirebaseFirestore.instance.collection('orcamento');

  Future<void> addOrcamento() {
    return orcamento
        .add({'nome': nome, 'valor': valor})
        .then((value) => print('Adicionar produto'))
        .catchError((error) => print('Erro ao adicionar o produto: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar produto"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Nome: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: nomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Valor: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: valorController,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            nome = nomeController.text;
                            valor = valorController.text;
                            addOrcamento();
                            clearText();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Orçamento cadastrado com sucesso!')));
                          });
                        }
                      },
                      child: const Text(
                        'Registrar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        clearText();
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
