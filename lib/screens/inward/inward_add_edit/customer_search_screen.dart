import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/inward/inward_bloc.dart';
import 'package:grocery_app/models/api_request/Profile/profile_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/common/all_name_id.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class SearchCustomerInwardScreen extends BaseStatefulWidget {
  static const routeName = '/SearchCustomerInwardScreen';

  @override
  _SearchCustomerInwardScreenState createState() =>
      _SearchCustomerInwardScreenState();
}

class _SearchCustomerInwardScreenState
    extends BaseState<SearchCustomerInwardScreen>
    with BasicScreen, WidgetsBindingObserver {
  InwardScreenBloc _inquiryBloc;

  // ProfileListResponse _searchCustomerListResponse;
  LoginResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  String CustomerID = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  TextEditingController _customerTypeController = TextEditingController();
  TextEditingController searchbar = TextEditingController();

  List<ProfileListResponseDetails> arrCustomerDetails = [];

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID =
        _offlineLoggedInData.details[0].customerName.replaceAll(' ', "");
    CustomerID = _offlineLoggedInData.details[0].customerID.toString();
    screenStatusBarColor = colorPrimary;
    _inquiryBloc = InwardScreenBloc(baseBloc);
    _customerTypeController.text = "supplier";
    FetchCustomerTypeDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InwardScreenBloc, InwardScreenStates>(
        builder: (BuildContext context, InwardScreenStates state) {
          if (state is GeneralCustomerSearchResponseState) {
            _onSearchInquiryListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GeneralCustomerSearchResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InwardScreenStates state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
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
            "Customer Search",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: colorWhite,
            padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              top: 5,
            ),
            child: Column(
              children: [
                CustomDropDown1("Customer Type",
                    enable1: false,
                    title: "Customer Type",
                    hintTextvalue: "Tap to Select Customer Type",
                    icon: Icon(Icons.arrow_drop_down),
                    controllerForLeft: _customerTypeController,
                    Custom_values1: arr_ALL_Name_ID_For_Folowup_Priority),
                _buildSearchView(),
                Expanded(child: _buildInquiryList())
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            "Min. 3 chars to search Customer",
            style: TextStyle(color: Getirblue, fontWeight: FontWeight.bold),
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
            height: 38,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: searchbar,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      _onSearchChanged(value);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 10),
                      hintText: "Tap to enter customer name",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Getirblue),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: Getirblue,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (arrCustomerDetails == null) {
      return Container();
    }
    return arrCustomerDetails.length != 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              return _buildSearchInquiryListItem(index);
            },
            shrinkWrap: true,
            itemCount: arrCustomerDetails.length,
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
                      ? "No Inward Exist !"
                      : "Search Keyword Not Matched !",
                  style: TextStyle(
                      color: Getirblue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    ProfileListResponseDetails model = arrCustomerDetails[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(model);
        },
        child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
            child: Text(
              model.customerName + "\n" + model.contactNo,
              style: TextStyle(color: Getirblue),
            ),
          ),
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  ///calls search list api
  void _onSearchChanged(String value) {
    if (value.trim().length > 3) {
      _inquiryBloc.add(GeneralCustomerSearchRequestCallEvent(
          1,
          true,
          ProfileListRequest(
              CustomerType: _customerTypeController.text,
              SearchKey: value,
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              CustomerID: "")));
    } else {
      _inquiryBloc.add(GeneralCustomerSearchRequestCallEvent(
          1,
          false,
          ProfileListRequest(
              CustomerType: _customerTypeController.text,
              SearchKey: value,
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              CustomerID: "")));
    }
  }

  void _onSearchInquiryListCallSuccess(
      GeneralCustomerSearchResponseState state) {
    //_searchCustomerListResponse = state.response;
    arrCustomerDetails.clear();
    if (searchbar.text != "") {
      if (state.IsClear == true) {
        arrCustomerDetails.addAll(state.response.details);
      } else {
        arrCustomerDetails.clear();
      }
    }
  }

  void FetchCustomerTypeDropDown() {
    for (var i = 0; i <= 1; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      if (i == 0) {
        all_name_id.Name = "customer";
      } else if (i == 1) {
        all_name_id.Name = "supplier";
      }
      arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
    }
  }

  Widget CustomDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              searchbar.text = "";
              showcustomdialogWithOnlyName(
                  values: Custom_values1,
                  context1: context,
                  controller: controllerForLeft,
                  lable: "Select $Category");

              _inquiryBloc.add(GeneralCustomerSearchRequestCallEvent(
                  1,
                  searchbar.text == "" ? false : true,
                  ProfileListRequest(
                      CustomerType: _customerTypeController.text,
                      SearchKey: searchbar.text,
                      CompanyId: CompanyID.toString(),
                      LoginUserID: LoginUserID,
                      CustomerID: "")));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
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
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: hintTextvalue,
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
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
