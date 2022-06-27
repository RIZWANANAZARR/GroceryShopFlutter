part of 'order_bloc.dart';

abstract class OrderScreenStates extends BaseStates {
  const OrderScreenStates();
}

///all states of AuthenticationStates

class OrderScreenInitialState extends OrderScreenStates {}

class OrderCustomerListResponseState extends OrderScreenStates {
  final int newpage;

  OrderCustomerListResponse response;

  OrderCustomerListResponseState(this.newpage, this.response);
}

class OrderProductListResponseState extends OrderScreenStates {
  final int newpage;

  OrderProductListResponse response;

  OrderProductListResponseState(this.newpage, this.response);
}

class OrderProductListResponseForCalculationState extends OrderScreenStates {
  final int newpage;
  final String InvoiceNo;

  OrderProductListResponse response;

  OrderProductListResponseForCalculationState(
      this.newpage, this.response, this.InvoiceNo);
}

class OrderProductJsonSaveResponseState extends OrderScreenStates {
  OrderProductJsonSaveResponse response;
  final List<OrderProductJsonDetails> quotationProductModel;

  OrderProductJsonSaveResponseState(this.response, this.quotationProductModel);
}

class PdfUploadResponseState extends OrderScreenStates {
  PdfUploadResponse response;
  String headerMsg;
  PdfUploadResponseState(this.response, this.headerMsg);
}

class OrderHeaderResponseState extends OrderScreenStates {
  OrderHeaderResponse response;

  OrderHeaderResponseState(this.response);
}

class TokenListResponseState extends OrderScreenStates {
  TokenListResponse response;

  TokenListResponseState(this.response);
}

class OrderDeleteResponseState extends OrderScreenStates {
  OrderDeleteResponse response;

  OrderDeleteResponseState(this.response);
}

class PlaceOrderDeleteResponseState extends OrderScreenStates {
  PlaceOrderDeleteResponse response;

  PlaceOrderDeleteResponseState(this.response);
}

class ManagePaymentSaveResponseState extends OrderScreenStates {
  String ReturnMsg;
  ManagePaymentSaveResponse response;

  ManagePaymentSaveResponseState(this.ReturnMsg, this.response);
}

class ManagePaymentListResponseState extends OrderScreenStates {
  final int newpage;
  ManagePaymentListResponse response;

  ManagePaymentListResponseState(this.newpage, this.response);
}
class OrderAllDetailDeleteResponseState extends OrderScreenStates {
  OrderAllDetailDeleteResponse response;

  OrderAllDetailDeleteResponseState(this.response);
}
//TokenListResponseDetails
