import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/inward/inward_bloc.dart';
import 'package:grocery_app/models/api_request/Inward/inward_delete_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/inward_header_add_edit_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/date_time_extensions.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class InwardListScreen extends BaseStatefulWidget {
  static const routeName = '/InwardListScreen';

  @override
  _InwardListScreenState createState() => _InwardListScreenState();
}

class _InwardListScreenState extends BaseState<InwardListScreen>
    with BasicScreen, WidgetsBindingObserver {
  TextEditingController searchbar = TextEditingController();
  int title_color = 0xFF000000;
  int pageNo = 0;
  int selected = 0;
  InwardScreenBloc productGroupBloc;
  InwardListResponse Response;
  InwardListResponseDetails details;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  String CustomerType = "";

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    CustomerType = _offlineLogindetails.details[0].customerType;

    productGroupBloc = InwardScreenBloc(baseBloc);
    searchbar.addListener(searchlistner);
    productGroupBloc
      ..add(InwardListRequestCallEvent(
          1,
          InwardListRequest(
              CompanyId: CompanyID,
              LoginUserID: LoginUserID,
              SearchKey: searchbar.text)));
  }

  searchlistner() {
    productGroupBloc
      ..add(InwardListRequestCallEvent(
          1,
          InwardListRequest(
              CompanyId: CompanyID,
              LoginUserID: LoginUserID,
              SearchKey: searchbar.text)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc
        ..add(InwardListRequestCallEvent(
            1,
            InwardListRequest(
                CompanyId: CompanyID,
                LoginUserID: LoginUserID,
                SearchKey: searchbar.text))),
      child: BlocConsumer<InwardScreenBloc, InwardScreenStates>(
        builder: (BuildContext context, InwardScreenStates state) {
          if (state is InwardListResponseState) {
            productlistsuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is InwardListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InwardScreenStates state) {
          if (state is InwardDeleteResponseState) {
            productDeleteSuccess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is InwardDeleteResponseState) {
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
            "Supplier List",
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
                      ..add(InwardListRequestCallEvent(
                          1,
                          InwardListRequest(
                              CompanyId: CompanyID,
                              LoginUserID: LoginUserID,
                              SearchKey: searchbar.text)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Column(
                      children: [
                        CustomerType.toLowerCase() == "customer"
                            ? Container()
                            : buildsearch(),
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
        floatingActionButton: CustomerType.toLowerCase() == "customer"
            ? Container()
            : FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await OfflineDbHelper.getInstance().deleteALLInwardProduct();

                  navigateTo(context, AddEditInwardScreen.routeName);
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ListSearchNotFound,
                    height: 200,
                  ),
                  Text(
                    searchbar.text == ""
                        ? "No Supplier Exist !"
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
      ..add(InwardListRequestCallEvent(
          1,
          InwardListRequest(
              CompanyId: CompanyID,
              LoginUserID: LoginUserID,
              SearchKey: searchbar.text)));
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    InwardListResponseDetails PD = Response.details[index];
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
              leading: Image.network(
                'https://cdn-icons-png.flaticon.com/512/1256/1256650.png',
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
                Response.details[index].inwardNo,
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
                                        Text(" Name:",
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
                                                        .customerName ==
                                                    ""
                                                ? "N/A"
                                                : Response.details[index]
                                                    .customerName,
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
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Created By:",
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
                                                            .createdBy ==
                                                        ""
                                                    ? "N/A"
                                                    : Response.details[index]
                                                        .createdBy,
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
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Created Date:",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    letterSpacing: .3)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                PD.createdDate == ""
                                                    ? "N/A"
                                                    : PD.createdDate.getFormattedDate(
                                                            fromFormat:
                                                                "yyyy-MM-ddTHH:mm:ss",
                                                            toFormat:
                                                                "dd-MM-yyyy HH:mm") ??
                                                        "-",
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontSize: 10,
                                                    letterSpacing: .3))
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
                      CustomerType.toLowerCase().toString() == "customer"
                          ? Container()
                          : GestureDetector(
                              /* shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),*/
                              onTap: () {
                                _onTapOfDelete(
                                    Response.details[index].inwardNo);
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

  void productlistsuccess(InwardListResponseState state) {
    if (pageNo != state.newpage || state.newpage == 1) {
      //checking if new data is arrived
      if (state.newpage == 1) {
        //resetting search
        Response = state.response;
      } else {
        Response.details.addAll(state.response.details);
      }
      pageNo = state.newpage;
    }
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

  void _onTapOfDelete(productID) {
    showCommonDialogWithTwoOptions(
      context,
      "Do you want to Delete This Supplier ?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.pop(context);

        productGroupBloc.add(InwardDeleteRequestCallEvent(InwardDeleteRequest(
            InwardNo: productID.toString(), CompanyId: CompanyID)));
      },
    );
  }

  void _onTapOfEditproduct(InwardListResponseDetails details) async {
    await OfflineDbHelper.getInstance().deleteALLInwardProduct();
    navigateTo(context, AddEditInwardScreen.routeName,
        clearAllStack: true, arguments: AddEditInwardScreenArguments(details));
  }

  Future<bool> _onBackpress() {
    navigateTo(context, AccountScreen.routeName, clearAllStack: true);
  }

  void productDeleteSuccess(InwardDeleteResponseState state) {
    navigateTo(context, InwardListScreen.routeName, clearAllStack: true);
  }
}
/**/

/*buildsearch(),
          SizedBox(height: 10,),
          Expanded(child: _buildInquiryList()),*/
