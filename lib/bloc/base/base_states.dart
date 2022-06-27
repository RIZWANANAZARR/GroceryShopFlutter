part of 'base_bloc.dart';

abstract class BaseStates {
  const BaseStates();
}

class CommonScreenRefreshState extends BaseStates {}

class ApiCallFailureState extends BaseStates {
  final Exception exception;

  ApiCallFailureState(this.exception);
}

class ShowProgressIndicatorState extends BaseStates {
  final bool showProgress;

  ShowProgressIndicatorState(this.showProgress);
}

class CommonInitialState extends BaseStates {}

///add your states here as below
// class YourApiCallResponseState extends BaseStates {
//   final YourApiCallResponse yourApiCallResponse;
//
//   YourApiCallResponseState(this.yourApiCallResponse);
// }
