import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:score_your_point/_comum/meu_snackbar.dart';
import 'package:score_your_point/componentes/decoracao_campo_autenticacao.dart';
import 'package:score_your_point/servicos/autenticacao_servico.dart';
import 'package:score_your_point/telas/inicio_tela.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTela();
}

class _AutenticacaoTela extends State<AutenticacaoTela> {
  bool queroEntrar = true;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmeSenhaController =
      TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  final AutenticacaoServico _autenServico = AutenticacaoServico();
  static bool _showPassword = false;
  static bool? _rememberPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // MinhasCores.azulTopogradiente,
                  // MinhasCores.azulBaixogradiente,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/score_your_point_logo1.png",
                        height: 200,
                      ),
                      const Text(
                        "Score Your Point",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: getAuthenticationInputDecoration("E-mail"),
                        validator: (String? value) {
                          if (value == null) {
                            return "O e-mail não pode ser vazio";
                          }
                          if (value.length < 5) {
                            return "O e-mail é muito curto";
                          }
                          if (!value.contains("@")) {
                            return "O e-mail não é válido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _senhaController,
                        decoration: getAuthenticationInputDecoration("Senha"),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {
                            return "A senha não pode ser vazia";
                          }
                          if (value.length < 5) {
                            return "A senha é muito curta";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Visibility(
                        visible: !queroEntrar,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _confirmeSenhaController,
                              decoration: getAuthenticationInputDecoration(
                                  "Confirme a Senha"),
                              obscureText: true,
                              validator: (String? value) {
                                if (value == null) {
                                  return "A confirmação de senha não pode ser vazia";
                                }
                                if (value.length < 5) {
                                  return "A confirmação de senha é muito curta";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _nomeController,
                              decoration:
                                  getAuthenticationInputDecoration("Nome"),
                              validator: (String? value) {
                                if (value == null) {
                                  return "O nome não pode ser vazio";
                                }
                                if (value.length < 5) {
                                  return "O nome é muito curto";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: queroEntrar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.8,
                              ),
                              fillColor: WidgetStateProperty.all<Color>(
                                const Color(0xFFFFFFFF),
                              ),
                              checkColor: Colors.black,
                              value: _rememberPassword,
                              onChanged: (bool? value) {
                                setState(() {
                                  _rememberPassword = value;
                                });
                              },
                            ),
                            const Text(
                              'Lembrar minha senha',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 50),
                            Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    style: const TextStyle(
                                      color: Colors.green,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.transparent,
                                      decorationThickness: 0.3,
                                    ),
                                    text: 'Esqueceu sua senha?',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.green),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        onPressed: () {
                          botaoPrincipalClicado();
                        },
                        child: Text(
                          (queroEntrar) ? "Entrar" : "Cadastrar",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            queroEntrar = !queroEntrar;
                          });
                        },
                        child: Text(
                          (queroEntrar)
                              ? "Não possui cadastro? Clique aqui"
                              : "Já tem uma conta? Entre!",
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: queroEntrar,
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                'Ou entre com',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: IconButton(
                                icon: const Image(
                                  image: AssetImage(
                                      'assets/images/google_logo_image.png'),
                                  fit: BoxFit.cover,
                                  width: 30,
                                  height: 30,
                                ),
                                iconSize: 20,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !queroEntrar,
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                'Ou cadastre-se com',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: IconButton(
                                icon: const Image(
                                  image: AssetImage(
                                      'assets/images/google_logo_image.png'),
                                  fit: BoxFit.cover,
                                  width: 30,
                                  height: 30,
                                ),
                                iconSize: 20,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  botaoPrincipalClicado() {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmeSenha = _confirmeSenhaController.text;
    if (_formkey.currentState!.validate()) {
      if (queroEntrar) {
        print("Entrada Validada");
        _autenServico.logarUsuarios(email: email, senha: senha).then(
          (String? erro) {
            if (erro != null) {
              // Voltou com erro
              mostrarSnackBar(context: context, texto: erro);
            }
          },
        );
      } else {
        print("Cadastro Validado");
        print(
            "${_emailController.text}, ${_senhaController.text}, ${_confirmeSenhaController.text}, ${_nomeController.text},");
        _autenServico
            .cadastrarUsuario(
                nome: nome,
                senha: senha,
                confirmeSenha: confirmeSenha,
                email: email)
            .then(
          (String? erro) {
            if (erro != null) {
              // Voltou com erro
              mostrarSnackBar(context: context, texto: erro);
            }
            // else {
            //   // Deu certo
            //   mostrarSnackBar(
            //     context: context,
            //     texto: "Cadastro efetuado com sucesso",
            //     isErro: false,
            //   );
            // }
          },
        );
      }
    } else {
      print("Form inválido");
    }
  }
}
