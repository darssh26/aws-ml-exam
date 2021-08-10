class Option {
  final int id;
  final String value;

  Option(this.id, this.value);

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(json['id'], json['value']);
  }
}
