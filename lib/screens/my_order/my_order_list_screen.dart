import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/models/api_request/pdf_list/pdf_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/pdf_list/pdf_list_response.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class MyOrder extends BaseStatefulWidget {
  static const routeName = '/MyOrder';

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends BaseState<MyOrder>
    with BasicScreen, WidgetsBindingObserver {
  CategoryScreenBloc _categoryScreenBloc;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  List<PDFListResponseDetails> arrMyOrderList = [];
  TextEditingController searchbar = TextEditingController();

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    _categoryScreenBloc = CategoryScreenBloc(baseBloc);
    searchbar.text = "";
    searchbar.addListener(searchlistner);

    _categoryScreenBloc.add(PdfListRequestCallEvent(PdfListRequest(
        CustomerID: CustomerID,
        CompanyId: CompanyID,
        SearchKey: searchbar.text.toString(),
        CustomerType: _offlineLogindetails.details[0].customerType)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is PDFListResponseState) {
            _OnMyOrderListResponse(state, context);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is PDFListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {
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
      onWillPop: _onBackpress,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorWhite),
            onPressed: () => navigateTo(context, AccountScreen.routeName,
                clearAllStack: true),
          ),
          backgroundColor: Getirblue,
          title: Text(
            "Order Invoice",
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
            _offlineLogindetails.details[0].customerType.toLowerCase() ==
                    "customer"
                ? Container()
                : buildsearch(),
            SizedBox(
              height: 10,
            ),
            Expanded(child: _buildInquiryList()),
          ],
        ) //_buildInquiryList(),
            ),
      ),
    );
  }

  searchlistner() {
    _categoryScreenBloc.add(PdfListRequestCallEvent(PdfListRequest(
        CustomerID: CustomerID,
        CompanyId: CompanyID,
        SearchKey: searchbar.text.toString(),
        CustomerType: _offlineLogindetails.details[0].customerType)));
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

  Future<bool> _onBackpress() {
    navigateTo(context, AccountScreen.routeName, clearAllStack: true);
  }

  _buildInquiryList() {
    if (arrMyOrderList.length == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            NO_ORDER,
            width: 200,
            height: 200,
          ),
          Text(
            "No Order Found.",
            style: TextStyle(
                fontSize: 15, color: Getirblue, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Getirblue),
            ),
            onPressed: () {
              //ontapofsave();
              navigateTo(context, TabHomePage.routeName, clearAllStack: true);
            },
            child: Padding(
              padding: EdgeInsets.all(13),
              child: Text(
                "View Product",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ));
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildCustomerList(index);
        },
        shrinkWrap: true,
        itemCount: arrMyOrderList.length,
      );
    }
  }

  void _OnMyOrderListResponse(
      PDFListResponseState state, BuildContext context) {
    arrMyOrderList.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      PDFListResponseDetails pdfListResponseDetails = PDFListResponseDetails();
      pdfListResponseDetails.pkID = state.response.details[i].pkID;
      pdfListResponseDetails.customerID = state.response.details[i].customerID;
      pdfListResponseDetails.customerName =
          state.response.details[i].customerName;
      pdfListResponseDetails.contactNo = state.response.details[i].contactNo;
      pdfListResponseDetails.address = state.response.details[i].address;
      pdfListResponseDetails.emailAddress =
          state.response.details[i].emailAddress;
      pdfListResponseDetails.fileName = state.response.details[i].fileName;
      pdfListResponseDetails.invoiceNo = state.response.details[i].invoiceNo;
      arrMyOrderList.add(pdfListResponseDetails);
    }
  }

  _buildCustomerList(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    PDFListResponseDetails pdfListResponseDetails = arrMyOrderList[index];
    print("LaunchPDFURL" +
        "URL :" +
        _offlineCompanydetails.details[0].siteURL +
        "/invoicepdf/" +
        pdfListResponseDetails.fileName);
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
                "https://cdn-icons-png.flaticon.com/512/1007/1007908.png",
                frameBuilder: (context, child, frame,
                    wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder:
                    (context, child, loadingProgress) {
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
                pdfListResponseDetails.customerName,
                style: TextStyle(
                    color: Getirblue, fontWeight: FontWeight.bold), //8A2CE2)),
              ),
              subtitle: Text(pdfListResponseDetails.invoiceNo,
                  style: TextStyle(color: Getirblue, fontSize: 12)),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        await _launchInBrowser(Uri.parse(
                                            _offlineCompanydetails
                                                    .details[0].siteURL +
                                                "/invoicepdf/" +
                                                pdfListResponseDetails
                                                    .fileName));

                                        /* var progesCount23;
                               webViewController.getProgress().whenComplete(() async =>  {
                                 progesCount23 = await webViewController.getProgress(),
                                 print("PAgeLoaded" + progesCount23.toString())
                               });*/

                                        /*  await _makePhoneCall(
                                        model.contactNo1);*/

                                        // baseBloc.emit(ShowProgressIndicatorState(true));
                                        /* setState(() {
                                  urlRequest = URLRequest(url: Uri.parse(SiteURL+"/Quotation.aspx?MobilePdf=yes&userid="+LoginUserID+"&password="+Password+"&pQuotID="+model.pkID.toString()));


                                });*/

                                        // await Future.delayed(const Duration(milliseconds: 500), (){});
                                        // baseBloc.emit(ShowProgressIndicatorState(false));
                                        //_QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          PDF_ICON,
                                          width: 48,
                                          height: 48,
                                        ),
                                      ),
                                    ),
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
                                        Text("Customer Name:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            pdfListResponseDetails
                                                        .customerName ==
                                                    ""
                                                ? "N/A"
                                                : pdfListResponseDetails
                                                    .customerName,
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
                                            Text("Email :",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    letterSpacing: .3)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                pdfListResponseDetails
                                                            .emailAddress ==
                                                        ""
                                                    ? "N/A"
                                                    : pdfListResponseDetails
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
                                        Text("Delivery Address:",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            pdfListResponseDetails.address == ""
                                                ? "N/A"
                                                : pdfListResponseDetails
                                                    .address,
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

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
