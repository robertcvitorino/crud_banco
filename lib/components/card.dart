// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CardComponents extends StatefulWidget {
  String nome;
  Function onchange;
  CardComponents({
    Key? key,
    required this.nome,
    required this.onchange,
  }) : super(key: key);

  @override
  State<CardComponents> createState() => _CardComponentsState();
}

class _CardComponentsState extends State<CardComponents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
      child: Card(
        margin: const EdgeInsets.only(top: 12),
        elevation: 2,
        child: InkWell(
          onTap: () {
            widget.onchange();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.nome} ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
