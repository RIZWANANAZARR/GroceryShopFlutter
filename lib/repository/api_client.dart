import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:grocery_app/models/common/globals.dart';
import 'package:grocery_app/utils/date_time_extensions.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'custom_exception.dart';
import 'error_response_exception.dart';

class ApiClient {
  ///set apis' base url here
  //static const BASE_URL = 'https://reqres.in/api/';
  //static const BASE_URL = 'http://208.109.14.134:82/';
  //static const BASE_URL = 'http://122.169.111.101:90/';
  //static const BASE_URL = 'http://122.169.111.101:6002/';/// General Flutter SerialKey = ABCD-EFGH-IJKL-MNOW / ID : admin / Pwd : Sharvaya / SiteURL : 122.169.11.101:3346
  // static const BASE_URL = 'http://122.169.111.101:6004/'; ///Dolphin Flutter SerialKey = DOLP-HIN1-FLUT-TER1 / ID : admin / Pwd : admin123 / SiteURL : 122.169.11.101:3386
  // static const BASE_URL = 'http://122.169.111.101:6003/';//Solios Flutter
  static const BASE_URL = 'http://122.169.111.101:106/'; //UK Client BaseURL

  ///add end point of your apis as below
  static const END_POINT_LOGIN = 'Login/SerialKey';

  /// end point of login User Details
  static const END_POINT_LOGIN_USER_DETAILS = 'Login';
  static const END_POINT_CATEGORY_DETAILS = 'Product/CategoryAndBrandWiseList';
  static const END_POINT_PRODUCTGROUP_DETAILS = 'ProductGroup/List';
  static const END_POINT_EXCLUSIVE_OFFER_DETAILS = 'Product/ExclusiveOffers';
  static const END_POINT_BEST_SELLING_DETAILS = 'Product/BestSelling';
  static const END_POINT_INQUIRY_PRODUCT_SAVE = "Cart/0/Save";
  static const END_POINT_CART_DELETE = "Cart/";
  static const END_POINT_CART_LIST = "Cart/List";

  static const END_POINT_Product_Master_Save = 'Product';
  static const END_POINT_Product_Master_Pagination = 'Product';
  static const END_POINT_Product_Master_Delete = 'Prouct';
  static const END_POINT_Product_Brand = 'ProductBrand/List';
  static const END_CUSTOMER_REGISTRATION = 'Customer/';
  static const END_FORGOTDETAILS = 'Customer/Forgotpassword';
  static const END_LOGINDETAILS = 'Customer/Login';
  static const END_POINT_Product_Brand_save = 'ProductBrand';
  static const END_POINT_Product_Brand_delete = 'ProductBrand';
  static const END_POINT_Product_Brand_search = 'ProductBrand/Search';
  static const END_POINT_FAVORITE_PRODUCT_SAVE = "Favourite/0/Save";
  static const END_POINT_FAVORITE_DELETE = "Favourite/";
  static const END_POINT_FAVORITE_LIST = "Favourite/List";
  static const END_POINT_Product_Group_Delete = 'ProductGroup';
  static const END_POINT_Product_Group = 'ProductGroup';
  static const END_POINT_PLACEORDER_SAVE = 'PlaceOrder/0/Save';
  static const END_POINT_PLACED_ORDER_LIST = "PlaceOrder/List";
  static const END_POINT_PRODUCT_IMAGE = "Product/UploadImage";
  static const END_POINT_TAB_PRODUCT_GROUP_LIST = "Product/BrandIdToGroupId";
  static const END_POINT_TAB_PRODUCT_LIST = "GroupID/ProductDetails";
  static const END_POINT_PRODUCT_IMAGE_DELETE = 'Product/';
  static const END_POINT_ORDER_CUSTOMER_LIST = 'PlaceOrder/CustomerList';
  static const END_POINT_ORDER_PRODUCT_LIST = 'PlaceOrder/OrderStatus';
  static const END_POINT_ORDER_PRODUCT_SAVE_LIST = 'PlaceOrderDetail';
  static const END_POINT_BRAND_IMAGE = "ProductBrand/UploadImage";
  static const END_POINT_BRAND_IMAGE_DELETE = 'ProductBrand/';
  static const END_POINT_GROUP_IMAGE = "ProductGroup/UploadImage";
  static const END_POINT_GROUP_IMAGE_DELETE = 'ProductGroup/';
  static const END_POINT_UPLOAD_PDF = "Invoice/UploadFile";
  static const END_POINT_PUSH_NOTIFICATION_URL =
      'https://fcm.googleapis.com/fcm/send';
  static const END_POINT_ORDER_HEADER_SAVE_LIST = 'PlaceOrder';
  static const END_POINT_TOKEN_SAVE = 'Token/TokenSave';
  static const END_POINT_TOKEN_LIST = 'Token/TokenList';
  static const END_POINT_PDF_LIST = 'PlaceOrder/CustPdfList';
  static const END_POINT_PROFILE_LIST = 'Customer';
  static const END_POINT_ORDER_DELETE = 'PlaceOrder';
  static const END_POINT_PLACE_ORDER_DELETE = 'PlaceOrderDetail';
  static const END_POINT_MANAGE_PAYMENT = 'Payments';
  static const END_POINT_MANAGE_PAYMENT_LIST = 'Payment';
  static const END_POINT_INWARD_LIST = 'Inward/';
  static const END_POINT_INWARD_DELETE = 'Inward/delete';
  static const END_POINT_INWARD_PRODUCT_LIST = 'InwardDetail/1-11';
  static const END_POINT_INWARD_PRODUCT_SAVE = "InwardDetail/";
  static const END_POINT_INWARD_ALL_PRODUCT_DELETE = 'Inward/Detail/Delete';
  static const END_POINT_BRANDID_GROUPID_TO_PRODUCTLIST =
      'BrnadID/GroupIDStatusList';
  static const END_POINT_ORDER_ALL_DETAIL_DELETE = 'PlaceOrderDetail/Del';
  static const END_POINT_TAB_PRODUCT_GROUP_DROP_DOWN = 'BrnadID/GroupDropDown';

  static const END_POINT_PRODUCT_REPORTING = 'ProductLedger/Report';

  final http.Client httpClient;

  ApiClient({this.httpClient});

  ///GET api call
  Future<dynamic> apiCallGet(String url, {String query = ""}) async {
    var responseJson;
    var getUrl;

    if (query.isNotEmpty) {
      getUrl = '$BASE_URL$url?$query';
    } else {
      getUrl = '$BASE_URL$url';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Api request url : $getUrl");
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print("Api request url : $getUrl\nHeaders - $headers");

    try {
      final response = await httpClient
          .get(Uri.parse(getUrl), headers: headers)
          .timeout(const Duration(seconds: 60));
      responseJson = await _response(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  ///POST api call
  Future<dynamic> apiCallPost(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = BASE_URL,
    bool showSuccessDialog = false,
    //dynamic jsontemparray,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    //String asd = json.encode(jsontemparray);
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap" /*+ "JSON Array $asd"*/);
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  /// POST API For Push Notification
  Future<dynamic> apiCallPostPushNotification(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = BASE_URL,
    bool showSuccessDialog = false,
    //dynamic jsontemparray,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Authorization':
          'key =AAAAAHm33wY:APA91bGXw_JTzeIagwOWF_Gcs3cod2YhjWiB7fz0606n97bltDfh244SqfCQb4BpxYq3qQJjg1cuEvXUAWjQo8WbX0DY7_xHcUitV46rzoMJDsH3XDQlWic7BmcDGEMztAJtq8ZDmS-b',
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    //String asd = json.encode(jsontemparray);
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap" /*+ "JSON Array $asd"*/);
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson = await _responsePushNotification(response,
          showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  Future<dynamic> apiCallPostforMultipleJSONArray(
    String url,
    dynamic jsontemparray, {
    String baseUrl = BASE_URL,
    bool showSuccessDialog = false,
    //dynamic jsontemparray,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    String asd = json.encode(jsontemparray);
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $asd" /*+ "JSON Array $asd"*/);
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body: (jsontemparray == null) ? null : json.encode(jsontemparray))
          .timeout(const Duration(seconds: 60));

      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///POST api call with multipart and multiple image

  Future<dynamic> apiCallPostMultipart(
      String url, Map<String, dynamic> requestJsonMap,
      {List<File> imageFilesToUpload,
      String baseUrl = BASE_URL,
      String imageFieldKey = "image",
      bool showSuccessDialog: false}) async {
    var responseJson;
    print("$baseUrl$url\n$requestJsonMap");
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl$url"));
    if (requestJsonMap != null) {
      request.fields.addAll(requestJsonMap);
    }
    request.headers.addAll(headers);

    if (imageFilesToUpload != null) {
      imageFilesToUpload.forEach((element) async {
        if (element != null) {
          var pic =
              await http.MultipartFile.fromPath(imageFieldKey, element.path);
          request.files.add(pic);
        }
      });
    }

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson =
          await _responseLogin(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///POST api call pagination
  Future<dynamic> apiCallPostPagination(
    String url,
    String query,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = BASE_URL,
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    var geturl;

    if (query.isNotEmpty) {
      geturl = '$BASE_URL$url/$query-10';
    } else {
      geturl = '$BASE_URL$url/0-10';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$geturl"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  /// Post api for Login_USer Details
  Future<dynamic> apiCallLoginUSerPost(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = BASE_URL,
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson =
          await _responseLogin(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  /// Post api for Login_USer Details
  Future<dynamic> apiCallCustomerPaginationPost(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = BASE_URL,
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///PUT api call with multipart and single image
  Future<dynamic> apiCallPutMultipart(
      String url, Map<String, String> requestJsonMap,
      {File imageFileToUpload, String baseUrl = BASE_URL}) async {
    var responseJson;
    print("$baseUrl$url\n$requestJsonMap");
    Map<String, String> headers = {};
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("PUT", Uri.parse("$baseUrl$url"));
    request.fields.addAll(requestJsonMap);
    request.headers.addAll(headers);

    if (imageFileToUpload != null) {
      var pic =
          await http.MultipartFile.fromPath("image", imageFileToUpload.path);
      request.files.add(pic);
    }

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = await _response(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///PUT api call with multipart and single image
  ///AWS api call
  Future<void> awsApiCallPut(
    String url,
    Map<String, String> requestJsonMap, {
    @required File imageFileToUpload,
  }) async {
    print("$url\n$requestJsonMap");
    print("Api request url : $url\nApi request params : $requestJsonMap");
    try {
      Uint8List bytes = imageFileToUpload.readAsBytesSync();

      var responseJson = await http.put(Uri.parse(url), body: bytes, headers: {
        "Content-Type":
            "image/${path.extension(imageFileToUpload.path).substring(1)}"
      });
      if (responseJson.statusCode == 200) {
        //uploaded successfully
        print("Response - ${responseJson.body}");
      } else {
        //uploading failed
        throw BadRequestException(
            "Uploading file operation failed, please try again later");
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    } catch (e) {
      print("exception e - $e");
      throw e;
    }
  }

  /*  Future<dynamic> apiCallPostMultipart(
      String url, Map<String, String> requestJsonMap,
      {List<File> imageFilesToUpload,
        String baseUrl = BASE_URL,
        String imageFieldKey = "image",
        bool showSuccessDialog: false}) async {
    var responseJson;
    print("$baseUrl$url\n$requestJsonMap");
    Map<String, String> headers = {};
    String authToken =
    SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl$url"));
    if (requestJsonMap != null) {
      request.fields.addAll(requestJsonMap);
    }
    request.headers.addAll(headers);

    if (imageFilesToUpload != null) {
      imageFilesToUpload.forEach((element) async {
        if (element != null) {
          var pic =
          await http.MultipartFile.fromPath(imageFieldKey, element.path);
          request.files.add(pic);
        }
      });
    }

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson =
      await _responseLogin(response, showSuccessDialog: showSuccessDialog);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }*/

  ///PUT api call
  Future<dynamic> apiCallPut(String url, Map<String, dynamic> requestJsonMap,
      {String baseUrl = BASE_URL, bool showSuccessDialog = false}) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}

    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .put(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));
      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///DELETE api call
  Future<dynamic> apiCallDelete(String url, Map<String, dynamic> requestJsonMap,
      {String baseUrl = BASE_URL, bool showSuccessDialog = false}) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }
    print("$baseUrl$url");

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    try {
      final response = await httpClient
          .delete(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));
      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///handling whole response
  ///decrypts response and checks for all status code error
  ///returns "data" object response if status is success

  Future<dynamic> _response(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        final data = responseJson["Data"];
        final message = responseJson["Message"];

        if (responseJson["Status"] == 1) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 2) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 3) {
          await showCommonDialogWithSingleOption(Globals.context, message,
              positiveButtonTitle: "OK");

          return data;
        }
        if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, message);
        }
        throw ErrorResponseException(null, message);
      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> _responsePushNotification(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        final data = responseJson;
        final message = responseJson;

        return data;

      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson;
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson;
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson;
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson;
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson;
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> _responseLogin(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);

        return responseJson;

      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> _responseImage(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        //final data = responseJson["details"];
        // final message = responseJson["Message"];

        /* if (responseJson["Status"] == 1) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 2) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }*/
        return responseJson;
      /* if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, message);
        }
        throw ErrorResponseException(null, message);*/
      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> apiCallGoogleGetDistance(String url,
      {String origins = "",
      String destinations = "",
      String key = "AIzaSyC8I7M35BI9V0wVOGXpLIaR7SlArdi3fso"}) async {
    var responseJson;
    var getUrl;

    if (origins.isNotEmpty) {
      getUrl = '$url?origins=$origins&destinations=$destinations&key=$key';
    } else {
      getUrl = '$url';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Api request url : $getUrl");
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print("Api request url : $getUrl\nHeaders - $headers");

    try {
      final response = await httpClient
          .get(Uri.parse(getUrl), headers: headers)
          .timeout(const Duration(seconds: 60));
      responseJson = await _responseGoogle(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> apiCallGoogleGetLocationAddress(String url,
      {String latlng = "",
      String key = "AIzaSyC8I7M35BI9V0wVOGXpLIaR7SlArdi3fso"}) async {
    var responseJson;
    var getUrl;

    if (latlng.isNotEmpty) {
      getUrl = '$url?key=$key&latlng=$latlng';
    } else {
      getUrl = '$url';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Api request url : $getUrl");
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print("Api request url : $getUrl\nHeaders - $headers");

    try {
      final response = await httpClient
          .get(Uri.parse(getUrl), headers: headers)
          .timeout(const Duration(seconds: 60));
      responseJson = await _responseGoogle(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> apiCallGoogleGet(String url,
      {String query = "",
      String key = "AIzaSyC8I7M35BI9V0wVOGXpLIaR7SlArdi3fso"}) async {
    var responseJson;
    var getUrl;

    if (query.isNotEmpty) {
      getUrl = '$url?query=$query&key=$key';
    } else {
      getUrl = '$url';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Api request url : $getUrl");
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print("Api request url : $getUrl\nHeaders - $headers");

    try {
      final response = await httpClient
          .get(Uri.parse(getUrl), headers: headers)
          .timeout(const Duration(seconds: 60));
      responseJson = await _responseGoogle(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> _responseGoogle(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        final data = responseJson; //["results"];
        //final message = responseJson["Message"];

        return data;

        if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, "RetriveDataSucess");
        }
        throw ErrorResponseException(null, "RetriveDataFail");
      case 400:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 400"; //responseJson["Message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 401"; //responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 403"; //responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 404"; //responseJson["Message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 500"; //responseJson["Message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
