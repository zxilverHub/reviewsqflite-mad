import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  static const String dbName = "heroes.db";
  static const int version = 2;

  static const String tbName = "hero";
  static const String colId = "colId";
  static const String colName = "colName";
  static const String colRule = "colRule";
  static const String colAge = "colAge";

  static Future<Database> openDb() async {
    var path = join(await getDatabasesPath(), dbName);
    var db = await openDatabase(
      path,
      version: version,
      onCreate: (db, version) {
        var sql = '''
        CREATE TABLE IF NOT EXISTS $tbName (
        $colId integer primary key,
        $colName varchar(250),
        $colRule varchar(250),
        $colAge interger
        );''';

        db.execute(sql);
        print("DB IS CREATED");
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (newVersion >= oldVersion) {
          var sql = "drop table $tbName";
          db.execute(sql);

          sql = '''
          CREATE TABLE IF NOT EXISTS $tbName (
          $colId integer primary key,
          $colName varchar(250),
          $colRule varchar(250),
          $colAge interger
          );''';

          db.execute(sql);
          print("DB IS CREATED");
        }
      },
    );

    return db;
  }

  static Future addHero(Map<String, dynamic> hero) async {
    var db = await openDb();
    var i = await db.insert(tbName, hero);
    print("ID: $i");
  }

  static Future<List<Map<String, dynamic>>> fetchData() async {
    var db = await openDb();
    var data = await db.query(tbName);
    return data;
  }

  static Future deleteHero(id) async {
    print(id);
    var db = await openDb();
    var i = await db.delete(
      tbName,
      where: "$colId = ?",
      whereArgs: [id],
    );

    return i;
  }

  static Future editItem(id, Map<String, dynamic> hero) async {
    var db = await openDb();
    var i = await db.update(
      tbName,
      hero,
      where: "$colId = ?",
      whereArgs: [id],
    );

    return i;
  }
}
