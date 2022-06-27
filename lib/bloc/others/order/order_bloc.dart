import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/models/api_request/ManagePayment/manage_payment_list_request.dart';
import 'package:grocery_app/models/api_request/ManagePayment/manage_payment_save_request.dart';
import 'package:grocery_app/models/api_request/Place_order/place_order_delete_request.dart';
import 'package:grocery_app/models/api_request/Token/token_list_request.dart';
import 'package:grocery_app/models/api_request/order/order_all_detail_delete_request.dart';
import 'package:grocery_app/models/api_request/order/order_customer_list_request.dart';
import 'package:grocery_app/models/api_request/order/order_delete_request.dart';
import 'package:grocery_app/models/api_request/order/order_header_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_json_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_list_request.dart';
import 'package:grocery_app/models/api_request/pdf_upload/pdf_upload_request.dart';
import 'package:grocery_app/models/api_response/ManagePayment/manage_payment_list_response.dart';
import 'package:grocery_app/models/api_response/ManagePayment/manage_payment_save_response.dart';
import 'package:grocery_app/models/api_response/Token/token_list_response.dart';
import 'package:grocery_app/models/api_response/order/order_all_detail_delete_response.dart';
import 'package:grocery_app/models/api_response/order/order_customer_list_response.dart';
import 'package:grocery_app/models/api_response/order/order_delete_response.dart';
import 'package:grocery_app/models/api_response/order/order_header_response.dart';
import 'package:grocery_app/models/api_response/order/order_product_json_response.dart';
import 'package:grocery_app/models/api_response/order/order_product_list_response.dart';
import 'package:grocery_app/models/api_response/pdf_upload/pdf_upload_response.dart';
import 'package:grocery_app/models/api_response/place_order/place_order_delete_response.dart';
import 'package:grocery_app/repository/repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderScreenBloc extends Bloc<OrderScreenEvents, OrderScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  OrderScreenBloc(this.baseBloc) : super(OrderScreenInitialState());

  @override
  Stream<OrderScreenStates> mapEventToState(OrderScreenEvents event) async* {
    /// sets state based on events

    if (event is OrderCustomerListRequestCallEvent) {
      yield* _mapOrderCustomerDetailsCallEventToState(event);
    }

    if (event is OrderProductListRequestCallEvent) {
      yield* _mapOrderProductDetailsCallEventToState(event);
    }
    if (event is OrderProductListRequestCalculationCallEvent) {
      yield* _mapOrderProductDetailsCallCalculationEventToState(event);
    }
    if (event is OrderProductJsonDetailsSaveCallEvent) {
      yield* _mapProductJSONSaveEventToState(event);
    }

    if (event is PdfUploadRequestEvent) {
      yield* _mapPdfUploadCallEventToState(event);
    }

    if (event is OrderHeaderJsonDetailsSaveCallEvent) {
      yield* _mapHeaderJSONSaveEventToState(event);
    }
    if (event is TokenListApiRequestCallEvent) {
      yield* _mapTokenListEventToState(event);
    }
    if (event is OrderDeleteRequestEvent) {
      yield* _mapProfileDeleteEventToState(event);
    }
    if (event is PlaceOrderDeleteRequestEvent) {
      yield* _mapPlaceOrderDeleteEventToState(event);
    }
    if (event is ManagePaymentSaveRequestEvent) {
      yield* _mapManagePaymnetSaveEventToState(event);
    }
    if (event is ManagePaymentListRequestEvent) {
      yield* _mapManagePaymentListEventToState(event);
    }

    if (event is OrderAllDetailDeleteRequestEvent) {
      yield* _mapOrderAllDetailsDeleteEventState(event);
    }
  }

  Stream<OrderScreenStates> _mapOrderCustomerDetailsCallEventToState(
      OrderCustomerListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      OrderCustomerListResponse loginResponse = await userRepository
          .ordercustomerListAPI(event.orderCustomerListRequest);
      yield OrderCustomerListResponseState(1, loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapOrderProductDetailsCallEventToState(
      OrderProductListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      OrderProductListResponse loginResponse = await userRepository
          .orderProductListAPI(event.orderProductListRequest);
      yield OrderProductListResponseState(1, loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapOrderProductDetailsCallCalculationEventToState(
      OrderProductListRequestCalculationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      OrderProductListResponse loginResponse = await userRepository
          .orderProductListAPI(event.orderProductListRequest);
      yield OrderProductListResponseForCalculationState(
          1, loginResponse, event.InvoiceNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapProductJSONSaveEventToState(
      OrderProductJsonDetailsSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      OrderProductJsonSaveResponse respo = await userRepository
          .quotationProductSaveDetails(event.pkID, event.quotationProductModel);
      yield OrderProductJsonSaveResponseState(
          respo, event.quotationProductModel);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapPdfUploadCallEventToState(
      PdfUploadRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PdfUploadResponse expenseUploadImageResponse =
          await userRepository.pdfUploadApi(event.imageFile, event.request);

      yield PdfUploadResponseState(expenseUploadImageResponse, event.headerMsg);
    } catch (error, stacktrace) {
      print(error);
      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapHeaderJSONSaveEventToState(
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

  Stream<OrderScreenStates> _mapTokenListEventToState(
      TokenListApiRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TokenListResponse respo =
          await userRepository.TokenListAPI(event.tokenListApiRequest);
      yield TokenListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapProfileDeleteEventToState(
      OrderDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      OrderDeleteResponse respo =
          await userRepository.OrderDeleteAPI(event.pkID, event.request);
      yield OrderDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapPlaceOrderDeleteEventToState(
      PlaceOrderDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PlaceOrderDeleteResponse respo =
          await userRepository.PlaceOrderDeleteAPI(event.pkID, event.request);
      yield PlaceOrderDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapManagePaymnetSaveEventToState(
      ManagePaymentSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ManagePaymentSaveResponse respo =
          await userRepository.ManagePaymentSaveAPI(event.pkID, event.request);
      yield ManagePaymentSaveResponseState(event.ReturnMsg, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapManagePaymentListEventToState(
      ManagePaymentListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ManagePaymentListResponse response = await userRepository
          .managePaymentListAPI(event.pageNo, event.request);
      yield ManagePaymentListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<OrderScreenStates> _mapOrderAllDetailsDeleteEventState(
      OrderAllDetailDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      OrderAllDetailDeleteResponse response =
          await userRepository.orderAllDetailDeleteAPI(event.request);
      yield OrderAllDetailDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
