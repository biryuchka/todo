import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../util/logger.dart';

class TaskPage extends StatefulWidget {
  const TaskPage(
      {Key? key,
      required this.created,
      required this.task,
      required this.index})
      : super(key: key);

  final bool created;
  final Map<String, dynamic> task;
  final int index;

  // потом индекс будет нужен для удаления

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController controller = TextEditingController();
  String importanceStr = 'Нет';
  bool deadlineSwitch = false;
  String deadlineDate = '';

  @override
  void initState() {
    initializeDateFormatting('ru', null);
    Intl.defaultLocale = "ru";
    if (widget.created) {
      if (widget.task["important"] == -1) {
        importanceStr = 'Низкий';
      } else if (widget.task["important"] == 1) {
        importanceStr = 'Высокий';
      }
      controller.text = widget.task["title"];
      if (widget.task["date"] != null) {
        deadlineSwitch = true;
        selectedDate = DateTime.parse(widget.task["date"]);
        deadlineDate = DateFormat('dd MMM yyyy').format(selectedDate);
      }
    }
    super.initState();
  }

  DateTime selectedDate = DateTime.utc(1900);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        locale: const Locale("ru", "RU"),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2016, 8),
        lastDate: DateTime(2040));
    if (picked != null &&
        (selectedDate.year == 1900 || picked != selectedDate)) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        // shadowColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFF7F6F2),
        foregroundColor: const Color(0xFF000000),
        actions: [
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                MyLogger.d("сохранение");
              },
              child: const Text("Сохранить",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    height: 24,
                    fontSize: 14,
                  )),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Material(
                shadowColor: const Color(0xFF000000),
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  focusNode: FocusNode(
                    descendantsAreFocusable: false,
                    descendantsAreTraversable: false,
                  ),
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    hintText: "Что надо сделать...",
                    // hintStyle: Themes.body,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  minLines: 4,
                  maxLines: 120,
                  // style: Themes.body,
                ),
              ),
              PopupMenuButton(
                offset: const Offset(0, -20),
                constraints: const BoxConstraints(minWidth: 164),
                child: ListTile(
                  title: const Text("Важность"),
                  subtitle: Text(importanceStr),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 0,
                    child: const Text(
                      'Нет',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      importanceStr = 'Нет';
                      setState(() {});
                      MyLogger.d("Изменение приоритета");
                    },
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: const Text(
                      "Низкий",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      importanceStr = "Низкий";
                      setState(() {});
                      MyLogger.d("Изменение приоритета");
                    },
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: () {
                      importanceStr = '!! Высокий';
                      setState(() {});
                      MyLogger.d("Изменение приоритета");
                    },
                    textStyle: const TextStyle(color: Colors.red),
                    child: const Text(
                      '!! Высокий',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Divider(
                height: 0.5,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                title: const Text(
                  "Сделать до",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                trailing: Switch(
                  onChanged: (newValue) {
                    if (newValue) {
                      selectedDate = DateTime.now();
                      _selectDate(context).then((value) {
                        setState(() {
                          deadlineDate =
                              DateFormat('d MMMM yyyy').format(selectedDate);
                        });
                      });
                    } else {
                      deadlineDate = '';
                    }
                    setState(() {
                      deadlineSwitch = newValue;
                    });
                  },
                  value: deadlineSwitch,
                ),
                subtitle: Text(
                  deadlineDate,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Divider(
                thickness: 1,
                height: 0.5,
              ),
              ListTile(
                textColor: widget.created ? Colors.red : Colors.grey,
                onTap: () {
                  MyLogger.d("удаление");
                },
                title: const Text("Удалить",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )),
                leading: Icon(
                  Icons.delete,
                  color: widget.created ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
