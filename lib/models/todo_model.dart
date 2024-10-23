import 'package:uuid/uuid.dart';

import 'package:uuid/uuid.dart';

class Todo {
  String id;
  String title;
  String note;
  int priority;
  DateTime dueDate;
  String category;
  List<String> tags;
  String? attachment;

  Todo({
    String? id,
    required this.title,
    required this.note,
    required this.priority,
    required this.dueDate,
    required this.category,
    required this.tags,
    this.attachment,
  }) : id = id ?? Uuid().v4(); // Unique Id for each ToDos

  // Convert data to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'category': category,
      'tags': tags,
      'attachment': attachment,
    };
  }

  // Converting incoming data into ToDo model
  Todo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        note = map['note'],
        priority = map['priority'],
        dueDate = DateTime.parse(map['dueDate']),
        category = map['category'],
        tags = List<String>.from(map['tags']),
        attachment = map['attachment'];
}


