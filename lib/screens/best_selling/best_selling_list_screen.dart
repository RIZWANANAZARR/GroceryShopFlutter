import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/BestSelling/best_selling_list_request.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_request/Exclusive_Offer/exclusive_offer_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/filter_screen.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:range_slider_dialog/range_slider_dialog.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BestSellingListScreen extends BaseStatefulWidget {
  static const routeName = '/BestSellingListScreen';

  @override
  _BestSellingListScreenState createState() => _BestSellingListScreenState();
}

class _BestSellingListScreenState extends BaseState<BestSellingListScreen>
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails= SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID = _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    _categoryScreenBloc..add(BestSellingListRequestCallEvent(BestSellingListRequest(Top10:"10",CompanyId: CompanyID)));

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if(state is BestSellingListResponseState)
          {
            _onBestSellingListResponse(state,context);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is BestSellingListResponseState) {
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
            text: "Best Selling",
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
        BestSellingProducts.map<StaggeredTile>((_) => StaggeredTile.fit(2))
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
  void _onBestSellingListResponse(BestSellingListResponseState state, BuildContext context) {

    BestSellingProducts.clear();
    for(int i=0;i<state.response.details.length;i++)
    {

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
      groceryItem.ProductName = state.response.details[i].bestSellingProductName;
      groceryItem.ProductID = state.response.details[i].productID;
      groceryItem.ProductAlias = state.response.details[i].bestSellingProductName;
      groceryItem.CustomerID =1;
      groceryItem.Unit = state.response.details[i].unit;
      groceryItem.UnitPrice = state.response.details[i].unitPrice;
      groceryItem.Quantity = state.response.details[i].bestSellingQuantity;
      groceryItem.DiscountPer = state.response.details[i].discountPercent;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification = state.response.details[i].productSpecification;
      // groceryItem.imagePath = "http://122.169.111.101:206/"+state.response.details[i].productImage;//"http://122.169.111.101:206/productimages/beverages.png";
      groceryItem.ProductImage = state.response.details[i].productImage==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+state.response.details[i].productImage;

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
        }
    ).then((double value) {
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
            title: Column(children: [

              Text("Select Number From Top 100 Products",style: TextStyle(fontSize: 15,color: colorBlack),),
              Divider(thickness: 1,)
            ],),


            content:StatefulBuilder(
                builder: (context, setState) {
                  return NumberPicker(
                    axis: Axis.horizontal,
                    selectedTextStyle: TextStyle(color: colorPrimary,fontSize: 18,fontWeight: FontWeight.bold),
                    value: _currentIntValue,
                    minValue: 1,
                    maxValue: 100,
                    onChanged: (value) => setState(() => _currentIntValue = value),
                  );
                }
            ),

            actions: [
              Center(
                child: TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    print("_currentIntValue"+ " Value : " + _currentIntValue.toString());
                    _categoryScreenBloc..add(BestSellingListRequestCallEvent(BestSellingListRequest(Top10:_currentIntValue.toString(),CompanyId: CompanyID)));

                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }






}



