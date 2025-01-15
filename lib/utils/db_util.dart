import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {

  static Future<sql.Database> openDatabaseConnection() async {

    final databasePath = await sql.getDatabasesPath();

    final pathToDatabase = path.join(databasePath, 'places.db');

    return sql.openDatabase(
      pathToDatabase,
      onCreate: (db, version) { //Se não estiver criado
        return db.execute(
          'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT NOT NULL, phone TEXT,' +
          ' email TEXT, latitude REAL NOT NULL, longitude REAL NOT NULL, address TEXT NOT NULL, image TEXT NOT NULL)'
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    //return Future.value();
    final db = await DbUtil.openDatabaseConnection();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql
          .ConflictAlgorithm.replace, //se inserir algo conlfitante (substitui)
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    //return Future<List<Map<String, dynamic>>>.value();
    final db = await DbUtil.openDatabaseConnection();
    return db.query(table);
  }
}
