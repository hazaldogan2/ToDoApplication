import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/todo_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _userId => _auth.currentUser!.uid;

  Future<String?> _uploadFile(File file) async {
    try {
      String fileName = basename(file.path);
      Reference ref = _storage.ref().child('uploads/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('File added successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> addTodo(Todo todo, {File? attachment}) async {
    try {
      if (attachment != null) {
        String? downloadUrl = await _uploadFile(attachment);
        if (downloadUrl != null) {
          todo.attachment = downloadUrl;
        } else {
          print('File could not be loaded.');
        }
      }
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('todos')
          .doc(todo.id)
          .set(todo.toMap());
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateTodo(String id, Todo todo, {File? attachment}) async {
    try {
      if (attachment != null) {
        String? downloadUrl = await _uploadFile(attachment);
        if (downloadUrl != null) {
          todo.attachment = downloadUrl;
          print('$downloadUrl');
        } else {
          print('Update Error');
        }
      }
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('todos')
          .doc(id)
          .update(todo.toMap());
    } catch (e) {
      print('Update Error: $e');
    }
  }

  Future<List<Todo>> getTodos() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('todos')
        .get();

    return snapshot.docs
        .map((doc) => Todo.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteTodo(String id) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('todos')
        .doc(id)
        .delete();
  }
}


