class DDown {
  DDown({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory DDown.fromJson(Map<String, dynamic> json) => DDown(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  String getIds(List<DDown> data) {
    List<int> tmp = [];

    for (var element in data) {
      tmp.add(element.id!);
    }
    return tmp.toString();
  }

  DDown.initialState()
      : id = 0,
        name = '';
}
