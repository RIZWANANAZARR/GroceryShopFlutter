import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app/models/api_request/BestSelling/best_selling_list_request.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_forgot_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_registration_request.dart';
import 'package:grocery_app/models/api_request/Exclusive_Offer/exclusive_offer_list_request.dart';
import 'package:grocery_app/models/api_request/Inward/Inward_header_save_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_all_product_delete_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_delete_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_list_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_product_list_request.dart';
import 'package:grocery_app/models/api_request/ManagePayment/manage_payment_list_request.dart';
import 'package:grocery_app/models/api_request/ManagePayment/manage_payment_save_request.dart';
import 'package:grocery_app/models/api_request/Place_order/place_order_delete_request.dart';
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
import 'package:grocery_app/models/api_request/ProductReporting/product_reporting_list_request.dart';
import 'package:grocery_app/models/api_request/Profile/profile_delete_request.dart';
import 'package:grocery_app/models/api_request/Profile/profile_list_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_group_list_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_list_from_brandID_groupID_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_list_request.dart';
import 'package:grocery_app/models/api_request/Token/token_Save_request.dart';
import 'package:grocery_app/models/api_request/Token/token_list_request.dart';
import 'package:grocery_app/models/api_request/company_details_request.dart';
import 'package:grocery_app/models/api_request/login_user_details_api_request.dart';
import 'package:grocery_app/models/api_request/order/order_all_detail_delete_request.dart';
import 'package:grocery_app/models/api_request/order/order_customer_list_request.dart';
import 'package:grocery_app/models/api_request/order/order_delete_request.dart';
import 'package:grocery_app/models/api_request/order/order_header_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_json_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_list_request.dart';
import 'package:grocery_app/models/api_request/pdf_list/pdf_list_request.dart';
import 'package:grocery_app/models/api_request/pdf_upload/pdf_upload_request.dart';
import 'package:grocery_app/models/api_request/product_brand/brand_image_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/brand_upload_image_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_save_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_seach_request.dart';
import 'package:grocery_app/models/api_request/push_notification/push_notification_request.dart';
import 'package:grocery_app/models/api_response/BestSelling/best_selling_list_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_delete_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_save_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/product_cart_list_response.dart';
import 'package:grocery_app/models/api_response/Category/category_list_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_forgot_respons.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_registration_response.dart';
import 'package:grocery_app/models/api_response/Exclusive_Offer/exclusive_offer_list_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_all_product_delete_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_delete_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_header_save_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_list_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_product_list_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_product_save_response.dart';
import 'package:grocery_app/models/api_response/ManagePayment/manage_payment_list_response.dart';
import 'package:grocery_app/models/api_response/ManagePayment/manage_payment_save_response.dart';
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
import 'package:grocery_app/models/api_response/ProductReporting/product_reporting_list_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_delete_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_list_response.dart';
import 'package:grocery_app/models/api_response/Tab_List/tab_product_group_list_response.dart';
import 'package:grocery_app/models/api_response/Tab_List/tab_product_list_responset.dart';
import 'package:grocery_app/models/api_response/Token/token_Save_response.dart';
import 'package:grocery_app/models/api_response/Token/token_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/customer_placed_order/customer_placed_order_response.dart';
import 'package:grocery_app/models/api_response/login_user_details_api_response.dart';
import 'package:grocery_app/models/api_response/order/order_all_detail_delete_response.dart';
import 'package:grocery_app/models/api_response/order/order_customer_list_response.dart';
import 'package:grocery_app/models/api_response/order/order_delete_response.dart';
import 'package:grocery_app/models/api_response/order/order_header_response.dart';
import 'package:grocery_app/models/api_response/order/order_product_json_response.dart';
import 'package:grocery_app/models/api_response/order/order_product_list_response.dart';
import 'package:grocery_app/models/api_response/pdf_list/pdf_list_response.dart';
import 'package:grocery_app/models/api_response/pdf_upload/pdf_upload_response.dart';
import 'package:grocery_app/models/api_response/place_order/place_order_delete_response.dart';
import 'package:grocery_app/models/api_response/product_brand/brand_image_delete_response.dart';
import 'package:grocery_app/models/api_response/product_brand/brand_upload_image_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_delete_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_save_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_search.dart';
import 'package:grocery_app/models/api_response/push_notification/push_notification_response.dart';
import 'package:grocery_app/models/database_models/InwardProductModel.dart';
import 'package:grocery_app/repository/api_client.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import 'error_response_exception.dart';

class Repository {
  SharedPrefHelper prefs = SharedPrefHelper.instance;
  final ApiClient apiClient;

  Repository({@required this.apiClient});

  static Repository getInstance() {
    return Repository(apiClient: ApiClient(httpClient: http.Client()));
  }

  ///add your functions of api calls as below

/*  Future<CompanyDetailsResponse> CompanyDetailsCallApi(CompanyDetailsApiRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGIN, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      CompanyDetailsResponse companyDetailsResponse =
      CompanyDetailsResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }*/

  ///Login USer APi Details as below
  Future<LoginUserDetialsResponse> loginUserDetailsCall(
      LoginUserDetialsAPIRequest loginUserDetialsAPIRequest) async {
    try {
      /*  String jsonString = await apiClient.apiCallLoginUSerPost(
          */ /*ApiClient.END_POINT_LOGIN_USER_DETAILS*/ /*
          "Login/" + loginUserDetialsAPIRequest.companyId.toString(),
          loginUserDetialsAPIRequest.toJson());
      print("json - $jsonString");
      List<dynamic> list = json.decode(jsonString);*/
      //return LoginUserDetials.fromJson(list[0]);

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGIN_USER_DETAILS +
              "/" +
              loginUserDetialsAPIRequest.companyId.toString(),
          loginUserDetialsAPIRequest.toJson());
      LoginUserDetialsResponse loginUserDetialsResponse =
          LoginUserDetialsResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CompanyDetailsResponse> CompanyDetailsCallApi(
      CompanyDetailsApiRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGIN, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      CompanyDetailsResponse companyDetailsResponse =
          CompanyDetailsResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerRegistrationResponse> CustomerRegistrationAPI(
      int pkID, CustomerRegistrationRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_CUSTOMER_REGISTRATION + pkID.toString() + "/Save",
          companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      CustomerRegistrationResponse companyDetailsResponse =
          CustomerRegistrationResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CategoryListResponse> categoryListAPI(
      CategoryListRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CATEGORY_DETAILS,
          loginUserDetialsAPIRequest.toJson());
      CategoryListResponse loginUserDetialsResponse =
          CategoryListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExclusiveOfferListResponse> ExcluSiveListAPI(
      ExclusiveOfferListRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXCLUSIVE_OFFER_DETAILS,
          loginUserDetialsAPIRequest.toJson());
      ExclusiveOfferListResponse loginUserDetialsResponse =
          ExclusiveOfferListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BestSellingListResponse> BestSellingListAPI(
      BestSellingListRequest bestSellingListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BEST_SELLING_DETAILS,
          bestSellingListRequest.toJson());
      BestSellingListResponse loginUserDetialsResponse =
          BestSellingListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryProductSaveResponse> inquiryProductSaveDetails(
      List<CartModel> inquiryProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_INQUIRY_PRODUCT_SAVE, inquiryProductModel);
      InquiryProductSaveResponse inquiryProductSaveResponse =
          InquiryProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InwardProductSaveResponse> inwardProductSaveDetails(
      String inwardNo, List<InWardProductModel> inquiryProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_INWARD_PRODUCT_SAVE + "0/Save",
              inquiryProductModel);
      InwardProductSaveResponse inquiryProductSaveResponse =
          InwardProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryProductSaveResponse> placeOrderSaveDetails(
      List<CartModel> inquiryProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_PLACEORDER_SAVE, inquiryProductModel);
      InquiryProductSaveResponse inquiryProductSaveResponse =
          InquiryProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryProductSaveResponse> inquiryFavoriteProductSaveDetails(
      List<CartModel> inquiryProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_FAVORITE_PRODUCT_SAVE, inquiryProductModel);
      InquiryProductSaveResponse inquiryProductSaveResponse =
          InquiryProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CartDeleteResponse> CartDeleteAPI(
      int CustomerID, CartDeleteRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CART_DELETE + CustomerID.toString() + "/Del",
          loginUserDetialsAPIRequest.toJson());
      CartDeleteResponse loginUserDetialsResponse =
          CartDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CartDeleteResponse> FavoriteDeleteAPI(
      int CustomerID, CartDeleteRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FAVORITE_DELETE + CustomerID.toString() + "/Del",
          loginUserDetialsAPIRequest.toJson());
      CartDeleteResponse loginUserDetialsResponse =
          CartDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductCartListResponse> ProductCartListAPI(
      ProductCartDetailsRequest productCartDetailsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CART_LIST, productCartDetailsRequest.toJson());
      ProductCartListResponse loginUserDetialsResponse =
          ProductCartListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PlacedOrderListResponse> PlacedOrderListAPI(
      ProductCartDetailsRequest productCartDetailsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PLACED_ORDER_LIST,
          productCartDetailsRequest.toJson());
      PlacedOrderListResponse loginUserDetialsResponse =
          PlacedOrderListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductCartListResponse> ProductFavoriteListAPI(
      ProductCartDetailsRequest productCartDetailsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FAVORITE_LIST,
          productCartDetailsRequest.toJson());
      ProductCartListResponse loginUserDetialsResponse =
          ProductCartListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductMasterSaveResponse> productmastersave(
      int id,
      /*File imageFile,*/
      ProductMasterSaveRequest productMasterSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Master_Save}/$id/Save',
          productMasterSaveRequest.toJson());

      /*  await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_Product_Master_Save,productMasterSaveRequest.toJson(),imageFilesToUpload: [imageFile]);*/

      ProductMasterSaveResponse response =
          ProductMasterSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductPaginationResponse> productmasterlist(
      int pageno, ProductPaginationRequest paginationRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Master_Pagination}/$pageno-10000000',
          paginationRequest.toJson());
      ProductPaginationResponse response =
          ProductPaginationResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ManagePaymentListResponse> managePaymentListAPI(
      int pageno, ManagePaymentListRequest paginationRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_MANAGE_PAYMENT_LIST}/$pageno-11',
          paginationRequest.toJson());
      ManagePaymentListResponse response =
          ManagePaymentListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OrderAllDetailDeleteResponse> orderAllDetailDeleteAPI(
      OrderAllDetailDeleteRequest paginationRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_ORDER_ALL_DETAIL_DELETE}',
          paginationRequest.toJson());
      OrderAllDetailDeleteResponse response =
          OrderAllDetailDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductMasterDeleteResponse> productmasterdelete(
      int id, ProductPaginationDeleteRequest paginationDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Master_Delete}/$id/Del',
          paginationDeleteRequest.toJson(),
          showSuccessDialog: true);
      ProductMasterDeleteResponse response =
          ProductMasterDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandResponse> productbrand(
      ProductBrandListRequest productBrandListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_Brand, productBrandListRequest.toJson());
      ProductBrandResponse response = ProductBrandResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TabProductGroupListResponse> TabproductGroupAPI(
      TabProductGroupListRequest productBrandListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TAB_PRODUCT_GROUP_LIST,
          productBrandListRequest.toJson());
      TabProductGroupListResponse response =
          TabProductGroupListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupDropDownResponse> ProductGroupDropDown(
      ProductGroupDropDownRequest productBrandListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TAB_PRODUCT_GROUP_DROP_DOWN,
          productBrandListRequest.toJson());
      ProductGroupDropDownResponse response =
          ProductGroupDropDownResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TabProductListResponse> TabproductListAPI(
      TabProductListRequest productBrandListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TAB_PRODUCT_LIST,
          productBrandListRequest.toJson());
      TabProductListResponse response = TabProductListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TabProductListResponse> TabproductListBrandIDGroupIDAPI(
      TabProductListBrandIDGroupIDRequest productBrandListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BRANDID_GROUPID_TO_PRODUCTLIST,
          productBrandListRequest.toJson());
      TabProductListResponse response = TabProductListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandResponse> productbrandFromTabScreen(
      ProductBrandListRequest productBrandListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_Brand, productBrandListRequest.toJson());
      ProductBrandResponse response = ProductBrandResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ForgotResponse> ForgotAPI(
      ForgotRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_FORGOTDETAILS, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      ForgotResponse companyDetailsResponse = ForgotResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> LoginAPI(LoginRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_LOGINDETAILS, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      LoginResponse companyDetailsResponse = LoginResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandSaveResponse> productbrandsave(
      int id, ProductBrandSaveRequest productBrandSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Brand_save}/$id/Save',
          productBrandSaveRequest.toJson());
      ProductBrandSaveResponse response =
          ProductBrandSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandDeleteResponse> productbranddelete(
      int id, ProductBrandDeleteRequest productBrandDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Brand_delete}/$id/Delete',
          productBrandDeleteRequest.toJson(),
          showSuccessDialog: true);
      ProductBrandDeleteResponse response =
          ProductBrandDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandResponse> productbrandsearch(
      ProductBrandSearchRequest productBrandSearchRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_Brand_search,
          productBrandSearchRequest.toJson());
      ProductBrandResponse response = ProductBrandResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandSearchResponse> productbrandmainsearch(
      ProductBrandSearchRequest productBrandSearchRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_Brand_search,
          productBrandSearchRequest.toJson());
      ProductBrandSearchResponse response =
          ProductBrandSearchResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupDeleteResponse> productgroupdelete(
      int id, ProductGroupDeleteRequest productGroupDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Group_Delete}/$id/Del',
          productGroupDeleteRequest.toJson(),
          showSuccessDialog: true);
      ProductGroupDeleteResponse response =
          ProductGroupDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupSaveResponse> productgroupsave(
      int id, ProductGroupSaveRequest productGroupSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Group}/$id/Save',
          productGroupSaveRequest.toJson());
      ProductGroupSaveResponse response =
          ProductGroupSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupListResponse> productGroupListAPI(
      ProductGroupListRequest productGroupListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCTGROUP_DETAILS,
          productGroupListRequest.toJson());
      ProductGroupListResponse productGroupListResponse =
          ProductGroupListResponse.fromJson(json);
      return productGroupListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupListResponse> productGroupListDashboardAPI(
      ProductGroupListRequest productGroupListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCTGROUP_DETAILS,
          productGroupListRequest.toJson());
      ProductGroupListResponse productGroupListResponse =
          ProductGroupListResponse.fromJson(json);
      return productGroupListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PushNotificationResponse> PushNotificationAPI(
      PushNotificationRequest productGroupListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostPushNotification(
          ApiClient.END_POINT_PUSH_NOTIFICATION_URL,
          productGroupListRequest.toJson());
      PushNotificationResponse productGroupListResponse =
          PushNotificationResponse.fromJson(json);
      return productGroupListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductImageDeleteResponse> productImageDeleteAPI(
      int pkId, ProductImageDeleteRequest productGroupListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCT_IMAGE_DELETE +
              pkId.toString() +
              "/DeleteImage",
          productGroupListRequest.toJson());
      ProductImageDeleteResponse productGroupListResponse =
          ProductImageDeleteResponse.fromJson(json);
      return productGroupListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BrandImageDeleteResponse> BrandImageDeleteAPI(
      int pkId, BrandImageDeleteRequest productGroupListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BRAND_IMAGE_DELETE +
              pkId.toString() +
              "/DeleteImage",
          productGroupListRequest.toJson());
      BrandImageDeleteResponse productGroupListResponse =
          BrandImageDeleteResponse.fromJson(json);
      return productGroupListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<GroupImageDeleteResponse> GroupImageDeleteAPI(
      int pkId, GroupImageDeleteRequest productGroupListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_GROUP_IMAGE_DELETE +
              pkId.toString() +
              "/DeleteImage",
          productGroupListRequest.toJson(),
          showSuccessDialog: true);
      GroupImageDeleteResponse productGroupListResponse =
          GroupImageDeleteResponse.fromJson(json);
      return productGroupListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductImageSaveResponse> getuploadImageProduct(File imagesfiles,
      ProductImageSaveRequest expenseUploadImageAPIRequest) async {
    try {
      Map<String, dynamic> jsons = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_PRODUCT_IMAGE,
          expenseUploadImageAPIRequest.toJson(),
          imageFilesToUpload: [imagesfiles]);
      print(jsons);
      ProductImageSaveResponse response =
          ProductImageSaveResponse.fromJson(jsons);

      return response;
    } on ErrorResponseException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<BrandImageUploadResponse> getBranduploadImageProduct(File imagesfiles,
      BrandUploadImageRequest expenseUploadImageAPIRequest) async {
    try {
      Map<String, dynamic> jsons = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_BRAND_IMAGE,
          expenseUploadImageAPIRequest.toJson(),
          imageFilesToUpload: [imagesfiles]);
      print(jsons);
      BrandImageUploadResponse response =
          BrandImageUploadResponse.fromJson(jsons);

      return response;
    } on ErrorResponseException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<GroupImageUploadResponse> getGroupuploadImageProduct(File imagesfiles,
      GroupUploadImageRequest expenseUploadImageAPIRequest) async {
    try {
      Map<String, dynamic> jsons = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_GROUP_IMAGE,
          expenseUploadImageAPIRequest.toJson(),
          imageFilesToUpload: [imagesfiles]);
      print(jsons);
      GroupImageUploadResponse response =
          GroupImageUploadResponse.fromJson(jsons);

      return response;
    } on ErrorResponseException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<OrderCustomerListResponse> ordercustomerListAPI(
      OrderCustomerListRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ORDER_CUSTOMER_LIST,
          loginUserDetialsAPIRequest.toJson());
      OrderCustomerListResponse loginUserDetialsResponse =
          OrderCustomerListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OrderProductListResponse> orderProductListAPI(
      OrderProductListRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ORDER_PRODUCT_LIST,
          loginUserDetialsAPIRequest.toJson());
      OrderProductListResponse loginUserDetialsResponse =
          OrderProductListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OrderProductJsonSaveResponse> quotationProductSaveDetails(
      String pkID, List<OrderProductJsonDetails> quotationProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              "${ApiClient.END_POINT_ORDER_PRODUCT_SAVE_LIST}/$pkID/Save",
              quotationProductModel);
      OrderProductJsonSaveResponse inquiryProductSaveResponse =
          OrderProductJsonSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OrderHeaderResponse> quotationHeaderSaveDetails(
      String pkID, List<OrderHeaderJsonDetails> quotationProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              "${ApiClient.END_POINT_ORDER_HEADER_SAVE_LIST}/$pkID/Save",
              quotationProductModel);
      OrderHeaderResponse inquiryProductSaveResponse =
          OrderHeaderResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PdfUploadResponse> pdfUploadApi(
      File imagesfiles, PdfUploadRequest expenseUploadImageAPIRequest) async {
    try {
      Map<String, dynamic> jsons = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_UPLOAD_PDF, expenseUploadImageAPIRequest.toJson(),
          imageFilesToUpload: [imagesfiles]);
      //print(jsons);
      PdfUploadResponse response = PdfUploadResponse.fromJson(jsons);

      return response;
    } on ErrorResponseException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<TokenSaveResponse> TokenSaveAPI(
      TokenSaveApiRequest tokenSaveApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TOKEN_SAVE, tokenSaveApiRequest.toJson());
      TokenSaveResponse loginUserDetialsResponse =
          TokenSaveResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PDFListResponse> PDFListAPI(PdfListRequest tokenSaveApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PDF_LIST, tokenSaveApiRequest.toJson());
      PDFListResponse loginUserDetialsResponse = PDFListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProfileListResponse> ProfileListAPI(
      int pageno, ProfileListRequest profileListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_PROFILE_LIST}/$pageno-11',
          profileListRequest.toJson());
      ProfileListResponse loginUserDetialsResponse =
          ProfileListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProfileDeleteResponse> ProfileDeleteAPI(
      int pkID, ProfileDeleteRequest profileListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_PROFILE_LIST}/$pkID/Delete',
          profileListRequest.toJson(),
          showSuccessDialog: true);
      ProfileDeleteResponse loginUserDetialsResponse =
          ProfileDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OrderDeleteResponse> OrderDeleteAPI(
      String pkID, OrderDeleteRequest profileListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_ORDER_DELETE}/$pkID/Del',
          profileListRequest.toJson(),
          showSuccessDialog: true);
      OrderDeleteResponse loginUserDetialsResponse =
          OrderDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PlaceOrderDeleteResponse> PlaceOrderDeleteAPI(
      String pkID, PlaceOrderDeleteRequest profileListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_PLACE_ORDER_DELETE}/$pkID/Del',
          profileListRequest.toJson());
      PlaceOrderDeleteResponse loginUserDetialsResponse =
          PlaceOrderDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ManagePaymentSaveResponse> ManagePaymentSaveAPI(
      String pkID, ManagePaymentSaveRequest profileListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_MANAGE_PAYMENT}/$pkID/ManagePayments',
          profileListRequest.toJson());
      ManagePaymentSaveResponse loginUserDetialsResponse =
          ManagePaymentSaveResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TokenListResponse> TokenListAPI(
      TokenListApiRequest tokenSaveApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TOKEN_LIST, tokenSaveApiRequest.toJson());
      TokenListResponse loginUserDetialsResponse =
          TokenListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InwardListResponse> inwardListAPI(
      int pageNo, InwardListRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INWARD_LIST + pageNo.toString() + "-100",
          loginUserDetialsAPIRequest.toJson());
      InwardListResponse loginUserDetialsResponse =
          InwardListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InwardHeaderSaveResponse> inwardHeaderSaveAPI(
      int pkID, InwardHeaderSaveRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INWARD_LIST + pkID.toString() + "/Save",
          loginUserDetialsAPIRequest.toJson());
      InwardHeaderSaveResponse loginUserDetialsResponse =
          InwardHeaderSaveResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InwardDeleteResponse> inwardDeleteAPI(
      InwardDeleteRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INWARD_DELETE,
          loginUserDetialsAPIRequest.toJson(),
          showSuccessDialog: true);
      InwardDeleteResponse loginUserDetialsResponse =
          InwardDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InwardALLProductDeleteResponse> inwardALLProductDeleteAPI(
      InwardAllProductDeleteRequest loginUserDetialsAPIRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INWARD_ALL_PRODUCT_DELETE,
          loginUserDetialsAPIRequest.toJson());
      InwardALLProductDeleteResponse loginUserDetialsResponse =
          InwardALLProductDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InwardProductListResponse> InwardProductListAPI(
      InwardProductListRequest inwardProductListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INWARD_PRODUCT_LIST,
          inwardProductListRequest.toJson());
      InwardProductListResponse loginUserDetialsResponse =
          InwardProductListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductReportingListResponse> productreportingApi(
      ProductReportingListRequest inwardProductListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCT_REPORTING,
          inwardProductListRequest.toJson());
      ProductReportingListResponse loginUserDetialsResponse =
          ProductReportingListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }
}
