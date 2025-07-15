import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  /* ======================================================
     Singleton Database
  ====================================================== */
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  /* ======================================================
     Inisialisasi Database
  ====================================================== */
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path   = join(dbPath, 'ekskul_app.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /* ------------------------------------------------------
     onCreate – Pertama kali DB dibuat
  ------------------------------------------------------ */
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT,
        role     TEXT
      );
    ''');

    await db.insert('users', {
      'username': 'admin',
      'password': 'admin123',
      'role'    : 'admin',
    });

    await db.execute('''
      CREATE TABLE biodata (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        username            TEXT,
        nis                 TEXT,
        namaLengkap         TEXT,
        kelas               TEXT,
        noHp                TEXT,
        email               TEXT,
        alamat              TEXT,
        namaPanggilan       TEXT,
        tempatTanggalLahir  TEXT,
        tinggiBadan         REAL,
        beratBadan          REAL,
        hasilTes            TEXT,
        alasan              TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE pilihan_ekskul (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        ekskul   TEXT,
        kategori TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE absensi (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        username   TEXT,
        tanggal    TEXT,
        status     TEXT,
        keterangan TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE penilaian (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        tanggal  TEXT,
        nilai    TEXT,
        catatan  TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE dokumentasi (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        username  TEXT,
        imagePath TEXT,
        caption   TEXT
      );
    ''');
  }

  /* ------------------------------------------------------
     onUpgrade – Menambahkan kolom jika naik versi
  ------------------------------------------------------ */
  Future<void> _onUpgrade(Database db, int oldV, int newV) async {
    if (oldV < 2) {
      await db.execute("ALTER TABLE biodata ADD COLUMN namaPanggilan TEXT;");
      await db.execute("ALTER TABLE biodata ADD COLUMN tempatTanggalLahir TEXT;");
      await db.execute("ALTER TABLE biodata ADD COLUMN tinggiBadan REAL;");
      await db.execute("ALTER TABLE biodata ADD COLUMN beratBadan REAL;");
      await db.execute("ALTER TABLE biodata ADD COLUMN hasilTes TEXT;");
      await db.execute("ALTER TABLE biodata ADD COLUMN alasan TEXT;");
    }
  }

  /* ======================================================
     USER AUTH
  ====================================================== */
  Future<int> registerUser(String username, String pass, String role) async {
    final db = await database;
    return db.insert('users', {
      'username': username,
      'password': pass,
      'role'    : role,
    });
  }

  Future<Map<String, dynamic>?> login(String u, String p) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [u, p],
    );
    return res.isNotEmpty ? res.first : null;
  }

  /* ======================================================
     BIODATA
  ====================================================== */
  Future<int> insertBiodata(Map<String, dynamic> data) async =>
      (await database).insert('biodata', data);

  Future<List<Map<String, dynamic>>> getAllBiodata() async =>
      (await database).query('biodata');

  Future<int> updateBiodata(int id, Map<String, dynamic> data) async =>
      (await database).update('biodata', data, where: 'id = ?', whereArgs: [id]);

  Future<int> deleteBiodata(int id) async =>
      (await database).delete('biodata', where: 'id = ?', whereArgs: [id]);

  Future<Map<String, dynamic>?> getBiodataByUsername(String username) async {
    final db = await database;
    final res = await db.query(
      'biodata',
      where: 'username = ?',
      whereArgs: [username],
    );
    return res.isNotEmpty ? res.first : null;
  }

  /* ======================================================
     PILIHAN EKSKUL
  ====================================================== */
  Future<int> insertPilihanEkskul({
    required String username,
    required String ekskul,
    required String kategori,
  }) async =>
      (await database).insert('pilihan_ekskul', {
        'username': username,
        'ekskul'  : ekskul,
        'kategori': kategori,
      });

  Future<Map<String, dynamic>?> getPilihanEkskul(String username) async {
    final res = await (await database).query(
      'pilihan_ekskul',
      where: 'username = ?',
      whereArgs: [username],
    );
    return res.isNotEmpty ? res.first : null;
  }

  /* ======================================================
     ABSENSI
  ====================================================== */
  Future<int> insertAbsensi(Map<String, dynamic> data) async =>
      (await database).insert('absensi', data);

  Future<List<Map<String, dynamic>>> getAbsensiByUser(String username) async =>
      (await database).query('absensi', where: 'username = ?', whereArgs: [username]);

  /* ======================================================
     PENILAIAN
  ====================================================== */
  Future<int> insertPenilaian(Map<String, dynamic> data) async =>
      (await database).insert('penilaian', data);

  Future<List<Map<String, dynamic>>> getPenilaianByUser(String username) async =>
      (await database).query('penilaian', where: 'username = ?', whereArgs: [username]);

  /* ======================================================
     DOKUMENTASI
  ====================================================== */
  Future<int> insertDokumentasi(Map<String, dynamic> data) async =>
      (await database).insert('dokumentasi', data);

  Future<List<Map<String, dynamic>>> getDokumentasiByUser(String username) async =>
      (await database).query('dokumentasi', where: 'username = ?', whereArgs: [username]);

  Future<int> deleteDokumentasi(int id) async =>
      (await database).delete('dokumentasi', where: 'id = ?', whereArgs: [id]);
}
