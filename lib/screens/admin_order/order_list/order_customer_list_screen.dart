import 'dart:io';
import 'dart:math';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/order/order_bloc.dart';
import 'package:grocery_app/models/api_request/order/order_customer_list_request.dart';
import 'package:grocery_app/models/api_request/order/order_delete_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/order/order_customer_list_response.dart';
import 'package:grocery_app/models/common/all_name_id.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/admin_order/order_add_edit/order_product_add_edit_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class OrderCustomerList extends BaseStatefulWidget {
  static const routeName = '/OrderCustomerList';

  @override
  _OrderCustomerListState createState() => _OrderCustomerListState();
}

class _OrderCustomerListState extends BaseState<OrderCustomerList>
    with BasicScreen, WidgetsBindingObserver {
  TextEditingController searchbar = TextEditingController();
  TextEditingController edt_LeadStatus = TextEditingController();
  TextEditingController amntcontroller = TextEditingController();
  TextEditingController vatamntcontroller = TextEditingController();
  TextEditingController totamntcontroller = TextEditingController();

  int title_color = 0xFF000000;
  int pageNo = 0;
  int selected = 0;
  OrderScreenBloc productGroupBloc;
  OrderCustomerListResponse Response;
  OrderCustomerListResponseDetails details;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];

  List<ALL_Name_ID> Arr_TotalAmountCalculationList = [];

  List<OrderCustomerListResponseDetails> arrcustomerDetails = [];

  List<String> custIdList = [];
  String navigationscreen = "";

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    edt_LeadStatus.text = "Open";
    searchbar.text = "";
    amntcontroller.text = "0.00";
    vatamntcontroller.text = "0.00";
    totamntcontroller.text = "0.00";
    LeadStatus();

    productGroupBloc = OrderScreenBloc(baseBloc);

    searchbar.clear();
    searchbar.addListener(searchlistner);

    edt_LeadStatus.addListener(() {
      productGroupBloc.add(OrderCustomerListRequestCallEvent(
          OrderCustomerListRequest(
              SearchKey: searchbar.text,
              Status: edt_LeadStatus.text,
              CompanyId: CompanyID)));
    });

    productGroupBloc
      ..add(OrderCustomerListRequestCallEvent(OrderCustomerListRequest(
          SearchKey: searchbar.text,
          Status: edt_LeadStatus.text,
          CompanyId: CompanyID)));
  }

  searchlistner() {
    productGroupBloc.add(OrderCustomerListRequestCallEvent(
        OrderCustomerListRequest(
            SearchKey: searchbar.text,
            Status: edt_LeadStatus.text,
            CompanyId: CompanyID)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc,
      child: BlocConsumer<OrderScreenBloc, OrderScreenStates>(
        builder: (BuildContext context, OrderScreenStates state) {
          if (state is OrderCustomerListResponseState) {
            productlistsuccess(state);
          }
          if (state is OrderProductListResponseForCalculationState) {
            _OnProductResponse(state, context);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is OrderCustomerListResponseState ||
              currentState is OrderProductListResponseForCalculationState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, OrderScreenStates state) {
          if (state is OrderDeleteResponseState) {
            _OnDleteOrderSucess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is OrderDeleteResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackpress,
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorWhite),
              onPressed: () {
                if (navigationscreen == "DashBoard") {
                  navigateTo(context, TabHomePage.routeName,
                      clearAllStack: true);
                } else {
                  navigateTo(context, AccountScreen.routeName,
                      clearAllStack: true);
                }
              }),
          backgroundColor: Getirblue,
          title: Text(
            "Order List",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    searchbar.clear();
                    productGroupBloc.add(OrderCustomerListRequestCallEvent(
                        OrderCustomerListRequest(
                            SearchKey: searchbar.text,
                            Status: edt_LeadStatus.text,
                            CompanyId: CompanyID)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: _buildEmplyeeListView(),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildStatusView(),
                              ),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        arrcustomerDetails.length != 0
                            ? Expanded(child: _buildInquiryList())
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      ListSearchNotFound,
                                      height: 200,
                                    ),
                                    Text(
                                      searchbar.text == ""
                                          ? "No Order Exist !"
                                          : "Search Keyword Not Matched !",
                                      style: TextStyle(
                                          color: Getirblue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmplyeeListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Search Customer",
              style: TextStyle(
                  fontSize: 12,
                  color: Getirblue,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
          Icon(
            Icons.filter_list_alt,
            color: Getirblue,
          ),
        ]),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: /* Text(
                        SelectedStatus =="" ?
                        "Tap to select Status" : SelectedStatus.Name,
                        style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),*/

                      TextField(
                    controller: searchbar,
                    /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
                    style: TextStyle(
                        color: Colors.black, // <-- Change this
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Search Customer"),
                  ),
                  // dropdown()
                ),
                /*  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )*/
              ],
            ),
          ),
        )
      ],
    );
  }

/*
  Widget buildsearch() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Search Customer",
                style: TextStyle(
                    fontSize: 12,
                    color: Getirblue,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
            Icon(
              Icons.filter_list_alt,
              color: Getirblue,
            ),
          ]),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: searchbar,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        //enabled: false,

                        //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                        decoration: InputDecoration(
                          hintText: "Tap To Search",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                        ),
                  ),
                  Icon(Icons.search),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
*/

  Widget _buildInquiryList() {
    if (arrcustomerDetails.isEmpty) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
          scrollInfo,
        )) {
          _onProductMasterPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildCustomerList(index);
        },
        shrinkWrap: true,
        itemCount: arrcustomerDetails.length,
      ),
    );
  }

  Widget _buildCustomerList(int index) {
    return ExpantionCustomer(context, index);
  }

  void _onProductMasterPagination() {
    productGroupBloc.add(OrderCustomerListRequestCallEvent(
        OrderCustomerListRequest(
            SearchKey: searchbar.text,
            Status: edt_LeadStatus.text,
            CompanyId: CompanyID)));
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    OrderCustomerListResponseDetails PD = Response.details[index];

    return Container(
      child: Column(
        children: [
          Container(
            child: ExpansionTileCard(
              initialElevation: 5.0,
              elevation: 5.0,
              elevationCurve: Curves.easeInOut,
              shadowColor: Color(0xFF504F4F),
              baseColor: Color(0xFFFCFCFC),
              expandedColor: Color(0xFFC1E0FA),
              //Colors.deepOrange[50],ADD8E6
              leading: PD.customerName != null
                  ? Image.network(
                      'https://flyclipart.com/thumb2/customer-ecommerce-icon-681338.png',
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
                        return Icon(Icons.error);
                      },
                      height: 35,
                      fit: BoxFit.fill,
                      width: 35,
                    )
                  : Icon(Icons.error),

              title: Text(
                PD.customerName,
                style: TextStyle(color: Getirblue, fontSize: 15), //8A2CE2)),
              ),

              subtitle: Text(
                "Mo. " + PD.contactNo,
                style: TextStyle(color: Colors.black, fontSize: 12), //8A2CE2)),
              ),
              children: [
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Container(
                    margin: EdgeInsets.all(20),
                    child: Container(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Email:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.emailAddress == ""
                                                ? "N/A"
                                                : Response.details[index]
                                                    .emailAddress,
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                  ]),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Address:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.address == ""
                                                ? "N/A"
                                                : PD.address,
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                  ]),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Amount:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index].NetAmount
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Vat Amount:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index].VatAmount
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                  ]),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("NetAmount:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index].NetTotal
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ))),
                ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonHeight: 52.0,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      GestureDetector(
                        /*shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),*/
                        onTap: () {
                          _onTapOfEditproduct(PD);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.edit,
                              color: colorDarkBlue,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(color: colorDarkBlue),
                            ),
                          ],
                        ),
                      ),
                      edt_LeadStatus.text == "open"
                          ? GestureDetector(
                              /*shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),*/
                              onTap: () {
                                _onTapOfDelete(
                                    Response.details[index].InvoiceNo);
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: colorDarkBlue,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: colorDarkBlue),
                                  ),
                                ],
                              ),
                            )
                          : Container()
                    ]),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  productlistsuccess(OrderCustomerListResponseState state) {
    if (pageNo != state.newpage || state.newpage == 1) {
      //checking if new data is arrived
      if (state.newpage == 1) {
        //resetting search
        Response = state.response;

        /* final jsonList =
            Response.details.map((item) => jsonEncode(item)).toList();
        final uniqueJsonList = jsonList.toSet().toList();
        final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();*/
        // Response = result;
        //Response.details.add(result);
      } else {
        Response.details.addAll(state.response.details.toSet().toList());
      }
      pageNo = state.newpage;
    }

    arrcustomerDetails.clear();
    custIdList.clear();
    for (int i = 0; i < Response.details.length; i++) {
      OrderCustomerListResponseDetails orderCustomerListResponseDetails =
          OrderCustomerListResponseDetails();
      orderCustomerListResponseDetails.InvoiceNo =
          state.response.details[i].InvoiceNo;
      orderCustomerListResponseDetails.pkID = state.response.details[i].pkID;
      orderCustomerListResponseDetails.customerID =
          state.response.details[i].customerID;
      orderCustomerListResponseDetails.customerName =
          state.response.details[i].customerName;
      orderCustomerListResponseDetails.address =
          state.response.details[i].address;
      orderCustomerListResponseDetails.contactNo =
          state.response.details[i].contactNo;
      orderCustomerListResponseDetails.emailAddress =
          state.response.details[i].emailAddress;
      orderCustomerListResponseDetails.profileImage =
          state.response.details[i].profileImage;
      orderCustomerListResponseDetails.remarks =
          state.response.details[i].remarks;
      orderCustomerListResponseDetails.NetAmount =
          state.response.details[i].NetAmount;
      orderCustomerListResponseDetails.VatAmount =
          state.response.details[i].VatAmount;
      orderCustomerListResponseDetails.NetTotal =
          state.response.details[i].NetTotal;
      arrcustomerDetails.add(orderCustomerListResponseDetails);
      custIdList.add(state.response.details[i].InvoiceNo);
    }
    // getproductdetails();

    /* productGroupBloc.add(OrderProductListRequestCalculationCallEvent(
        arrcustomerDetails[i].InvoiceNo,
        OrderProductListRequest(
            OrderNo: arrcustomerDetails[i].InvoiceNo,
            Status: edt_LeadStatus.text,
            CompanyId: CompanyID,
            CustomerType: _offlineLogindetails.details[0].customerType)));*/

    /* for (int i = 0; i < arrcustomerDetails.length; i++) {

    }*/
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

  Future<bool> _onBackpress() {
    if (navigationscreen == "DashBoard") {
      navigateTo(context, TabHomePage.routeName, clearAllStack: true);
    } else {
      navigateTo(context, AccountScreen.routeName, clearAllStack: true);
    }
  }

  _buildStatusView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        /* showcustomdialog(
            values: arr_ALL_Name_ID_For_Folowup_Status,
            context1: context,
            controller: edt_FollowupStatus,
            lable: "Select Status");*/
        // _expenseBloc.add(ExpenseTypeByNameCallEvent(ExpenseTypeAPIRequest(CompanyId: CompanyID.toString())));
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_LeadStatus,
            context1: context,
            controller: edt_LeadStatus,
            lable: "Select Lead Status");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Select Status",
                style: TextStyle(
                    fontSize: 12,
                    color: Getirblue,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
            Icon(
              Icons.filter_list_alt,
              color: Getirblue,
            ),
          ]),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: /* Text(
                        SelectedStatus =="" ?
                        "Tap to select Status" : SelectedStatus.Name,
                        style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),*/

                        TextField(
                      controller: edt_LeadStatus,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
                      style: TextStyle(
                          color: Colors.black, // <-- Change this
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 15,
                          bottom: 11,
                          top: 11,
                        ),
                        hintText: "Select",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  LeadStatus() {
    arr_ALL_Name_ID_For_LeadStatus.clear();
    for (var i = 0; i < 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Open";
      } else if (i == 1) {
        all_name_id.Name = "Closed";
      }
      arr_ALL_Name_ID_For_LeadStatus.add(all_name_id);
    }
  }

  void _onTapOfEditproduct(OrderCustomerListResponseDetails pd) {
    navigateTo(context, OrderProductAddEdit.routeName,
            arguments: AddUpdateOrderProductAddEditArguments(
                pd.customerID.toString(),
                edt_LeadStatus.text.toString(),
                pd.pkID.toString(),
                pd.InvoiceNo,
                pd))
        .then((value) {
      productGroupBloc.add(OrderCustomerListRequestCallEvent(
          OrderCustomerListRequest(
              SearchKey: searchbar.text,
              Status: edt_LeadStatus.text,
              CompanyId: CompanyID)));
      //_expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,word: edt_FollowupStatus.text,needALL: "0")));
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  void _onTapOfDelete(String pkID) {
    showCommonDialogWithTwoOptions(
      context,
      "Do you want to Delete This Order?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.pop(context);

        productGroupBloc.add(OrderDeleteRequestEvent(
            pkID, OrderDeleteRequest(CompanyId: CompanyID)));
      },
    );
  }

  void _OnDleteOrderSucess(OrderDeleteResponseState state) {
    productGroupBloc.add(OrderCustomerListRequestCallEvent(
        OrderCustomerListRequest(
            SearchKey: searchbar.text,
            Status: edt_LeadStatus.text,
            CompanyId: CompanyID)));
  }

  void _OnProductResponse(
      OrderProductListResponseForCalculationState state, BuildContext context) {
    Arr_TotalAmountCalculationList.clear();

    double amount_ = 0.00;
    double vatamnount_ = 0.00;
    double vat = 0.00;
    double totnetamnt = 0.00;
    for (int i = 0; i < state.response.details.length; i++) {
      if (state.InvoiceNo == state.response.details[i].InvoiceNo) {
        double unitrate = state.response.details[i].quantity *
            state.response.details[i].unitPrice;
        double vatamntt = unitrate * state.response.details[i].Vat / 100;
        double tot = unitrate + vatamntt;
        amount_ += unitrate;
        vatamnount_ += vatamntt;
        totnetamnt += tot;

        // ALL_Name_ID all_name_id = ALL_Name_ID();
      }
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Amount = amount_;
      all_name_id.VatAmount = vatamnount_;
      all_name_id.NetAmount = totnetamnt;
      all_name_id.InvoiceNo = state.InvoiceNo;

      Arr_TotalAmountCalculationList.add(all_name_id);
      // setState(() {});
    }

    for (int i = 0; i < Arr_TotalAmountCalculationList.length; i++) {
      print("Amounttobepaid" +
          " InvoiceNo = " +
          Arr_TotalAmountCalculationList[i].InvoiceNo +
          " Amount = " +
          Arr_TotalAmountCalculationList[i].Amount.toString() +
          " VatAmount = " +
          Arr_TotalAmountCalculationList[i].VatAmount.toString() +
          "NetAmount = " +
          Arr_TotalAmountCalculationList[i].NetAmount.toString());
    }
  }

  void getproductdetails() {
    for (int i = 0; i < custIdList.length; i++) {
      productGroupBloc.add(OrderProductListRequestCalculationCallEvent(
          custIdList[i],
          OrderProductListRequest(
              OrderNo: custIdList[i],
              Status: edt_LeadStatus.text,
              CompanyId: CompanyID,
              CustomerType: _offlineLogindetails.details[0].customerType)));
    }
  }
}

/**/

/*buildsearch(),
          SizedBox(height: 10,),
          Expanded(child: _buildInquiryList()),*/
