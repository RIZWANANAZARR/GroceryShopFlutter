part of 'first_screen_bloc.dart';

@immutable
abstract class FirstScreenEvents {}

///all events of AuthenticationEvents

class LoginUserDetailsCallEvent extends FirstScreenEvents {
  final LoginUserDetialsAPIRequest request;

  LoginUserDetailsCallEvent(this.request);
}

class CompanyDetailsCallEvent extends FirstScreenEvents {
  final CompanyDetailsApiRequest companyDetailsApiRequest;

  CompanyDetailsCallEvent(this.companyDetailsApiRequest);
}

class CustomerRegistrationRequestCallEvent extends FirstScreenEvents {
  final int pkID;
  final CustomerRegistrationRequest customerRegistrationRequest;

  CustomerRegistrationRequestCallEvent(
      this.pkID, this.customerRegistrationRequest);
}

class ForgotRequestCallEvent extends FirstScreenEvents {
  final ForgotRequest forgotRequest;

  ForgotRequestCallEvent(this.forgotRequest);
}

class LoginRequestCallEvent extends FirstScreenEvents {
  final LoginRequest loginRequest;

  LoginRequestCallEvent(this.loginRequest);
}

class DummyLoginRequestCallEvent extends FirstScreenEvents {
  final LoginRequest loginRequest;

  DummyLoginRequestCallEvent(this.loginRequest);
}

class ProductFavoriteDetailsRequestCallEvent extends FirstScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  ProductFavoriteDetailsRequestCallEvent(this.productCartDetailsRequest);
}

class ProductCartDetailsRequestCallEvent extends FirstScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  ProductCartDetailsRequestCallEvent(this.productCartDetailsRequest);
}

class LoginProductCartDetailsRequestCallEvent extends FirstScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  LoginProductCartDetailsRequestCallEvent(this.productCartDetailsRequest);
}

class InquiryProductSaveCallEvent extends FirstScreenEvents {
  final List<CartModel> inquiryProductModel;
  InquiryProductSaveCallEvent(this.inquiryProductModel);
}

class CartDeleteRequestCallEvent extends FirstScreenEvents {
  final int CustomerID;
  final CartDeleteRequest cartDeleteRequest;
  CartDeleteRequestCallEvent(this.CustomerID, this.cartDeleteRequest);
}
