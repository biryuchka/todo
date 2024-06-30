import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/model/task.dart';
import 'package:todo/ui/providers/provider.dart';
import 'package:todo/util/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_edit.dart';
import '../widgets/appbar.dart';
import '../widgets/list_item.dart';
import '../../domain/model/task.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  bool _showCompleted = true;

  void callbackSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = ref.watch(taskStateProvider).valueOrNull ?? [];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MySliverAppBar(
              onEyePressed: () {
                setState(() {
                  _showCompleted = !_showCompleted;
                });
              },
              completedCount: tasks.where((task) => task.done).length,
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index >= tasks.length) {
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 36,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        )
                      ],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TaskPage(task: emptyTask()),
                          ),
                        );
                      },
                      title: Text(
                        '${AppLocalizations.of(context).new_todo}...',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 20 / 16,
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                      ),
                      leading: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                final task = tasks[index];
                if (!_showCompleted && task.done) {
                  return const SizedBox(height: 0,width: 0,);
                }
                return TaskItem(
                  task: task,
                  onTap: () {
                    MyLogger.d('Переход на страницу');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskPage(
                          task: tasks[index],
                        ),
                      ),
                    );
                  },
                  onCheckboxChanged: (bool? value) {
                    setState(() {
                      MyLogger.d('выполнение таски');
                      // change task
                      // task.done = value!;
                    });
                  },
                );
              },
              childCount: tasks.length + 1,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyLogger.d('Переход на страницу');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TaskPage(task: emptyTask()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
