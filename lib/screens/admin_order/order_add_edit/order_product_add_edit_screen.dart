import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/order/order_bloc.dart';
import 'package:grocery_app/models/api_request/ManagePayment/manage_payment_save_request.dart';
import 'package:grocery_app/models/api_request/Token/token_list_request.dart';
import 'package:grocery_app/models/api_request/order/order_all_detail_delete_request.dart';
import 'package:grocery_app/models/api_request/order/order_header_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_json_request.dart';
import 'package:grocery_app/models/api_request/order/order_product_list_request.dart';
import 'package:grocery_app/models/api_request/pdf_upload/pdf_upload_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/order/order_customer_list_response.dart';
import 'package:grocery_app/models/api_response/order/order_product_list_response.dart';
import 'package:grocery_app/models/common/all_name_id.dart';
import 'package:grocery_app/screens/admin_order/order_list/order_customer_list_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/invoice/api/pdf_invoice_api.dart';
import 'package:grocery_app/screens/invoice/model/customer.dart';
import 'package:grocery_app/screens/invoice/model/invoice.dart';
import 'package:grocery_app/screens/invoice/model/supplier.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/date_time_extensions.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AddUpdateOrderProductAddEditArguments {
  String customerId, status, pkID, InvoiceNoFromEditMode;
  OrderCustomerListResponseDetails customerdetails;
  AddUpdateOrderProductAddEditArguments(this.customerId, this.status, this.pkID,
      this.InvoiceNoFromEditMode, this.customerdetails);
}

class OrderProductAddEdit extends BaseStatefulWidget {
  static const routeName = '/OrderProductAddEdit';

  final AddUpdateOrderProductAddEditArguments arguments;

  OrderProductAddEdit(this.arguments);

  @override
  _OrderProductAddEditState createState() => _OrderProductAddEditState();
}

class _OrderProductAddEditState extends BaseState<OrderProductAddEdit>
    with BasicScreen, WidgetsBindingObserver {
  int title_color = 0xFF000000;
  int pageNo = 0;
  int selected = 0;
  OrderScreenBloc productGroupBloc;
  OrderProductListResponse Response;
  OrderProductListResponseDetails details;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  String _customerId = "";
  String _status = "";
  String _pkID = "";
  String _InvoiceNoFromEditMode;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  List<OrderHeaderJsonDetails> arHeaderRequestList = [];

  TextEditingController OrderQty = TextEditingController();

  TextEditingController DispatchQTY = TextEditingController();
  TextEditingController Remarks = TextEditingController();

  List<OrderProductListResponseDetails> arrProductDetails = [];

  List<OrderProductJsonDetails> quotationProductModel = [];

  File pdfFile;

  String Latitude = "";
  String Longitude = "";

  String TokenGetFromAPI = "";
  double CardViewHeight = 35;
  TextEditingController _discPerController = TextEditingController();
  TextEditingController _BasicAmount = TextEditingController();
  TextEditingController _Discount = TextEditingController();
  TextEditingController _Vat = TextEditingController();
  TextEditingController _Tot_NetAmnt = TextEditingController();

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    Latitude = SharedPrefHelper.instance.getLatitude();
    Longitude = SharedPrefHelper.instance.getLongitude();
    productGroupBloc = OrderScreenBloc(baseBloc);
    _customerId = widget.arguments.customerId;
    _pkID = widget.arguments.pkID;
    print("OrderNo234" + widget.arguments.InvoiceNoFromEditMode);
    _status = widget.arguments.status.toLowerCase();
    _InvoiceNoFromEditMode = widget.arguments.InvoiceNoFromEditMode;
    productGroupBloc
      ..add(OrderProductListRequestCallEvent(OrderProductListRequest(
          OrderNo: widget.arguments.InvoiceNoFromEditMode,
          Status: _status,
          CompanyId: CompanyID,
          CustomerType: _offlineLogindetails.details[0].customerType)));
    productGroupBloc.add(TokenListApiRequestCallEvent(TokenListApiRequest(
        CompanyId: CompanyID.toString(), CustomerID: _customerId)));

    print("TokenFromAPIdfdf" + TokenGetFromAPI);

    _discPerController.text = "0.00";
    _BasicAmount.text = "0.00";
    _Discount.text = "0.00";
    _Vat.text = "0.00";
    _Tot_NetAmnt.text = "0.00";
    // _discPerController.addListener(TotalAmountCalculation);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc,
      child: BlocConsumer<OrderScreenBloc, OrderScreenStates>(
        builder: (BuildContext context, OrderScreenStates state) {
          if (state is OrderProductListResponseState) {
            productlistsuccess(state);
          }

          if (state is TokenListResponseState) {
            _OnTokenGetSucess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is OrderProductListResponseState ||
              currentState is TokenListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, OrderScreenStates state) {
          if (state is OrderProductJsonSaveResponseState) {
            productSaveSucess(state);
          }

          if (state is PdfUploadResponseState) {
            uploadpdfSucess(state);
          }

          if (state is ManagePaymentSaveResponseState) {
            managepaynmentsucess(state);
          }

          if (state is OrderAllDetailDeleteResponseState) {
            _OnorderDetailDeleteSucess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is OrderProductJsonSaveResponseState ||
              currentState is PdfUploadResponseState ||
              currentState is ManagePaymentSaveResponseState ||
              currentState is OrderAllDetailDeleteResponseState) {
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
        appBar: AppBar(
          backgroundColor: Getirblue,
          title: Text(
            "Order Details",
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
                child: Container(
                  padding: EdgeInsets.only(
                    left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                    right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                    top: 25,
                  ),
                  child: Column(
                    children: [
                      Expanded(child: _buildInquiryList()),
                    ],
                  ),
                ),
              ),
              _status == "open"
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /* Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 1, child: DiscPer()),
                              ]),*/
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "BasicAmount : ",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Getirblue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          " £ " + _BasicAmount.text,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Getirblue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "VatAmount : ",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Getirblue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          " £ " + _Vat.text,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Getirblue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "NetAmount : ",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Getirblue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          " £ " + _Tot_NetAmnt.text,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Getirblue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            /*height: 60,
                            minWidth: 300,
                            color: Getirblue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),*/
                            onPressed: () {
                              showCommonDialogWithTwoOptions(
                                context,
                                "Do You Want To Submit This Details ?",
                                negativeButtonTitle: "No",
                                positiveButtonTitle: "Yes",
                                onTapOfPositiveButton: () {
                                  Navigator.pop(context);

                                  productGroupBloc.add(
                                      OrderAllDetailDeleteRequestEvent(
                                          OrderAllDetailDeleteRequest(
                                              OrderNo: _InvoiceNoFromEditMode,
                                              CompanyId:
                                                  CompanyID.toString())));

                                  onPlaceOrderClicked(
                                      "0",
                                      _InvoiceNoFromEditMode,
                                      "Added Successfully");
                                },
                              );

                              // _onTapOfEditproduct(PD);
                            },
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Submit Details',
                                  style: TextStyle(color: colorWhite),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget DiscPer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Disc.%",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      onTap: () => {
                            _discPerController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _discPerController.text.length,
                            )
                          },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _discPerController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildInquiryList() {
    if (Response == null) {
      return Container();
    }
    return ListView.builder(
      key: Key('selected $selected'),
      itemBuilder: (context, index) {
        return _buildCustomerList(index);
      },
      shrinkWrap: true,
      itemCount: Response.details.length,
    );
  }

  Widget _buildCustomerList(int index) {
    return ExpantionCustomer(context, index);
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    OrderProductListResponseDetails PD = arrProductDetails[index];
    double VatAmount = (PD.unitPrice * PD.Vat) / 100;
    double NetAmount = PD.dispatchQuantity * PD.unitPrice;
    double closingstk = double.parse(
        PD.ClosingSTK.toString() == "" ? "0.00" : PD.ClosingSTK.toString());
    /* if (_status == "open") {
      PD.dispatchQuantity = PD.quantity;
    }*/

    return Container(
      //margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Container(
            //margin: EdgeInsets.only(left: 15, right: 15),
            child: ExpansionTileCard(
              initialElevation: 5.0,
              elevation: 5.0,
              elevationCurve: Curves.easeInOut,
              shadowColor: Color(0xFF504F4F),
              baseColor: Color(0xFFFCFCFC),
              expandedColor: Color(0xFFC1E0FA),
              //Colors.deepOrange[50],ADD8E6
              leading: PD.productName != null
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
                PD.productName,
                style: TextStyle(
                    fontSize: 15,
                    color:
                        closingstk > 0 ? Getirblue : colorRedDark), //8A2CE2)),
              ),

              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "Available Stock : " + PD.ClosingSTK.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: closingstk > 0 ? Getirblue : colorRedDark),
                  ),
                  PD.quantity.toString() != "" ||
                          PD.dispatchQuantity.toString() != ""
                      ? Divider(
                          thickness: 1,
                        )
                      : Container(),
                  PD.quantity.toString() != "" ||
                          PD.dispatchQuantity.toString() != ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              children: [
                                Text("Order Qty : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                Text(
                                  PD.quantity.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: colorPrimary),
                                ),
                              ],
                            ),
                            PD.dispatchQuantity.toString() != ""
                                ? Row(
                                    children: [
                                      Text("Disp.Qty : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                      Text(
                                        PD.dispatchQuantity.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: colorPrimary),
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  )
                ],
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
                                        Text("Invoice No.",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.InvoiceNo == null
                                                ? ""
                                                : PD.InvoiceNo,
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
                                        Text("Order Date",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.InvoiceDate.toString() == ""
                                                ? "N/A"
                                                : PD.InvoiceDate.getFormattedDate(
                                                    fromFormat:
                                                        "yyyy-MM-ddTHH:mm:ss",
                                                    toFormat: "dd-MM-yyyy"),
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
                                        Text("Status",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(_status,
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
                                        Text("Unit Price",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.unitPrice.toString() == ""
                                                ? "N/A"
                                                : PD.unitPrice.toString(),
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
                                        Text("Unit",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.unit.toString() == ""
                                                ? "N/A"
                                                : PD.unit.toString(),
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
                                        Text("Created By",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.createdBy.toString() == ""
                                                ? "N/A"
                                                : PD.createdBy.toString(),
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
                                        Text("Created Date",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.CreatedDate == ""
                                                ? "N/A"
                                                : PD.CreatedDate.getFormattedDate(
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
                                        Text("Remarks",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.Remarks.toString() == ""
                                                ? "N/A"
                                                : PD.Remarks.toString(),
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
                                        Text("Quantity",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.quantity.toString() == ""
                                                ? "N/A"
                                                : PD.quantity.toString(),
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
                                        Text("Dispatch Quantity",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.dispatchQuantity.toString() == ""
                                                ? "N/A"
                                                : PD.dispatchQuantity
                                                    .toString(),
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
                                        Text("Vat %",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            PD.Vat.toString() == ""
                                                ? "N/A"
                                                : PD.Vat.toString(),
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
                                        Text("Amount",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(NetAmount.toStringAsFixed(2),
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
                _status == "open"
                    ? ButtonBar(
                        alignment: MainAxisAlignment.center,
                        buttonHeight: 52.0,
                        buttonMinWidth: 90.0,
                        children: <Widget>[
                            ElevatedButton(
                              /*shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),*/
                              onPressed: () {
                                // _onTapOfEditproduct(PD);

                                OrderQty.text = PD.quantity.toString();
                                DispatchQTY.text =
                                    PD.dispatchQuantity.toString();
                                Remarks.text = PD.Remarks;
                                showcustomdialog(
                                    context1: context,
                                    finalCheckingItems: PD,
                                    index1: index);
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    DispatchPNG,
                                    height: 48,
                                    width: 48,
                                  ),
                                  Text(
                                    'Dispatched',
                                    style: TextStyle(color: colorDarkBlue),
                                  ),
                                ],
                              ),
                            ),
                          ])
                    : Container(),
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

  showcustomdialog({
    BuildContext context1,
    OrderProductListResponseDetails finalCheckingItems,
    int index1,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorPrimary, //                   <--- border color
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        15.0) //                 <--- border radius here
                    ),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Update",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Order Quantity",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorPrimary,
                                    fontWeight: FontWeight
                                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                height: 38,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          enabled: false,
                                          controller: OrderQty,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText:
                                                "Tap to enter Dispatch Quantity",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Dispatched QTy",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorPrimary,
                                    fontWeight: FontWeight
                                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                height: 38,
                                padding: EdgeInsets.only(left: 25, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          enabled: true,
                                          controller: DispatchQTY,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          textInputAction: TextInputAction.next,
                                          onTap: () => {
                                                DispatchQTY.selection =
                                                    TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      DispatchQTY.text.length,
                                                )
                                              },
                                          decoration: InputDecoration(
                                            hintText:
                                                "Tap to enter Dispatch Quantity",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Remarks",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorPrimary,
                                    fontWeight: FontWeight
                                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                height: 38,
                                padding: EdgeInsets.only(left: 25, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          enabled: true,
                                          controller: Remarks,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter Remarks",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () {
                              if (DispatchQTY.text != "") {
                                if (Remarks.text != "") {
                                  double qt =
                                      double.parse(OrderQty.text.toString());
                                  double oqt =
                                      double.parse(DispatchQTY.text.toString());
                                  print("sdjds" +
                                      "QT : " +
                                      qt.toString() +
                                      oqt.toString());

                                  if (finalCheckingItems.dispatchQuantity <=
                                      finalCheckingItems.ClosingSTK) {
                                    if (oqt <= qt) {
                                      setState(() {
                                        finalCheckingItems.dispatchQuantity =
                                            double.parse(DispatchQTY.text);
                                        finalCheckingItems.Remarks =
                                            Remarks.text;
                                      });
                                      TotalAmountCalculation();
                                      Navigator.pop(context123);
                                    } else {
                                      commonalertbox(
                                          "Dispatched Quantity Should Not Be Greater Than Order Quantity");
                                    }
                                  } else {
                                    commonalertbox(
                                        "Dispatched Quantity Should Not Be Greater Than to Closing Stock");
                                  }

                                  // _productList[index1].SerialNo = edt_Application.text;
                                } else {
                                  commonalertbox("Remarks should not Empty");
                                }
                              } else {
                                commonalertbox(
                                    "Dispatched Quantity should not Empty");
                              }
                            },
                            "Submit",
                            backGroundColor: Getirblue,
                            textColor: colorWhite,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () {
                              Navigator.pop(context);
                            },
                            "Close",
                            backGroundColor: Getirblue,
                            textColor: colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  productlistsuccess(OrderProductListResponseState state) {
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
    arrProductDetails.clear();
    //arrProductDetails.addAll(Response.details);

    /*for (int i = 0; i < arrProductDetails.length; i++) {
      print("dfffd" + arrProductDetails[i].InvoiceNo);
    }*/

    for (int i = 0; i < Response.details.length; i++) {
      OrderProductListResponseDetails orderProductListResponseDetails =
          OrderProductListResponseDetails();

      orderProductListResponseDetails.InvoiceNo = Response.details[i].InvoiceNo;
      orderProductListResponseDetails.pkID = Response.details[i].pkID;
      orderProductListResponseDetails.productID = Response.details[i].productID;
      orderProductListResponseDetails.productName =
          Response.details[i].productName;
      orderProductListResponseDetails.unit = Response.details[i].unit;
      orderProductListResponseDetails.unitPrice = Response.details[i].unitPrice;
      orderProductListResponseDetails.productImage =
          Response.details[i].productImage;
      orderProductListResponseDetails.discountPercent =
          Response.details[i].discountPercent;
      orderProductListResponseDetails.status = Response.details[i].status;

      if (_status == "open") {
        orderProductListResponseDetails.dispatchQuantity =
            Response.details[i].quantity;
      } else {
        orderProductListResponseDetails.dispatchQuantity =
            Response.details[i].dispatchQuantity;
      }
      orderProductListResponseDetails.InvoiceDate =
          Response.details[i].InvoiceDate;

      orderProductListResponseDetails.quantity = Response.details[i].quantity;
      orderProductListResponseDetails.createdBy = Response.details[i].createdBy;
      orderProductListResponseDetails.CreatedDate =
          Response.details[i].CreatedDate;
      orderProductListResponseDetails.UpdatedDate =
          Response.details[i].UpdatedDate;

      orderProductListResponseDetails.Vat = Response.details[i].Vat;
      orderProductListResponseDetails.Remarks = Response.details[i].Remarks;
      orderProductListResponseDetails.ClosingSTK =
          Response.details[i].ClosingSTK == null
              ? 0.00
              : Response.details[i].ClosingSTK;

      arrProductDetails.add(orderProductListResponseDetails);
    }
    TotalAmountCalculation();
  }

  Widget commonalertbox(String msg,
      {GestureTapCallback onTapofPositive, bool useRootNavigator = true}) {
    showDialog(
        context: context,
        barrierDismissible: false,
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
    navigateTo(context, OrderCustomerList.routeName, clearAllStack: true);
  }

  void productSaveSucess(OrderProductJsonSaveResponseState state) {
    GeneratePDF(state.quotationProductModel, state.response.details[0].column2,
        state.response.details[0].column3, _InvoiceNoFromEditMode);
  }

  void GeneratePDF(List<OrderProductJsonDetails> quotationProductModel123,
      String returnMsg, int pkID, String InvoceName) async {
    String InvoceNamePDF = InvoceName.toString() + ".pdf";
    List<InvoiceItem> invoiceItemList = [];
    for (int i = 0; i < quotationProductModel123.length; i++) {
      /* InvoiceItem(description: quotationProductModel123[i].productID.toString() ,
        date: DateTime.now(),
        quantity:quotationProductModel123[i].quantity.toInt(),
          vat: 0.19,
          unitPrice: quotationProductModel123[i].unitPrice
        );*/

      invoiceItemList.add(InvoiceItem(
          description: quotationProductModel123[i].ProductName.toString(),
          date: DateTime.now(),
          quantity: quotationProductModel123[i].dispatchQuantity.toInt(),
          vat: quotationProductModel123[i].Vat,
          unitPrice: quotationProductModel123[i].unitPrice));
    }

    final date = DateTime.now();
    final dueDate = date.add(Duration(days: 7));
    File f = await urlToFile(
        "https://play-lh.googleusercontent.com/B-jI_E6TPSF-7mLb-rNnUSMFgRpTPjouMu9sLKIJ0MBK_O6OYbnQSacnuTiUnUbK3Q=s180-rw");

    final invoice = Invoice(
      supplier: Supplier(
          filename: f,
          name: 'Sk Spices',
          address: '39 Wyvern Avenue , Leicester ,\nLE4 7HJ',
          paymentInfo: 'https://paypal.me/sarahfieldzz',
          mobileNo: "07424346746",
          EmailAddress: "Skspices@outlook.com"),
      customer: Customer(
          name: widget.arguments.customerdetails
              .customerName, //_offlineLogindetails.details[0].customerName,
          address: widget.arguments.customerdetails
              .address, //_offlineLogindetails.details[0].address,
          mobileNo: widget.arguments.customerdetails.contactNo,
          EmailAddress: widget.arguments.customerdetails.emailAddress),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description:
            'Sharvaya was started with a simple mission – to put the power of technology and data in the hands of technology challenged sales and workflow management organizations.',
        number: InvoceName, //'${DateTime.now().year}-9999',
      ),
      items: invoiceItemList,
      /* items: [
        InvoiceItem(
          description: 'Coffee',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 5.99,
        ),
        InvoiceItem(
          description: 'Water',
          date: DateTime.now(),
          quantity: 8,
          vat: 0.19,
          unitPrice: 0.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Apple',
          date: DateTime.now(),
          quantity: 8,
          vat: 0.19,
          unitPrice: 3.99,
        ),
        InvoiceItem(
          description: 'Mango',
          date: DateTime.now(),
          quantity: 1,
          vat: 0.19,
          unitPrice: 1.59,
        ),
        InvoiceItem(
          description: 'Blue Berries',
          date: DateTime.now(),
          quantity: 5,
          vat: 0.19,
          unitPrice: 0.99,
        ),
        InvoiceItem(
          description: 'Lemon',
          date: DateTime.now(),
          quantity: 4,
          vat: 0.19,
          unitPrice: 1.29,
        ),
      ],*/
    );
    pdfFile = await PdfInvoiceApi.generate(
        invoice, InvoceNamePDF, _Vat.text.toString());
    //PdfApi.openFile(pdfFile);

    productGroupBloc.add(PdfUploadRequestEvent(
        returnMsg,
        pdfFile,
        PdfUploadRequest(
            pkID: pkID.toString(),
            CustomerID: _customerId,
            InvoiceNo: InvoceName,
            Name: InvoceNamePDF,
            CompanyId: CompanyID,
            LoginUserId: LoginUserID)));
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

  void uploadpdfSucess(PdfUploadResponseState state) {
    print("PDFUploadMsg" + state.headerMsg);

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String OrderDate = formatter.format(now);

    productGroupBloc.add(ManagePaymentSaveRequestEvent(
        state.headerMsg,
        "0",
        ManagePaymentSaveRequest(
            PoNo: _InvoiceNoFromEditMode,
            CustomerID: widget.arguments.customerdetails.customerID.toString(),
            PaymentType: "COD",
            PaymentAmt: _Tot_NetAmnt.text,
            PaymentDate: OrderDate,
            TransactionStatus: "Done",
            LoginUserID: LoginUserID,
            CompanyId: CompanyID)));
  }

  void onPlaceOrderHeaderRequest(double totalAmount) {
    arHeaderRequestList.clear();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String OrderDate = formatter.format(now);

    OrderHeaderJsonDetails orderHeaderJsonDetails = OrderHeaderJsonDetails();

    orderHeaderJsonDetails.pkID = "0";
    orderHeaderJsonDetails.OrderNo = arrProductDetails[0].InvoiceNo;
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

    productGroupBloc.add(OrderHeaderJsonDetailsSaveCallEvent(
        context, arrProductDetails[0].InvoiceNo, arHeaderRequestList));
  }

  void _onHeaderResponse(OrderHeaderResponseState state, BuildContext context) {
    String ReturnMsg = state.response.details[0].column2;
    String RetrunPKID = state.response.details[0].column3;

    String ReturnOrderNo = state.response.details[0].column4;
  }

  void onPlaceOrderClicked(
      String retrunPKID, String returnOrderNo, String returnMsg) {
    quotationProductModel.clear();
    for (int i = 0; i < arrProductDetails.length; i++) {
      OrderProductJsonDetails orderProductJsonDetails =
          OrderProductJsonDetails();
      orderProductJsonDetails.productID = arrProductDetails[i].productID;
      orderProductJsonDetails.ProductName = arrProductDetails[i].productName;
      orderProductJsonDetails.pkID = 0;

      orderProductJsonDetails.unit = arrProductDetails[i].unit;
      orderProductJsonDetails.unitPrice = arrProductDetails[i].unitPrice;
      // orderProductJsonDetails.productImage = arrProductDetails[i].productImage;
      orderProductJsonDetails.discountPercent =
          arrProductDetails[i].discountPercent;
      //orderProductJsonDetails.status = arrProductDetails[i].status;
      orderProductJsonDetails.dispatchQuantity =
          arrProductDetails[i].dispatchQuantity;
      orderProductJsonDetails.quantity = arrProductDetails[i].quantity;
      //orderProductJsonDetails.remarks = arrProductDetails[i].remarks;
      orderProductJsonDetails.loginUserID = LoginUserID.toString();
      orderProductJsonDetails.companyId = int.parse(CompanyID);
      //orderProductJsonDetails.InvoiceNo = arrProductDetails[i].InvoiceNo;

      orderProductJsonDetails.InvoiceDate = arrProductDetails[i]
          .InvoiceDate
          .getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

      orderProductJsonDetails.DeliveryDate = formattedDate();

      double Total = arrProductDetails[i].dispatchQuantity *
          arrProductDetails[i].unitPrice;
      orderProductJsonDetails.NetAmount = Total;
      orderProductJsonDetails.NetRate = 0;

      orderProductJsonDetails.Vat = arrProductDetails[i].Vat;
      orderProductJsonDetails.VatAmount =
          Total * arrProductDetails[i].Vat / 100;

      orderProductJsonDetails.Remarks = arrProductDetails[i].Remarks;

      print("fidofidfdf" +
          " Remarks : " +
          arrProductDetails[i].Remarks +
          "Dispatched : " +
          arrProductDetails[i].dispatchQuantity.toString());
      quotationProductModel.add(orderProductJsonDetails);
    }
    // GeneratePDF(quotationProductModel, "Updated");

    productGroupBloc.add(OrderProductJsonDetailsSaveCallEvent(
        context, returnOrderNo, quotationProductModel));
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
        "body": "Your Order Dispatched Successfully",
        "title": OrderNo213,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      'notification': {
        "body": "Your Order Dispatched Successfully",
        "title": OrderNo213
      },
    });
  }

  void _OnTokenGetSucess(TokenListResponseState state) {
    TokenGetFromAPI = state.response.details[0].tokenNo;
  }

  TotalAmountCalculation() {
    double basicamnt = 0.00;
    // double discountamnt = double.parse(_discPerController.text);
    double totdiscountamnt = 0.00;
    double _netamnt = 0.00;
    double _totvat = 0.00;
    for (int i = 0; i < arrProductDetails.length; i++) {
      var unitRate = arrProductDetails[i].unitPrice *
          arrProductDetails[i].dispatchQuantity;
      //var a = unitRate * discountamnt / 100;
      //var b = unitRate - a;
      var c = (unitRate * arrProductDetails[i].Vat) / 100;
      basicamnt = basicamnt + unitRate;
      // totdiscountamnt = totdiscountamnt + a;
      _totvat = _totvat + c;
    }
    _BasicAmount.text = basicamnt.toStringAsFixed(2);
    // _Discount.text = totdiscountamnt.toStringAsFixed(2);
    _Vat.text = _totvat.toStringAsFixed(2);
    _netamnt = basicamnt + _totvat;

    _Tot_NetAmnt.text = _netamnt.toStringAsFixed(2);
  }

  void managepaynmentsucess(ManagePaymentSaveResponseState state) {
    commonalertbox(/*state.ReturnMsg*/ "Order Dispatched Successfully!",
        onTapofPositive: () {
      // Navigator.pop(context);
      sendPushMessage(TokenGetFromAPI, _InvoiceNoFromEditMode, state.ReturnMsg);
      navigateTo(context, OrderCustomerList.routeName, clearSingleStack: true);
    });
  }

  String formattedDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  void _OnorderDetailDeleteSucess(OrderAllDetailDeleteResponseState state) {
    print("OrderDeleted" +
        "OrderDeleteStatus : " +
        state.response.details[0].column1.toString());
  }
}
/**/

/*buildsearch(),
          SizedBox(height: 10,),
          Expanded(child: _buildInquiryList()),*/
