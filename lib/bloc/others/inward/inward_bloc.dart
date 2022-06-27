import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/models/api_request/Inward/Inward_header_save_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_all_product_delete_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_delete_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_list_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_product_list_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_pagination_request.dart';
import 'package:grocery_app/models/api_request/Profile/profile_list_request.dart';
import 'package:grocery_app/models/api_response/Inward/inward_all_product_delete_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_delete_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_header_save_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_list_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_product_list_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_product_save_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_list_response.dart';
import 'package:grocery_app/models/database_models/InwardProductModel.dart';
import 'package:grocery_app/repository/repository.dart';

part 'inward_event.dart';
part 'inward_state.dart';

class InwardScreenBloc extends Bloc<InwardScreenEvents, InwardScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  InwardScreenBloc(this.baseBloc) : super(InwardScreenInitialState());

  @override
  Stream<InwardScreenStates> mapEventToState(InwardScreenEvents event) async* {
    /// sets state based on events

    if (event is InwardListRequestCallEvent) {
      yield* _mapInwardListCallEventToState(event);
    }

    if (event is InwardDeleteRequestCallEvent) {
      yield* _mapInwardDeleteCallEventToState(event);
    }
    if (event is GeneralCustomerSearchRequestCallEvent) {
      yield* _mapGeneralCustomerSearchEventToState(event);
    }

    if (event is InwardProductListRequestCallEvent) {
      yield* _mapProductListEventToState(event);
    }
    if (event is GeneralProductSearchCallEvent) {
      yield* _mapGeneralProductSearchCallEventToState(event);
    }
    if (event is InwardHeaderSaveRequestCallEvent) {
      yield* _mapInwardHeaderSaveCallEventToState(event);
    }

    if (event is InwardProductSaveCallEvent) {
      yield* _mapInwardProductSaveEventToState(event);
    }

    if (event is InwardALLProductDeleteRequestCallEvent) {
      yield* _mapInwardALLProductDeleteCallEventToState(event);
    }
  }

  Stream<InwardScreenStates> _mapInwardListCallEventToState(
      InwardListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      InwardListResponse loginResponse = await userRepository.inwardListAPI(
          event.pageNo, event.inwardListRequest);
      yield InwardListResponseState(1, loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InwardScreenStates> _mapInwardDeleteCallEventToState(
      InwardDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      InwardDeleteResponse loginResponse =
          await userRepository.inwardDeleteAPI(event.inwardDeleteRequest);
      yield InwardDeleteResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InwardScreenStates> _mapGeneralCustomerSearchEventToState(
      GeneralCustomerSearchRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProfileListResponse respo =
          await userRepository.ProfileListAPI(event.pageno, event.request);
      yield GeneralCustomerSearchResponseState(
          event.pageno, event.IsClear, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InwardScreenStates> _mapProductListEventToState(
      InwardProductListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InwardProductListResponse respo =
          await userRepository.InwardProductListAPI(
              event.inwardProductListRequest);
      yield InwardProductListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InwardScreenStates> _mapGeneralProductSearchCallEventToState(
      GeneralProductSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductPaginationResponse response =
          await userRepository.productmasterlist(event.pageno, event.request);
      yield GenralProductSearchResponseState(event.pageno, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InwardScreenStates> _mapInwardHeaderSaveCallEventToState(
      InwardHeaderSaveRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      InwardHeaderSaveResponse loginResponse =
          await userRepository.inwardHeaderSaveAPI(event.pkID, event.request);
      yield InwardHeaderSaveResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InwardScreenStates> _mapInwardProductSaveEventToState(
      InwardProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InwardProductSaveResponse respo = await userRepository
          .inwardProductSaveDetails(event.InwardNo, event.inwardProductModel);
      yield InwardProductSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InwardScreenStates> _mapInwardALLProductDeleteCallEventToState(
      InwardALLProductDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      InwardALLProductDeleteResponse loginResponse = await userRepository
          .inwardALLProductDeleteAPI(event.inwardAllProductDeleteRequest);
      yield InwardProductALLProductResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
