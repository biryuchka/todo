import 'package:todo/util/device_id.dart';
import 'package:todo/util/logger.dart';

import '../../repository/db/db.dart';
import '../../repository/db/service.dart';

import 'task_repository.dart';
import '../model/task.dart';

class TaskRepositoryImpl implements TasksRepository {
  final DbRepository db;
  final Service service;
  bool dbCreated = true;

  TaskRepositoryImpl({required this.db, required this.service});

  @override
  Future<List<Task>> getAll() async {
    MyLogger.d('yes&');
    if (await service.hasConnection()) {
      var response = await service.getTasks(await db.getRevision());
      await db.addList(response.tasks);
      await db.updateRevision(response.revision);
    }
    return db.getTasks();
  }

  @override
  Future<List<Task>> inlineUpdateTask(Task task) async {
    if (await service.hasConnection()) {
      var response = await service.updateTask(task, await db.getRevision());
      if (response != null) {
        await db.updateTask(response.task);
        await db.updateRevision(response.revision);
      }
    } else {
      await db.updateTask(task);
    }
    return db.getTasks();
  }

  @override
  Future<List<Task>> inlineDeleteTask(Task task) async {
    if (await service.hasConnection()) {
      var response = await service.deleteTask(task, await db.getRevision());
      if (response != null) {
        await db.deleteTask(response.task);
        await db.updateRevision(response.revision);
      }
    } else {
      await db.deleteTask(task);
    }
    return db.getTasks();
  }

  @override
  Future<List<Task>> addTask(Task task) async {
    if (await service.hasConnection()) {
      var response = await service.createTask(
          task.copyWith(lastUpdatedBy: await getId()), await db.getRevision(),);
      if (response != null) {
        await db.updateRevision(response.revision);
      }
    }
    MyLogger.d('yes&');
    await db.addTask(task);
    return db.getTasks();
  }

  @override
  Future<List<Task>> updateTask(Task task) async {
    if (await service.hasConnection()) {
      var response = await service.updateTask(task, await db.getRevision());
      if (response != null) {
        await db.updateRevision(response.revision);
      }
    }
    await db.updateTask(task);
    return db.getTasks();
  }

  @override
  Future<List<Task>> deleteTask(Task task) async {
    if (await service.hasConnection()) {
      var response = await service.deleteTask(task, await db.getRevision());
      if (response != null) {
        await db.updateRevision(response.revision);
      }
    }
    await db.deleteTask(task);
    return db.getTasks();
  }
}
