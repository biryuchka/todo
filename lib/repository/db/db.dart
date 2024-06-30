import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/util/logger.dart';
import '../../domain/model/task.dart';

class DbRepository {
  static const tableTasks = 'task';
  static const tableRevisions = 'revision';

  DbRepository();

  Future<Database> init() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'database.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE IF NOT EXISTS $tableTasks '
            '(id TEXT PRIMARY KEY, done BOOLEAN NOT NULL CHECK (done IN (0, 1)), '
            'text TEXT, importance TEXT, deadline INTEGER, createdAt INTEGER, '
            'updatedAt INTEGER, lastUpdatedBy TEXT, color TEXT)');
        await db.execute('CREATE TABLE IF NOT EXISTS $tableRevisions'
            '(id INTEGER PRIMARY KEY, revision INTEGER)');
        await db
            .execute('INSERT INTO $tableRevisions(id, revision) VALUES (1, 0)');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final Database db = await init();
    var list = await db.query(tableTasks);
    List<Task> parseDb(List<Map<String, Object?>> list) =>
        list.map((el) => Task.fromDb(el)).toList();
    return compute(parseDb, list);
  }

  Future<void> addList(List<Task> tasks) async {
    final Database db = await init();
    await db.transaction((txn) async {
      for (var task in tasks) {
        await txn.insert(tableTasks, task.toDb(),
            conflictAlgorithm: ConflictAlgorithm.ignore,);
      }
    });
  }

  Future<int> addTask(Task task) async {
    final Database db = await init();
    MyLogger.d('saving ${task.toString()}');
    return await db.insert(tableTasks, task.toDb());
  }

  Future<int> updateTask(Task task) async {
    final Database db = await init();
    return await db
        .update(tableTasks, task.toDb(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(Task task) async {
    final Database db = await init();
    return await db.delete(tableTasks, where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> getRevision() async {
    final Database db = await init();
    var list = await db.query(tableRevisions);
    return list.first['revision'] as int;
  }

  Future<void> updateRevision(int revision) async {
    final Database db = await init();
    await db.update(tableRevisions, {'revision': revision}, where: 'id = 1');
  }
}
