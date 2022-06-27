part of 'order_bloc.dart';

@immutable
abstract class OrderScreenEvents {}

///all events of AuthenticationEvents

class OrderCustomerListRequestCallEvent extends OrderScreenEvents {
  final OrderCustomerListRequest orderCustomerListRequest;

  OrderCustomerListRequestCallEvent(this.orderCustomerListRequest);
}

class OrderProductListRequestCallEvent extends OrderScreenEvents {
  final OrderProductListRequest orderProductListRequest;

  OrderProductListRequestCallEvent(this.orderProductListRequest);
}

class OrderProductListRequestCalculationCallEvent extends OrderScreenEvents {
  final OrderProductListRequest orderProductListRequest;
  final String InvoiceNo;

  OrderProductListRequestCalculationCallEvent(
      this.InvoiceNo, this.orderProductListRequest);
}

class OrderProductJsonDetailsSaveCallEvent extends OrderScreenEvents {
  String pkID;
  BuildContext context;
  final List<OrderProductJsonDetails> quotationProductModel;
  OrderProductJsonDetailsSaveCallEvent(
      this.context, this.pkID, this.quotationProductModel);
}

class PdfUploadRequestEvent extends OrderScreenEvents {
  File imageFile;
  String headerMsg;
  final PdfUploadRequest request;

  PdfUploadRequestEvent(this.headerMsg, this.imageFile, this.request);
}

class OrderHeaderJsonDetailsSaveCallEvent extends OrderScreenEvents {
  String pkID;
  BuildContext context;
  final List<OrderHeaderJsonDetails> quotationProductModel;
  OrderHeaderJsonDetailsSaveCallEvent(
      this.context, this.pkID, this.quotationProductModel);
}

class TokenListApiRequestCallEvent extends OrderScreenEvents {
  final TokenListApiRequest tokenListApiRequest;

  TokenListApiRequestCallEvent(this.tokenListApiRequest);
}

class OrderDeleteRequestEvent extends OrderScreenEvents {
  String pkID;
  final OrderDeleteRequest request;

  OrderDeleteRequestEvent(this.pkID, this.request);
}

class PlaceOrderDeleteRequestEvent extends OrderScreenEvents {
  String pkID;
  final PlaceOrderDeleteRequest request;

  PlaceOrderDeleteRequestEvent(this.pkID, this.request);
}

class ManagePaymentSaveRequestEvent extends OrderScreenEvents {
  String pkID;
  String ReturnMsg;
  final ManagePaymentSaveRequest request;

  ManagePaymentSaveRequestEvent(this.ReturnMsg, this.pkID, this.request);
}

class ManagePaymentListRequestEvent extends OrderScreenEvents {
  int pageNo;
  final ManagePaymentListRequest request;

  ManagePaymentListRequestEvent(this.pageNo, this.request);
}
class OrderAllDetailDeleteRequestEvent extends OrderScreenEvents {
  final OrderAllDetailDeleteRequest request;

  OrderAllDetailDeleteRequestEvent(this.request);
}