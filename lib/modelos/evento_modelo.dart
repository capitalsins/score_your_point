class EventoModelo {
  String id;
  String nome;
  String local;
  String descricao;

  String? urlImagem;

  EventoModelo({
    required this.id,
    required this.nome,
    required this.local,
    required this.descricao,
  });

  EventoModelo.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        nome = map["nome"],
        local = map["local"],
        descricao = map["descricao"],
        urlImagem = map["urlImagem"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "local": local,
      "descricao": descricao,
      "urlImagem": urlImagem,
    };
  }
}
