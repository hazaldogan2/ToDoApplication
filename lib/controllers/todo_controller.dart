import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/todo_model.dart';
import '../todo_service.dart';
import 'dart:io';
import 'dart:core';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  var isLoading = false.obs;
  final TodoService todoService = TodoService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get _userId => _auth.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      isLoading(true);
      List<Todo> fetchedTodos = await todoService.getTodos();
      fetchedTodos.sort((a, b) => a.priority.compareTo(b.priority));
      todos.assignAll(fetchedTodos);
    } catch (e) {
      Get.snackbar("Error", "Failed to load TODOs: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTodo(Todo todo, {File? attachment}) async {
    try {
      await todoService.addTodo(todo, attachment: attachment);
      todos.add(todo);
      todos.sort((a, b) => a.priority.compareTo(b.priority));
    } catch (e) {
      Get.snackbar("Error", "Failed to add TODO: $e");
    }
  }

  Future<void> updateTodo(String id, Todo updatedTodo, {File? attachment}) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('todos')
          .doc(id)
          .get();

      if (!doc.exists) {
        print("Document does not exist with ID: $id");
        throw Exception('document does not exist');
      }

      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      String? existingAttachmentUrl = (data != null && data.containsKey('attachment'))
          ? data['attachment'] as String?
          : null;

      if (attachment == null && existingAttachmentUrl != null) {
        updatedTodo.attachment = existingAttachmentUrl;
      }

      await todoService.updateTodo(id, updatedTodo, attachment: attachment);

      int index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index] = updatedTodo;
        todos.sort((a, b) => a.priority.compareTo(b.priority));
      }
    } catch (e) {
      print("$e");
      throw e;
    }
  }


  Future<void> deleteTodo(String id) async {
    try {
      await todoService.deleteTodo(id);
      todos.removeWhere((todo) => todo.id == id);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete TODO: $e");
    }
  }

  // Group and sort by days
  Map<String, List<Todo>> groupTodosByDate([List<Todo>? filteredTodos]) {
    Map<String, List<Todo>> groupedTodos = {};

    final sourceTodos = filteredTodos ?? todos;

    for (var todo in sourceTodos) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(todo.dueDate);

      if (!groupedTodos.containsKey(formattedDate)) {
        groupedTodos[formattedDate] = [];
      }
      groupedTodos[formattedDate]!.add(todo);
    }

    groupedTodos.forEach((key, value) {
      value.sort((a, b) => a.priority.compareTo(b.priority));
    });

    var sortedKeys = groupedTodos.keys.toList()
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a);
        DateTime dateB = DateTime.parse(b);
        return dateA.compareTo(dateB); // Sort from old to new
      });

    Map<String, List<Todo>> sortedGroupedTodos = {
      for (var key in sortedKeys) key: groupedTodos[key]!,
    };

    return sortedGroupedTodos;
  }

  // Search TODOs by title
  List<Todo> searchTodos(String query) {
    if (query.isEmpty) {
      return todos;
    }
    return todos.where((todo) => todo.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  Future<File?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        String? filePath = result.files.single.path;
        if (filePath != null) {
          return File(filePath);
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error picking file: $e");
      return null;
    }
    return null;
  }
}






