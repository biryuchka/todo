import 'package:flutter/material.dart';


class TaskItem extends StatefulWidget {
  final Map<String, dynamic> task;
  final DismissDirectionCallback onDismissed;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;

  const TaskItem({
    required this.task,
    required this.onDismissed,
    required this.onTap,
    required this.onCheckboxChanged,
    super.key,
  });

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
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
        key: Key(task['title']),
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
          widget.onDismissed(direction);
          return direction == DismissDirection.endToStart;
        },
        child: ListTile(
          leading: Checkbox(
            value: task['completed'],
            onChanged: widget.onCheckboxChanged,
            side: BorderSide(
              color:
              (task["important"] == 1) ? Colors.red : Colors.grey.shade500,
              width: 1.5,
            ),
            fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.green;
                  }
                  return (task["important"] == 1)
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
                    padding: const EdgeInsets.only(top: 10, left: 0, right: 5),
                    child: Builder(
                      builder: (context) {
                        if (task["important"] == 1) {
                          return const Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Icon(Icons.priority_high, color: Colors.red),
                              Positioned(
                                left: 10,
                                child: Icon(Icons.priority_high,
                                    color: Colors.red),
                              ),
                              SizedBox(width: 15),
                            ],
                          );
                        } else if (task["important"] == -1) {
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
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        task['title'],
                        style: TextStyle(
                          decoration: task['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task['completed']
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
            task['date'] ?? "",
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
