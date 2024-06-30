import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/repository/db/db.dart';
import 'package:todo/repository/db/service.dart';
import 'package:dio/dio.dart';
import '../domain/repository/task_repository.dart';
import '../domain/repository/task_repository_impl.dart';

final taskRepositoryProvider = Provider<TasksRepository>(
(ref) => TaskRepositoryImpl(db: DbRepository(), service: Service(dio: Dio(
    BaseOptions(
      followRedirects: true,
      validateStatus: (status) {
        return status != null && status < 400;
      },
    ),
  ),),),
) ;

