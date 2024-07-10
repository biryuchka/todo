// ignore_for_file: prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/task.dart';
import '../../util/logger.dart';
import '../providers/provider.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({
    required this.task,
    super.key,
  });

  final Task task;

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  TextEditingController controller = TextEditingController();
  String importanceStr = '';
  bool deadlineSwitch = false;
  String deadlineDate = '';
  DateTime? deadline;

  late Task task;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    if (widget.task.id != '') {
      importanceStr = widget.task.importance;
      controller.text = widget.task.text;
      if (widget.task.deadline != null) {
        deadlineSwitch = true;
        deadlineDate = DateFormat('dd mm yyyy').format(widget.task.deadline!);
      }
    }
    task = widget.task;
  }

  DateTime selectedDate = DateTime.utc(1900);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2016, 8),
      lastDate: DateTime(2040),
    );
    if (picked != null &&
        (selectedDate.year == 1900 || picked != selectedDate)) {
      setState(() {
        selectedDate = picked;
        deadline = picked;
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
        backgroundColor: const Color.fromARGB(255, 244, 237, 206),
        foregroundColor: const Color(0xFF000000),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                var tmpImportance =
                    importanceStr == AppLocalizations.of(context).importance_low
                        ? 'low'
                        : (importanceStr ==
                                AppLocalizations.of(context).importance_basic
                            ? 'basic'
                            : 'high');

                ref.read(taskStateProvider.notifier).addOrEditTask(
                      task.copyWith(
                        text: controller.text,
                        deadline: deadline,
                        importance: tmpImportance,
                      ),
                    );
                MyLogger.d('Сохранить');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
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
                    hintText: '${AppLocalizations.of(context).hint}...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  minLines: 4,
                  maxLines: 120,
                ),
              ),
              PopupMenuButton(
                offset: const Offset(0, -20),
                constraints: const BoxConstraints(minWidth: 164),
                child: ListTile(
                  title: Text(AppLocalizations.of(context).importance),
                  subtitle: Text(importanceStr),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 0,
                    child: Text(
                      AppLocalizations.of(context).importance_basic,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      importanceStr =
                          AppLocalizations.of(context).importance_basic;
                      setState(() {});
                      MyLogger.d('Изменение приоритета');
                    },
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      AppLocalizations.of(context).importance_low,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      importanceStr =
                          AppLocalizations.of(context).importance_low;
                      setState(() {});
                      MyLogger.d('Изменение приоритета');
                    },
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: () {
                      importanceStr =
                          AppLocalizations.of(context).importance_high;
                      setState(() {});
                      MyLogger.d('Изменение приоритета');
                    },
                    textStyle: const TextStyle(color: Colors.red),
                    child: Text(
                      AppLocalizations.of(context).importance_high,
                      style: const TextStyle(
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
                title: Text(
                  AppLocalizations.of(context).do_until,
                  style: const TextStyle(
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
                textColor: widget.task.done ? Colors.red : Colors.grey,
                onTap: () {
                  MyLogger.d('удаление');
                },
                title: Text(AppLocalizations.of(context).delete,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),),
                leading: Icon(
                  Icons.delete,
                  color: widget.task.done ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
