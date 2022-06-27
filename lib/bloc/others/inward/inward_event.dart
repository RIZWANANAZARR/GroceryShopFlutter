part of 'inward_bloc.dart';

@immutable
abstract class InwardScreenEvents {}

///all events of AuthenticationEvents

class InwardListRequestCallEvent extends InwardScreenEvents {
  int pageNo;
  final InwardListRequest inwardListRequest;

  InwardListRequestCallEvent(this.pageNo, this.inwardListRequest);
}

class InwardDeleteRequestCallEvent extends InwardScreenEvents {
  final InwardDeleteRequest inwardDeleteRequest;

  InwardDeleteRequestCallEvent(this.inwardDeleteRequest);
}

class GeneralCustomerSearchRequestCallEvent extends InwardScreenEvents {
  final int pageno;
  final bool IsClear;
  final ProfileListRequest request;

  GeneralCustomerSearchRequestCallEvent(
      this.pageno, this.IsClear, this.request);
}

class InwardProductListRequestCallEvent extends InwardScreenEvents {
  final InwardProductListRequest inwardProductListRequest;

  InwardProductListRequestCallEvent(this.inwardProductListRequest);
}

class GeneralProductSearchCallEvent extends InwardScreenEvents {
  final int pageno;
  final ProductPaginationRequest request;

  GeneralProductSearchCallEvent(this.pageno, this.request);
}

class InwardHeaderSaveRequestCallEvent extends InwardScreenEvents {
  final int pkID;

  final InwardHeaderSaveRequest request;

  InwardHeaderSaveRequestCallEvent(this.pkID, this.request);
}

class InwardProductSaveCallEvent extends InwardScreenEvents {
  String InwardNo;
  final List<InWardProductModel> inwardProductModel;

  InwardProductSaveCallEvent(this.InwardNo, this.inwardProductModel);
}

class InwardALLProductDeleteRequestCallEvent extends InwardScreenEvents {
  final InwardAllProductDeleteRequest inwardAllProductDeleteRequest;

  InwardALLProductDeleteRequestCallEvent(this.inwardAllProductDeleteRequest);
}
