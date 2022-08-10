part of 'first_screen_bloc.dart';

abstract class FirstScreenStates extends BaseStates {
  const FirstScreenStates();
}

///all states of AuthenticationStates

class FirstScreenInitialState extends FirstScreenStates {}

class LoginUserDetialsCallEventResponseState extends FirstScreenStates {
  LoginUserDetialsResponse response;

  LoginUserDetialsCallEventResponseState(this.response);
}

class ComapnyDetailsEventResponseState extends FirstScreenStates {
  final CompanyDetailsResponse companyDetailsResponse;

  ComapnyDetailsEventResponseState(this.companyDetailsResponse);
}

class CustomerRegistrationResponseState extends FirstScreenStates {
  final int custID;
  final CustomerRegistrationResponse customerRegistrationResponse;
  final CustomerRegistrationRequest customerRequest;
  CustomerRegistrationResponseState(
      this.custID, this.customerRequest, this.customerRegistrationResponse);
}

class ForgotResponseState extends FirstScreenStates {
  final ForgotResponse forgotResponse;

  ForgotResponseState(this.forgotResponse);
}

class LoginResponseState extends FirstScreenStates {
  final LoginResponse loginResponse;

  LoginResponseState(this.loginResponse);
}

class DummyLoginResponseState extends FirstScreenStates {
  final LoginResponse loginResponse;

  DummyLoginResponseState(this.loginResponse);
}

class ProductFavoriteResponseState extends FirstScreenStates {
  final ProductCartListResponse cartDeleteResponse;
  ProductFavoriteResponseState(this.cartDeleteResponse);
}

class ProductCartResponseState extends FirstScreenStates {
  final ProductCartListResponse cartDeleteResponse;
  ProductCartResponseState(this.cartDeleteResponse);
}

class LoginProductCartResponseState extends FirstScreenStates {
  final ProductCartListResponse cartDeleteResponse;
  LoginProductCartResponseState(this.cartDeleteResponse);
}

class CartDeleteResponseState extends FirstScreenStates {
  final CartDeleteResponse cartDeleteResponse;
  CartDeleteResponseState(this.cartDeleteResponse);
}

class InquiryProductSaveResponseState extends FirstScreenStates {
  final InquiryProductSaveResponse inquiryProductSaveResponse;
  InquiryProductSaveResponseState(this.inquiryProductSaveResponse);
}
