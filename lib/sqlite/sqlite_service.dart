import 'package:helpme/models/demande_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static Database? _db;

  Future<Database> get database async {
    return _db ??= await initDB();
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'helpme.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE "demandes"(
        "uid" TEXT PRIMARY KEY,
        "userUid" TEXT,
        "titre" TEXT,
        "description" TEXT,
        "categorie" TEXT,
        "lieu" TEXT,
        "date" TEXT,
        "cloture" INTEGER
        )
        ''');
      },
    );
  }

  Future<void> insertDemande(DemandeModel demande) async {
    final db = await database;
    await db.insert(
      'demandes',
      demande.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DemandeModel>> getDemandes() async {
    final db = await database;
    final maps = await db.query('demandes');
    return maps.map((m) => DemandeModel.fromJson(m)).toList();
  }
}
