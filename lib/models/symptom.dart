class Symptom {
  final String name;
  final int weight;

  Symptom({this.name, this.weight});

  // faz o mapeamento do Json para um objeto Symptom(Sintôma)
  factory Symptom.fromJson(Map<String, dynamic> json) {
    return new Symptom(
      name: json['name'] as String,
      weight: json['weight'] as int
    );
  }

}