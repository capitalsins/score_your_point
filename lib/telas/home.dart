import 'package:flutter/material.dart';
import 'package:score_your_point/_comum/minhas_cores.dart';
import 'package:score_your_point/telas/autenticacao_tela.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _login() {
    Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const AutenticacaoTela()),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: MinhasCores.verdeClaro,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Column(
              children: [
                Image(
                  image: AssetImage('assets/images/score_your_point_logo2.png'),
                  width: 281,
                ),
                Text(
                  'Score Your Point',
                  style: TextStyle(
                      fontFamily: 'Dangrek',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white),
                )
              ],
            ),
            SizedBox(
              width: 250,
              child: TextButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: _login,
                child: const Text(
                  'Começar',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: MinhasCores.verdeClaro,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
