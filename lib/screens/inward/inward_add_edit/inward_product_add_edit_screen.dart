import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/inward/inward_bloc.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/common/all_name_id.dart';
import 'package:grocery_app/models/database_models/InwardProductModel.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/general_product_search_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class AddInquiryProductScreenArguments {
  InWardProductModel model;

  AddInquiryProductScreenArguments(this.model);
}

class AddInquiryProductScreen extends BaseStatefulWidget {
  static const routeName = '/AddInquiryProductScreen';
  final AddInquiryProductScreenArguments arguments;

  AddInquiryProductScreen(this.arguments);

  @override
  _AddInquiryProductScreenState createState() =>
      _AddInquiryProductScreenState();
}

class _AddInquiryProductScreenState extends BaseState<AddInquiryProductScreen>
    with BasicScreen, WidgetsBindingObserver {
  //DesignationApiResponse _offlineCustomerDesignationData;

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productIDController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _unitPriceController = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _UnitController = TextEditingController();

  FocusNode QuantityFocusNode;

  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  bool isProductExist = false;

  InwardScreenBloc _inquiryBloc;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Designation = [];
  ProductPaginationDetails _searchDetails;
  double airFlow;
  double velocity;
  double valueFinal;
  String sam, sam2;
  String airFlowText, velocityText, finalText;
  List<InWardProductModel> _inquiryProductList = [];

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

    screenStatusBarColor = colorWhite;
    QuantityFocusNode = FocusNode();
    _UnitController.text = "";

    // _offlineCustomerDesignationData = SharedPrefHelper.instance.getCustomerDesignationData();
    if (widget.arguments != null) {
      //for update
      isForUpdate = true;
      _productNameController.text = widget.arguments.model.ProductName;
      _productIDController.text = widget.arguments.model.ProductID.toString();
      _UnitController.text = widget.arguments.model.Unit.toString();

      _quantityController.text =
          widget.arguments.model.Quantity.toStringAsFixed(2);
      _unitPriceController.text =
          widget.arguments.model.UnitRate.toStringAsFixed(2);
      _totalAmountController.text =
          widget.arguments.model.Amount.toStringAsFixed(2);

      //_totalAmountController.text = _quantityController.text +_unitPriceController.text ;
    }
    // _totalAmountController.text = totalCalculated();
    _quantityController.addListener(TotalAmountCalculation);
    _unitPriceController.addListener(TotalAmountCalculation);
    _totalAmountController.addListener(TotalAmountCalculation);
    _inquiryBloc = InwardScreenBloc(baseBloc);
    //_onDesignationCallSuccess(_offlineCustomerDesignationData);
    /* _productNameController.addListener(() {
      QuantityFocusNode.requestFocus();
    });*/
  }

  /* String totalCalculated() {
    airFlowText = _quantityController.text;
    velocityText = _unitPriceController.text;
    finalText = _totalAmountController.text;

    if (airFlowText != '' && velocityText != '') {
      sam = (airFlow * velocity).toString();
      _totalAmountController.value = _totalAmountController.value.copyWith(
        text: sam.toString(),
      );
    }
    return sam;
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InwardScreenBloc, InwardScreenStates>(
        builder: (BuildContext context, InwardScreenStates state) {
          //handle states
          /*  if (state is In) {
            _onDesignationCallSuccess(state);
          }
*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          /* if (currentState is DesignationListEventResponseState) {
            return true;
          }*/
          return false;
        },
        listener: (BuildContext context, InwardScreenStates state) {},
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          /* if (currentState is StateListEventResponseState) {
            return true;
          }
          if (currentState is DistrictListEventResponseState) {
            return true;
          }*/

          return false;
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    QuantityFocusNode.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorWhite),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Getirblue,
          title: Text(
            "${isForUpdate ? "Update" : "Add"} Product",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildSearchView(),
                  SizedBox(height: 20),
                  UnitController(),
                  SizedBox(
                    height: 20,
                  ),
                  Quantity(),
                  SizedBox(
                    height: 20,
                  ),
                  UnitPrice(),
                  SizedBox(
                    height: 20,
                  ),
                  TotalAmount(),
                  SizedBox(
                    height: 20,
                  ),
                  getCommonButton(baseTheme, () {
                    _onTapOfAdd();
                  }, isForUpdate ? "Update" : "Add")
                ],
              ),
            ),
          )),
        ),
      ],
    );
  }

  _onTapOfAdd() async {
    await getInquiryProductDetails();
    if (_formKey.currentState.validate()) {
      //checkExistProduct();

      showCommonDialogWithTwoOptions(
        context,
        "Are you sure you want Add Product ?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes",
        onTapOfPositiveButton: () async {
          Navigator.pop(context);
          print("BoolProductValue" +
              " IsExist : " +
              isProductExist.toString() +
              "ISUpdate : " +
              isForUpdate.toString());
          if (isProductExist == false) {
            if (isForUpdate) {
              /*int pkID,   int ProductID,   int CompanyId,   double Quantity,   double UnitRate,   double Amount,
           double NetAmount,   String ProductName,   String Unit,   String LoginUserID,*/

              // int pkID = widget.arguments.model.pkID;
              int ProductID = widget.arguments.model.ProductID;
              int CompanyId = int.parse(CompanyID);
              double Quantity =
                  double.parse(_quantityController.text.toString());
              double UnitRate =
                  double.parse(_unitPriceController.text.toString());
              double Amount =
                  double.parse(_totalAmountController.text.toString());
              double NetAmount = Amount;
              String ProductName = widget.arguments.model.ProductName;
              String Unit = _UnitController.text.toString();
              String LoginUserID_ = LoginUserID;
              await OfflineDbHelper.getInstance().updateInwardProduct(
                  InWardProductModel(
                      "",
                      ProductID,
                      CompanyId,
                      Quantity,
                      UnitRate,
                      Amount,
                      NetAmount,
                      ProductName,
                      Unit,
                      LoginUserID_,
                      id: widget.arguments.model.id));
            } else {
              int pkID = 0;
              int ProductID = int.parse(_productIDController.text
                  .toString()); //widget.arguments.model.ProductID;
              int CompanyId = int.parse(CompanyID);
              double Quantity =
                  double.parse(_quantityController.text.toString());
              double UnitRate =
                  double.parse(_unitPriceController.text.toString());
              double Amount =
                  double.parse(_totalAmountController.text.toString());
              double NetAmount = Amount;
              String ProductName = _productNameController.text
                  .toString(); //widget.arguments.model.ProductName;
              String Unit = _UnitController.text
                  .toString(); //widget.arguments.model.Unit;
              String LoginUserID_ = LoginUserID;
              await OfflineDbHelper.getInstance()
                  .insertInwardProduct(InWardProductModel(
                "",
                ProductID,
                CompanyId,
                Quantity,
                UnitRate,
                Amount,
                NetAmount,
                ProductName,
                Unit,
                LoginUserID_,
              ));
            }
            Navigator.of(context).pop();
          } else {
            if (isForUpdate == true) {
              //int pkID = widget.arguments.model.pkID;
              int ProductID = widget.arguments.model.ProductID;
              int CompanyId = int.parse(CompanyID);
              double Quantity =
                  double.parse(_quantityController.text.toString());
              double UnitRate =
                  double.parse(_unitPriceController.text.toString());
              double Amount =
                  double.parse(_totalAmountController.text.toString());
              double NetAmount = Amount;
              String ProductName = widget.arguments.model.ProductName;
              String Unit = _UnitController.text.toString();
              String LoginUserID_ = LoginUserID;
              await OfflineDbHelper.getInstance().updateInwardProduct(
                  InWardProductModel(
                      "",
                      ProductID,
                      CompanyId,
                      Quantity,
                      UnitRate,
                      Amount,
                      NetAmount,
                      ProductName,
                      Unit,
                      LoginUserID_,
                      id: widget.arguments.model.id));
              Navigator.of(context).pop();
            } else {
              showCommonDialogWithSingleOption(
                  context, "Duplicate Product Not Allowed..!!",
                  positiveButtonTitle: "OK");
            }
          }
          /* navigateTo(context, InquiryProductListScreen.routeName,
              clearAllStack: true);*/
        },
      );
    }
  }

  Widget Quantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Quantity",
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
                  child: TextFormField(
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      focusNode: QuantityFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _quantityController,
                      onChanged: (_quantityController) {
                        setState(() {
                          airFlow =
                              double.parse(_quantityController.toString());
                        });
                      },
                      onTap: () {
                        setState(() {
                          _quantityController.clear();
                          _totalAmountController.clear();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Tap to enter Quantity",
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
                  Icons.style,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget UnitPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("UnitPrice",
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
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _unitPriceController,
                      onChanged: (_unitPriceController) {
                        setState(() {
                          velocity =
                              double.parse(_unitPriceController.toString());
                        });
                      },
                      onTap: () {
                        setState(() {
                          _unitPriceController.clear();
                          _totalAmountController.clear();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Tap to enter UnitPrice",
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
                Image.network(
                  "https://www.freeiconspng.com/uploads/rupees-symbol-png-10.png",
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
                  height: 18,
                  width: 18,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget TotalAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("NetAmount",
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
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _totalAmountController,
                      onChanged: (value) {
                        setState(() {
                          _totalAmountController.value =
                              _totalAmountController.value.copyWith(
                            text: value.toString(),
                          );
                        });
                      },
                      onTap: () {
                        setState(() {
                          _totalAmountController.clear();
                          _totalAmountController.value =
                              _totalAmountController.value.copyWith(
                            text: '',
                          );
                        });
                      },
                      decoration: InputDecoration(
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
                Image.network(
                  "https://www.freeiconspng.com/uploads/rupees-symbol-png-10.png",
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
                  height: 18,
                  width: 18,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        if (isForUpdate == true) {
          Container();
        } else {
          _onTapOfSearchView();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Product",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

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
                    child: /*TextField(
                      _searchDetails == null
                          ? "Tap to search inquiry"
                          : _searchDetails.productName,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _searchDetails == null
                              ? colorGrayDark
                              : colorBlack),
                    ),
                    */
                        TextFormField(
                            validator: (value) {
                              if (value.toString().trim().isEmpty) {
                                return "Please enter this field";
                              }
                              return null;
                            },
                            onTap: () {
                              if (isForUpdate == true) {
                                Container();
                              } else {
                                _onTapOfSearchView();
                              }

                              ///_onTapOfSearchView();
                            },
                            readOnly: true,
                            controller: _productNameController,
                            decoration: InputDecoration(
                              hintText: "Tap to search Product",
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
    /* navigateTo(context, SearchInquiryProductScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _inquiryBloc.add(InquiryProductSearchNameCallEvent(InquiryProductSearchRequest(pkID: "",CompanyId: "10032",ListMode: "L",SearchKey: value)));
       print("ProductDetailss345"+_searchDetails.productName +"Alias"+ _searchDetails.productAlias);
      }
    });*/
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _searchDetails = value;
        _productNameController.text = _searchDetails.productName.toString();
        _productIDController.text = _searchDetails.pkID.toString();
        _unitPriceController.text = _searchDetails.unitPrice.toString();
        _UnitController.text = _searchDetails.unit.toString();
        //_totalAmountController.text = ""
        if (_productNameController.text ==
            _searchDetails.productName.toString()) {
          QuantityFocusNode.requestFocus();
        }
      }
    });
  }

  TotalAmountCalculation() {
    if (_quantityController.text.toString() != null &&
        _unitPriceController.text.toString() != null) {
      double Quantity = double.parse(_quantityController.text.toString());
      double UnitPrice = double.parse(_unitPriceController.text.toString());
      double TotalAmount = Quantity * UnitPrice;
      _totalAmountController.text = TotalAmount.toString();
    }
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<InWardProductModel> temp =
        await OfflineDbHelper.getInstance().getInwardProductList();
    _inquiryProductList.addAll(temp);
    if (_inquiryProductList.length != 0) {
      for (var i = 0; i < _inquiryProductList.length; i++) {
        if (_inquiryProductList[i].ProductID.toString() ==
            _productIDController.text.toString()) {
          isProductExist = true;
          break;
        } else {
          isProductExist = false;
        }
      }
    } else {
      isProductExist = false;
    }
    setState(() {});
  }

  bool checkExistProduct() {
    if (_inquiryProductList.length != 0) {
      for (var i = 0; i < _inquiryProductList.length; i++) {
        if (_inquiryProductList[i].ProductID.toString() ==
            _productIDController.text.toString()) {
          return isProductExist = true;
        } else {
          return isProductExist = false;
        }
      }
    } else {
      return isProductExist = false;
    }
    setState(() {});
  }

  UnitController() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(" Unit",
          style: TextStyle(
              fontSize: 12,
              color: colorPrimary,
              fontWeight: FontWeight
                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

          ),
      Card(
        elevation: 5,
        color: colorLightGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 60,
          padding: EdgeInsets.only(left: 20, right: 20),
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                child: /*TextField(
                      _searchDetails == null
                          ? "Tap to search inquiry"
                          : _searchDetails.productName,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _searchDetails == null
                              ? colorGrayDark
                              : colorBlack),
                    ),
                    */
                    TextFormField(
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return "Please enter this field";
                          }
                          return null;
                        },
                        controller: _UnitController,
                        decoration: InputDecoration(
                          hintText: "Tap to enter Unit",
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
    ]);
  }
}
