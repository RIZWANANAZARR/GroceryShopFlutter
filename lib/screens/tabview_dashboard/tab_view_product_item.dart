import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_list_from_brandID_groupID_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/product_details/favourite_toggle_icon_widget.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_product_card_view.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/item_count_for_cart.dart';

import 'only_product_details.dart';

class AddTabProductItemsScreenArguments {
  String ProductGroupID;
  String ProductBrandID;

  AddTabProductItemsScreenArguments(this.ProductGroupID, this.ProductBrandID);
}

class TabProductItemsScreen extends BaseStatefulWidget {
  static const routeName = '/TabProductItemsScreen';
  final AddTabProductItemsScreenArguments arguments;
  TabProductItemsScreen(this.arguments);

  @override
  _TabProductItemsScreenState createState() => _TabProductItemsScreenState();
}

class _TabProductItemsScreenState extends BaseState<TabProductItemsScreen>
    with BasicScreen, WidgetsBindingObserver {
  CategoryScreenBloc _categoryScreenBloc;
  String _ProductGroupID;
  String _ProductBrandID;
  List<GroceryItem> AllProducts = [];

  String ProductGroupName = "";

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  final double width = 200;
  double height = 250;

  PersistentBottomSheetController _bottomsheetcontroller; // instance variable

  TextEditingController _amount = TextEditingController();
  bool isAdd = false;
  int amount = 1;
  bool isProductinCart = false;
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);

    _amount.text = "";
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    _ProductGroupID = widget.arguments.ProductGroupID;
    _ProductBrandID = widget.arguments.ProductBrandID;
    /*_categoryScreenBloc
      ..add(TabProductListCallEvent(TabProductListRequest(
          ActiveFlag: "1", GroupID: _ProductGroupID, CompanyId: CompanyID)));*/
    _categoryScreenBloc.add(TabProductListBrandIDGroupIDRequestEvent(
        TabProductListBrandIDGroupIDRequest(
            BrandID: _ProductBrandID,
            GroupID: _ProductGroupID,
            ActiveFlag: "1",
            CompanyId: CompanyID.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is TabProductListResponseState) {
            _onCategoryResponse(state, context);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is TabProductListResponseState) {
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: AllProducts.isNotEmpty
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                /* leading: GestureDetector(
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
          ),*/
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
                ],
                /*title: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: AppText(
              text: ProductGroupName,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),*/
              ),
              body: AllProducts.isNotEmpty
                  ? StaggeredGridView.count(
                      crossAxisCount: 6,
                      // I only need two card horizontally
                      children: AllProducts.asMap().entries.map<Widget>((e) {
                        GroceryItem groceryItem = e.value;
                        return GestureDetector(
                          onTap: () {
                            //onItemClicked(context, groceryItem);
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            // child: ItemCardWidget(groceryItem),
                            child: TabProductItemCardWidget(
                                groceryItem, _ProductGroupID),
                          ),
                        );
                      }).toList(),
                      staggeredTiles: AllProducts.map<StaggeredTile>(
                          (_) => StaggeredTile.fit(2)).toList(),
                      mainAxisSpacing: 3.0,
                      crossAxisSpacing: 0.0, // add some space
                    )
                  : Center(
                      child: Image.asset(
                        NO_DASHBOARD,
                        width: 250,
                      ),
                    ))
          : Center(
              child: Image.asset(
              NO_DASHBOARD,
              height: 200,
              width: 200,
            )),
    );
  }

  Future<bool> _onBackPressed() {
    //navigateTo(context, AccountScreen.routeName, clearAllStack: true);
    _bottomsheetcontroller.close();
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(groceryItem)),
    );
  }

  void _onCategoryResponse(
      TabProductListResponseState state, BuildContext context) {
    AllProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      if (_ProductGroupID == "") {
        ProductGroupName = "All Items";
      } else {
        ProductGroupName = state.response.details[i].productGroupName;
      }
      print("CategoryProduct" + state.response.details[i].productName);
      /*GroceryItem groceryItem = GroceryItem();
      groceryItem.name = state.response.details[i].productName;
      groceryItem.price = state.response.details[i].unitPrice;
      groceryItem.description = "";
      groceryItem.Nutritions = state.response.details[i].unit;
      groceryItem.imagePath = state.response.details[i].productImage==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+state.response.details[i].productImage;
     */

      GroceryItem groceryItem = GroceryItem();
      groceryItem.ProductName = state.response.details[i].productName;
      groceryItem.ProductID = state.response.details[i].pkID;
      groceryItem.ProductAlias = state.response.details[i].productName;
      groceryItem.CustomerID = 1;
      groceryItem.Unit = state.response.details[i].unit;
      groceryItem.UnitPrice = state.response.details[i].unitPrice.toDouble();
      groceryItem.Quantity = 0.00;
      groceryItem.DiscountPer = state.response.details[i].discountPercent;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification =
          state.response.details[i].productSpecification;
      groceryItem.ProductImage = state.response.details[i].productImage == ""
          ? ""
          : _offlineCompanydetails.details[0].siteURL +
              "/productimages/" +
              state.response.details[i].productImage;
      groceryItem.Vat = state.response.details[i].vat;

      AllProducts.add(groceryItem);
    }
  }

  Widget imageWidget(GroceryItem _groceryItem) {
    return AspectRatio(
      aspectRatio: 3 / 3,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(_groceryItem.ProductImage),
                fit: BoxFit.scaleDown)),
        child: Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
            ),
            /*  gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.0),
              ])*/
          ),
          // child: Align(alignment: Alignment.topLeft, child: addWidget())

          /*isAdd == false
              ? Align(alignment: Alignment.topRight, child: addWidget())
              :  Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borderColor,
                        ),
                        color: colorWhite),
                    child: ItemCounterWidget(
                      onAmountChanged: (newAmount) {
                        setState(() {
                          amount = newAmount;
                        });
                      },
                    ),
                  ),
                ),*/
        ),
      ),
    );
  }

  removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }

  Widget getProductDataRowWidget(GroceryItem _groceryItem, String label,
      {Widget customWidget}) {
    return InkWell(
      onTap: () {
        if (label == "Product Details") {
          _groceryItem.Quantity = amount.toDouble();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen2(_groceryItem)),
          );
        } else {
          showCommonDialogWithSingleOption(
              context,
              "Product : " +
                  _groceryItem.ProductName +
                  "\n" +
                  "Product Specification : " +
                  _groceryItem.ProductSpecification +
                  "\n" +
                  "Price : " +
                  _groceryItem.UnitPrice.toString() +
                  " Unit : " +
                  _groceryItem.Unit,
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Row(
          children: [
            AppText(
              text: label,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: Getirblue,
            ),
            Spacer(),
            if (customWidget != null) ...[
              customWidget,
              SizedBox(
                width: 20,
              )
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Getirblue,
            )
          ],
        ),
      ),
    );
  }

  Widget nutritionWidget(GroceryItem groceryItem) {
    return Container(
      padding: EdgeInsets.all(2),
      width: 25,
      height: 20,
      decoration: BoxDecoration(
        color: Getirblue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: AppText(
          text: groceryItem.Unit,
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: colorWhite,
        ),
      ),
    );
  }

  Widget ratingWidget() {
    Widget starIcon() {
      return Icon(
        Icons.star,
        color: Color(0xffF3603F),
        size: 20,
      );
    }

    return Row(
      children: [
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
      ],
    );
  }

  double getTotalPrice(GroceryItem groceryItem) {
    var tot = amount * groceryItem.UnitPrice;
    print("sfjklfj" + tot.toString() + "Amount : " + amount.toString());
    _amount.text = "\£" + tot.toString();
    return amount * groceryItem.UnitPrice;
  }

  _OnTaptoAddProductinCart(GroceryItem groceryItem_) async {
    String name = groceryItem_.ProductName;
    String Alias = groceryItem_.ProductName;
    int ProductID = groceryItem_.ProductID;
    int CustomerID = groceryItem_.CustomerID;

    String Unit = groceryItem_.Unit;
    String description = groceryItem_.ProductSpecification;
    String ImagePath = groceryItem_.ProductImage;
    int Qty = amount;
    double Amount = groceryItem_.UnitPrice; //getTotalPrice();
    double DiscountPer = groceryItem_.DiscountPer;
    String LoginUserID = groceryItem_.LoginUserID;
    String CompanyID = groceryItem_.ComapanyID;
    String ProductSpecification = groceryItem_.ProductSpecification;
    String ProductImage = groceryItem_.ProductImage;
    double Vat = groceryItem_.Vat;

    ProductCartModel productCartModel = new ProductCartModel(
        name,
        Alias,
        ProductID,
        CustomerID,
        Unit,
        Amount,
        Qty,
        DiscountPer,
        LoginUserID,
        CompanyID,
        ProductSpecification,
        ProductImage,
        Vat);

    await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);

    fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Cart"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    isProductinCart = true;

    Navigator.pop(context);
  }

  ItemCardWidget(GroceryItem groceryItem) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //   Positioned(right: 0.00, top: 0.00, child: addWidget()),
          Center(
            child: InkWell(
                onTap: () {
                  // _bottomsheetcontroller.close;

                  _bottomsheetcontroller.close();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(groceryItem)),
                  );

                  // Navigator.pop(bootomsheetContext);
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(widget._item)),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(widget._item)),
                  );*/
                },
                child: imageWidget(groceryItem)),
          ),
          SizedBox(
            height: 10,
          ),
          AppText(
            text: groceryItem.ProductName.toUpperCase(),
            fontSize: 10,
            color: Colors.black,
          ),
          SizedBox(
            height: 5,
          ),
          AppText(
            text: "Price \£${groceryItem.UnitPrice.toStringAsFixed(2)}",
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 5,
          ),

          /* Text(
              "\£${((widget._item.UnitPrice * widget._item.DiscountPer) / 100) + widget._item.UnitPrice}",
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, fontSize: 8)),*/
          /* Text("${widget._item.DiscountPer}\% off",
              style: TextStyle(fontSize: 10)),*/

          Column(
            children: [
              SizedBox(
                height: 5,
              ),
              /*ItemCounterWidget(
                      onAmountChanged: (newAmount) {
                        setState(() {
                          amount = newAmount;
                        });
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),*/
              GestureDetector(
                onTap: () {
                  /*isProductinCart == true
                      ? navigateTo(context, DynamicCartScreen.routeName,
                          clearAllStack: true)
                      : _OnTaptoAddProductinCart();*/
                  //_bottomsheetcontroller.close();
                  setState(() {
                    isAdd = true;

                    _bottomsheetcontroller = showBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return SafeArea(
                            child: Container(
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              height: 300,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: SingleChildScrollView(
                                child: Container(
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      gradient: LinearGradient(colors: [
                                        cardgredient1,
                                        cardgredient2
                                      ])),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //getImageHeaderWidget(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: AppText(
                                                text: groceryItem.ProductName,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Getirblue,
                                              ),
                                              trailing: InkWell(
                                                  onTap: () {
                                                    /* setState(() {
                                                      favorite = !favorite;
                                                      if (favorite == true) {
                                                        _OnTaptoAddProductinCartFavorit();
                                                      } else {
                                                        _onTapOfDeleteContact();
                                                      }
                                                    });*/
                                                  },
                                                  child: /*Icon(
                                                  favorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: favorite
                                                      ? Colors.red
                                                      : Colors.blueGrey,
                                                  size: 30,
                                                ),*/
                                                      FavoriteToggleIcon(
                                                          groceryItem)),
                                              subtitle: AppText(
                                                text: groceryItem
                                                    .ProductSpecification,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Getirblue,
                                              ),
                                            ),
                                            // Spacer(),
                                            Row(
                                              children: [
                                                /* ItemCounterWidget(
                                onAmountChanged: (newAmount) {
                                  setState(() {
                                    amount = newAmount;
                                  });
                                },
                              ),*/
                                                ItemCounterWidgetForCart(
                                                  onAmountChanged:
                                                      (newAmount) async {
                                                    setState(() {
                                                      amount = newAmount;
                                                      print("asjksdh" +
                                                          " Amount : " +
                                                          amount.toString());
                                                      getTotalPrice(groceryItem)
                                                          .toStringAsFixed(2);
                                                    });
                                                  },
                                                  amount: amount,
                                                ),
                                                // Spacer(),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                /*Text(
                                                  "\£${getTotalPrice().toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Getirblue,
                                                  ),
                                                )*/
                                                Expanded(
                                                  child: TextField(
                                                    enabled: false,
                                                    controller: _amount,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    //enabled: false,

                                                    //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                                    decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Getirblue,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Getirblue,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //Spacer(),
                                            Divider(thickness: 1),
                                            getProductDataRowWidget(
                                                groceryItem, "Product Details"),
                                            Divider(thickness: 1),
                                            getProductDataRowWidget(
                                                groceryItem, "Unit",
                                                customWidget: nutritionWidget(
                                                    groceryItem)),

                                            Divider(thickness: 1),
                                            SizedBox(
                                              height: 5,
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, //Center Row contents horizontally,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center, //Center Row contents vertically,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    isProductinCart == true
                                                        ? navigateTo(
                                                            context,
                                                            DynamicCartScreen
                                                                .routeName,
                                                            clearAllStack: true)
                                                        : _OnTaptoAddProductinCart(
                                                            groceryItem);
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      height: 40,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: AppColors
                                                              .primaryColor),
                                                      child: Center(
                                                        child: Text(
                                                          isProductinCart ==
                                                                  true
                                                              ? "View On Cart"
                                                              : "Add to Cart",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      height: 40,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: AppColors
                                                              .primaryColor),
                                                      child: Center(
                                                        child: Text(
                                                          "Close",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 20,
                                            ),
                                            /* AppButton(
                      label: isProductinCart == true
                          ? "View On Cart"
                          : "Add To Basket",
                      onPressed: () {
                        isProductinCart == true
                            ? navigateTo(context, DynamicCartScreen.routeName,
                                clearAllStack: true)
                            : _OnTaptoAddProductinCart();

                        */ /* Fluttertoast.showToast(
                                    msg: "Item Added To Cart",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );*/ /*
                        //
                      },
                    ),*/
                                            //Spacer(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /* child: ProductDetailsScreen1(
                                  ProductDetailsScreen1Argument(widget._item,
                                      isProductinCart, widget._ProductGroupID)),*/
                            ),
                          );
                        });
                  });
                },
                child: Container(
                  height: 32,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.primaryColor),
                  child: Center(
                    child: Text(
                      isProductinCart == true ? "View" : "Add",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
