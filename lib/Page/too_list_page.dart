import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import 'package:lista_de_tarefas/repositories/todo_repositorie.dart';

import '../Widgtes/too_list_item.dart';

class TooListPage extends StatefulWidget {
  const TooListPage({super.key});

  @override
  State<TooListPage> createState() => _TooListPageState();
}

class _TooListPageState extends State<TooListPage> {
  //Creating a controller to control and instantiating TextEditingController
  final TextEditingController todoController = TextEditingController();

  final TodoRepository todoRepository = TodoRepository();

  // Creating a list that starts empty;
  List<Todo> todos = [];

  Todo? deleteTodo;
  int? deleteTodoPost;

  String? errorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: "Lista de Tarefas",
                            errorText: errorText,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff00d7f3),
                                width: 2,
                              )
                            ),
                            labelStyle: const TextStyle(fontSize: 18),
                            hintText: "Adicione uma Tarefa"),
                        ),
                     ),
                   ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // String of type text that is receiving todoController and storing its value inside text.
                      String text = todoController.text;

                      if (text.isEmpty) {
                        setState(() {
                          errorText = "Opss. Título não pode ser vazio!";
                        });
                        return;
                      }

                      setState(() {
                        // setState to update the entire main screen when the user's message is captured and sent
                        Todo newTodo = Todo(
                          title: text,
                          dateTime: DateTime.now(),
                        );
                        todos.add(
                            newTodo); //Adding a new item and saving it inside the text variable
                        errorText = null;
                      });
                      // Clearing all fields, text when it is sent.
                      todoController.clear();
                      todoRepository.saveTodoList(todos);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        backgroundColor: const Color(0xff00d7f3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    child: const Icon(
                      // Add icon, with size 30.
                      size: 30,
                      Icons.add,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // For each of the tasks that are inside the task list, it creates an item for TooListItem
                    for (Todo todo in todos)
                      TooListItem(
                        todo: todo,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child:
                        Text("Você possui ${todos.length} tarefas pendentes"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: showDeleteTodosConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        backgroundColor: const Color(0xff00d7f3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    child: const Text(
                      "Limpar Tudo",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deleteTodo = todo;
    deleteTodoPost = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa ${todo.title} foi removida com sucesso!",
          style: const TextStyle(
            color: Color(0xff00d7f3),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: "Desfazer",
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              todos.insert(
                deleteTodoPost!,
                deleteTodo!,
              );
              todoRepository.saveTodoList(todos);
            });
          },
        ),
        duration: const Duration(
          seconds: 5,
        ),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar Tudo?"),
        content: const Text(
          "Tem certeza que deseja apagar todas a tarefas? 🤔",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xff00d7f3),
            ),
            child: const Text(
              "Cancelar",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(
              "Limpar Tudo",
            ),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
