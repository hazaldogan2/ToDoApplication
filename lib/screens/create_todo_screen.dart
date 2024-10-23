import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_project/screens/details_todo_screen.dart';
import '../../controllers/todo_controller.dart';
import '../../models/todo_model.dart';

class CreateTodoScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TodoController todoController = Get.find();

  int priority = 1;
  DateTime? dueDate;
  File? attachedFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 18)),
              ),
              const Text(
                'New Reminder',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () async {
                  final todo = Todo(
                    title: titleController.text,
                    note: noteController.text,
                    priority: priority,
                    dueDate: dueDate ?? DateTime.now(),
                    category: categoryController.text,
                    tags: tagsController.text.split(',').map((tag) => tag.trim()).toList(),
                  );
                  if (attachedFile != null) {
                    await todoController.addTodo(todo, attachment: attachedFile);
                  } else {
                    await todoController.addTodo(todo);
                  }
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: "Notes",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: ListTile(
              title: const Text(
                "Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                dueDate != null
                    ? "${DateFormat('dd.MM.yyyy').format(dueDate!)}"
                    : "Today",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.bottomSheet(
                  DetailsTodoScreen(
                    onDetailsSelected: (selectedDueDate, selectedPriority, file) {
                      dueDate = selectedDueDate;
                      priority = selectedPriority;
                      attachedFile = file;
                    },
                  ),
                  isScrollControlled: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





