import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/BestSelling/best_selling_list_request.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/Place_order/place_order_delete_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/common/globals.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/placed_order/place_order_product_list_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:range_slider_dialog/range_slider_dialog.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PlacedOrderListScreen extends BaseStatefulWidget {
  static const routeName = '/PlacedOrderListScreen';

  @override
  _PlacedOrderListScreenState createState() => _PlacedOrderListScreenState();
}

class _PlacedOrderListScreenState extends BaseState<PlacedOrderListScreen>
    with BasicScreen, WidgetsBindingObserver {
  CategoryScreenBloc _categoryScreenBloc;
  String _ProductGroupID;
  List<GroceryItem> BestSellingProducts = [];

  String ProductGroupName = "";
  double CardViewHeight = 45.00;
  TextEditingController edt_PercentageFillter = TextEditingController();
  RangeValues _rangeValues = RangeValues(10, 20);
  SfRangeValues _values = SfRangeValues(40.0, 80.0);
  int _currentIntValue = 10;

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  final double width = 174;
  final double height = 250;
  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 18;
  double totalNetAmnt = 0.00;

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
      ..add(PlacedOrderDetailsRequestCallEvent(ProductCartDetailsRequest(
          CustomerID: CustomerID.toString(), CompanyId: CompanyID)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is PlacedOrderResponseState) {
            _onBestSellingListResponse(state, context);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is PlacedOrderResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {
          if (state is PlaceOrderDelete12ResponseState) {
            placeOrderDeleteResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is PlaceOrderDelete12ResponseState) {
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              // navigateTo(context, TabHomePage.routeName, clearAllStack: true);
              navigateTo(context, AccountScreen.routeName, clearAllStack: true);
            },
            child: Container(
                padding: EdgeInsets.only(left: 25),
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 35,
                  color: Getirblue,
                )),
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
                onTap: () async {
                  /* NumberPicker(
                    value: _currentIntValue,
                    minValue: 0,
                    maxValue: 100,
                    step: 10,
                    haptics: true,
                    onChanged: (value) => setState(() => _currentIntValue = value),
                  );*/

                  var age = 25;

                  pickValue();
                },
                child: Container())
          ],
          title: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: AppText(
              text: "Placed Order",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: BestSellingProducts.length != 0
            ? StaggeredGridView.count(
                crossAxisCount: 4,
                // I only need two card horizontally
                children: BestSellingProducts.asMap().entries.map<Widget>((e) {
                  GroceryItem item = e.value;
                  totalNetAmnt = item.Quantity * item.UnitPrice;
                  /* return GestureDetector(
                    onTap: () {
                      onItemClicked(context, groceryItem);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: PlacedItemCardWidget(groceryItem),
                    ),
                  );*/

                  return Container(
                    width: width,
                    height: height,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: borderColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        borderRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: imageWidget(item),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AppText(
                            text: item.ProductName,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          AppText(
                            text: item.ProductAlias,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7C7C7C),
                          ),
                          Row(
                            children: [
                              AppText(
                                text: "\£${totalNetAmnt.toStringAsFixed(2)}",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    showCommonDialogWithTwoOptions(
                                      context,
                                      "Do you want to Delete This Product?",
                                      negativeButtonTitle: "No",
                                      positiveButtonTitle: "Yes",
                                      onTapOfPositiveButton: () {
                                        Navigator.pop(context);
                                        _categoryScreenBloc.add(
                                            PlaceOrderDelete12RequestEvent(
                                                item.pkID.toString(),
                                                PlaceOrderDeleteRequest(
                                                    CompanyId: CompanyID)));
                                      },
                                    );
                                  },
                                  child: addWidget(item))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
                staggeredTiles: BestSellingProducts.map<StaggeredTile>(
                    (_) => StaggeredTile.fit(2)).toList(),
                mainAxisSpacing: 3.0,
                crossAxisSpacing: 0.0, // add some space
              )
            : Center(
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
                        fontSize: 15,
                        color: Getirblue,
                        fontWeight: FontWeight.bold),
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
                      navigateTo(context, TabHomePage.routeName,
                          clearAllStack: true);
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
              )),
      ),
    );
  }

  Future<bool> _onBackpress() {
    navigateTo(context, AccountScreen.routeName, clearAllStack: true);
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    /*  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlacedOrderDetailsScreen(groceryItem)),
    );*/
    navigateTo(context, PlacedOrderDetailsScreen.routeName,
            arguments: PlacedOrderDetailsScreenArguments(groceryItem))
        .then((value) {
      _categoryScreenBloc
        ..add(PlacedOrderDetailsRequestCallEvent(ProductCartDetailsRequest(
            CustomerID: CustomerID.toString(), CompanyId: CompanyID)));
    });
  }

  void _onBestSellingListResponse(
      PlacedOrderResponseState state, BuildContext context) {
    BestSellingProducts.clear();
    for (int i = 0; i < state.cartDeleteResponse.details.length; i++) {
      /*String ProductName;
  String ProductAlias;
  int ProductID;
  int CustomerID;
  String Unit;
  double UnitPrice;
  double Quantity;
  double DiscountPer;
  String LoginUserID;
  String ComapanyID;
  String ProductSpecification;
  String ProductImage;*/
      GroceryItem groceryItem = GroceryItem();
      groceryItem.pkID = state.cartDeleteResponse.details[i].pkID;
      groceryItem.ProductName = state.cartDeleteResponse.details[i].productName;
      groceryItem.ProductID = state.cartDeleteResponse.details[i].productID;
      groceryItem.ProductAlias =
          state.cartDeleteResponse.details[i].productName;
      groceryItem.CustomerID = 1;
      groceryItem.Unit = state.cartDeleteResponse.details[i].unit;
      groceryItem.UnitPrice = state.cartDeleteResponse.details[i].unitPrice;
      groceryItem.Quantity = state.cartDeleteResponse.details[i].quantity;
      groceryItem.DiscountPer =
          state.cartDeleteResponse.details[i].discountPercent;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification = "";
      // groceryItem.imagePath = "http://122.169.111.101:206/"+state.response.details[i].productImage;//"http://122.169.111.101:206/productimages/beverages.png";
      groceryItem.ProductImage = _offlineCompanydetails.details[0].siteURL +
          "productimages/" +
          state.cartDeleteResponse.details[i].productImage;

      BestSellingProducts.add(groceryItem);
    }
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

  void _showDialog(context) {
    showDialog<double>(
        context: context,
        builder: (BuildContext context) {
          return NumberPicker(
            value: _currentIntValue,
            minValue: 0,
            maxValue: 100,
            step: 10,
            haptics: true,
            onChanged: (value) => setState(() => _currentIntValue = value),
          );
        }).then((double value) {
      if (value != null) {
        setState(() => _currentIntValue = value.toInt());
      }
    });
  }

  void pickValue() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  "Select Number From Top 100 Products",
                  style: TextStyle(fontSize: 15, color: colorBlack),
                ),
                Divider(
                  thickness: 1,
                )
              ],
            ),
            content: StatefulBuilder(builder: (context, setState) {
              return NumberPicker(
                axis: Axis.horizontal,
                selectedTextStyle: TextStyle(
                    color: colorPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                value: _currentIntValue,
                minValue: 1,
                maxValue: 100,
                onChanged: (value) => setState(() => _currentIntValue = value),
              );
            }),
            actions: [
              Center(
                child: TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    print("_currentIntValue" +
                        " Value : " +
                        _currentIntValue.toString());
                    _categoryScreenBloc
                      ..add(BestSellingListRequestCallEvent(
                          BestSellingListRequest(
                              Top10: _currentIntValue.toString(),
                              CompanyId: CompanyID)));

                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  Widget imageWidget(GroceryItem item) {
    return GestureDetector(
      onTap: () {
        onItemClicked(context, item);
      },
      child: Container(
          child: //Image.asset(item.imagePath),
              //Image.network("http://122.169.111.101:206/productimages/beverages.png")
              Image.network(
        item.ProductImage,
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
        errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
          return Image.asset(NO_IMAGE_FOUND);
        },
      )),
    );
  }

  Widget addWidget(GroceryItem item) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.primaryColor),
      child: Center(
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }

  void placeOrderDeleteResponse(PlaceOrderDelete12ResponseState state) async {
    await showCommonDialogWithSingleOption(
        Globals.context, state.response.details[0].column1,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, PlacedOrderListScreen.routeName, clearAllStack: true);
    });
  }
}
