import 'package:flutter/material.dart';
import 'package:score_your_point/modelos/detalhes_modelo.dart';
import 'package:score_your_point/servicos/detalhes_servico.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> mostrarAdicionarEditarDetalhesDialog(
  BuildContext context, {
  required String idEvento,
  DetalhesModelo? detalhesModelo,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController detalhesController = TextEditingController();
      if (detalhesModelo != null) {
        detalhesController.text = detalhesModelo.detalhe;
      }

      return AlertDialog(
        title: const Text("Descreva o evento"),
        content: TextFormField(
          controller: detalhesController,
          decoration: const InputDecoration(
            label: Text("Diga sobre o evento"),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              DetalhesModelo detalhes = DetalhesModelo(
                id: const Uuid().v1(),
                detalhe: detalhesController.text,
                data: DateTime.now().toString(),
              );

              if (detalhesModelo != null) {
                detalhes.id = detalhesModelo.id;
              }
              DetalhesServico().adicionarDetalhes(
                idEvento: idEvento,
                detalhesModelo: detalhes,
              );
              Navigator.pop(context);
            },
            child: Text((detalhesModelo != null)
                ? "Editar detalhes"
                : "Criar detalhes"),
          ),
        ],
      );
    },
  );
}
