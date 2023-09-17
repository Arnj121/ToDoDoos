import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
class DatabaseHelper{
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  String table='todolist';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $table (
                id INTEGER PRIMARY KEY,
                list TEXT,
                done integer,
                date text,
                category TEXT
              )''');
    await db.execute('''CREATE TABLE category (
                id INTEGER PRIMARY KEY,
                category text
              )''');
  }

  Future<dynamic> queryAll()async{
    Database db = await database;
    return await db.query(table);
  }

  Future mark(int index,int value)async{
    Database db = await database;
    await db.update(table, {'done':value},where: 'id=?',whereArgs: [index]);
  }

  Future add(int id,String text,String date,String category)async{
    Database db = await database;
    await db.insert(table, {'id':id,'list':text,'done':0,'date':date,'category':category});
  }

  Future createCat(int id,String cat)async{
    Database db = await database;
    await db.insert('category', {'id':id,'category':cat});
  }

  Future<bool> addTocat(int id,String cat)async{
    Database db = await database;
    dynamic cl = await this.getcat();
    for(int i=0;i<cl.length;i++){
      if (cl[0]['category']==cat){
        return false;
      }
    }
    await db.update(table, {'category':cat},where: 'id=?',whereArgs: [id]);
    return true;
  }

  Future deleteList(int id)async{
    Database db = await database;
    await db.delete(table,whereArgs: [id],where: 'id=?');
  }
  Future<dynamic> getcat()async{
    Database db = await database;
    return await db.query('category');
  }

  Future deleteCat(String cat)async{
    Database db = await database;
    await db.update(table, {'category':''},where: 'category=?',whereArgs: [cat]);
    await db.delete('category',whereArgs: [cat],where: 'category=?');
  }

  Future<dynamic> getListCat(String cat)async{
    Database db = await database;
    return await db.query(table,where: 'category=?',whereArgs: [cat]);
  }

  Future<dynamic> getSorted(int date,int completed,String type)async{
    Database db = await database;
    String where ='1=1 order by ';
    if (date==1)
      where+=' date';
    if(completed==1){
      if(date==1)
        where+=',done ';
      else
        where+='done ';
    }
    where+=type;
    print(where);
    return await db.query(table,where:where);
  }
}