import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/Page/too_list_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TooListPage(),
    );
  }
}