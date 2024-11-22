 class Client {
    final int? id;
    final String name;
    final String address;
    final String? lamps;

    Client({this.id, required this.name, required this.address, required this.lamps,});

    factory Client.fromMap(Map<String, dynamic> json) => Client(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      lamps: json['lamps']
    );

    Map<String, dynamic> toMap() => {
      "id": id,
      "name": name,
      "address": address,
      "lamps": lamps
    };

    List<String> splitLamps() => lamps != null? lamps!.split(","): [];
 }