import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/util/logger.dart';
import '../../domain/model/task.dart';
import '../providers/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TaskItem extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItem({
    required this.task,
    required this.onTap,
    super.key,
  });

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter =
        DateFormat('dd MMMM yyyy', AppLocalizations.of(context).localeName);
    final task = widget.task;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: Dismissible(
        key: ValueKey(task.id),
        background: Container(
          color: Colors.green,
          padding: const EdgeInsets.only(left: 27),
          child: const Row(
            children: [
              Icon(
                Icons.check,
                color: Colors.white,
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          padding: const EdgeInsets.only(right: 27),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            MyLogger.d('Mark done action.id: ${widget.task.id}');
            setState(() {
              ref
                  .read(taskStateProvider.notifier)
                  .markDoneOrNot(widget.task, true);
            });

            await ref
                .read(taskStateProvider.notifier)
                .markDoneOrNot(widget.task, widget.task.done);
            return false;
          } else if (direction == DismissDirection.endToStart) {
            return true;
          }
          return false;
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            MyLogger.d('Delete action.id: ${widget.task.id}');
            ref.read(taskStateProvider.notifier).deleteTask(widget.task);
          }
        },
        child: ListTile(
          leading: Checkbox(
            value: task.done,
            onChanged: (bool? value) {
              ref
                  .read(taskStateProvider.notifier)
                  .markDoneOrNot(widget.task, !widget.task.done);
              MyLogger.d('check ${widget.task.id}');
            },
            side: BorderSide(
              color: (task.importance == 'high')
                  ? Colors.red
                  : Colors.grey.shade500,
              width: 1.5,
            ),
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green;
              }
              return (task.importance == 'high')
                  ? Colors.red.withOpacity(.3)
                  : Colors.white;
            }),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: widget.onTap,
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, left: 0, right: 5),
                    child: Builder(
                      builder: (context) {
                        if (task.importance == 'high') {
                          return const Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Icon(Icons.priority_high, color: Colors.red),
                              Positioned(
                                left: 10,
                                child: Icon(Icons.priority_high,
                                    color: Colors.red,),
                              ),
                              SizedBox(width: 15),
                            ],
                          );
                        } else if (task.importance == 'low') {
                          return const Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              SizedBox(width: 15),
                              Icon(Icons.arrow_downward_sharp),
                              SizedBox(width: 15),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        task.text,
                        style: TextStyle(
                          decoration: task.done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.done
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Text(
            task.deadline == null ? '' : formatter.format(task.deadline!),
            style: TextStyle(
              fontSize: 14,
              height: 20 / 14,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }
}
