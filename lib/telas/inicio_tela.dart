import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:score_your_point/componentes/adicionar_editar_evento_modal.dart';
import 'package:score_your_point/componentes/inicio_lista_widget.dart';
import 'package:score_your_point/modelos/evento_modelo.dart';
import 'package:score_your_point/servicos/autenticacao_servico.dart';
import 'package:score_your_point/servicos/evento_servico.dart';

class InicioTela extends StatefulWidget {
  final User user;
  const InicioTela({super.key, required this.user});

  @override
  State<InicioTela> createState() => _InicioTelaState();
}

class _InicioTelaState extends State<InicioTela> {
  final EventoServico servico = EventoServico();
  bool isDecrecente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Eventos"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isDecrecente = !isDecrecente;
                });
              },
              icon: const Icon(Icons.sort_by_alpha_rounded))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/icone_do_perfil_do_usuario.png"),
              ),
              accountName: Text((widget.user.displayName != null)
                  ? widget.user.displayName!
                  : ""),
              accountEmail: Text(widget.user.email!),
            ),
            const ListTile(
              title: Text("Minha bio."),
              leading: Icon(Icons.menu_book_rounded),
              dense: true,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Deslogar"),
              onTap: () {
                AutenticacaoServico().deslogar();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          mostrarAdicionarEditarEventoModal(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: StreamBuilder(
          stream: servico.conectarStreamEventos(isDecrecente),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.docs.isNotEmpty) {
                List<EventoModelo> listaEventos = [];
        
                for (var doc in snapshot.data!.docs) {
                  listaEventos.add(EventoModelo.fromMap(doc.data()));
                }
        
                return ListView(
                  children: List.generate(
                    listaEventos.length,
                    (index) {
                      EventoModelo eventoModelo = listaEventos[index];
                      return InicioItemLista(
                          eventoModelo: eventoModelo, servico: servico);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text("Ainda nenhum evento. 😥\nVamos adicionar?"),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
