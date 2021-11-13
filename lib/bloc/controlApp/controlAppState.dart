abstract class ControlAppState {}

class ControlAppStateInitial extends ControlAppState {
  int index = 0;
}

class ControlAppChangedBottomBar extends ControlAppState {
  final int index;
  ControlAppChangedBottomBar(this.index);
}

class ChangedCategory extends ControlAppState {}

class ChangedViews extends ControlAppState {}

class ChangedNotification extends ControlAppState {}
