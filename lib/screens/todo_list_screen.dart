import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/todo_controller.dart';
import 'create_todo_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'edit_todo_screen.dart';

class TodoListScreen extends StatelessWidget {
  final TodoController todoController = Get.put(TodoController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    todoController.fetchTodos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Plantist',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (todoController.todos.isEmpty) {
          return const Center(child: Text("No planned ToDo list"));
        }
        var filteredTodos = todoController.todos.where((todo) {
          return todo.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        }).toList();
        // Group and sort by date
        var groupedTodos = todoController.groupTodosByDate(filteredTodos).entries.toList()
          ..sort((a, b) {
            DateTime dateA = DateTime.parse(a.key);
            DateTime dateB = DateTime.parse(b.key);
            return dateA.compareTo(dateB);
          });

        return ListView.builder(
          itemCount: groupedTodos.length,
          itemBuilder: (context, index) {
            final date = groupedTodos[index].key;
            var todos = groupedTodos[index].value;

            todos.sort((a, b) => b.priority.compareTo(a.priority));

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      date == DateTime.now().toString().split(' ')[0]
                          ? 'Today'
                          : DateFormat('dd.MM.yyyy').format(DateTime.parse(date)),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...todos.asMap().entries.map((entry) {
                    final todo = entry.value;

                    return Column(
                      children: [
                        Slidable(
                          key: Key(todo.id),
                          direction: Axis.horizontal,
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Get.bottomSheet(
                                    EditTodoScreen(todo: todo),
                                    isScrollControlled: true,
                                  );
                                },
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  todoController.deleteTodo(todo.id);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: _getPriorityColor(todo.priority).withOpacity(0.5),
                                ),
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: _getPriorityColor(todo.priority),
                                ),
                              ],
                            ),
                            title: Text(todo.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(todo.note ?? ''),
                                const SizedBox(height: 4),
                                if (todo.attachment != null && todo.attachment!.isNotEmpty) ...[
                                  const Row(
                                    children: [
                                      Icon(Icons.attachment, size: 16),
                                      SizedBox(width: 4),
                                      Text('1 Attachment'),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment : MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('dd.MM.yyyy').format(todo.dueDate),
                                  style: TextStyle(color: Colors.black54, fontSize: 15),

                                ),
                                if (todo.dueDate.hour != 0 || todo.dueDate.minute != 0)
                                  Text(
                                    DateFormat('HH:mm').format(todo.dueDate),
                                    style: TextStyle(color: Colors.red, fontSize: 15),
                                  )
                                else
                                  SizedBox.shrink(),
                              ],
                            ),
                            onTap: () {
                              Get.bottomSheet(
                                EditTodoScreen(todo: todo),
                                isScrollControlled: true,
                              );
                              },
                          ),
                        ),
                        if (index != todos.length - 1) Divider(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: SizedBox(
        width: 380,
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.bottomSheet(
              CreateTodoScreen(),
              isScrollControlled: true,
            );
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: const Text(
            "New Reminder",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  // Search according to the Title
  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Search by Title"),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: "Enter title", focusColor: Colors.black),
            onChanged: (query) {
              searchQuery.value = query;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                searchController.clear();
                searchQuery.value = '';
                Get.back();
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Search', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Determine color according to priority level
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}











