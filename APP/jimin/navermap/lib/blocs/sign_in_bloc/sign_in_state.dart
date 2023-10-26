part of 'sign_in_bloc.dart';

sealed class SingInState extends Equatable {
  const SingInState();

  @override
  List<Object> get props => [];
}

final class SingInInitial extends SingInState {}
