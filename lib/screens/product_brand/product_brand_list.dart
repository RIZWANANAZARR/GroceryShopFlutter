import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/product/product_bloc.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_seach_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_search.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_brand/product_brand_add.dart';
import 'package:grocery_app/screens/product_brand/product_brand_search.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class ProductBrandPagination extends BaseStatefulWidget {
  static const routeName = '/ProductBrandPagination';

  @override
  _ProductBrandPaginationState createState() => _ProductBrandPaginationState();
}

class _ProductBrandPaginationState extends BaseState<ProductBrandPagination>
    with BasicScreen, WidgetsBindingObserver {
  TextEditingController searchbar = TextEditingController();
  int title_color = 0xFF000000;
  int pageNo = 0;
  int selected = 0;
  int delid = 0;
  ProductBrandSearchDetails PSD;
  ProductGroupBloc productGroupBloc;
  ProductBrandResponse Response;
  ProductPaginationDetails details;

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    productGroupBloc = ProductGroupBloc(baseBloc);
    productGroupBloc
      ..add(ProductBrandCallEvent(ProductBrandListRequest(
          SearchKey: "",
          ActiveFlag: "0",
          CompanyId: CompanyID,
          LoginUserID: LoginUserID)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc
        ..add(ProductBrandCallEvent(ProductBrandListRequest(
            CompanyId: CompanyID, LoginUserID: LoginUserID))),
      child: BlocConsumer<ProductGroupBloc, ProductStates>(
        builder: (BuildContext context, ProductStates state) {
          if (state is ProductBrandResponseState) {
            productbrandlistsuccess(state);
          }
          if (state is ProductBrandSearchResponseState) {
            searchsuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ProductBrandResponseState ||
              currentState is ProductBrandSearchResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ProductStates state) {
          if (state is ProductBrandDeleteResponseState) {
            productbranddeletesuccess(state);
          }
          if (state is ProductBrandSearchResponseState) {
            searchsuccess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ProductBrandDeleteResponseState ||
              currentState is ProductBrandSearchResponseState) {
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
            onPressed: () => navigateTo(context, AccountScreen.routeName,
                clearAllStack: true),
          ),
          backgroundColor: Getirblue,
          title: Text(
            "Product Brand List",
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

                    productGroupBloc
                      ..add(ProductBrandCallEvent(ProductBrandListRequest(
                          SearchKey: searchbar.text.toString(),
                          ActiveFlag: "0",
                          CompanyId: CompanyID,
                          LoginUserID: LoginUserID)));
                    /*productGroupBloc
                      ..add(ProductBrandCallEvent(ProductBrandListRequest(
                          CompanyId: CompanyID, LoginUserID: LoginUserID)));*/
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
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            navigateTo(context, ManageProductBrand.routeName);
          },
          backgroundColor: Getirblue,
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
                    enabled: true,
                    onChanged: (value) {
                      /// searchbar.text = value;
                      productGroupBloc
                        ..add(ProductBrandCallEvent(ProductBrandListRequest(
                            SearchKey: value,
                            ActiveFlag: "0",
                            CompanyId: CompanyID,
                            LoginUserID: LoginUserID)));
                    },

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ListSearchNotFound,
                    height: 200,
                  ),
                  Text(
                    searchbar.text == ""
                        ? "No Product Brand Exist !"
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
    productGroupBloc.add(ProductBrandCallEvent(ProductBrandListRequest(
        CompanyId: CompanyID, LoginUserID: LoginUserID)));
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    ProductBrandDetails PD = Response.details[index];
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

              title: Text(
                Response.details[index].brandName,
                style: TextStyle(color: Colors.black), //8A2CE2)),
              ),
              subtitle: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Text(
                    Response.details[index].activeFlag == true
                        ? "Active"
                        : "InActive",
                    style: TextStyle(
                        color: Response.details[index].activeFlag == true
                            ? Colors.green
                            : Colors.red,
                        fontSize: 10,
                        letterSpacing: .3)),
              ),
              leading: Response.details[index].brandImage != null
                  ? Image.network(
                      _offlineCompanydetails.details[0].siteURL +
                          "/productbrandimages/" +
                          Response.details[index].brandImage,
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
                                        Text(" Name:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            Response.details[index].brandName ==
                                                    ""
                                                ? "N/A"
                                                : Response
                                                    .details[index].brandName,
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
                                            Text("Brand Alias :",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    letterSpacing: .3)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                Response.details[index]
                                                            .brandAlias ==
                                                        ""
                                                    ? "N/A"
                                                    : Response.details[index]
                                                        .brandAlias,
                                                style: TextStyle(
                                                    color: colorDarkBlue,
                                                    fontSize: 13,
                                                    letterSpacing: .3)),
                                          ],
                                        )),
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(" Status:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                          child: Text(
                                              Response.details[index]
                                                          .activeFlag ==
                                                      true
                                                  ? "Active"
                                                  : "InActive",
                                              style: TextStyle(
                                                  color: Response.details[index]
                                                              .activeFlag ==
                                                          true
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 10,
                                                  letterSpacing: .3)),
                                        ),
                                      ],
                                    )),
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
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
                        /* shape: RoundedRectangleBorder(
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
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        /* shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),*/
                        onTap: () {
                          _onTapOfDelete(Response.details[index].pkID);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: colorDarkBlue,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(color: colorDarkBlue),
                            ),
                          ],
                        ),
                      )
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

  /*void productdeletesuccess(ProductMasterDeleteResponseState state) {
    commonalertbox(state.response.details[0].column2,
        onTapofPositive: (){
          Navigator.pop(context);
          navigateTo(context, ProductPagination.routeName);
        }
    );
  }*/
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

  /*void _onTapOfDelete(productID) {
    showCommonDialogWithTwoOptions(context, "Do you want to Delete This Product?",
      onTapOfPositiveButton: (){
        Navigator.pop(context);
        productGroupBloc.add(ProductMasterDeleteCallEvent(productID,ProductPaginationDeleteRequest(CompanyId: 4094)));

      },
    );

  }*/

  /*void _onTapOfEditproduct(ProductPaginationDetails details) {
    navigateTo(context, ManageProduct.routeName,
        arguments:EditProduct(details)
    );
  }*/

  void productbrandlistsuccess(ProductBrandResponseState state) {
    Response = state.response;
  }

  void productbranddeletesuccess(ProductBrandDeleteResponseState state) {
    /* commonalertbox(state.response.details[0].column1, onTapofPositive: () {
      Navigator.pop(context);
    });*/

    navigateTo(context, ProductBrandPagination.routeName);
  }

  void _onTapOfDelete(int pkID) {
    showCommonDialogWithTwoOptions(
        context, "Do You Want To Delete This Product Brand?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      productGroupBloc.add(ProductBrandDeleteCallEvent(
          pkID, ProductBrandDeleteRequest(CompanyId: CompanyID)));
    });
  }

  Future<void> onsearchtap() async {
    navigateTo(context, SearchProductBrandScreen.routeName).then((value) {
      if (value != null) {
        PSD = value;
        productGroupBloc.add(
          ProductBrandSearchCallEvent(ProductBrandSearchRequest(
              CompanyId: CompanyID, LoginUserID: LoginUserID, pkID: PSD.pkID)),
        );
      }
    });
  }

  void searchsuccess(ProductBrandSearchResponseState state) {
    Response = state.response;
  }

  void _onTapOfEditproduct(ProductBrandDetails pd) {
    navigateTo(context, ManageProductBrand.routeName,
        arguments: EditProductBrand(pd), clearAllStack: true);
  }

  Future<bool> _onBackpress() {
    navigateTo(context, AccountScreen.routeName, clearAllStack: true);
  }
}
/**/

/*buildsearch(),
          SizedBox(height: 10,),
          Expanded(child: _buildInquiryList()),*/
