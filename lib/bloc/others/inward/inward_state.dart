part of 'inward_bloc.dart';

abstract class InwardScreenStates extends BaseStates {
  const InwardScreenStates();
}

///all states of AuthenticationStates

class InwardScreenInitialState extends InwardScreenStates {}

class InwardListResponseState extends InwardScreenStates {
  final int newpage;

  InwardListResponse response;

  InwardListResponseState(this.newpage, this.response);
}

class InwardDeleteResponseState extends InwardScreenStates {
  InwardDeleteResponse response;

  InwardDeleteResponseState(this.response);
}

class GeneralCustomerSearchResponseState extends InwardScreenStates {
  final int newpage;
  ProfileListResponse response;
  final bool IsClear;
  GeneralCustomerSearchResponseState(this.newpage, this.IsClear, this.response);
}

class InwardProductListResponseState extends InwardScreenStates {
  InwardProductListResponse response;

  InwardProductListResponseState(this.response);
}

class GenralProductSearchResponseState extends InwardScreenStates {
  final int newpage;
  ProductPaginationResponse response;

  GenralProductSearchResponseState(this.newpage, this.response);
}

class InwardHeaderSaveResponseState extends InwardScreenStates {
  InwardHeaderSaveResponse response;

  InwardHeaderSaveResponseState(this.response);
}

class InwardProductSaveResponseState extends InwardScreenStates {
  InwardProductSaveResponse response;

  InwardProductSaveResponseState(this.response);
}

class InwardProductALLProductResponseState extends InwardScreenStates {
  InwardALLProductDeleteResponse response;

  InwardProductALLProductResponseState(this.response);
}
