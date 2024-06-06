import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:score_your_point/_comum/minhas_cores.dart';
import 'package:score_your_point/componentes/adicionar_editar_detalhes_modal.dart';
import 'package:score_your_point/modelos/evento_modelo.dart';
import 'package:score_your_point/modelos/detalhes_modelo.dart';
import 'package:score_your_point/servicos/detalhes_servico.dart';

class EventoTela extends StatefulWidget {
  final EventoModelo eventoModelo;
  EventoTela({super.key, required this.eventoModelo});

  @override
  State<EventoTela> createState() => _EventoTelaState();
}

class _EventoTelaState extends State<EventoTela> {
  final DetalhesServico _detalhesServico = DetalhesServico();

  final imagePicker = ImagePicker();

  File? imageFile;

  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.eventoModelo.nome,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            Text(
              widget.eventoModelo.local,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: MinhasCores.azulEscuro,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.blue,
        onPressed: () {
          mostrarAdicionarEditarDetalhesDialog(
            context,
            idEvento: widget.eventoModelo.id,
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pick(ImageSource.gallery);
                    },
                    child: const Text("Enviar foto"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pick(ImageSource.camera);
                    },
                    child: const Text("Tirar foto"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Descrição do evento!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.eventoModelo.descricao),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            const Text(
              "Detalhes - Data e Hora",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            StreamBuilder(
              stream: _detalhesServico.conectarStream(
                  idEvento: widget.eventoModelo.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    final List<DetalhesModelo> listaDetalhes = [];

                    for (var doc in snapshot.data!.docs) {
                      listaDetalhes.add(DetalhesModelo.fromMap(doc.data()));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        listaDetalhes.length,
                        (index) {
                          DetalhesModelo detalhesAgora = listaDetalhes[index];
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(detalhesAgora.detalhe),
                            subtitle: Text(detalhesAgora.data),
                            leading: const Icon(Icons.double_arrow),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    mostrarAdicionarEditarDetalhesDialog(
                                        context,
                                        idEvento: widget.eventoModelo.id,
                                        detalhesModelo: detalhesAgora);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _detalhesServico.removerDetalhes(
                                      eventoId: widget.eventoModelo.id,
                                      detalhesId: detalhesAgora.id,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("Nenhuma descrição dos detalhes");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
