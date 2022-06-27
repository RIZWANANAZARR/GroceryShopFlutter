import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/group_image_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/group_image_upload_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_drop_down_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_list_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_save_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_image_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_image_save_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_master_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_master_save_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_pagination_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_group_list_request.dart';
import 'package:grocery_app/models/api_request/product_brand/brand_image_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/brand_upload_image_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_save_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_seach_request.dart';
import 'package:grocery_app/models/api_response/Category/category_list_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/group_image_delete_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/group_image_upload_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_delete_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_dropdown_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_list_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_save_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_delete_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_image_delete_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_image_save_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_master_save_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/Tab_List/tab_product_group_list_response.dart';
import 'package:grocery_app/models/api_response/product_brand/brand_image_delete_response.dart';
import 'package:grocery_app/models/api_response/product_brand/brand_upload_image_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_delete_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_save_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_search.dart';
import 'package:grocery_app/repository/repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductGroupBloc extends Bloc<ProductGroupEvents, ProductStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ProductGroupBloc(this.baseBloc) : super(ProductGroupInitialState());

  @override
  Stream<ProductStates> mapEventToState(ProductGroupEvents event) async* {
    /// sets state based on events

    if (event is ProductBrandCallEvent) {
      yield* _mapProductBrandCallEventToState(event);
    }
    if (event is ProductMasterSaveCallEvent) {
      yield* _mapProductMasterSaveCallEventToState(event);
    }
    if (event is ProductMasterPaginationCallEvent) {
      yield* _mapProductMasterPaginationCallEventToState(event);
    }
    if (event is ProductMasterPaginationSearchCallEvent) {
      yield* _mapProductMasterPaginationSearchCallEventToState(event);
    }
    if (event is ProductMasterDeleteCallEvent) {
      yield* _mapProductMasterDeleteCallEventToState(event);
    }
    if (event is ProductBrandSaveCallEvent) {
      yield* _mapProductBrandSaveCallEventToState(event);
    }
    if (event is ProductBrandDeleteCallEvent) {
      yield* _mapProductBrandDeleteCallEventToState(event);
    }
    if (event is ProductBrandSearchCallEvent) {
      yield* _mapProductBrandSearchCallEventToState(event);
    }
    if (event is ProductBrandSearchMainCallEvent) {
      yield* _mapProductBrandSearchMainCallEventToState(event);
    }

    if (event is ProductGroupSaveCallEvent) {
      yield* _mapProductGroupSaveCallEventToState(event);
    }
    if (event is ProductGroupDeleteCallEvent) {
      yield* _mapProductGroupDeleteCallEventToState(event);
    }
    if (event is ProductGroupCallEvent) {
      yield* _mapProductGroupCallEventToState(event);
    }
    if (event is ProductGroupSearchCallEvent) {
      yield* _mapProductGroupSearchCallEventToState(event);
    }

    if (event is ProductImageSaveRequestEvent) {
      yield* _mapProductUploadImageCallEventToState(event);
    }

    if (event is ProductImageDeleteCallEvent) {
      yield* _mapProductImageDeleteCallEventToState(event);
    }
    if (event is BrandUploadImageRequestEvent) {
      yield* _mapBrandUploadImageCallEventToState(event);
    }
    if (event is BrandImageDeleteCallEvent) {
      yield* _mapBrandImageDeleteCallEventToState(event);
    }

    if (event is GroupUploadImageRequestEvent) {
      yield* _mapGroupUploadImageCallEventToState(event);
    }
    if (event is GroupImageDeleteCallEvent) {
      yield* _mapGroupImageDeleteCallEventToState(event);
    }

    if (event is CategoryListRequestCallEvent) {
      yield* _mapLoginUserDetailsCallEventToState(event);
    }

    if (event is TabProductGroupListCallEvent) {
      yield* _mapTabProductGroupCallEventToState(event);
    }

    if (event is ProductGroupDropDownRequestCallEvent) {
      yield* _mapProductGroupDropDownRequestCallEventToState(event);
    }
  }

  Stream<ProductStates> _mapProductBrandCallEventToState(
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

  Stream<ProductStates> _mapProductMasterSaveCallEventToState(
      ProductMasterSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductMasterSaveResponse response = await userRepository
          .productmastersave(event.id, /*event.imageFile,*/ event.request);

      yield ProductMasterSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductMasterPaginationCallEventToState(
      ProductMasterPaginationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductPaginationResponse response =
          await userRepository.productmasterlist(event.pageno, event.request);
      yield ProductMasterPaginationResponseState(event.pageno, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductMasterPaginationSearchCallEventToState(
      ProductMasterPaginationSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductPaginationResponse response =
          await userRepository.productmasterlist(event.pageno, event.request);
      yield ProductMasterPaginationResponseState(event.pageno, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductMasterDeleteCallEventToState(
      ProductMasterDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductMasterDeleteResponse response =
          await userRepository.productmasterdelete(event.id, event.request);
      yield ProductMasterDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductBrandSaveCallEventToState(
      ProductBrandSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandSaveResponse response =
          await userRepository.productbrandsave(event.id, event.request);
      yield ProductBrandSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductBrandDeleteCallEventToState(
      ProductBrandDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandDeleteResponse response =
          await userRepository.productbranddelete(event.id, event.request);
      yield ProductBrandDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductBrandSearchCallEventToState(
      ProductBrandSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandResponse response =
          await userRepository.productbrandsearch(event.request);
      yield ProductBrandSearchResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductBrandSearchMainCallEventToState(
      ProductBrandSearchMainCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandSearchResponse response =
          await userRepository.productbrandmainsearch(event.request);
      yield ProductBrandSearchMainResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductGroupDeleteCallEventToState(
      ProductGroupDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupDeleteResponse response =
          await userRepository.productgroupdelete(event.id, event.request);
      yield ProductGroupDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductGroupSaveCallEventToState(
      ProductGroupSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupSaveResponse response =
          await userRepository.productgroupsave(event.id, event.request);
      yield ProductGroupSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductGroupCallEventToState(
      ProductGroupCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupListResponse productGroupListResponse =
          await userRepository.productGroupListAPI(event.request);
      yield ProductGroupResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductGroupSearchCallEventToState(
      ProductGroupSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupListResponse productGroupListResponse =
          await userRepository.productGroupListAPI(event.request);
      yield ProductGroupSearchResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductUploadImageCallEventToState(
      ProductImageSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProductImageSaveResponse expenseUploadImageResponse = await userRepository
          .getuploadImageProduct(event.imageFile, event.request);

      yield ProductImageSaveResponseState(
          expenseUploadImageResponse, event.headerMsg);
    } catch (error, stacktrace) {
      print(error);
      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductImageDeleteCallEventToState(
      ProductImageDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductImageDeleteResponse productGroupListResponse =
          await userRepository.productImageDeleteAPI(event.id, event.request);
      yield ProductImageDeleteResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapBrandUploadImageCallEventToState(
      BrandUploadImageRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      BrandImageUploadResponse expenseUploadImageResponse = await userRepository
          .getBranduploadImageProduct(event.imageFile, event.request);

      yield BrandImageUploadResponseState(
          expenseUploadImageResponse, event.headerMsg);
    } catch (error, stacktrace) {
      print(error);
      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapBrandImageDeleteCallEventToState(
      BrandImageDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      BrandImageDeleteResponse productGroupListResponse =
          await userRepository.BrandImageDeleteAPI(event.id, event.request);
      yield BrandImageDeleteResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapGroupUploadImageCallEventToState(
      GroupUploadImageRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      GroupImageUploadResponse expenseUploadImageResponse = await userRepository
          .getGroupuploadImageProduct(event.imageFile, event.request);

      yield GroupImageUploadResponseState(
          expenseUploadImageResponse, event.headerMsg);
    } catch (error, stacktrace) {
      print(error);
      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapGroupImageDeleteCallEventToState(
      GroupImageDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      GroupImageDeleteResponse productGroupListResponse =
          await userRepository.GroupImageDeleteAPI(event.id, event.request);
      yield GroupImageDeleteResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapLoginUserDetailsCallEventToState(
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

  Stream<ProductStates> _mapTabProductGroupCallEventToState(
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

  Stream<ProductStates> _mapProductGroupDropDownRequestCallEventToState(
      ProductGroupDropDownRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupDropDownResponse response =
          await userRepository.ProductGroupDropDown(event.request);
      yield ProductGroupDropDownResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
