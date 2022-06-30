import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_banco/pages/produto/add_produto.dart';
import 'package:crud_banco/pages/produto/update_produto.dart';
import 'package:flutter/material.dart';

class ProdutoPage extends StatefulWidget {
  const ProdutoPage({Key? key}) : super(key: key);

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  final Stream<QuerySnapshot> produtoStream =
      FirebaseFirestore.instance.collection('produto').snapshots();

  // For Deleting User
  CollectionReference produto =
      FirebaseFirestore.instance.collection('produto');
  Future<void> deleteProduto(id) {
    // print("User Deleted $id");
    return produto
        .doc(id)
        .delete()
        .then((value) => print('Deletar produto'))
        .catchError((error) => print('Falha ao deletar produto: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: produtoStream,
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
                                      'Produto: ${storedocs[index]['nome'].toString()}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Quantidade: ${storedocs[index]['quantidade'].toString()}',
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
                                          builder: (context) => ProdutoUpdate(
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
                                      deleteProduto(storedocs[index]['id']);
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
              builder: (context) => const CriarProduto(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
