import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class DaoFactory {
  static Database? _db;
  static final DaoFactory _instance = DaoFactory._initialize();


  factory DaoFactory() {
    return _instance;
  }

  DaoFactory._initialize();



}