// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrcamentoUpdate extends StatefulWidget {
  String? id;
  OrcamentoUpdate({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<OrcamentoUpdate> createState() => _OrcamentoUpdateState();
}

class _OrcamentoUpdateState extends State<OrcamentoUpdate> {
  final _formKey = GlobalKey<FormState>();
  /* Conexão com banco Firebase */
  CollectionReference orcamento =
      FirebaseFirestore.instance.collection('orcamento');

  Future<void> updateUser(id, nome, valor) {
    /* Update do objeto no banco  */
    return orcamento
        .doc(id)
        .update({
          'nome': nome,
          'valor': valor,
        })
        .then((value) => print("Update produto"))
        .catchError((error) => print("Falha ao atulizar: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Produto"),
      ),
      body: Form(
          key: _formKey,
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('orcamento')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Erro as conectar');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.data();
              var nome = data!['nome'];
              var quantidade = data['valor'];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: nome,
                        autofocus: false,
                        onChanged: (value) => nome = value,
                        decoration: const InputDecoration(
                          labelText: 'Nome: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe um nome';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: quantidade!.toString(),
                        autofocus: false,
                        onChanged: (value) => quantidade = value,
                        decoration: const InputDecoration(
                          labelText: 'Valor: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe um numero';
                          }
                          return null;
                        },
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
                                updateUser(widget.id, nome, quantidade);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => {},
                            child: const Text(
                              'Reset',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
