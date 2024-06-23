import 'package:flutter/material.dart';
import 'package:todo/util/logger.dart';

import 'add_edit.dart';
import 'appbar.dart';
import 'list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'title':
          'Купить что-то, Купить что-то, Купить что-тоКупить что-тоКупить что-тоКупить что-тоКупить что-тоКупить что-тоКупить что-тоКупить что-тоКупить что-тоКупить что-тоКупить что-то',
      'completed': false,
      'important': 1,
      'date': '2024-06-21'
    },
    {
      'title': 'Купить что-то еще',
      'completed': false,
      'important': 1,
      'date': null
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': -1,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': 0,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то еще',
      'completed': false,
      'important': 0,
      'date': null
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': 0,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': 1,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': 1,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то еще',
      'completed': false,
      'important': -1,
      'date': null
    },
    {
      'title': 'Купить что-то еще',
      'completed': false,
      'important': -1,
      'date': null
    },
    {
      'title': 'Купить что-то еще',
      'completed': false,
      'important': 0,
      'date': null
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': 0,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': 1,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': false,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': false,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': false,
      'date': '2024-06-20'
    },
    {
      'title': 'Купить что-то для дома',
      'completed': true,
      'important': false,
      'date': '2024-06-20'
    },
  ];

  bool _showCompleted = true;

  void callbackSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              completedCount: _tasks.where((task) => task['completed']).length,
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index >= _tasks.length) {
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
                                const TaskPage(created: false, task: {}, index: -1),
                          ),
                        );
                      },
                      title: const Text(
                        "Новая задача...",
                        style: TextStyle(
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

                final task = _tasks[index];
                if (!_showCompleted && task['completed']) {
                  return Container();
                }
                return TaskItem(
                  task: task,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        _tasks.removeAt(index);
                        MyLogger.d("Удаление");
                      });
                    } else {
                      setState(() {
                        task['completed'] = true;
                        MyLogger.d("выполнение таски");
                      });
                    }
                  },
                  onTap: () {
                    MyLogger.d("Переход на страницу");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskPage(
                          created: true,
                          task: _tasks[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                  onCheckboxChanged: (bool? value) {
                    setState(() {
                      MyLogger.d("выполнение таски");
                      task['completed'] = value!;
                    });
                  },
                );
              },
              childCount: _tasks.length + 1,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const TaskPage(created: false, task: {}, index: -1),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
