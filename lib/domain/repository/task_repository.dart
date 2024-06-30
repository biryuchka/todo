import '../model/task.dart';

abstract interface class TasksRepository {
  Future<List<Task>> getAll();

  Future<List<Task>> inlineUpdateTask(Task task);

  Future<List<Task>> inlineDeleteTask(Task task);

  Future<List<Task>> addTask(Task task);

  Future<List<Task>> updateTask(Task task);

  Future<List<Task>> deleteTask(Task task);
}
