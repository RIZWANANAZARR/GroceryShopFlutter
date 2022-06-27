
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/product/product_bloc.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_seach_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_search.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';




class SearchProductBrandScreen extends BaseStatefulWidget {
  static const routeName = '/SearchProductBrandScreen';

  @override
  _SearchProductBrandScreenState createState() => _SearchProductBrandScreenState();
}

class _SearchProductBrandScreenState extends BaseState<SearchProductBrandScreen>
    with BasicScreen, WidgetsBindingObserver {
  ProductGroupBloc productGroupBloc;

  ProductBrandSearchResponse Response1;

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails= SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID = _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    screenStatusBarColor = colorPrimary;
    productGroupBloc = ProductGroupBloc(baseBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc,
      child: BlocConsumer<ProductGroupBloc, ProductStates>(
        builder: (BuildContext context, ProductStates state) {
          if (state is ProductBrandSearchMainResponseState) {
            _onSearchProductBrand(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ProductBrandSearchMainResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ProductStates state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Product Brand"),
      ),
      body: Column(
        children: [

          Expanded(
            child: Column(
              children: [
                _buildSearchView(),
                Expanded(child: _buildInquiryList())
              ],
            ),
          ),

        ],
      ),
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 20,right: 10),
          child: Text(
              "Min. 3 chars to search ProductBrand",
              style:TextStyle(fontSize: 12,color: colorPrimary,fontWeight: FontWeight.bold)     ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          child: Card(
            elevation: 5,
            color: colorLightGray,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus:true,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        _onSearchChanged(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Tap to enter Product Brand",
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
          ),
        )
      ],
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (Response1 == null) {
      return Container();
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildSearchInquiryListItem(index);
      },
      shrinkWrap: true,
      itemCount: Response1.details.length,
    );
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    ProductBrandSearchDetails PS = Response1.details[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(PS);
        },
        child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, /*top: 25, bottom: 25*/),
            child:ListTile(
              title: Text(PS.brandName),
              subtitle: Text(PS.brandAlias),
            ),
          ),
          margin: EdgeInsets.only(top: 10,left: 10,right: 10),
        ),
      ),
    );
  }

  void _onSearchProductBrand(ProductBrandSearchMainResponseState state) {
    Response1 = state.response;
  }

  void _onSearchChanged(String value) {
    if(value.trim().length>2){
      productGroupBloc.add(ProductBrandSearchMainCallEvent(ProductBrandSearchRequest(CompanyId: CompanyID,LoginUserID: LoginUserID,SearchKey: value)));
    }
  }


}
