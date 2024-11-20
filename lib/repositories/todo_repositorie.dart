import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

const TodoListKey = 'todo_list';

class TodoRepository {

  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(TodoListKey) ?? '[]';
    final List jsonDecode = json.decode(jsonString) as List;
    return jsonDecode.map((e) => Todo.fromJson(e)).toList();
  }

  // saveTodoList estará recebendo uma lista de "todo"
  void saveTodoList(List<Todo> todos) {

    // Aqui irá transformar a lista de tarefas em um txt.
    final jsonString = json.encode(todos);
    sharedPreferences.setString(TodoListKey, jsonString);
  }

}