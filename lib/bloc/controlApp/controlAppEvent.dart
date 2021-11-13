abstract class ControlAppEvent {}

class ControlAppChangeBottomBar extends ControlAppEvent {
  final int index;
  ControlAppChangeBottomBar(this.index);
}

class ChangeCategory extends ControlAppEvent {
  final String catID;
  ChangeCategory(this.catID);
}

class InitialValue extends ControlAppEvent {}

class AddNotification extends ControlAppEvent {
  final String title;
  final String body;
  AddNotification({required this.title, required this.body});
}

class ChangeGridToList extends ControlAppEvent {}

class RemoveNotification extends ControlAppEvent {
  final int index;
  RemoveNotification(this.index);
}
