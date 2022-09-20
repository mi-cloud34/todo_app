import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<bool> deletedTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<Task> updatedTask({required Task task});
  Future<List<Task>> getAllTask();
}

class HiveLocator extends LocalStorage {
  late Box<Task> _taskBox;
  HiveLocator() {
    _taskBox = Hive.box<Task>('tasks');
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deletedTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();
    if (_allTask.isNotEmpty) {
      _allTask.sort((Task a, Task b) => a.createdAt.compareTo(b.createdAt));
    }
    return _allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    }
  }

  @override
  Future<Task> updatedTask({required Task task}) async {
    await task.save();
    return task;
  }
}
