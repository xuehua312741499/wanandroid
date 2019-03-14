import 'package:fish_redux/fish_redux.dart';
import 'package:wanandroid/model/todo.dart';

enum TodoAction { init, onRefresh, refresh, onLoadMore, loadMore }

class TodoActionCreator {
  static Action onInitAction(List<Todo> todos) {
    return Action(TodoAction.init, payload: todos);
  }

  static Action onRefreshAction() {
    return Action(TodoAction.onRefresh);
  }
  static Action refreshAction(List<Todo> todos) {
    return Action(TodoAction.refresh,payload: todos);
  }

  static Action onLoadMoreAction() {
    return Action(TodoAction.onLoadMore);
  }

  static Action loadMoreAction(List<Todo> todos) {
    return Action(TodoAction.loadMore,payload: todos);
  }
}
