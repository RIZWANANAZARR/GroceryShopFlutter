part of 'category_bloc.dart';

@immutable
abstract class CategoryScreenEvents {}

///all events of AuthenticationEvents

class CategoryListRequestCallEvent extends CategoryScreenEvents {
  final CategoryListRequest categoryListRequest;

  CategoryListRequestCallEvent(this.categoryListRequest);
}

class ProductGroupListRequestCallEvent extends CategoryScreenEvents {
  final ProductGroupListRequest productGroupListRequest;

  ProductGroupListRequestCallEvent(this.productGroupListRequest);
}

class ExclusiveOfferListRequestCallEvent extends CategoryScreenEvents {
  final ExclusiveOfferListRequest exclusiveOfferListRequest;

  ExclusiveOfferListRequestCallEvent(this.exclusiveOfferListRequest);
}

class BestSellingListRequestCallEvent extends CategoryScreenEvents {
  final BestSellingListRequest bestSellingListRequest;

  BestSellingListRequestCallEvent(this.bestSellingListRequest);
}

class InquiryProductSaveCallEvent extends CategoryScreenEvents {
  final List<CartModel> inquiryProductModel;
  InquiryProductSaveCallEvent(this.inquiryProductModel);
}

class CartDeleteRequestCallEvent extends CategoryScreenEvents {
  final int CustomerID;
  final CartDeleteRequest cartDeleteRequest;
  CartDeleteRequestCallEvent(this.CustomerID, this.cartDeleteRequest);
}

class FavoriteDeleteRequestCallEvent extends CategoryScreenEvents {
  final int CustomerID;
  final CartDeleteRequest cartDeleteRequest;
  FavoriteDeleteRequestCallEvent(this.CustomerID, this.cartDeleteRequest);
}

class ProductCartDetailsRequestCallEvent extends CategoryScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  ProductCartDetailsRequestCallEvent(this.productCartDetailsRequest);
}

class InquiryFavoriteProductSaveCallEvent extends CategoryScreenEvents {
  final List<CartModel> inquiryProductModel;
  InquiryFavoriteProductSaveCallEvent(this.inquiryProductModel);
}

class ProductFavoriteDetailsRequestCallEvent extends CategoryScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  ProductFavoriteDetailsRequestCallEvent(this.productCartDetailsRequest);
}

class PlaceOrderSaveCallEvent extends CategoryScreenEvents {
  final List<CartModel> inquiryProductModel;
  PlaceOrderSaveCallEvent(this.inquiryProductModel);
}

class PlacedOrderDetailsRequestCallEvent extends CategoryScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  PlacedOrderDetailsRequestCallEvent(this.productCartDetailsRequest);
}

class ProductBrandCallEvent extends CategoryScreenEvents {
  final ProductBrandListRequest request;

  ProductBrandCallEvent(this.request);
}

/*
class placeOrderDeleteRequestCallEvent extends CategoryScreenEvents {
  final int CustomerID;
  final CartDeleteRequest cartDeleteRequest;
  CartDeleteRequestCallEvent(this.CustomerID,this.cartDeleteRequest);
}*/
class TabProductGroupListCallEvent extends CategoryScreenEvents {
  final TabProductGroupListRequest request;

  TabProductGroupListCallEvent(this.request);
}

class TabProductListCallEvent extends CategoryScreenEvents {
  final TabProductListRequest request;

  TabProductListCallEvent(this.request);
}

class OrderProductJsonDetailsSaveCallEvent extends CategoryScreenEvents {
  String pkID;
  BuildContext context;
  String HeaderMsg;
  final List<OrderProductJsonDetails> quotationProductModel;
  OrderProductJsonDetailsSaveCallEvent(
      this.context, this.pkID, this.HeaderMsg, this.quotationProductModel);
}

class ProductGroupCallEvent extends CategoryScreenEvents {
  final ProductGroupListRequest request;

  ProductGroupCallEvent(this.request);
}

class PushNotificationRequestCallEvent extends CategoryScreenEvents {
  final PushNotificationRequest request;

  PushNotificationRequestCallEvent(this.request);
}

class OrderHeaderJsonDetailsSaveCallEvent extends CategoryScreenEvents {
  String pkID;
  BuildContext context;
  final List<OrderHeaderJsonDetails> quotationProductModel;
  OrderHeaderJsonDetailsSaveCallEvent(
      this.context, this.pkID, this.quotationProductModel);
}

class TokenSaveApiRequestCallEvent extends CategoryScreenEvents {
  final TokenSaveApiRequest request;

  TokenSaveApiRequestCallEvent(this.request);
}

class PdfListRequestCallEvent extends CategoryScreenEvents {
  final PdfListRequest request;

  PdfListRequestCallEvent(this.request);
}

//ProfileListRequest
class ProfileListRequestCallEvent extends CategoryScreenEvents {
  final int pageno;

  final ProfileListRequest request;

  ProfileListRequestCallEvent(this.pageno, this.request);
}

class ProfileDeleteRequestCallEvent extends CategoryScreenEvents {
  final int pkID;

  final ProfileDeleteRequest request;

  ProfileDeleteRequestCallEvent(this.pkID, this.request);
}

class PlaceOrderDelete12RequestEvent extends CategoryScreenEvents {
  String pkID;
  final PlaceOrderDeleteRequest request;

  PlaceOrderDelete12RequestEvent(this.pkID, this.request);
}

class TabProductListBrandIDGroupIDRequestEvent extends CategoryScreenEvents {
  final TabProductListBrandIDGroupIDRequest request;

  TabProductListBrandIDGroupIDRequestEvent(this.request);
}

class LoginRequestCallEvent extends CategoryScreenEvents {
  final LoginRequest loginRequest;

  LoginRequestCallEvent(this.loginRequest);
}

class ProductReportingListRequestCallEvent extends CategoryScreenEvents {
  final ProductReportingListRequest productReportingListRequest;

  ProductReportingListRequestCallEvent(this.productReportingListRequest);
}
