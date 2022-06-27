import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/repository/repository.dart';

part 'base_events.dart';

part 'base_states.dart';

class BaseBloc extends Bloc<BaseEvents, BaseStates> {
  Repository userRepository = Repository.getInstance();

  BaseBloc() : super(CommonInitialState());

  @override
  Stream<BaseStates> mapEventToState(BaseEvents event) async* {
  }

  void refreshScreen() {
    emit(CommonScreenRefreshState());
  }
}
