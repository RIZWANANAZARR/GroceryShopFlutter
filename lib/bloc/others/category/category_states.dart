part of 'category_bloc.dart';

abstract class CategoryScreenStates extends BaseStates {
  const CategoryScreenStates();
}

///all states of AuthenticationStates

class CategoryScreenInitialState extends CategoryScreenStates {}

class CategoryListResponseState extends CategoryScreenStates {
  CategoryListResponse response;

  CategoryListResponseState(this.response);
}

class ProductGroupListResponseState extends CategoryScreenStates {
  ProductGroupListResponse response;

  ProductGroupListResponseState(this.response);
}

class ExclusiveOfferListResponseState extends CategoryScreenStates {
  ExclusiveOfferListResponse response;

  ExclusiveOfferListResponseState(this.response);
}

class BestSellingListResponseState extends CategoryScreenStates {
  BestSellingListResponse response;

  BestSellingListResponseState(this.response);
}

class InquiryProductSaveResponseState extends CategoryScreenStates {
  final InquiryProductSaveResponse inquiryProductSaveResponse;
  InquiryProductSaveResponseState(this.inquiryProductSaveResponse);
}

class CartDeleteResponseState extends CategoryScreenStates {
  final CartDeleteResponse cartDeleteResponse;
  CartDeleteResponseState(this.cartDeleteResponse);
}

class ProductCartResponseState extends CategoryScreenStates {
  final ProductCartListResponse cartDeleteResponse;
  ProductCartResponseState(this.cartDeleteResponse);
}

class InquiryFavoriteProductSaveResponseState extends CategoryScreenStates {
  final InquiryProductSaveResponse inquiryProductSaveResponse;
  InquiryFavoriteProductSaveResponseState(this.inquiryProductSaveResponse);
}

class FavoriteDeleteResponseState extends CategoryScreenStates {
  final CartDeleteResponse cartDeleteResponse;
  FavoriteDeleteResponseState(this.cartDeleteResponse);
}

class ProductFavoriteResponseState extends CategoryScreenStates {
  final ProductCartListResponse cartDeleteResponse;
  ProductFavoriteResponseState(this.cartDeleteResponse);
}

class PlaceOrderSaveResponseState extends CategoryScreenStates {
  final InquiryProductSaveResponse inquiryProductSaveResponse;
  PlaceOrderSaveResponseState(this.inquiryProductSaveResponse);
}

class PlacedOrderResponseState extends CategoryScreenStates {
  final PlacedOrderListResponse cartDeleteResponse;
  PlacedOrderResponseState(this.cartDeleteResponse);
}

class ProductBrandResponseState extends CategoryScreenStates {
  ProductBrandResponse response;

  ProductBrandResponseState(this.response);
}

class TabProductGroupListResponseState extends CategoryScreenStates {
  TabProductGroupListResponse response;

  TabProductGroupListResponseState(this.response);
}

class TabProductListResponseState extends CategoryScreenStates {
  TabProductListResponse response;

  TabProductListResponseState(this.response);
}

class OrderProductJsonSaveResponseState extends CategoryScreenStates {
  OrderProductJsonSaveResponse response;
  String pkID;
  String headerMsg;

  OrderProductJsonSaveResponseState(this.response, this.pkID, this.headerMsg);
}

class ProductGroupResponseState extends CategoryScreenStates {
  ProductGroupListResponse response;

  ProductGroupResponseState(this.response);
}

class PushNotificationResponseState extends CategoryScreenStates {
  PushNotificationResponse response;

  PushNotificationResponseState(this.response);
}

class OrderHeaderResponseState extends CategoryScreenStates {
  OrderHeaderResponse response;

  OrderHeaderResponseState(this.response);
}

class TokenSaveResponseState extends CategoryScreenStates {
  TokenSaveResponse response;

  TokenSaveResponseState(this.response);
}

class PDFListResponseState extends CategoryScreenStates {
  PDFListResponse response;

  PDFListResponseState(this.response);
}

class ProfileListResponseState extends CategoryScreenStates {
  final int newpage;
  ProfileListResponse response;

  ProfileListResponseState(this.newpage, this.response);
}

class ProfileDeleteResponseState extends CategoryScreenStates {
  ProfileDeleteResponse response;

  ProfileDeleteResponseState(this.response);
}

class PlaceOrderDelete12ResponseState extends CategoryScreenStates {
  PlaceOrderDeleteResponse response;

  PlaceOrderDelete12ResponseState(this.response);
}
class LoginResponseState extends CategoryScreenStates {
  final LoginResponse loginResponse;

  LoginResponseState(this.loginResponse);
}


class ProductReportingListResponseState extends CategoryScreenStates {
  final ProductReportingListResponse productReportingListResponse;

  ProductReportingListResponseState(this.productReportingListResponse);
}