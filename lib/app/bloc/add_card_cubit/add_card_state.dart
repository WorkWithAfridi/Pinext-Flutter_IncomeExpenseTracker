part of 'add_card_cubit.dart';

abstract class AddCardState extends Equatable {
  AddCardState({
    required this.title,
    required this.description,
    required this.balance,
    required this.color,
  });
  String title;
  String description;
  double balance;
  String color;

  @override
  List<Object> get props => [
        title,
        description,
        balance,
        color,
      ];
}

class AddCardDefaultState extends AddCardState {
  AddCardDefaultState({
    required super.title,
    required super.description,
    required super.balance,
    required super.color,
  });
  @override
  List<Object> get props => [
        title,
        description,
        balance,
        color,
      ];
}

class AddCardErrorState extends AddCardState {
  AddCardErrorState({
    required super.title,
    required super.description,
    required super.balance,
    required super.color,
  });
  @override
  List<Object> get props => [
        title,
        description,
        balance,
        color,
      ];
}

class AddCardSuccessState extends AddCardState {
  AddCardSuccessState({
    required super.title,
    required super.description,
    required super.balance,
    required super.color,
  });
}

class EditCardErrorState extends AddCardState {
  EditCardErrorState({
    required super.title,
    required super.description,
    required super.balance,
    required super.color,
  });
  @override
  List<Object> get props => [
        title,
        description,
        balance,
        color,
      ];
}

class EditCardSuccessState extends AddCardState {
  EditCardSuccessState({
    required super.title,
    required super.description,
    required super.balance,
    required super.color,
  });
  @override
  List<Object> get props => [
        title,
        description,
        balance,
        color,
      ];
}
