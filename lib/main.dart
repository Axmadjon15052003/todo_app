
import 'package:flutter/material.dart';
import 'package:todo_app/repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter To Do ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 131, 227, 71)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter To Do Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Repository repository;

  @override
  void initState() {
    repository = Repository();
    super.initState();
  }


    void deleteToDo(int id) {
    repository.deleteToDo(id);
  }


   void updateToDo(int id, String newTitle, String newDescription) {
    repository.updateToDo(id, newTitle, newDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          _showAddToDoBottomSheet();
        },
        backgroundColor: Colors.amber,
        shape: CircleBorder(eccentricity: 1, side: BorderSide(color: Colors.blue, width: 4)),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<ToDoModel>>(
        stream: repository.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text('No'),
            );
          } else {
            final todos = snapshot.data!;
            return ListView.separated(
              itemBuilder: (_, index) => ListTile(
                title: Text(todos[index].title),
                subtitle: Text(todos[index].description),


                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditToDoBottomSheet(todos[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        repository.deleteToDo(todos[index].id);
                      },
                    ),
                  ],
                ),
              ),
              separatorBuilder: (_, __) => SizedBox(height: 6),
              itemCount: todos.length,
            );
          }
        },
      ),
    );
  }

  void _showAddToDoBottomSheet() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    repository.createToDO(titleController.text, descriptionController.text);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add todo'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditToDoBottomSheet(ToDoModel todo) {
    TextEditingController titleController = TextEditingController(text: todo.title);
    TextEditingController descriptionController = TextEditingController(text: todo.description);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    updateToDo(todo.id, titleController.text, descriptionController.text);
                    Navigator.pop(context);
                  }
                },
                child: Text(' ToDo'),
              ),
            ],
          ),
        );
      },
    );
  }
}
