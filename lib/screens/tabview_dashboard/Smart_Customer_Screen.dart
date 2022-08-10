import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/inward/inward_bloc.dart';
import 'package:grocery_app/models/api_request/Profile/profile_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class SearchSmartCustomerScreen extends BaseStatefulWidget {
  static const routeName = '/SearchSmartCustomerScreen';

  @override
  _SearchSmartCustomerScreenState createState() =>
      _SearchSmartCustomerScreenState();
}

class _SearchSmartCustomerScreenState
    extends BaseState<SearchSmartCustomerScreen>
    with BasicScreen, WidgetsBindingObserver {
  InwardScreenBloc _inquiryBloc;
  LoginResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  String CustomerID = "";

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
    return WillPopScope(
      onWillPop: _onBackpress,
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: colorWhite),
                onPressed: () {
                  navigateTo(context, TabHomePage.routeName,
                      clearAllStack: true);
                }),
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
              padding: EdgeInsets.only(
                left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                top: 25,
              ),
              child: Column(
                children: [
                  _buildSearchView(),
                  Expanded(child: _buildInquiryList())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackpress() {
    navigateTo(context, TabHomePage.routeName, clearAllStack: true);
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
            style: TextStyle(color: Getirblue),
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
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      _onSearchChanged(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Tap to enter customer name",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Getirblue),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    arrCustomerDetails.clear();
                  },
                  child: Icon(
                    Icons.search,
                    color: Getirblue,
                  ),
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
    if (arrCustomerDetails.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              ListSearchNotFound,
              height: 200,
              width: 200,
            ),
            Text(
              "No Customer Found !",
              style: TextStyle(
                  color: Getirblue, fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
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
                  width: 200,
                ),
                Text(
                  "No Customer Found !",
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
          Navigator.of(context).pop(arrCustomerDetails[index]);
        },
        child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
            child: Text(
              arrCustomerDetails[index].customerName +
                  "\n" +
                  arrCustomerDetails[index].contactNo,
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
    //arrCustomerDetails.clear();

    if (value.trim().length > 3) {
      _inquiryBloc.add(GeneralCustomerSearchRequestCallEvent(
          1,
          true,
          ProfileListRequest(
              CustomerType: "customer",
              SearchKey: value,
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              CustomerID: "")));
    } else {
      _inquiryBloc.add(GeneralCustomerSearchRequestCallEvent(
          1,
          false,
          ProfileListRequest(
              CustomerType: _offlineLoggedInData.details[0].customerType,
              SearchKey: value,
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              CustomerID: "")));
    }
  }

  void _onSearchInquiryListCallSuccess(
      GeneralCustomerSearchResponseState state) {
    arrCustomerDetails.clear();

    if (state.IsClear == true) {
      for (int i = 0; i < state.response.details.length; i++) {
        ProfileListResponseDetails profileListResponseDetails =
            ProfileListResponseDetails();

        profileListResponseDetails.rowNum = state.response.details[i].rowNum;
        profileListResponseDetails.customerID =
            state.response.details[i].customerID;
        profileListResponseDetails.customerName =
            state.response.details[i].customerName;
        profileListResponseDetails.address = state.response.details[i].address;
        profileListResponseDetails.contactNo =
            state.response.details[i].contactNo;
        profileListResponseDetails.customerType =
            state.response.details[i].customerType;
        profileListResponseDetails.emailAddress =
            state.response.details[i].emailAddress;
        profileListResponseDetails.blockCustomer =
            state.response.details[i].blockCustomer;
        profileListResponseDetails.password =
            state.response.details[i].password;
        profileListResponseDetails.profileImage =
            state.response.details[i].profileImage;
        profileListResponseDetails.createdBy =
            state.response.details[i].createdBy;
        profileListResponseDetails.createdDate =
            state.response.details[i].createdDate;
        profileListResponseDetails.updatedBy =
            state.response.details[i].updatedBy;
        profileListResponseDetails.updatedDate =
            state.response.details[i].updatedDate;

        if (state.response.details[i].customerType != "supplier") {
          arrCustomerDetails.add(profileListResponseDetails);
        }
      }
    }
  }
}
