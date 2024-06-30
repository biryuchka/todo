import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../../domain/model/task.dart';

typedef TaskListResponse = ({List<Task> tasks, int revision});
typedef TaskResponse = ({Task task, int revision});
const String token = 'Dagnir';

class Service {
  final Dio dio;
  int revision = 0;
  
  static const String baseUrl = 'https://beta.mrdekk.ru/task';
  static const String listUrl = 'https://beta.mrdekk.ru/task/list';
  String idUrl(String id) => 'https://beta.mrdekk.ru/task/list$id';

  static Task parsetask(Map<String, dynamic> map) => Task.fromJson(map);
  static List<Task> parsetaskList(List<dynamic> list) =>
      list.map((el) => Task.fromJson(el)).toList();
  static List<Task> parseDbtaskList(List<Map<String, Object?>> list) =>
      list.map((el) => Task.fromDb(el)).toList();
  static String taskListToJson(List<Task> tasks) => jsonEncode({
        'list': tasks.map((task) => task.toMap()).toList(),
      });

  Service({required this.dio}) {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers['Authorization'] = 'Bearer $token';
      options.headers['X-Last-Known-Revision'] = revision.toString();
      return handler.next(options);
    },),);

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<bool> hasConnection() async {
    try {
      var response = await dio.get(baseUrl);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<TaskListResponse> getTasks(int revision) async {
    var response = await dio.get(listUrl);
    if (response.statusCode == 200) {
      var array = response.data['list'] as List<dynamic>;
      return (
        tasks: await compute(parsetaskList, array),
        revision: response.data['revision'] as int
      );
    }
    return (tasks: <Task>[], revision: revision);
  }

  Future<TaskListResponse> updateTaskList(
      List<Task> tasks, int revision,) async {
    var response = await dio.patch(listUrl,
        data: taskListToJson(tasks),);
    if (response.statusCode == 200) {
      var array = response.data['list'] as List<dynamic>;
      return (
        tasks: await compute(parsetaskList, array),
        revision: response.data['revision'] as int
      );
    }
    return (tasks: <Task>[], revision: revision);
  }

  Future<TaskResponse?> getTask(String id) async {
    var response = await dio.get(idUrl(id));
    if (response.statusCode == 200) {
      var map = response.data['element'] as Map<String, dynamic>;
      return (
        task: await compute(parsetask, map),
        revision: response.data['revision'] as int
      );
    }
    return null;
  }

  Future<TaskResponse?> createTask(Task task, int revision) async {
    var response = await dio.post(listUrl,
        data: task.toJson(),);
    if (response.statusCode == 200) {
      var map = response.data['element'] as Map<String, dynamic>;
      return (
        task: await compute(parsetask, map),
        revision: response.data['revision'] as int
      );
    }
    return null;
  }

  Future<TaskResponse?> updateTask(Task task, int revision) async {
    var response = await dio.put(idUrl(task.id),
        data: task.toJson(),);
    if (response.statusCode == 200) {
      var map = response.data['element'] as Map<String, dynamic>;
      return (
        task: await compute(parsetask, map),
        revision: response.data['revision'] as int
      );
    }
    return null;
  }

  Future<TaskResponse?> deleteTask(Task task, int revision) async {
    var response =
        await dio.delete(idUrl(task.id));
    if (response.statusCode == 200) {
      var map = response.data['element'] as Map<String, dynamic>;
      return (
        task: await compute(parsetask, map),
        revision: response.data['revision'] as int
      );
    }
    return null;
  }
}