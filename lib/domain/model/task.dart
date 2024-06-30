import 'package:uuid/v4.dart';
import '../../util/device_id.dart';
import 'dart:convert';

class Task {
  final String id;
  final bool done;
  final String text;
  final String importance;
  final DateTime? deadline;
  final String? color;
  final DateTime createdAt;
  final DateTime changedAt;
  final String? lastUpdatedBy;

  Task({
    required this.id,
    required this.done,
    required this.text,
    required this.importance,
    required this.deadline,
    required this.color,
    required this.createdAt,
    required this.lastUpdatedBy,
    required this.changedAt,
  });


  factory Task.fromDb(Map<String, Object?> object) => Task(
        id: object['id'] as String,
        done: object['done'] as int == 1,
        text: object['text'] as String,
        importance: object['importance'] as String,
        deadline: object['deadline'] != null
            ? DateTime.fromMillisecondsSinceEpoch(object['deadline'] as int)
            : null,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(object['createdAt'] as int),
        changedAt:
            DateTime.fromMillisecondsSinceEpoch(object['updatedAt'] as int),
        lastUpdatedBy: object['lastUpdatedBy'] as String,
        color: object['color'] != null
            ? object['color'] as String
            : null,
      );

  Map<String, dynamic> toDb() => {
        'id': id,
        'done': done ? 1 : 0,
        'text': text,
        'importance': importance,
        'deadline': deadline?.millisecondsSinceEpoch,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': changedAt.millisecondsSinceEpoch,
        'lastUpdatedBy': lastUpdatedBy,
        'color': color,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'done': done,
        'text': text,
        'importance': importance,
        'deadline': deadline?.millisecondsSinceEpoch,
        'created_at': createdAt.millisecondsSinceEpoch,
        'changed_at': changedAt.millisecondsSinceEpoch,
        'last_updated_by': lastUpdatedBy,
        'color': color,
      };


  String toJson() => jsonEncode({
        'element': toMap(),
  });

  factory Task.fromJson(Map<String, dynamic> object) => Task(
        id: object['id'] as String,
        done: object['done'] as int == 1,
        text: object['text'] as String,
        importance: object['importance'] as String,
        deadline: object['deadline'] != null
            ? DateTime.fromMillisecondsSinceEpoch(object['deadline'] as int)
            : null,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(object['createdAt'] as int),
        changedAt:
            DateTime.fromMillisecondsSinceEpoch(object['updatedAt'] as int),
        lastUpdatedBy: object['lastUpdatedBy'] as String,
        color: object['color'] != null
            ? object['color'] as String
            : null,
      );

  Task copyWith({
    bool? done,
    String? text,
    String? importance,
    DateTime? deadline,
    bool nullDeadline = false,
    bool nullColor = false,
    String? id,
    String? color,
    DateTime? createdAt,
    DateTime? changedAt,
    String? lastUpdatedBy,
  }) {
    return Task(
      done: done ?? this.done,
      text: text ?? this.text,
      importance: importance ?? this.importance,
      deadline: nullDeadline ? null : deadline ?? this.deadline,
      id: id ?? this.id,
      color: nullColor ? null : color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      changedAt: changedAt ?? this.changedAt,
    );
  }
}

Task emptyTask() {
    return Task(id: const UuidV4().generate(),
        createdAt : DateTime.now(),
        changedAt : DateTime.now(),
        lastUpdatedBy : '',
        done : false,
        text : '',
        importance : 'basic',
        deadline : null,
        color : '',
        );
  }