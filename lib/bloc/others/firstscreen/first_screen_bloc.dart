import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_forgot_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_registration_request.dart';
import 'package:grocery_app/models/api_request/company_details_request.dart';
import 'package:grocery_app/models/api_request/login_user_details_api_request.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_delete_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_save_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/product_cart_list_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_forgot_respons.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_registration_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/login_user_details_api_response.dart';
import 'package:grocery_app/repository/repository.dart';

part 'first_screen_events.dart';
part 'first_screen_states.dart';

class FirstScreenBloc extends Bloc<FirstScreenEvents, FirstScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  FirstScreenBloc(this.baseBloc) : super(FirstScreenInitialState());

  @override
  Stream<FirstScreenStates> mapEventToState(FirstScreenEvents event) async* {
    /// sets state based on events

    if (event is LoginUserDetailsCallEvent) {
      yield* _mapLoginUserDetailsCallEventToState(event);
    }

    if (event is CompanyDetailsCallEvent) {
      yield* _mapCompanyDetailsCallEventToState(event);
    }

    if (event is CustomerRegistrationRequestCallEvent) {
      yield* _mapCustomerRegistrationEventToState(event);
    }

    if (event is ForgotRequestCallEvent) {
      yield* _mapForgotCallEventToState(event);
    }

    if (event is LoginRequestCallEvent) {
      yield* _mapLoginCallEventToState(event);
    }
    if (event is ProductFavoriteDetailsRequestCallEvent) {
      yield* _mapProductFavoriteDetailEventToState(event);
    }

    if (event is ProductCartDetailsRequestCallEvent) {
      yield* _mapProductCartDetailEventToState(event);
    }

    if (event is LoginProductCartDetailsRequestCallEvent) {
      yield* _mapLoginProductCartDetailEventToState(event);
    }

    if (event is DummyLoginRequestCallEvent) {
      yield* _mapDummyLoginCallEventToState(event);
    }
    if (event is CartDeleteRequestCallEvent) {
      yield* _mapCartDeleteRequestEventToState(event);
    }
    if (event is InquiryProductSaveCallEvent) {
      yield* _mapInquiryProductSaveEventToState(event);
    }
  }

  ///event functions to states implementation
  /* Stream<FirstScreenStates> _mapCompanyDetailsCallEventToState(
      CompanyDetailsCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CompanyDetailsResponse companyDetailsResponse =
      await userRepository.CompanyDetailsCallApi(event.companyDetailsApiRequest);
      yield ComapnyDetailsEventResponseState(companyDetailsResponse);

    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  ///event functions to states implementation
  Stream<FirstScreenStates> _mapLoginUserDetailsCallEventToState(
      LoginUserDetailsCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      LoginUserDetialsResponse loginResponse =
          await userRepository.loginUserDetailsCall(event.request);
      yield LoginUserDetialsCallEventResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///event functions to states implementation
  Stream<FirstScreenStates> _mapCompanyDetailsCallEventToState(
      CompanyDetailsCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CompanyDetailsResponse companyDetailsResponse =
          await userRepository.CompanyDetailsCallApi(
              event.companyDetailsApiRequest);
      yield ComapnyDetailsEventResponseState(companyDetailsResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapCustomerRegistrationEventToState(
      CustomerRegistrationRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CustomerRegistrationResponse companyDetailsResponse =
          await userRepository.CustomerRegistrationAPI(
              event.pkID, event.customerRegistrationRequest);
      yield CustomerRegistrationResponseState(event.pkID,
          event.customerRegistrationRequest, companyDetailsResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapForgotCallEventToState(
      ForgotRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ForgotResponse companyDetailsResponse =
          await userRepository.ForgotAPI(event.forgotRequest);
      yield ForgotResponseState(companyDetailsResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapLoginCallEventToState(
      LoginRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      LoginResponse companyDetailsResponse =
          await userRepository.LoginAPI(event.loginRequest);
      yield LoginResponseState(companyDetailsResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapDummyLoginCallEventToState(
      DummyLoginRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      LoginResponse companyDetailsResponse =
          await userRepository.LoginAPI(event.loginRequest);
      yield DummyLoginResponseState(companyDetailsResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapProductFavoriteDetailEventToState(
      ProductFavoriteDetailsRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductCartListResponse loginResponse =
          await userRepository.ProductFavoriteListAPI(
              event.productCartDetailsRequest);
      yield ProductFavoriteResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState " + "Msg : " + error.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapProductCartDetailEventToState(
      ProductCartDetailsRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductCartListResponse loginResponse =
          await userRepository.ProductCartListAPI(
              event.productCartDetailsRequest);
      yield ProductCartResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState " + "Msg : " + error.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapLoginProductCartDetailEventToState(
      LoginProductCartDetailsRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductCartListResponse loginResponse =
          await userRepository.ProductCartListAPI(
              event.productCartDetailsRequest);
      yield LoginProductCartResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState " + "Msg : " + error.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapCartDeleteRequestEventToState(
      CartDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CartDeleteResponse loginResponse = await userRepository.CartDeleteAPI(
          event.CustomerID, event.cartDeleteRequest);
      yield CartDeleteResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState " + "Msg : " + error.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapInquiryProductSaveEventToState(
      InquiryProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryProductSaveResponse respo = await userRepository
          .inquiryProductSaveDetails(event.inquiryProductModel);
      yield InquiryProductSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
