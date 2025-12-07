import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';

class MBTilesProvider {
  Database? _db;

  Future<void> open(String path) async {
    _db = await openDatabase(path, readOnly: true);
  }

  Future<Uint8List?> getTile(int z, int x, int y) async {
    if (_db == null) return null;

    // MBTiles는 Y값이 TMS 포맷이라 뒤집어야 함
    final invertedY = (1 << z) - 1 - y;

    final rows = await _db!.query(
      'tiles',
      columns: ['tile_data'],
      where: 'zoom_level = ? AND tile_column = ? AND tile_row = ?',
      whereArgs: [z, x, invertedY],
      limit: 1,
    );

    if (rows.isNotEmpty) {
      return rows.first['tile_data'] as Uint8List;
    }

    return null;
  }

  Future<void> close() async {
    await _db?.close();
  }
}