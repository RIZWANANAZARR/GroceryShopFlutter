import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/models/api_request/BestSelling/best_selling_list_request.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/Exclusive_Offer/exclusive_offer_list_request.dart';
import 'package:grocery_app/models/api_request/Place_order/place_order_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_list_request.dart';
import 'package:grocery_app/models/api_request/ProductReporting/product_reporting_list_request.dart';
import 'package:grocery_app/models/api_request/Profile/profile_delete_request.dart';
import 'package:grocery_app/models/api_request/Profile/profile_list_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_group_list_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_list_from_brandID_groupID_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_list_request.dart';
import 'package:grocery_app/models/api_request/Token/token_Save_request.dart';
import 'package:grocery_app/models/api_request/order/order_header_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_json_request.dart';
import 'package:grocery_app/models/api_request/pdf_list/pdf_list_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_request/push_notification/push_notification_request.dart';
import 'package:grocery_app/models/api_response/BestSelling/best_selling_list_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_delete_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_save_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/product_cart_list_response.dart';
import 'package:grocery_app/models/api_response/Category/category_list_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Exclusive_Offer/exclusive_offer_list_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_list_response.dart';
import 'package:grocery_app/models/api_response/ProductReporting/product_reporting_list_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_delete_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_list_response.dart';
import 'package:grocery_app/models/api_response/Tab_List/tab_product_group_list_response.dart';
import 'package:grocery_app/models/api_response/Tab_List/tab_product_list_responset.dart';
import 'package:grocery_app/models/api_response/Token/token_Save_response.dart';
import 'package:grocery_app/models/api_response/customer_placed_order/customer_placed_order_response.dart';
import 'package:grocery_app/models/api_response/order/order_header_response.dart';
import 'package:grocery_app/models/api_response/order/order_product_json_response.dart';
import 'package:grocery_app/models/api_response/pdf_list/pdf_list_response.dart';
import 'package:grocery_app/models/api_response/place_order/place_order_delete_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_response.dart';
import 'package:grocery_app/models/api_response/push_notification/push_notification_response.dart';
import 'package:grocery_app/repository/repository.dart';

part 'category_events.dart';
part 'category_states.dart';

class CategoryScreenBloc
    extends Bloc<CategoryScreenEvents, CategoryScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  CategoryScreenBloc(this.baseBloc) : super(CategoryScreenInitialState());

  @override
  Stream<CategoryScreenStates> mapEventToState(
      CategoryScreenEvents event) async* {
    /// sets state based on events

    if (event is CategoryListRequestCallEvent) {
      yield* _mapLoginUserDetailsCallEventToState(event);
    }

    if (event is ProductGroupListRequestCallEvent) {
      yield* _mapProductGroupListEventToState(event);
    }

    if (event is ExclusiveOfferListRequestCallEvent) {
      yield* _mapExclusiveOfferListEventToState(event);
    }

    if (event is BestSellingListRequestCallEvent) {
      yield* _mapBestSellingListEventToState(event);
    }
    if (event is InquiryProductSaveCallEvent) {
      yield* _mapInquiryProductSaveEventToState(event);
    }
    if (event is CartDeleteRequestCallEvent) {
      yield* _mapCartDeleteRequestEventToState(event);
    }

    if (event is ProductCartDetailsRequestCallEvent) {
      yield* _mapProductCartDetailEventToState(event);
    }

    if (event is InquiryFavoriteProductSaveCallEvent) {
      yield* _mapInquiryFavoriteProductSaveEventToState(event);
    }

    if (event is FavoriteDeleteRequestCallEvent) {
      yield* _mapFavoriteDeleteRequestEventToState(event);
    }

    if (event is ProductFavoriteDetailsRequestCallEvent) {
      yield* _mapProductFavoriteDetailEventToState(event);
    }
    if (event is PlaceOrderSaveCallEvent) {
      yield* _mapPlaceOrderSaveEventToState(event);
    }

    if (event is PlacedOrderDetailsRequestCallEvent) {
      yield* _mapPlacedOrdertDetailEventToState(event);
    }

    if (event is ProductBrandCallEvent) {
      yield* _mapProductBrandCallEventToState(event);
    }

    if (event is TabProductGroupListCallEvent) {
      yield* _mapTabProductGroupCallEventToState(event);
    }

    if (event is TabProductListCallEvent) {
      yield* _mapTabProductListCallEventToState(event);
    }

    if (event is OrderProductJsonDetailsSaveCallEvent) {
      yield* _mapProductJSONSaveEventToState(event);
    }

    if (event is ProductGroupCallEvent) {
      yield* _mapGroupItem(event);
    }
    if (event is PushNotificationRequestCallEvent) {
      yield* _sendPushNotification(event);
    }
    if (event is OrderHeaderJsonDetailsSaveCallEvent) {
      yield* _mapHeaderJSONSaveEventToState(event);
    }

    if (event is TokenSaveApiRequestCallEvent) {
      yield* _mapTokenSaveEventToState(event);
    }
    if (event is PdfListRequestCallEvent) {
      yield* _mapPDFListEventToState(event);
    }

    if (event is ProfileListRequestCallEvent) {
      yield* _mapProfileListEventToState(event);
    }
    if (event is ProfileDeleteRequestCallEvent) {
      yield* _mapProfileDeleteEventToState(event);
    }
    if (event is PlaceOrderDelete12RequestEvent) {
      yield* _mapPlaceOrderDelete123EventToState(event);
    }

    if (event is TabProductListBrandIDGroupIDRequestEvent) {
      yield* _mapTabProductListBrandIDGroupIDCallEventToState(event);
    }
    if (event is LoginRequestCallEvent) {
      yield* _mapLoginCallEventToState(event);
    }
    if (event is ProductReportingListRequestCallEvent) {
      yield* _mapProductReportingListRequestCallEventState(event);
    }

    //
    //ProfileListRequestCallEvent
  }

  Stream<CategoryScreenStates> _mapLoginUserDetailsCallEventToState(
      CategoryListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CategoryListResponse loginResponse =
          await userRepository.categoryListAPI(event.categoryListRequest);
      yield CategoryListResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapProductGroupListEventToState(
      ProductGroupListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupListResponse loginResponse = await userRepository
          .productGroupListAPI(event.productGroupListRequest);
      yield ProductGroupListResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapExclusiveOfferListEventToState(
      ExclusiveOfferListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ExclusiveOfferListResponse loginResponse =
          await userRepository.ExcluSiveListAPI(
              event.exclusiveOfferListRequest);
      yield ExclusiveOfferListResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapBestSellingListEventToState(
      BestSellingListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      BestSellingListResponse loginResponse =
          await userRepository.BestSellingListAPI(event.bestSellingListRequest);
      yield BestSellingListResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState " + "Msg : " + error.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapInquiryProductSaveEventToState(
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

  Stream<CategoryScreenStates> _mapInquiryFavoriteProductSaveEventToState(
      InquiryFavoriteProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryProductSaveResponse respo = await userRepository
          .inquiryFavoriteProductSaveDetails(event.inquiryProductModel);
      yield InquiryFavoriteProductSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapCartDeleteRequestEventToState(
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

  Stream<CategoryScreenStates> _mapFavoriteDeleteRequestEventToState(
      FavoriteDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CartDeleteResponse loginResponse = await userRepository.FavoriteDeleteAPI(
          event.CustomerID, event.cartDeleteRequest);
      yield FavoriteDeleteResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState " + "Msg : " + error.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapProductCartDetailEventToState(
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

  Stream<CategoryScreenStates> _mapProductFavoriteDetailEventToState(
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

  Stream<CategoryScreenStates> _mapPlaceOrderSaveEventToState(
      PlaceOrderSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryProductSaveResponse respo =
          await userRepository.placeOrderSaveDetails(event.inquiryProductModel);
      yield PlaceOrderSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapPlacedOrdertDetailEventToState(
      PlacedOrderDetailsRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      PlacedOrderListResponse loginResponse =
          await userRepository.PlacedOrderListAPI(
              event.productCartDetailsRequest);
      yield PlacedOrderResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState " + "Msg : " + error.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapProductBrandCallEventToState(
      ProductBrandCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandResponse response =
          await userRepository.productbrand(event.request);
      yield ProductBrandResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapTabProductGroupCallEventToState(
      TabProductGroupListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      TabProductGroupListResponse response =
          await userRepository.TabproductGroupAPI(event.request);
      yield TabProductGroupListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapTabProductListCallEventToState(
      TabProductListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      TabProductListResponse response =
          await userRepository.TabproductListAPI(event.request);
      yield TabProductListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapTabProductListBrandIDGroupIDCallEventToState(
      TabProductListBrandIDGroupIDRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      TabProductListResponse response =
          await userRepository.TabproductListBrandIDGroupIDAPI(event.request);
      yield TabProductListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapProductJSONSaveEventToState(
      OrderProductJsonDetailsSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      OrderProductJsonSaveResponse respo = await userRepository
          .quotationProductSaveDetails(event.pkID, event.quotationProductModel);
      yield OrderProductJsonSaveResponseState(
          respo, event.pkID, event.HeaderMsg);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapGroupItem(
      ProductGroupCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupListResponse productGroupListResponse =
          await userRepository.productGroupListDashboardAPI(event.request);
      yield ProductGroupResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _sendPushNotification(
      PushNotificationRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      PushNotificationResponse productGroupListResponse =
          await userRepository.PushNotificationAPI(event.request);
      yield PushNotificationResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapHeaderJSONSaveEventToState(
      OrderHeaderJsonDetailsSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      OrderHeaderResponse respo = await userRepository
          .quotationHeaderSaveDetails(event.pkID, event.quotationProductModel);
      yield OrderHeaderResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapTokenSaveEventToState(
      TokenSaveApiRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TokenSaveResponse respo =
          await userRepository.TokenSaveAPI(event.request);
      yield TokenSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapPDFListEventToState(
      PdfListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PDFListResponse respo = await userRepository.PDFListAPI(event.request);
      yield PDFListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapProfileListEventToState(
      ProfileListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProfileListResponse respo =
          await userRepository.ProfileListAPI(event.pageno, event.request);
      yield ProfileListResponseState(event.pageno, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapProfileDeleteEventToState(
      ProfileDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProfileDeleteResponse respo =
          await userRepository.ProfileDeleteAPI(event.pkID, event.request);
      yield ProfileDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapPlaceOrderDelete123EventToState(
      PlaceOrderDelete12RequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PlaceOrderDeleteResponse respo =
          await userRepository.PlaceOrderDeleteAPI(event.pkID, event.request);
      yield PlaceOrderDelete12ResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapLoginCallEventToState(
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

  Stream<CategoryScreenStates> _mapProductReportingListRequestCallEventState(
      ProductReportingListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductReportingListResponse companyDetailsResponse = await userRepository
          .productreportingApi(event.productReportingListRequest);
      yield ProductReportingListResponseState(companyDetailsResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
