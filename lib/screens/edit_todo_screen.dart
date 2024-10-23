import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/todo_controller.dart';
import '../../models/todo_model.dart';

class EditTodoScreen extends StatelessWidget {
  final Todo todo;

  EditTodoScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
    TextEditingController(text: todo.title);
    final TextEditingController noteController =
    TextEditingController(text: todo.note);
    int priority = todo.priority;
    final TodoController todoController = Get.find();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
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
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final updatedTodo = Todo(
                    id: todo.id,
                    title: titleController.text,
                    note: noteController.text,
                    priority: priority,
                    dueDate: todo.dueDate,
                    category: todo.category,
                    tags: todo.tags,
                    attachment: todo.attachment,
                  );

                  try {
                    await todoController.updateTodo(todo.id, updatedTodo);
                    print("Todo updated successfully");

                    Get.back();
                  } catch (e) {
                    print("Error updating Todo: $e");
                    Get.snackbar("Error", "Failed to update TODO: Document does not exist.");
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
            ],
          ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
              hintStyle: TextStyle(fontSize: 24),
            ),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: noteController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Notes',
              hintStyle: TextStyle(fontSize: 24),
            ),
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}


