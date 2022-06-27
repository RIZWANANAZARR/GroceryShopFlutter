import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_request/order/order_header_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_json_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/push_notification_service.dart';
import 'package:grocery_app/screens/account/about_us_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CheckoutBottomSheet extends BaseStatefulWidget {
  static const routeName = '/CheckoutBottomSheet';

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends BaseState<CheckoutBottomSheet>
    with BasicScreen, WidgetsBindingObserver {
  double TotalAmount;
  List<ProductCartModel> placedOrderList = [];

  CategoryScreenBloc _categoryScreenBloc;

  List<OrderProductJsonDetails> quotationProductModel = [];
  List<OrderHeaderJsonDetails> arHeaderRequestList = [];

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  int CustomerID = 0;
  String LoginUserID = "";
  String CompanyID = "";
  PushNotificationService pushNotificationService = PushNotificationService();
  String token = "";

  String Latitude = "";
  String Longitude = "";
  List<Menu> data = [];
  List dataList = [];
  /*List dataList = [
    {
      "name": "Sales",
      "icon": Icons.payment,
      "subMenu": [
        {"name": "Orders", "icon": Icons.payment},
        {"name": "Invoices", "icon": Icons.payment}
      ]
    },
  ];*/

  @override
  void initState() {
    // TODO: implement initState

    /* Menu menu = Menu();
    menu.name = "Product Details";
    menu.icon = Icons.all_inbox;
    Menu menu2 = Menu();
    menu2.name = "Product1";
    Menu menu3 = Menu();
    menu3.name = "Product2";
    List<Menu> sublist = [];
    sublist.add(menu2);
    sublist.add(menu3);

    menu.subMenu = sublist;

    dataList.add(menu);*/

    /* dataList.add(sublist);
    dataList.forEach((element) {
      data.add(Menu.fromJson(element));
    });*/
    super.initState();

    getToken123();

    print("token7up" + token.toString());
    TotalAmount = 0.00;
    Latitude = SharedPrefHelper.instance.getLatitude();
    Longitude = SharedPrefHelper.instance.getLongitude();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID;
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    getproductlistfromdbMethod();
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    placedOrderList.clear();
    data.clear();
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    placedOrderList.addAll(Tempgetproductlistfromdb);
    //getproductlistfromdb.addAll(Tempgetproductlistfromdb);
    for (int i = 0; i < Tempgetproductlistfromdb.length; i++) {
      /*TotalAmount += (Tempgetproductlistfromdb[i].UnitPrice *
          Tempgetproductlistfromdb[i].Quantity);*/
      Menu menu = Menu();
      menu.name = Tempgetproductlistfromdb[i].ProductName;
      menu.icon = Tempgetproductlistfromdb[i].ProductImage;
      menu.Quantity = Tempgetproductlistfromdb[i].Quantity.toInt().toString();

      double netamnttt = Tempgetproductlistfromdb[i].Quantity *
          Tempgetproductlistfromdb[i].UnitPrice;
      menu.Amount = netamnttt.toStringAsFixed(2);

      //print("dkfjf" + Tempgetproductlistfromdb[i].vat.toString());
      menu.VatAmount = Tempgetproductlistfromdb[i].vat == null
          ? "0.00"
          : Tempgetproductlistfromdb[i].vat.toStringAsFixed(2);

      print("45dfdf" + menu.VatAmount);
      double Vatpercent = Tempgetproductlistfromdb[i].vat == null
          ? 0.00
          : Tempgetproductlistfromdb[i].vat;
      print("45dfdf676767" + Vatpercent.toString());

      double netamnt = (netamnttt * Vatpercent) / 100;
      double tot = netamnttt + netamnt;

      menu.TotalAmount = tot.toStringAsFixed(2);
      TotalAmount += tot;
      data.add(menu);
      setState(() {});
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          /*if(state is ProductCartResponseState)
            {


              _onCartListResponse(state,context);
            }*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {
          if (state is OrderHeaderResponseState) {
            _onHeaderResponse(state, context);
          }
          if (state is OrderProductJsonSaveResponseState) {
            _onPlaceOrderSucessResponse(state, context);
          }
          if (state is CartDeleteResponseState) {
            _ondeleteCartFromAPIResponse(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is OrderHeaderResponseState ||
              currentState is OrderProductJsonSaveResponseState ||
              currentState is CartDeleteResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 30,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: new Wrap(
          children: <Widget>[
            Row(
              children: [
                AppText(
                  text: "Order Summary",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 25,
                    ))
              ],
            ),
            SizedBox(
              height: 45,
            ),
            getDivider(),
            //checkoutRow("Product Details", trailingText: "By Delivery Boy"),

            /* ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _buildList(data[index]);
              },
            ),*/
            _buildList(data),
            getDivider(),
            checkoutRow("Delivery", trailingText: "By Delivery Boy"),
            getDivider(),
            checkoutRow("Payment",
                trailingText:
                    "Cash On Delivery" /*trailingWidget: Icon(Icons.payment)*/),
            getDivider(),
            /* checkoutRow("Promo Code", trailingText: "Pick Discount"),
            getDivider(),*/
            checkoutRow("Total Cost",
                trailingText: "\£" + TotalAmount.toStringAsFixed(2)),
            getDivider(),
            SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: () {
                  navigateTo(context, AboutUsDialogue.routeName);
                },
                child: termsAndConditionsAgreement(context)),
            Container(
              margin: EdgeInsets.only(
                top: 25,
              ),
              child: AppButton(
                label: "Submit Order",
                fontWeight: FontWeight.w600,
                padding: EdgeInsets.symmetric(
                  vertical: 25,
                ),
                onPressed: () {
                  onPlaceOrderHeaderRequest(TotalAmount);

                  //onPlaceOrderClicked();
                  /*_categoryScreenBloc.add(PushNotificationRequestCallEvent(
                      PushNotificationRequest(
                          to: token,
                          notification: notificationParam,
                          data: dataparam)));*/
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendPushMessage(
      String _token, String OrderNo123, String HeaderMsg) async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Authorization':
              'key =AAAAAHm33wY:APA91bGXw_JTzeIagwOWF_Gcs3cod2YhjWiB7fz0606n97bltDfh244SqfCQb4BpxYq3qQJjg1cuEvXUAWjQo8WbX0DY7_xHcUitV46rzoMJDsH3XDQlWic7BmcDGEMztAJtq8ZDmS-b',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token, OrderNo123, HeaderMsg),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  Widget getDivider() {
    return Divider(
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }

  Widget termsAndConditionsAgreement(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: 'By placing an order you agree to our',
          style: TextStyle(
            color: Color(0xFF7C7C7C),
            fontSize: 14,
            fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
                text: " Terms",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            TextSpan(text: " And"),
            TextSpan(
                text: " Conditions",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ]),
    );
  }

  Widget checkoutRow(String label,
      {String trailingText, Widget trailingWidget}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 15,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: AppText(
              text: label,
              fontSize: 15,
              color: Color(0xFF7C7C7C),
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          trailingText == null
              ? trailingWidget
              : AppText(
                  text: trailingText,
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  onPlaceOrderClicked(
      String retrunPKID, String returnOrderNo, String returnMsg) {
    for (int i = 0; i < placedOrderList.length; i++) {
      OrderProductJsonDetails orderProductJsonDetails =
          OrderProductJsonDetails();
      orderProductJsonDetails.productID = placedOrderList[i].ProductID;
      orderProductJsonDetails.pkID = 0;
      orderProductJsonDetails.unit = placedOrderList[i].Unit;
      orderProductJsonDetails.unitPrice = placedOrderList[i].UnitPrice;
      // orderProductJsonDetails.productImage = placedOrderList[i].ProductImage;
      orderProductJsonDetails.discountPercent =
          placedOrderList[i].DiscountPercent;
      // orderProductJsonDetails.status = "open";
      orderProductJsonDetails.dispatchQuantity = 0;

      orderProductJsonDetails.quantity = placedOrderList[i].Quantity.toDouble();
      //orderProductJsonDetails.remarks = "";
      orderProductJsonDetails.loginUserID = LoginUserID.toString();
      orderProductJsonDetails.companyId = int.parse(CompanyID);
      //orderProductJsonDetails.InvoiceNo = "";

      orderProductJsonDetails.InvoiceDate = formattedDate();
      orderProductJsonDetails.DeliveryDate = formattedDate();

      double Total = placedOrderList[i].Quantity * placedOrderList[i].UnitPrice;
      orderProductJsonDetails.NetAmount = Total;
      orderProductJsonDetails.NetRate = 0;
      orderProductJsonDetails.Vat =
          placedOrderList[i].vat == null ? 0.00 : placedOrderList[i].vat;

      double vat334 =
          placedOrderList[i].vat == null ? 0.00 : placedOrderList[i].vat;
      // print("Dfkdkf" + " Vat Null  : " + placedOrderList[i].vat.toString());

      orderProductJsonDetails.VatAmount = Total * vat334 / 100;
      orderProductJsonDetails.Remarks = "";
      print("fdfdffdf56" +
          " Vat Null  : " +
          orderProductJsonDetails.VatAmount.toString());
      quotationProductModel.add(orderProductJsonDetails);
    }

    _categoryScreenBloc.add(OrderProductJsonDetailsSaveCallEvent(
        context, returnOrderNo, returnMsg, quotationProductModel));
  }

  void _onPlaceOrderSucessResponse(
      OrderProductJsonSaveResponseState state, BuildContext context) async {
    await OfflineDbHelper.getInstance().deleteContactTable();

    _categoryScreenBloc.add(CartDeleteRequestCallEvent(
        CustomerID, CartDeleteRequest(CompanyID: CompanyID)));

    sendPushMessage(token, state.pkID, state.headerMsg);

    await showCommonDialogWithSingleOption(context,
        /*state.response.details[0].column2*/ "Order Successfully placed! ",
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      navigateTo(context, TabHomePage.routeName, clearSingleStack: true);
    });
  }

  Widget commonalertbox(String msg,
      {GestureTapCallback onTapofPositive, bool useRootNavigator = true}) {
    showDialog(
        context: context,
        builder: (BuildContext ab) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 10,
            actions: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Getirblue, width: 2.00),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Alert!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Getirblue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.center,
                //margin: EdgeInsets.only(left: 10),
                child: Text(
                  msg,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 1.00,
                thickness: 2.00,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: onTapofPositive ??
                    () {
                      Navigator.of(context, rootNavigator: useRootNavigator)
                          .pop();
                    },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  void _ondeleteCartFromAPIResponse(CartDeleteResponseState state) {
    print("CartDeleteAPI" +
        " DeleteResponse " +
        state.cartDeleteResponse.details[0].column1.toString());
  }

  String formattedDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  void _onreceviedPushNotification(PushNotificationResponseState state) {
    print("NotificaationResponse" + state.response.success.toString());
  }

  void getToken123() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  String constructFCMPayload(
      String token, String OrderNo213, String HeaderMsg123) {
    /*NotificationParam notificationParam = NotificationParam();
                notificationParam.body = "Test123";
                notificationParam.title = "Inquiry";

                DataParam dataparam = DataParam();
                dataparam.body = "NOV-2021";
                dataparam.title = "Inquiry";
                dataparam.clickAction = "FLUTTER_NOTIFICATION_CLICK";*/
    return jsonEncode({
      'to': token,
      'data': {
        "body": "Your Order Placed Successfully",
        "title": OrderNo213,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      'notification': {
        "body": "Your Order Placed Successfully",
        "title": OrderNo213
      },
    });
  }

  void onPlaceOrderHeaderRequest(double totalAmount) {
    arHeaderRequestList.clear();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String OrderDate = formatter.format(now);

    OrderHeaderJsonDetails orderHeaderJsonDetails = OrderHeaderJsonDetails();

    orderHeaderJsonDetails.pkID = "0";
    orderHeaderJsonDetails.OrderNo = "";
    orderHeaderJsonDetails.OrderDate = OrderDate;
    orderHeaderJsonDetails.CustomerID =
        _offlineLogindetails.details[0].customerID.toString();
    orderHeaderJsonDetails.Latitude = Latitude;
    orderHeaderJsonDetails.Longitude = Longitude;
    orderHeaderJsonDetails.DeliveryDate = OrderDate;
    orderHeaderJsonDetails.BasicAmt = totalAmount.toStringAsFixed(2);
    orderHeaderJsonDetails.DiscountAmt = "0";
    orderHeaderJsonDetails.Remarks = "";
    orderHeaderJsonDetails.NetAmt = totalAmount.toStringAsFixed(2);
    orderHeaderJsonDetails.LoginUserID = LoginUserID;
    orderHeaderJsonDetails.CompanyId = CompanyID;

    arHeaderRequestList.add(orderHeaderJsonDetails);

    showCommonDialogWithTwoOptions(
      context,
      "Do You Want To Submit ? ",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.pop(context);
        _categoryScreenBloc.add(OrderHeaderJsonDetailsSaveCallEvent(
            context, "0", arHeaderRequestList));
      },
    );
  }

  void _onHeaderResponse(OrderHeaderResponseState state, BuildContext context) {
    String ReturnMsg = state.response.details[0].column2;
    String RetrunPKID = state.response.details[0].column3;

    String ReturnOrderNo = state.response.details[0].column4;

    print("HeaderResponse" +
        " PKID : " +
        RetrunPKID +
        " OrderNo : " +
        ReturnOrderNo);
    onPlaceOrderClicked(RetrunPKID, ReturnOrderNo, ReturnMsg);
  }

  Widget _buildList(List<Menu> list) {
    return ExpansionTile(
      title: Text(
        "Product Details",
        style: TextStyle(fontSize: 15, color: Getirblue),
      ),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        data[index].icon,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return child;
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          return Image.asset(
                            NO_IMAGE_FOUND,
                            height: 35,
                            width: 35,
                          );
                        },
                        height: 35,
                        fit: BoxFit.fill,
                        width: 35,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        list[index].name,
                        style: TextStyle(
                            color: Getirblue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 50, right: 10, top: 5, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Qty : ",
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text(
                                      list[index].Quantity,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "Amount : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text(
                                      list[index].Amount,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "VAT % : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text(
                                      list[index].VatAmount,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "Total : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text(
                                      list[index].TotalAmount,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  index < list.length
                      ? Container()
                      : Container() //Divider(thickness: 2)
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class Menu {
  String name;
  String icon;
  String Amount;
  String VatAmount;
  String Quantity;
  String TotalAmount;

  List<Menu> subMenu = [];

  Menu(
      {this.name,
      this.icon,
      this.Amount,
      this.VatAmount,
      this.Quantity,
      this.subMenu,
      this.TotalAmount});

  Menu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    if (json['subMenu'] != null) {
      subMenu.clear();
      json['subMenu'].forEach((v) {
        subMenu?.add(new Menu.fromJson(v));
      });
    }
  }
}
