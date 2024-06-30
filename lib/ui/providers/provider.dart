import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers.dart';
import '../../domain/model/task.dart';

part 'provider.g.dart';


@riverpod
class TaskState extends _$TaskState {
  @override
  Future<List<Task>> build() async {
    List<Task> list = await ref.read(taskRepositoryProvider).getAll();
    return list;
  }

  Future<void> addOrEditTask(Task task) async {
    List<Task> list;
    if (task.id == '') {
      list = await ref.read(taskRepositoryProvider).addTask(task);
    } else {
      list = await ref.read(taskRepositoryProvider).updateTask(task);
    }
    state = AsyncValue.data(list);
  }

  Future<void> deleteTask(Task task) async {
    if (task.id != '') {
      List<Task> list =
          await ref.read(taskRepositoryProvider).inlineDeleteTask(task);
      state = AsyncValue.data(list);
    }
  }

  Future<void> getAlltasks() async {
    List<Task> list = await ref.read(taskRepositoryProvider).getAll();
    state = AsyncValue.data(list);
  }

  Future<void> markDoneOrNot(Task task, bool done) async {
    addOrEditTask(task.copyWith(done: done));
  }

}