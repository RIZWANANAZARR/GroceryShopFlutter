import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/inward/inward_bloc.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_pagination_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class SearchInquiryProductScreen extends BaseStatefulWidget {
  static const routeName = '/SearchInquiryProductScreen';

  @override
  _SearchInquiryProductScreenState createState() =>
      _SearchInquiryProductScreenState();
}

class _SearchInquiryProductScreenState
    extends BaseState<SearchInquiryProductScreen>
    with BasicScreen, WidgetsBindingObserver {
  InwardScreenBloc _inquiryBloc;
  ProductPaginationResponse _searchProductListResponse;
  //CustomerSourceResponse _offlineCustomerSource;
  LoginResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";

  TextEditingController searchbar = TextEditingController();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimaryLight;
    // _offlineCustomerSource= SharedPrefHelper.instance.getCustomerSourceData();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID =
        _offlineLoggedInData.details[0].customerName.replaceAll(' ', "");
    _inquiryBloc = InwardScreenBloc(baseBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InwardScreenBloc, InwardScreenStates>(
        builder: (BuildContext context, InwardScreenStates state) {
          if (state is GenralProductSearchResponseState) {
            _onSearchProductListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GenralProductSearchResponseState) {
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
            "Search Product",
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
              top: 25,
            ),
            child: Column(
              children: [
                _buildSearchView(),
                Expanded(child: _buildProductList())
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
        Text("Min. 3 chars to search Product",
            style: TextStyle(
                fontSize: 12,
                color: colorPrimary,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorGray,
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
                    controller: searchbar,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      _onSearchChanged(value.trim());
                    },
                    decoration: InputDecoration(
                      hintText: "Enter product name",
                      border: InputBorder.none,
                    ),
                    style: baseTheme.textTheme.subtitle2
                        .copyWith(color: colorBlack),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///builds product list
  Widget _buildProductList() {
    if (_searchProductListResponse == null) {
      return Center(
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
                ? "No Product Found !"
                : "Search Keyword Not Matched !",
            style: TextStyle(
                color: Getirblue, fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ));
    }
    if (_searchProductListResponse.details.isEmpty) {
      //return getCommonEmptyView(message: "No products found");
      return Center(
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
                ? "No Product Exist !"
                : "Search Keyword Not Matched !",
            style: TextStyle(
                color: Getirblue, fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ));
    }
    return _searchProductListResponse.details.length != 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              return _buildSearchProductListItem(index);
            },
            shrinkWrap: true,
            itemCount: _searchProductListResponse.details.length,
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
                      ? "No Product Exist !"
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
  Widget _buildSearchProductListItem(int index) {
    ProductPaginationDetails model = _searchProductListResponse.details[index];

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
              model.productName,
              style: TextStyle(fontSize: 15, color: Getirblue),
            ),
          ),
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  ///calls search list api
  void _onSearchChanged(String value) {
    if (value.trim().length > 2) {
      // _inquiryBloc.add(InquiryProductSearchNameCallEvent(InquiryProductSearchRequest(pkID: "",CompanyId:CompanyID.toString() ,ListMode: "L",SearchKey: value)));
      _inquiryBloc.add(GeneralProductSearchCallEvent(
          1,
          ProductPaginationRequest(
              CompanyId: CompanyID.toString(),
              SearchKey: value,
              ActiveFlag: "1")));
    }
  }

  void _onSearchProductListCallSuccess(GenralProductSearchResponseState state) {
    for (var i = 0; i < state.response.details.length; i++) {
      print("InquiryProductName" + state.response.details[i].productName);
    }
    _searchProductListResponse = state.response;
  }
}
