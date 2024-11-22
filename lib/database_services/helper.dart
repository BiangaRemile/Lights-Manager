import 'package:lights/data/lamp.dart';
import 'package:lights/data/persons.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "lights.db";

  String sqlLights = '''
    CREATE TABLE IF NOT EXISTS lamps (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      code TEXT UNIQUE,
      status INTEGER NOT NULL,
      alocate INTEGER,
      user INTEGER
    )
  ''';

  String sqlClients = '''
    CREATE TABLE IF NOT EXISTS clients (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE,
      address TEXT NOT NULL,
      lamps TEXT 
    )
  ''';

  Future<Database> intDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1,
      onCreate: (db, version) {
        db.execute(sqlLights);
        db.execute(sqlClients);
      },
      onUpgrade: (db, oldVersion, newVersion){
        db.execute(sqlLights);
        db.execute(sqlClients);
    });
  }

  Future<List<Lamp>> getLamps() async {
    final Database db = await intDB();
    var lamps = await db.rawQuery("SELECT * FROM lamps");
    List<Lamp> listLamp = [];

    for (Map<String, dynamic> lmp in lamps) {
      listLamp.add(Lamp.fromMap(lmp));
    }
    return listLamp;
  }

  Future<Lamp?> getLamp(String lmp) async {
    final Database db = await intDB();
    var lamp = await db.rawQuery("SELECT * FROM lamps where code = ?", [lmp]);

    return lamp.isNotEmpty? Lamp.fromMap(lamp.first):null;
  }

  Future<int> addLamp(Lamp lmp) async {
    final Database db = await intDB();
    return await db.insert("lamps", lmp.toMap());
  }

  Future<int> deleteLamp(Lamp lamp) async {
    final Database db = await intDB();
    if (lamp.user != null) {
      var client = await getClient(lamp.user!);
      List? lamps = client.splitLamps();
      lamps.remove(lamp.code);
      if(lamps.length == 0) {
        await db.rawUpdate("UPDATE clients SET lamps = ? WHERE id = ?", [null, client.id]);
      } else {
        await db.rawUpdate("UPDATE clients SET lamps = ? WHERE id = ?", [lamps.join(","), client.id]);
      }
    }
    return await db.delete("lamps", where: "code = ?", whereArgs: [lamp.code]);
  }

  Future<int> addClient(Client client) async {
    final Database db = await intDB();
    return db.insert("clients", client.toMap());
  }

  Future<List<Client>> getClients() async {
    final Database db = await intDB();

    var clients = await db.rawQuery("SELECT * FROM clients");
    List<Client> listClients = [];

    for (Map<String, dynamic> clt in clients) {
      listClients.add(Client.fromMap(clt));
    }
    return listClients;
  }

  Future<Client> getClient(int id) async {
    final Database db = await intDB();
    var client = await db.rawQuery("SELECT * FROM clients WHERE id = ?", [id]);
    return Client.fromMap(client.first);
  }

  Future<int> deleteClient(Client client) async {
    final Database db = await intDB();
    List? lamps = client.splitLamps();
    for(String code in lamps) {

      await db.rawUpdate("UPDATE lamps SET alocate = ?, status = ? WHERE code = ?", [null, 0, code]);
    }
    return await db.delete("clients", where: "id = ?", whereArgs: [client.id]);
  }

  bool isLampForClient(Client clt, String lmpCode){
    List lampes = clt.lamps != null? clt.splitLamps(): [];
    if(lampes.contains(lmpCode)) {
      return true;
    }
    return false;
  }

  Future<bool> addClientLamps(Client clt, String lmpCode) async {
    final Database db = await intDB();
    List lampes = clt.lamps != null? clt.splitLamps(): [];
    if(!isLampForClient(clt, lmpCode)) {
      lampes.add(lmpCode);
      var time = DateTime.now().microsecondsSinceEpoch;
      await db.rawUpdate("UPDATE clients SET lamps = ? WHERE id = ?", [lampes.join(","), clt.id]);
      await db.rawUpdate("UPDATE lamps SET alocate = ?, status = ?, user = ? WHERE code = ?", [time, 1, clt.id, lmpCode]);
      print(time);
      return true;
    }
    return false;
  }

  giveBackLamp(String code) async {
    final Database db = await intDB();

    Lamp? lamp = await getLamp(code);
    if (lamp != null) {
      Client? client = await getClient(lamp.user!);

      db.update("lamps", {"alocate": null, "status": 0, "user": null}, where: "code = ?", whereArgs: [code]);
      List lamps = client.splitLamps();
      lamps.remove(code);

      if(lamps.isEmpty) {
        await db.rawUpdate("UPDATE clients SET lamps = ? WHERE id = ?", [null, client.id]);
      } else {
        await db.rawUpdate("UPDATE clients SET lamps = ? WHERE id = ?", [lamps.join(","), client.id]);
      }
    }
  }
}