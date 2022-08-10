import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/models/api_request/ProductReporting/product_reporting_list_request.dart';
import 'package:grocery_app/models/api_response/Category/category_list_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/ProductReporting/product_reporting_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/ExploreDashBoard/explore_dashboard_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class ProductReportingListScreen extends BaseStatefulWidget {
  static const routeName = '/ProductReportingListScreen';
  @override
  _ProductReportingListScreenState createState() =>
      _ProductReportingListScreenState();
}

class _ProductReportingListScreenState
    extends BaseState<ProductReportingListScreen>
    with BasicScreen, WidgetsBindingObserver {
  TextEditingController searchbar = TextEditingController();
  int title_color = 0xFF000000;
  int pageNo = 0;
  int selected = 0;
  CategoryScreenBloc categoryScreenBloc;
  ProductReportingListResponse Response;
  CategoryListResponse categoryListResponse;
  CategoryListResponseDetails categoryListResponseDetails;
  ProductPaginationDetails details;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  List<CategoryListResponseDetails> arrcategoryListResponseDetails = [];

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    categoryScreenBloc = CategoryScreenBloc(baseBloc);
    searchbar.text = "";
    searchbar.addListener(searchlistner);

    /* productGroupBloc
      ..add(CategoryListRequestCallEvent(CategoryListRequest(
          BrandID: "",
          ProductGroupID: "",
          ProductID: "",
          SearchKey: "",
          CompanyId: CompanyID,
          ActiveFlag: "1")));*/

    categoryScreenBloc
      ..add(ProductReportingListRequestCallEvent(ProductReportingListRequest(
          SearchKey: searchbar.text, CompanyId: CompanyID)));
  }

  searchlistner() {
    categoryScreenBloc
      ..add(ProductReportingListRequestCallEvent(ProductReportingListRequest(
          SearchKey: searchbar.text, CompanyId: CompanyID)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => categoryScreenBloc
        ..add(ProductReportingListRequestCallEvent(ProductReportingListRequest(
            SearchKey: searchbar.text, CompanyId: CompanyID))),
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is ProductReportingListResponseState) {
            _onproductreportinglistresponse(state);
          }

          /*  if (state is ProductMasterPaginationResponseState) {
            productlistsuccess(state);
          }
          if (state is ProductMasterPaginationSearchResponseState) {
            productsearchsuccess(state);
          }
          if (state is CategoryListResponseState) {
            _OnAllProductBrandGroupSearchSucess(state, context);
          }*/

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          /*  if (currentState is ProductMasterPaginationResponseState ||
              currentState is ProductMasterPaginationSearchResponseState ||
              currentState is CategoryListResponseState) {
            return true;
          }*/

          if (currentState is ProductReportingListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {
          /*if (state is ProductMasterPaginationSearchResponseState) {
            productsearchsuccess(state);
          }
          if (state is ProductMasterDeleteResponseState) {
            productdeletesuccess(state);
          }*/
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          /* if (currentState is ProductMasterPaginationSearchResponseState ||
              currentState is ProductMasterDeleteResponseState) {
            return true;
          }*/
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
              onPressed: () => navigateTo(
                  context, ExploreDashBoardScreen.routeName,
                  clearAllStack: true)),
          backgroundColor: Getirblue,
          title: Text(
            "Product Search",
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
                    searchbar.text = "";

                    categoryScreenBloc
                      ..add(ProductReportingListRequestCallEvent(
                          ProductReportingListRequest(
                              SearchKey: searchbar.text,
                              CompanyId: CompanyID)));
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
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Card(
        elevation: 5,
        color: colorLightGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                  children: [
                    Image.asset(
                      ListSearchNotFound,
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      searchbar.text == ""
                          ? " No Product Exist !"
                          : "Search Keyword Not Matched !",
                      style: TextStyle(
                          color: Getirblue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ));
  }

  Widget _buildCustomerList(int index) {
    return ExpantionCustomer(context, index);
  }

  void _onProductMasterPagination() {
    categoryScreenBloc
      ..add(ProductReportingListRequestCallEvent(ProductReportingListRequest(
          SearchKey: searchbar.text, CompanyId: CompanyID)));
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    // CategoryListResponseDetails PD = Response.details[index];

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
              //Colors.deepOrange[50],ADD8E6
              leading: Response.details[index].productImage != null
                  ? Response.details[index].productImage != "no-figure.png"
                      ? Image.network(
                          _offlineCompanydetails.details[0].siteURL +
                              "/productimages/" +
                              Response.details[index].productImage,
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
                        )
                      : Image.asset(
                          NO_IMAGE_FOUND,
                          height: 35,
                          width: 35,
                        )
                  : Image.asset(
                      NO_IMAGE_FOUND,
                      height: 35,
                      width: 35,
                    ),

              title: Text(
                Response.details[index].productName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Response.details[index].closingSTK >= 0
                        ? Colors.black
                        : Colors.red), //8A2CE2)),
              ),
              subtitle: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Unit : " + "KG",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Response.details[index].closingSTK >= 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 10,
                            letterSpacing: .3)),
                    Text(
                        "Stock : " +
                            Response.details[index].closingSTK
                                .toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Response.details[index].closingSTK >= 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 10,
                            letterSpacing: .3)),
                  ],
                ),
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
                                        Text(" Alias :",
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
                                                        .productAlias ==
                                                    ""
                                                ? "N/A"
                                                : Response.details[index]
                                                    .productAlias,
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Unit Price:",
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
                                                            .unitPrice
                                                            .toString() ==
                                                        ""
                                                    ? "0.00"
                                                    : Response.details[index]
                                                        .unitPrice
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
                                        Text("Opening STK",
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
                                                        .openingSTK ==
                                                    null
                                                ? "0.00"
                                                : Response
                                                    .details[index].openingSTK
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Closing STK :",
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
                                                            .closingSTK ==
                                                        null
                                                    ? "0.00"
                                                    : Response.details[index]
                                                        .closingSTK
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
                                        Text("Inward STK",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            Response.details[index].inwardSTK ==
                                                    null
                                                ? "0.00"
                                                : Response
                                                    .details[index].inwardSTK
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("OutWard STK :",
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
                                                            .outwardSTK ==
                                                        null
                                                    ? "0.00"
                                                    : Response.details[index]
                                                        .outwardSTK
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
                                        Text("Vat %:",
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
                                                        .vatPercent ==
                                                    null
                                                ? "0.00"
                                                : Response
                                                    .details[index].vatPercent
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: colorDarkBlue,
                                                fontSize: 13,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                    Expanded(
                                        flex: 1,
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
                                                Response.details[index]
                                                            .vatAmount ==
                                                        null
                                                    ? "0.00"
                                                    : Response.details[index]
                                                        .vatAmount
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
    navigateTo(context, ExploreDashBoardScreen.routeName, clearAllStack: true);
    // Navigator.pop(context);
  }

  void _onproductreportinglistresponse(
      ProductReportingListResponseState state) {
    Response = state.productReportingListResponse;
  }
}
