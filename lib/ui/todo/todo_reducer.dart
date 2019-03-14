import 'package:fish_redux/fish_redux.dart';
import 'package:wanandroid/model/todo.dart';
import 'package:wanandroid/ui/todo/todo_action.dart';
import 'package:wanandroid/ui/todo/todo_state.dart';

Reducer<TodoState> buildReducer() {
  return asReducer(<Object, Reducer<TodoState>>{TodoAction.init: _onInitData});
}

TodoState _onInitData(TodoState state, Action action) {
  List<Todo> todos = action.payload ?? <Todo>[];
  var clone = state.clone();
  clone.todos.addAll(todos);
  return clone;
}