import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/inward/inward_bloc.dart';
import 'package:grocery_app/models/Model_for_dropdown/Model_for_list.dart';
import 'package:grocery_app/models/api_request/Inward/Inward_header_save_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_all_product_delete_request.dart';
import 'package:grocery_app/models/api_request/Inward/inward_product_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Inward/inward_list_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/InwardProductModel.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/customer_search_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/inward_product_list_screen.dart';
import 'package:grocery_app/screens/inward/inward_list/inward_list_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/date_time_extensions.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class AddEditInwardScreenArguments {
  InwardListResponseDetails detail;
  AddEditInwardScreenArguments(this.detail);
}

class AddEditInwardScreen extends BaseStatefulWidget {
  static const routeName = '/AddEditInwardScreen';
  AddEditInwardScreenArguments edit;
  AddEditInwardScreen(this.edit);
  @override
  _AddEditInwardScreenState createState() => _AddEditInwardScreenState();
}

class _AddEditInwardScreenState extends BaseState<AddEditInwardScreen>
    with BasicScreen, WidgetsBindingObserver {
  double height = 50;
  InwardScreenBloc productGroupBloc;
  int headerpkID = 0;
  List<ALL_NAME_ID> PG = [];
  List<ALL_NAME_ID> PB = [];

  InwardListResponseDetails PD;
  String fileName;

  bool _isForUpdate = false;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  bool isImageDeleted = false;
  bool _isswitch = true;

  final TextEditingController edt_InwardNO = TextEditingController();

  final TextEditingController edt_InquiryDate = TextEditingController();
  final TextEditingController edt_ReverseInquiryDate = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  ProfileListResponseDetails _searchInquiryListResponse;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<InWardProductModel> _inquiryProductList = [];

  @override
  void initState() {
    super.initState();
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    productGroupBloc = InwardScreenBloc(baseBloc);

    _isForUpdate = widget.edit != null;
    if (_isForUpdate) {
      PD = widget.edit.detail;
      filldata();
    } else {
      edt_InwardNO.text = "";
      edt_InquiryDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseInquiryDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc,
      child: BlocConsumer<InwardScreenBloc, InwardScreenStates>(
        builder: (BuildContext context, InwardScreenStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, InwardScreenStates state) {
          if (state is InwardProductListResponseState) {
            _onproductListResponse(state);
          }

          if (state is InwardHeaderSaveResponseState) {
            _onHeaderSaveResponse(state, context);
          }

          if (state is InwardProductSaveResponseState) {
            _onProductSaveResponse(state, context);
          }

          if (state is InwardProductALLProductResponseState) {
            _OnAllProductDeleteResponse(state, context);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is InwardProductListResponseState ||
              currentState is InwardHeaderSaveResponseState ||
              currentState is InwardProductSaveResponseState ||
              currentState is InwardProductALLProductResponseState) {
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorWhite),
            onPressed: () => navigateTo(context, InwardListScreen.routeName,
                clearAllStack: true),
          ),
          backgroundColor: Getirblue,
          title: Text(
            "Manage Inward Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      _buildFollowupDate(),
                      SizedBox(
                        height: 15,
                      ),
                      _buildSearchView(),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Getirblue),
                          ),
                          onPressed: () {
                            navigateTo(
                                context, InquiryProductListScreen.routeName,
                                arguments:
                                    AddProductListArgument(edt_InwardNO.text));
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Add Products",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Getirblue),
                          ),
                          onPressed: () {
                            //ontapofsave();
                            ontapofsave();
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Save Inward",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /*ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Getirblue),
                        ),
                        onPressed: () {
                          ontapofsave();
                        },
                        child: Text(
                          "Save Brand",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),*/
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<InWardProductModel> temp =
        await OfflineDbHelper.getInstance().getInwardProductList();
    _inquiryProductList.addAll(temp);
    setState(() {});
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Search Customer *",
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
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: edt_CustomerName,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search customer",
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
                  Icon(
                    Icons.search,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onTapOfSearchView() async {
    if (_isForUpdate == false) {
      navigateTo(context, SearchCustomerInwardScreen.routeName).then((value) {
        if (value != null) {
          _searchInquiryListResponse = value;
          edt_CustomerName.text = _searchInquiryListResponse.customerName;
          edt_CustomerpkID.text =
              _searchInquiryListResponse.customerID.toString();
          /* _inquiryBloc.add(SearchInquiryListByNameCallEvent(
              SearchInquiryListByNameRequest(word:  edt_CustomerName.text,CompanyId:CompanyID.toString(),LoginUserID: LoginUserID,needALL: "1")));
*/
          //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));

        }
      });
    }
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _isForUpdate == true
            ? Container()
            : _selectDate(context, edt_InquiryDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Inquiry Date *",
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
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_InquiryDate.text == null || edt_InquiryDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_InquiryDate.text,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Getirblue,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_InquiryDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseInquiryDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  void ontapofsave() async {
    await getInquiryProductDetails();
    if (edt_InquiryDate.text == "") {
      commonalertbox("Inward Date Is Required !");
    } else if (edt_CustomerName.text == "") {
      commonalertbox("Customer Name Is Required !");
    } else {
      if (_inquiryProductList.length != 0) {
        showCommonDialogWithTwoOptions(
          context,
          "Do You Want To Save This Details?",
          negativeButtonTitle: "No",
          positiveButtonTitle: "Yes",
          onTapOfPositiveButton: () {
            Navigator.pop(context);

            String InwardNo = edt_InwardNO.text.toString();
            String InwardDate = edt_ReverseInquiryDate.text.toString();
            String CustomerID = edt_CustomerpkID.text.toString();

            print("InwardDate" +
                "INDATE : " +
                edt_ReverseInquiryDate.text.toString());

            if (InwardNo != "") {
              productGroupBloc.add(InwardALLProductDeleteRequestCallEvent(
                  InwardAllProductDeleteRequest(
                      InwardNo: InwardNo, CompanyId: CompanyID.toString())));
            }

            productGroupBloc.add(InwardHeaderSaveRequestCallEvent(
                headerpkID,
                InwardHeaderSaveRequest(
                    InwardNo: InwardNo,
                    InwardDate: InwardDate,
                    CustomerID: CustomerID,
                    LoginUserID: LoginUserID,
                    CompanyId: CompanyID.toString())));
          },
        );
      } else {
        commonalertbox(" Product Details Are Required !");
      }
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

  void filldata() async {
    headerpkID = PD.pkID;
    edt_CustomerName.text = PD.customerName;
    edt_CustomerpkID.text = PD.customerID.toString();
    edt_InwardNO.text = PD.inwardNo;
    edt_InquiryDate.text = PD.inwardDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseInquiryDate.text = PD.inwardDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    if (edt_InwardNO.text != "") {
      await _onTapOfDeleteALLProduct();
    }
    productGroupBloc.add(InwardProductListRequestCallEvent(
        InwardProductListRequest(InwardNo: PD.inwardNo, CompanyId: CompanyID)));
  }

  Future<bool> _onBackpress() {
    navigateTo(context, InwardListScreen.routeName, clearAllStack: true);
  }

  void _onproductListResponse(InwardProductListResponseState state) {
    for (int i = 0; i < state.response.details.length; i++) {
      int pkID = state.response.details[i].pkID;

      int ProductID = state.response.details[i].productID;
      int _CompanyId = int.parse(CompanyID);
      double Quantity = state.response.details[i].quantity;
      double UnitRate = state.response.details[i].unitRate;
      double Amount = state.response.details[i].amount;
      double NetAmount = state.response.details[i].netAmount;
      String ProductName = state.response.details[i].productName;
      String Unit = state.response.details[i].unit;
      String _LoginUserID = LoginUserID;

      OnTaptoAddInDB(pkID, ProductID, _CompanyId, Quantity, UnitRate, Amount,
          NetAmount, ProductName, Unit, _LoginUserID);
    }
  }

  void OnTaptoAddInDB(
      int _pkID,
      int _productID,
      int _companyId,
      double _quantity,
      double _unitRate,
      double _amount,
      double _netAmount,
      String _productName,
      String _unit,
      String _loginUserID) async {
    await OfflineDbHelper.getInstance().insertInwardProduct(InWardProductModel(
      "",
      _productID,
      _companyId,
      _quantity,
      _unitRate,
      _amount,
      _netAmount,
      _productName,
      _unit,
      _loginUserID,
    ));
  }

  void _onHeaderSaveResponse(
      InwardHeaderSaveResponseState state, BuildContext context) {
    if (state.response.details[0].column2 == "Inward Added Successfully !" ||
        state.response.details[0].column2 == "Inward Updated Successfully !") {
      updateRetrunInquiryNoToDB(state.response.details[0].column3);
      productGroupBloc.add(InwardProductSaveCallEvent(
          state.response.details[0].column3, _inquiryProductList));
    } else {
      commonalertbox(state.response.details[0].column2,
          onTapofPositive: () async {
        Navigator.pop(context);
        navigateTo(context, InwardListScreen.routeName, clearSingleStack: true);
      });
    }
  }

  void updateRetrunInquiryNoToDB(String ReturnInquiryNo) {
    _inquiryProductList.forEach((element) {
      element.InwardNo = ReturnInquiryNo;
    });
  }

  void _onProductSaveResponse(
      InwardProductSaveResponseState state, BuildContext context) {
    commonalertbox(state.response.details[0].column2,
        onTapofPositive: () async {
      Navigator.pop(context);
      navigateTo(context, InwardListScreen.routeName, clearSingleStack: true);
    });
  }

  void _OnAllProductDeleteResponse(
      InwardProductALLProductResponseState state, BuildContext context) {
    print("DeleAllProduct" + state.response.details[0].column1.toString());
  }

  _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLInwardProduct();
  }
}
