  import 'dart:developer' as log;
  import 'dart:typed_data';
  import 'package:path/path.dart';
  import 'package:sqflite/sqflite.dart';


  class DbHelper {
    DbHelper._();

    static final DbHelper dbHelper = DbHelper._();

    Database? database;


    Future<Database?> initDB() async {
      String path = await getDatabasesPath();
      String dbPath = join(path, 'kids.db');

      database = await openDatabase(dbPath, version: 2, onCreate: (Database db, int version) async {
        String createForestTable = 'CREATE TABLE IF NOT EXISTS forest(CatID INTEGER, animalId INTEGER, Image BLOB, Title TEXT, lanId INTEGER, DesTitle TEXT, Description TEXT, Date TEXT);';
        await db.execute(createForestTable);

        String createCategoryTable = 'CREATE TABLE IF NOT EXISTS category(catId INTEGER, Title TEXT, image4 BLOB, Date TEXT);';
        await db.execute(createCategoryTable);

        String createDescriptionTable = 'CREATE TABLE IF NOT EXISTS description(CatID INTEGER, animalId INTEGER, lanId INTEGER, description TEXT, title TEXT);';
        await db.execute(createDescriptionTable);
      });

      return database;
    }
    //Category

    Future<void> insertCategoryData(int catId,String Title,Uint8List image4,String Date) async {
      database = await initDB();

      String sql = 'INSERT INTO category(catId, Title, image4, Date) VALUES (?, ?, ?, ?);';

      List args = [catId, Title, image4, Date];

      await database!.rawInsert(sql, args).then((value) {
        getCatImageData();
      });
    }

    Future<List<Map<String, dynamic>>> getCatImageData() async {
      database = await initDB();

      String sql = 'SELECT * FROM category;';

      List<Map<String, dynamic>> result = await database!.rawQuery(sql);

      log.log(
        result.length.toString(),
      );

      return result;
    }

    Future<void> insertDescriptionData(int animalId,int lanId, String title, String description) async {
      database = await initDB();

      String sql = 'INSERT INTO description(animalId ,lanId, title, description) VALUES (?, ?, ?, ?);';

      List args = [animalId, lanId, title, description];

      await database!.rawInsert(sql, args).then((value) {
        getDescriptionData(animalId);
      });
    }

    Future<List<Map<String, dynamic>>> getDescriptionData(int animalId) async {
      database = await initDB();

      String sql = 'SELECT * FROM description WHERE animalId = ?;';
      List<dynamic> args = [animalId];

      List<Map<String, dynamic>> result = await database!.rawQuery(sql, args);

      print(result.length.toString()); // Logging the number of retrieved descriptions

      return result;
    }


    Future<String> getDescriptionStringByAnimalIdAndLanId(int animalID, int lanId) async {
      try {
        database = await initDB();
        List args = [animalID, lanId];

        String sql = 'SELECT * FROM description WHERE animalID = ? AND lanId = ?;';
        List<Map<String, dynamic>> result = await database!.rawQuery(sql, args);

        // Convert the result into a string
        String descriptionString = result.toString();

        print(descriptionString);
        return descriptionString;
      } catch (e) {
        print(e);
        return ''; // Return an empty string in case of any error
      }
    }



    Future<void> insertForestData(int CatId,int animalId, Uint8List Image, String Title, String Date) async {
      database = await initDB();

      String sql = 'INSERT INTO forest(CatID ,animalId, Image, Title, Date) VALUES (?, ?, ?, ?, ?);';

      List args = [CatId ,animalId, Image, Title, Date];

      await database!.rawInsert(sql, args).then((value) {
        getForestImageData(CatId);
      });
    }

    Future<List<Map<String, dynamic>>> getForestImageData(int CatID) async {
      database = await initDB();
      List args = [CatID];

      String sql = 'SELECT * FROM forest WHERE CatID = ?;';

      List<Map<String, dynamic>> result = await database!.rawQuery(sql, args);


      log.log(
        result.length.toString(),
      );

      return result;
    }

    Future<void> updateCateDate(int CatID, String Date) async {
      database = await initDB();
      List args = [CatID, Date];

      int updateCount = await database!.rawUpdate('''
                  UPDATE category SET Date = ? WHERE CatID = ?''',
          ['$Date', CatID]);

      print(updateCount);
    }

    Future<void> updateForestDate(int animalId, String Date) async {
      database = await initDB();
      List args = [animalId, Date];

      int updateCount = await database!.rawUpdate('''
                  UPDATE forest SET Date = ? WHERE animalId = ?''',
          ['$Date', animalId]);

      print(updateCount);
    }


    //dose Exist

    Future<bool> doesAnimalDataExist(int animalId, String table) async {
      database = await initDB();

      String sql = 'SELECT COUNT(*) as count FROM $table WHERE animalId = ?;';
      List args = [animalId];

      List<Map<String, dynamic>> result = await database!.rawQuery(sql, args);

      int count = Sqflite.firstIntValue(result) ?? 0;

      return count > 0;
    }


    Future<bool> doesCatIdExist(int CatId, String table) async {
      database = await initDB();

      String sql = 'SELECT COUNT(*) as count FROM $table WHERE CatId = ?;';
      List args = [CatId];

      List<Map<String, dynamic>> result = await database!.rawQuery(sql, args);

      int count = Sqflite.firstIntValue(result) ?? 0;

      return count > 0;
    }

    Future<bool> doesCategoryDataExist(int catId, String table) async {
      database = await initDB();

      String sql = 'SELECT COUNT(*) as count FROM $table WHERE catId = ?;';
      List args = [catId];

      List<Map<String, dynamic>> result = await database!.rawQuery(sql, args);

      int count = Sqflite.firstIntValue(result) ?? 0;

      return count > 0;
    }
  }
