class DetalhesModelo {
  String id;
  String detalhe;
  String data;
  
  // construtor base
  DetalhesModelo(
      {required this.id, required this.detalhe, required this.data});

  // construtor nomeado para converter de um map, normalmente vai usar, quando pegar essa informação do banco de dados
  DetalhesModelo.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        detalhe = map["sentindo"],
        data = map["data"];
  
  // metodo para transformar num map, quando a gente quer enviar a informação pro banco de dados.
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "sentindo": detalhe,
      "data": data,
    };
  }
}