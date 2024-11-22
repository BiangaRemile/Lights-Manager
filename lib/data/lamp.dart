class Lamp {
  final int? id;
  final String code;
  final int status;
  final int? alocate;
  final int? user;

  Lamp({this.id, this.alocate, this.user, required this.code, required this.status});

  factory Lamp.fromMap(Map<String, dynamic> json) => Lamp(
      id: json["id"],
      code: json['code'],
      status: json['status'],
      alocate: json['alocate'],
      user: json['user']
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "code": code,
    "status": status,
    "alocate": alocate,
    "user": user
  };

  String toStringDate() {
    var date = DateTime.fromMicrosecondsSinceEpoch(alocate!);
    return "${date.day} - ${date.month}";
  }
}