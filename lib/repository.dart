import 'dart:async';

class Repository {
// controller yaratdik generator hisoblanadi
  final StreamController<List<ToDoModel>> _controller =
      StreamController<List<ToDoModel>>();

  final List<ToDoModel> _todos = [];

  Stream<List<ToDoModel>> get stream async* {
    yield* _controller.stream;
  }



Future<void> createToDO(String title, String description) async {
  final newToDo = ToDoModel(
    id: _todos.lastOrNull == null ? 0 : _todos.last.id + 1,
    title: title,
    description: description,
  );
  _todos.add(newToDo);
  _controller.add(_todos);
}

  void updateToDo(int id, String text, String text2) {
    // _todos[index].id  = id;

  }

  void deleteToDo(int id) async{
_todos.remove(id);

  }
}








class ToDoModel {
  final int id;
  final String title;
  final String description;

  ToDoModel({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  bool operator ==(covariant ToDoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;
}
