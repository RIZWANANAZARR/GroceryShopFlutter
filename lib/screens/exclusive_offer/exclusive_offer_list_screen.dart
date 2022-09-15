import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/Exclusive_Offer/exclusive_offer_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:range_slider_dialog/range_slider_dialog.dart';

class ExclusiveOfferListScreen extends BaseStatefulWidget {
  static const routeName = '/ExclusiveOfferListScreen';

  @override
  _ExclusiveOfferListScreenState createState() =>
      _ExclusiveOfferListScreenState();
}

class _ExclusiveOfferListScreenState extends BaseState<ExclusiveOfferListScreen>
    with BasicScreen, WidgetsBindingObserver {
  CategoryScreenBloc _categoryScreenBloc;
  String _ProductGroupID;
  List<GroceryItem> AllProducts = [];

  String ProductGroupName = "";
  double CardViewHeight = 45.00;
  TextEditingController edt_PercentageFillter = TextEditingController();
  RangeValues _rangeValues = RangeValues(10, 20);
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    _categoryScreenBloc
      ..add(ExclusiveOfferListRequestCallEvent(ExclusiveOfferListRequest(
          PercentTo: "01", PercentFrom: "30", CompanyId: CompanyID)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is ExclusiveOfferListResponseState) {
            _onExclusiveOfferListResponse(state, context);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ExclusiveOfferListResponseState) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 25),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          /* GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.sort,
                color: Colors.black,
              ),
            ),
          ),*/
          GestureDetector(
              onTap: () {
                //navigateTo(context, FilterScreen.routeName);
                // RangeValues _currentRangeValues = const RangeValues(40, 80);

                //showcustomdialog(context1: context,rangeValues: _currentRangeValues);

                //  dialog(context,_currentRangeValues);

                showRangeSliderDialog(context, 1, 100, this._rangeValues, (e) {
                  setState(() {
                    this._rangeValues = e;
                    print("RangValue" +
                        "Value Start: " +
                        e.start.toInt().toString() +
                        "Value End :" +
                        e.end.toInt().toString());
                    _categoryScreenBloc.add(ExclusiveOfferListRequestCallEvent(
                        ExclusiveOfferListRequest(
                            PercentTo: e.start.toInt().toString(),
                            PercentFrom: e.end.toInt().toString(),
                            CompanyId: CompanyID)));
                  });
                });
              },
              child: Container(
                padding: EdgeInsets.only(right: 25),
                child: Icon(
                  Icons.sort,
                  color: Colors.black,
                ),
              ))
        ],
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: AppText(
            text: "Exclusive Offer",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: AllProducts.length != 0
          ? StaggeredGridView.count(
              crossAxisCount: 4,
              // I only need two card horizontally
              children: AllProducts.asMap().entries.map<Widget>((e) {
                GroceryItem groceryItem = e.value;
                return GestureDetector(
                  onTap: () {
                    onItemClicked(context, groceryItem);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: GroceryItemCardWidget(
                      item: groceryItem,
                    ),
                  ),
                );
              }).toList(),
              staggeredTiles:
                  AllProducts.map<StaggeredTile>((_) => StaggeredTile.fit(2))
                      .toList(),
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 0.0, // add some space
            )
          : Center(
              child: Text(
                "No Item Available",
                style: TextStyle(fontSize: 20, color: colorBlack),
              ),
            ),
    );
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(groceryItem)),
    );
  }

  void _onExclusiveOfferListResponse(
      ExclusiveOfferListResponseState state, BuildContext context) {
    AllProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      GroceryItem groceryItem = GroceryItem();
      groceryItem.ProductName = state.response.details[i].productName;
      groceryItem.ProductID = state.response.details[i].productID;
      groceryItem.ProductAlias = state.response.details[i].productName;
      groceryItem.CustomerID = 1;
      groceryItem.Unit = state.response.details[i].unit;
      groceryItem.UnitPrice = state.response.details[i].unitPrice;
      groceryItem.Quantity = 0.00;
      groceryItem.DiscountPer = state.response.details[i].discountPercent;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification =
          state.response.details[i].productSpecification;
      // groceryItem.imagePath = "http://122.169.111.101:206/"+state.response.details[i].productImage;//"http://122.169.111.101:206/productimages/beverages.png";

      groceryItem.ProductImage = state.response.details[i].productImage == ""
          ? "https://img.icons8.com/bubbles/344/no-image.png"
          : "http://122.169.111.101:206/" +
              state.response.details[i].productImage;

      AllProducts.add(groceryItem);
    }
  }

  showcustomdialog({BuildContext context1, RangeValues rangeValues}) async {
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
                    "Filter",
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
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text("Discount % ",
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
                              height: CardViewHeight,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  /* TextField(
                                      enabled: true,
                                      controller: edt_PercentageFillter,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: "Tap to enter Discount",
                                        labelStyle: TextStyle(
                                          color: Color(0xFF000000),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF000000),
                                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                      ),*/
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RangeSlider(
                            values: rangeValues,
                            max: 100,
                            divisions: 5,
                            labels: RangeLabels(
                              rangeValues.start.round().toString(),
                              rangeValues.end.round().toString(),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                rangeValues = values;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        // color: colorPrimary,
                        onPressed: () {
                          setState(() {
                            _categoryScreenBloc.add(
                                ExclusiveOfferListRequestCallEvent(
                                    ExclusiveOfferListRequest(
                                        PercentTo: rangeValues.start
                                            .round()
                                            .toString(),
                                        PercentFrom:
                                            rangeValues.end.round().toString(),
                                        CompanyId: CompanyID)));
                          });
                          // _productList[index1].SerialNo = edt_Application.text;
                          Navigator.pop(context123);
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(color: colorWhite),
                        ))
                  ],
                )),
          ],
        );
      },
    );
  }

  void showRangeSliderDialog(BuildContext context, int minValue, int maxValue,
      RangeValues defaultValue, Function(RangeValues) callback) async {
    await RangeSliderDialog.display(context,
        minValue: minValue ?? 1,
        maxValue: maxValue ?? 40,
        acceptButtonText: 'Apply',
        cancelButtonText: 'Close',
        headerText: 'Select Discount',
        selectedRangeValues: defaultValue, onApplyButtonClick: (value) {
      callback(value);
      Navigator.pop(context);
    });
  }
}
