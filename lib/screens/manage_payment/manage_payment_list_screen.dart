import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/order/order_bloc.dart';
import 'package:grocery_app/bloc/others/product/product_bloc.dart';
import 'package:grocery_app/models/api_request/ManagePayment/manage_payment_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ManagePayment/manage_payment_list_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_group/product_group_add.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/date_time_extensions.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class ManagePaymentPagination extends BaseStatefulWidget {
  static const routeName = '/ManagePaymentPagination';
  @override
  _ManagePaymentPaginationState createState() =>
      _ManagePaymentPaginationState();
}

class _ManagePaymentPaginationState extends BaseState<ManagePaymentPagination>
    with BasicScreen, WidgetsBindingObserver {
  TextEditingController searchbar = TextEditingController();
  int title_color = 0xFF000000;
  int pageNo = 0;
  int selected = 0;
  int delid = 0;

  OrderScreenBloc productGroupBloc;
  ManagePaymentListResponse Response;

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  int _pageNo = 0;

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    productGroupBloc = OrderScreenBloc(baseBloc);
    searchbar.addListener(onsearchsuccess);
  }

  void onsearchsuccess() {
    setState(() {
      productGroupBloc
        ..add(ManagePaymentListRequestEvent(
            1,
            ManagePaymentListRequest(
                pkID: "",
                ListMode: "",
                SearchKey: searchbar.text.toString(),
                CompanyId: CompanyID,
                LoginUserID: LoginUserID)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc
        ..add(ManagePaymentListRequestEvent(
            _pageNo + 1,
            ManagePaymentListRequest(
                pkID: "",
                ListMode: "",
                SearchKey: searchbar.text.toString(),
                CompanyId: CompanyID,
                LoginUserID: LoginUserID))),
      child: BlocConsumer<OrderScreenBloc, OrderScreenStates>(
        builder: (BuildContext context, OrderScreenStates state) {
          if (state is ManagePaymentListResponseState) {
            productgrouplistsuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ManagePaymentListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, OrderScreenStates state) {
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorWhite),
            onPressed: () => navigateTo(context, AccountScreen.routeName,
                clearAllStack: true),
          ),
          backgroundColor: Getirblue,
          title: Text(
            "Manage Payment List",
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
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    searchbar.clear();
                    productGroupBloc.add(ManagePaymentListRequestEvent(
                        1,
                        ManagePaymentListRequest(
                            pkID: "",
                            ListMode: "",
                            SearchKey: searchbar.text.toString(),
                            CompanyId: CompanyID,
                            LoginUserID: LoginUserID)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Column(
                      children: [
                        buildsearch(),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(child: _buildInquiryList()),
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

  Widget buildsearch() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Card(
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
      ),
    );
  }

  Widget _buildInquiryList() {
    if (Response == null) {
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
      child: Response.details.length != 0
          ? ListView.builder(
              key: Key('selected $selected'),
              itemBuilder: (context, index) {
                return _buildCustomerList(index);
              },
              shrinkWrap: true,
              itemCount: Response.details.length,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ListSearchNotFound,
                    height: 350,
                    width: 350,
                  ),
                  Text(
                    searchbar.text == ""
                        ? "Record Not Exist !"
                        : "Search Keyword Not Matched !",
                    style: TextStyle(
                        color: Getirblue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildCustomerList(int index) {
    return ExpantionCustomer(context, index);
  }

  void _onProductMasterPagination() {
    productGroupBloc
      ..add(ManagePaymentListRequestEvent(
          _pageNo + 1,
          ManagePaymentListRequest(
              pkID: "",
              ListMode: "",
              SearchKey: searchbar.text.toString(),
              CompanyId: CompanyID,
              LoginUserID: LoginUserID)));
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    ManagePaymentListResponseDetails PG = Response.details[index];
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: ExpansionTileCard(
              initialElevation: 5.0,
              elevation: 5.0,
              elevationCurve: Curves.easeInOut,
              shadowColor: Color(0xFF504F4F),
              baseColor: Color(0xFFFCFCFC),
              expandedColor: Color(0xFFC1E0FA),
              leading: Image.network(
                'https://flyclipart.com/thumb2/customer-ecommerce-icon-681338.png',
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
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
              ),
              title: Text(
                Response.details[index].customerName,
                style: TextStyle(color: Colors.black), //8A2CE2)),
              ),
              subtitle: Text(
                Response.details[index].poNO,
                style: TextStyle(color: Colors.black), //8A2CE2)),
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
                                        Text("PaymentType:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index]
                                                        .paymentType ==
                                                    ""
                                                ? "N/A"
                                                : Response
                                                    .details[index].paymentType,
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
                                        Text("PaymentAmt :",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index]
                                                        .paymentAmt ==
                                                    0.00
                                                ? "N/A"
                                                : Response
                                                    .details[index].paymentAmt
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
                                        Text("TransactionStatus :",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index]
                                                        .transactionStatus ==
                                                    ""
                                                ? "N/A"
                                                : Response.details[index]
                                                    .transactionStatus,
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
                                        Text("Approved By :",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index].createdBy ==
                                                    ""
                                                ? "N/A"
                                                : Response
                                                    .details[index].createdBy,
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
                                        Text("Created Date :",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index]
                                                        .createdDate ==
                                                    ""
                                                ? "N/A"
                                                : Response.details[index]
                                                        .createdDate
                                                        .getFormattedDate(
                                                            fromFormat:
                                                                "yyyy-MM-ddTHH:mm:ss",
                                                            toFormat:
                                                                "dd-MM-yyyy HH:mm") ??
                                                    "-",
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
                            ],
                          ),
                        ),
                      ],
                    ))),
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
                margin: EdgeInsets.only(left: 10),
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

  void _onTapOfDelete(int pkID) {
    showCommonDialogWithTwoOptions(
        context, "Do You Want To Delete This Product Group?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.pop(context);
      productGroupBloc
        ..add(ManagePaymentListRequestEvent(
            1,
            ManagePaymentListRequest(
                pkID: "",
                ListMode: "",
                SearchKey: searchbar.text.toString(),
                CompanyId: CompanyID,
                LoginUserID: LoginUserID)));
    });
  }

  void _onTapOfEditproduct(ProductGroupListResponseDetails pd) {
    navigateTo(
      context,
      ManageProductGroup.routeName,
      arguments: EditProductGroup(pd),
    );
  }

  void productgrouplistsuccess(ManagePaymentListResponseState state) {
    if (_pageNo != state.newpage || state.newpage == 1) {
      //checking if new data is arrived
      if (state.newpage == 1) {
        //resetting search

        Response = state.response;
      } else {
        Response.details.addAll(state.response.details);
      }
      _pageNo = state.newpage;
    }
  }

  void productgroupdeletesuccess(ProductGroupDeleteResponseState state) {
    commonalertbox(state.response.details[0].column1, onTapofPositive: () {
      Navigator.pop(context);
      navigateTo(context, AccountScreen.routeName, clearSingleStack: true);
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, AccountScreen.routeName, clearAllStack: true);
  }
}
