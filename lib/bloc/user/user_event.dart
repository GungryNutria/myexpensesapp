part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SaveUser extends UserEvent {
  final User user;

  SaveUser(this.user);
}
