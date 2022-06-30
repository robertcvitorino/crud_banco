import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_banco/pages/orcamento/update_orcamento.dart';
import 'package:flutter/material.dart';

import 'add_orcamento.dart';

class OrcamentoPage extends StatefulWidget {
  const OrcamentoPage({Key? key}) : super(key: key);

  @override
  State<OrcamentoPage> createState() => _OrcamentoPageState();
}

class _OrcamentoPageState extends State<OrcamentoPage> {
  final Stream<QuerySnapshot> orcamentoStream =
      FirebaseFirestore.instance.collection('orcamento').snapshots();

  CollectionReference orcamento =
      FirebaseFirestore.instance.collection('orcamento');
  Future<void> deleteOrcamento(id) {
    return orcamento
        .doc(id)
        .delete()
        .then((value) => print('Deletar orcamento'))
        .catchError((error) => print('Falha ao deletar orcamento: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: orcamentoStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('Impossivel conectar');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List storedocs = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              storedocs.add(a);
              a['id'] = document.id;
            }).toList();

            return ListView.builder(
              itemBuilder: ((context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
                  child: Card(
                    margin: const EdgeInsets.only(top: 12),
                    elevation: 2,
                    child: InkWell(
                      onTap: () {/* => abrirDetalhes() */},
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Despesa: ${storedocs[index]['nome'].toString()}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Valor: ${storedocs[index]['valor'].toString()}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    title: const Text('Alterar'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrcamentoUpdate(
                                              id: storedocs[index]['id']),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    title: const Text('Remover '),
                                    onTap: () {
                                      deleteOrcamento(storedocs[index]['id']);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              itemCount: storedocs.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CriarOrcamento(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
