import 'package:flutter/material.dart';
import 'package:score_your_point/_comum/minhas_cores.dart';
import 'package:score_your_point/modelos/evento_modelo.dart';
import 'package:score_your_point/servicos/evento_servico.dart';

import 'adicionar_editar_evento_modal.dart';
import '../telas/evento_tela.dart';

class InicioItemLista extends StatelessWidget {
  final EventoModelo eventoModelo;
  final EventoServico servico;
  const InicioItemLista(
      {super.key, required this.eventoModelo, required this.servico});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventoTela(eventoModelo: eventoModelo),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black,
              spreadRadius: 1,
              offset: Offset(2, 2),
            )
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: MinhasCores.azulEscuro,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                height: 30,
                width: 150,
                child: Center(
                  child: Text(
                    eventoModelo.local,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          eventoModelo.nome,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: MinhasCores.azulEscuro,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              mostrarAdicionarEditarEventoModal(context, evento: eventoModelo);
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              SnackBar snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Deseja remover ${eventoModelo.nome}?",
                                ),
                                action: SnackBarAction(
                                  label: "REMOVER",
                                  textColor: Colors.white,
                                  onPressed: () {
                                    servico.removerEvento(
                                        idEvento: eventoModelo.id);
                                  },
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red,),
                          ),
                        ],
                      ),
                    ],
                  )
                , Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(eventoModelo.descricao,
                      overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
