import 'package:hive/hive.dart';

class ToDoDataBase {

  List toDoList = [];
  //reference box
  final _box = Hive.box('box');

  //initialize for first time
  void createInitialData() {
    toDoList = [
      ["Tutorial", false],
      ["Exercise", false],
    ];
  }

  //load stored data
  void loadData() {
    toDoList = _box.get("TODOLIST");
  }

  //update db
  void updateData() {
    _box.put("TODOLIST", toDoList);
  }
}