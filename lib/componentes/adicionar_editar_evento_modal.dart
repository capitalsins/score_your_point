import 'package:flutter/material.dart';
import 'package:score_your_point/_comum/minhas_cores.dart';
import 'package:score_your_point/componentes/decoracao_campo_autenticacao.dart';
import 'package:score_your_point/modelos/evento_modelo.dart';
import 'package:score_your_point/modelos/detalhes_modelo.dart';
import 'package:score_your_point/servicos/detalhes_servico.dart';
import 'package:score_your_point/servicos/evento_servico.dart';
import 'package:uuid/uuid.dart';

mostrarAdicionarEditarEventoModal(BuildContext context, {EventoModelo? evento}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: MinhasCores.azulEscuro,
    isDismissible: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(32),
      ),
    ),
    builder: (context) {
      return EventoModal(
        eventoModelo: evento,
      );
    },
  );
}

class EventoModal extends StatefulWidget {
  final EventoModelo? eventoModelo;
  const EventoModal({super.key, this.eventoModelo});

  @override
  State<EventoModal> createState() => _EventoModalState();
}

class _EventoModalState extends State<EventoModal> {
  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _localCtrl = TextEditingController();
  final TextEditingController _enderecoCtrl = TextEditingController();
  final TextEditingController _descricaoCtrl = TextEditingController();

  bool isCarregando = false;

  final EventoServico _eventoServico = EventoServico();

  @override
  void initState() {
    if (widget.eventoModelo != null) {
      _nomeCtrl.text = widget.eventoModelo!.nome;
      _localCtrl.text = widget.eventoModelo!.local;
      _descricaoCtrl.text = widget.eventoModelo!.descricao;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        (widget.eventoModelo != null)
                            ? "Editar ${widget.eventoModelo!.nome}"
                            : "Adicionar Evento",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomeCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o nome do evento?",
                        icon: const Icon(
                          Icons.abc,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _localCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o local do evento?",
                        icon: const Icon(
                          Icons.map_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _enderecoCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o endereço do evento?",
                        icon: const Icon(
                          Icons.list_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (widget.eventoModelo == null),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descricaoCtrl,
                            decoration: getAuthenticationInputDecoration(
                              "Qual a descrição do evento?",
                              icon: const Icon(
                                Icons.notes_rounded,
                                color: Colors.white,
                              ),
                            ),
                            maxLines: null,
                          ),
                          const Text(
                            "Você não precisa prencher isso agora.",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                enviarClicado();
              },
              child: (isCarregando)
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: MinhasCores.azulEscuro,
                      ),
                    )
                  : Text((widget.eventoModelo != null)
                      ? "Editar evento"
                      : "Criar evento"),
            ),
          ],
        ),
      ),
    );
  }

  enviarClicado() {
    setState(() {
      isCarregando = true;
    });

    String nome = _nomeCtrl.text;
    String local = _localCtrl.text;
    String endereco = _enderecoCtrl.text;
    String descricao = _descricaoCtrl.text;

    EventoModelo evento = EventoModelo(id: const Uuid().v1(), nome: nome, local: local, descricao: descricao,);

    if (widget.eventoModelo != null) {
      evento.id = widget.eventoModelo!.id;
    }

    _eventoServico.adicionarEvento(evento).then((value) {
      if (descricao != "") {
        DetalhesModelo detalhes = DetalhesModelo(
          id: const Uuid().v1(),
          detalhe: descricao,
          data: DateTime.now().toString(),
        );
        DetalhesServico().adicionarDetalhes(idEvento: evento.id, detalhesModelo: detalhes).then(
          (value) {
            setState(() {
              isCarregando = false;
            });
            Navigator.pop(context);
          },
        );
      } else {
        Navigator.pop(context);
      }
    });
  }
}
