import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'fetch_service.dart';

class DBService {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'results.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE results(
            tanggal TEXT PRIMARY KEY,
            hari TEXT,
            sgp TEXT,
            hk TEXT,
            sdy TEXT
          )
        ''');
      },
    );
  }

  static Future<void> upsertAll(List<ResultData> data) async {
    final dbc = await db;
    final batch = dbc.batch();
    for (final r in data) {
      batch.insert('results', {
        'tanggal': r.tanggal,
        'hari': r.hari,
        'sgp': r.sgp,
        'hk': r.hk,
        'sdy': r.sdy,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<List<ResultData>> getAll() async {
    final dbc = await db;
    final maps = await dbc.query('results', orderBy: 'tanggal DESC');
    return maps.map((m) => ResultData(
      tanggal: m['tanggal'] as String,
      hari: m['hari'] as String,
      sgp: m['sgp'] as String,
      hk: m['hk'] as String,
      sdy: m['sdy'] as String,
    )).toList();
  }
}
