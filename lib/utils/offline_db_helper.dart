import 'package:grocery_app/models/database_models/InwardProductModel.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDbHelper {
  static OfflineDbHelper _offlineDbHelper;
  static Database database;

  static const TABLE_PRODUCT_CART = "product_cart";
  static const TABLE_PRODUCT_CART_FAVORITE = "favorite_product_cart";
  static const TABLE_INWARD_PRODUCT = "inward_product";

/*  static createInstance() async {
    _offlineDbHelper = OfflineDbHelper();
    database = await openDatabase(
      join(await getDatabasesPath(), 'soleoserp_database.db'),
      onCreate: (db, version) {
        return db.execute(


          'CREATE TABLE $TABLE_CONTACTS(id INTEGER PRIMARY KEY AUTOINCREMENT, pkId TEXT,CustomerID TEXT, ContactDesignationName TEXT, ContactDesigCode1 TEXT, CompanyId TEXT, ContactPerson1 TEXT, ContactNumber1 TEXT, ContactEmail1 TEXT, LoginUserID TEXT)',
         // 'CREATE TABLE $TABLE_INQUIRY_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, InquiryNo TEXT,LoginUserID TEXT, CompanyId TEXT, ProductName TEXT, ProductID TEXT, Quantity TEXT, UnitPrice TEXT)',

        );

      },
      version: 2,
    );
  }*/

  static createInstance() async {
    _offlineDbHelper = OfflineDbHelper();
    database = await openDatabase(
        join(await getDatabasesPath(), 'grocery_database.db'),
        onCreate: (db, version) => _createDb(db),
        version: 7);
  }

  static void _createDb(Database db) {
    /* int id;
  final String name;
  final String description;
  final double price;
  final String Nutritions;
  final String imagePath;*/

    //db.execute('CREATE TABLE $TABLE_PRODUCT_CART(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,description TEXT, price DOUBLE, Qty INTEGER , Nutritions TEXT, imagePath TEXT)',);

    /* int id;
                                                                                                                                                    int pkID, ProductID, CompanyId;
                                                                                                                                                    double Quantity,UnitRate,Amount,NetAmount;
                                                                                                                                                    String ProductName, Unit, LoginUserID;
                                                                                                                                                  */
    db.execute(
      'CREATE TABLE $TABLE_PRODUCT_CART(id INTEGER PRIMARY KEY AUTOINCREMENT, ProductName TEXT,ProductAlias TEXT, ProductID INTEGER, CustomerID INTEGER , Unit TEXT, UnitPrice DOUBLE, Quantity INTEGER , DiscountPercent DOUBLE , LoginUserID TEXT, CompanyId TEXT, ProductSpecification TEXT, ProductImage TEXT,vat DOUBLE)',
    );
    db.execute(
      'CREATE TABLE $TABLE_PRODUCT_CART_FAVORITE(id INTEGER PRIMARY KEY AUTOINCREMENT, ProductName TEXT,ProductAlias TEXT, ProductID INTEGER, CustomerID INTEGER , Unit TEXT, UnitPrice DOUBLE, Quantity INTEGER , DiscountPercent DOUBLE , LoginUserID TEXT, CompanyId TEXT, ProductSpecification TEXT, ProductImage TEXT,vat DOUBLE)',
    );
    db.execute(
      'CREATE TABLE $TABLE_INWARD_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, InwardNo TEXT,ProductID INTEGER, CompanyId INTEGER, Quantity DOUBLE , UnitRate DOUBLE , Amount DOUBLE, NetAmount DOUBLE, ProductName TEXT, Unit TEXT,LoginUserID TEXT)',
    );
  }

  static OfflineDbHelper getInstance() {
    return _offlineDbHelper;
  }

  ///Here Customer Contact Table Implimentation

  Future<int> insertProductToCart(ProductCartModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_PRODUCT_CART,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProductCartModel>> getProductCartList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(TABLE_PRODUCT_CART);

    return List.generate(maps.length, (i) {
      /* int id;
  String ProductName;
  String ProductAlias;
  int ProductID;
  int CustomerID;
  String Unit;
  double UnitPrice;
  double Quantity;
  double DiscountPer;
  String LoginUserID;
  String ComapanyID;
  String ProductSpecification;
  String ProductImage;*/

      return ProductCartModel(
        maps[i]['ProductName'],
        maps[i]['ProductAlias'],
        maps[i]['ProductID'],
        maps[i]['CustomerID'],
        maps[i]['Unit'],
        maps[i]['UnitPrice'],
        maps[i]['Quantity'],
        maps[i]['DiscountPercent'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductImage'],
        maps[i]['vat'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateContact(ProductCartModel model) async {
    final db = await database;

    await db.update(
      TABLE_PRODUCT_CART,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<List<ProductCartModel>> updateduplicate() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select ProductID, ProductName, ProductAlias, CustomerID, Unit , DiscountPercent, LoginUserID, CompanyId, ProductSpecification, ProductImage, vat, UnitPrice , Sum(Quantity) As Quantity  From $TABLE_PRODUCT_CART Group By ProductID, ProductName');

    /* final List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select ProductID, ProductName, ProductAlias, CustomerID, Unit , DiscountPercent, LoginUserID, CompanyId, ProductSpecification, ProductImage, vat, Sum(UnitPrice) As UnitPrice , Sum(Quantity) As Quantity  From $TABLE_PRODUCT_CART Group By ProductID, ProductName');
*/
    return List.generate(maps.length, (i) {
      /* int id;
  String ProductName;
  String ProductAlias;
  int ProductID;
  int CustomerID;
  String Unit;
  double UnitPrice;
  double Quantity;
  double DiscountPer;
  String LoginUserID;
  String ComapanyID;
  String ProductSpecification;
  String ProductImage;*/

      return ProductCartModel(
        maps[i]['ProductName'],
        maps[i]['ProductAlias'],
        maps[i]['ProductID'],
        maps[i]['CustomerID'],
        maps[i]['Unit'],
        maps[i]['UnitPrice'],
        maps[i]['Quantity'],
        maps[i]['DiscountPercent'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductImage'],
        maps[i]['vat'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> deleteContact(int id) async {
    final db = await database;

    await db.delete(
      TABLE_PRODUCT_CART,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteContactTable() async {
    final db = await database;

    await db.delete(TABLE_PRODUCT_CART);
  }

  /// Here Favorits Product Implimentation

  Future<int> insertProductToCartFavorit(ProductCartModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_PRODUCT_CART_FAVORITE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProductCartModel>> getProductCartFavoritList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_PRODUCT_CART_FAVORITE);

    return List.generate(maps.length, (i) {
      /* int id;
  String ProductName;
  String ProductAlias;
  int ProductID;
  int CustomerID;
  String Unit;
  double UnitPrice;
  double Quantity;
  double DiscountPer;
  String LoginUserID;
  String ComapanyID;
  String ProductSpecification;
  String ProductImage;*/

      return ProductCartModel(
        maps[i]['ProductName'],
        maps[i]['ProductAlias'],
        maps[i]['ProductID'],
        maps[i]['CustomerID'],
        maps[i]['Unit'],
        maps[i]['UnitPrice'],
        maps[i]['Quantity'],
        maps[i]['DiscountPercent'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductImage'],
        maps[i]['vat'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateContactFavorit(ProductCartModel model) async {
    final db = await database;

    await db.update(
      TABLE_PRODUCT_CART_FAVORITE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteContactFavorit(int id) async {
    final db = await database;

    await db.delete(
      TABLE_PRODUCT_CART_FAVORITE,
      where: 'ProductID = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteContactTableFavorit() async {
    final db = await database;

    await db.delete(TABLE_PRODUCT_CART_FAVORITE);
  }

  /// Here Inward Product Implimentation

  Future<int> insertInwardProduct(InWardProductModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_INWARD_PRODUCT,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InWardProductModel>> getInwardProductList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_INWARD_PRODUCT);

    return List.generate(maps.length, (i) {
      /* int id;
  String ProductName;
  String ProductAlias;
  int ProductID;
  int CustomerID;
  String Unit;
  double UnitPrice;
  double Quantity;
  double DiscountPer;
  String LoginUserID;
  String ComapanyID;
  String ProductSpecification;
  String ProductImage;*/

      /* "pkID": 10023,
        "ProductID": 8,
        "Quantity": 5,
        "Unit": "ltr",
        "UnitRate": 350,
        "Amount": 0,
        "NetAmount": 0,
        "LoginUserID": "admin",
        "CompanyId": 4135*/
//      'CREATE TABLE $TABLE_INWARD_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT,
//      pkID INTEGER,ProductID INTEGER, CompanyId INTEGER, Quantity DOUBLE ,
//      UnitRate DOUBLE , Amount DOUBLE, NetAmount DOUBLE, ProductName TEXT, Unit TEXT,LoginUserID TEXT)',
      return InWardProductModel(
        maps[i]['InwardNo'],
        maps[i]['ProductID'],
        maps[i]['CompanyId'],
        maps[i]['Quantity'],
        maps[i]['UnitRate'],
        maps[i]['Amount'],
        maps[i]['NetAmount'],
        maps[i]['ProductName'],
        maps[i]['Unit'],
        maps[i]['LoginUserID'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateInwardProduct(InWardProductModel model) async {
    final db = await database;

    await db.update(
      TABLE_INWARD_PRODUCT,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteInwardProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_INWARD_PRODUCT,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLInwardProduct() async {
    final db = await database;

    await db.delete(TABLE_INWARD_PRODUCT);
  }
}
