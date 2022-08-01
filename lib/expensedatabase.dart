
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';



class SqlDB {

  String firstDate= '${DateTime.now().year}/${DateTime.now().month}/1';

  static Database? _db;

  Future<Database?> get db async {

    if (_db == null) {
      _db = await initialDB();
      return _db;

    } else {
      return _db;
    }


  }

  initialDB() async {

    String databasePath= await getDatabasesPath();
    String path = join(databasePath, 'expenses.db');  // expenses is the database name

    Database myDB = await openDatabase(path, onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return myDB;

  }

  _onUpgrade(Database db, int oldversion, int newversion) {



    print('Database upgraded ======================');
  }

  // below function is used to create the table in the database and it's done once only

  _onCreate(Database db, int version) async {

    await db.execute('''
    
    CREATE TABLE expensesTable (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    category TEXT,
    amount REAL
     )
        ''');

    await db.execute('''
    
    CREATE TABLE settingsTable (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    currency TEXT,
    target REAL
     )
        ''');

    await db.execute("INSERT INTO expensesTable ('date','amount') VALUES ('$firstDate','0')");

    await db.execute("INSERT INTO settingsTable ('currency','target') VALUES ('AED','0')");

    print('Databases Created =====================');
  }


  // below are operations functions of the database which will be used to handle the database

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  // read(String sql) async {
  //   Database? mydb = await db;
  //   List<Map> response = await mydb!.query(table);
  //   return response;
  // }


}