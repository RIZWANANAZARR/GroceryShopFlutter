import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/tabview_dashboard/only_product_details.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/widgets/item_count_for_cart.dart';

class ProductDetailsScreen1Argument {
  GroceryItem _groceryItem;
  bool _isProductinCart;
  String _ProductGroupID;
  ProductDetailsScreen1Argument(
      this._groceryItem, this._isProductinCart, this._ProductGroupID);
}

class ProductDetailsScreen1 extends BaseStatefulWidget {
  static const routeName = '/ProductDetailsScreen1';

  ProductDetailsScreen1Argument arguments;

  ProductDetailsScreen1(this.arguments);
  // final GroceryItem groceryItem;

  // const ProductDetailsScreen1(this.groceryItem);

  @override
  _ProductDetailsScreen1State createState() => _ProductDetailsScreen1State();
}

class _ProductDetailsScreen1State extends BaseState<ProductDetailsScreen1>
    with BasicScreen, WidgetsBindingObserver {
  int amount = 1;
  FToast fToast;
  bool isProductinCart = false;
  bool favorite = false;
  GroceryItem groceryItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    groceryItem = widget.arguments._groceryItem;
    isProductinCart = widget.arguments._isProductinCart;
    getproductlistfromdbMethod();
    getproductFavoritelistfromdbMethod();
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    await OfflineDbHelper.getInstance().getProductCartList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    for (int i = 0; i < groceryItemdb.length; i++) {
      if (groceryItemdb[i].ProductID == groceryItem.ProductID) {
        isProductinCart = true;
        break;
      } else {
        isProductinCart = false;
      }

      print("FlagDeBIUG" +
          isProductinCart.toString() +
          " DBPRID " +
          groceryItemdb[i].ProductID.toString() +
          groceryItem.ProductID.toString());
    }

    setState(() {});
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            navigateTo(context, TabHomePage.routeName, clearAllStack: true);
          },
          child: Container(
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.keyboard_arrow_left,
                size: 35,
                color: Getirblue,
              )),
        ),
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: AppText(
            text: widget.groceryItem.ProductName,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),*/
      body: SingleChildScrollView(
        child: Container(
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(colors: [cardgredient1, cardgredient2])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //getImageHeaderWidget(),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: AppText(
                        text: groceryItem.ProductName,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Getirblue,
                        /* style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),*/
                      ),
                      subtitle: AppText(
                        text: groceryItem.ProductSpecification,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Getirblue,
                      ),
                      trailing: /*FavoriteToggleIcon()*/ InkWell(
                        onTap: () {
                          setState(() {
                            favorite = !favorite;
                            if (favorite == true) {
                              _OnTaptoAddProductinCartFavorit();
                            } else {
                              _onTapOfDeleteContact();
                            }
                          });
                        },
                        child: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: favorite ? Colors.red : Colors.blueGrey,
                          size: 30,
                        ),
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
                          onAmountChanged: (newAmount) async {
                            setState(() {
                              amount = newAmount;
                            });
                          },
                        ),
                        // Spacer(),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "\£${getTotalPrice().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Getirblue,
                          ),
                        )
                      ],
                    ),
                    //Spacer(),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Product Details"),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Unit",
                        customWidget: nutritionWidget()),

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
                                    context, DynamicCartScreen.routeName,
                                    clearAllStack: true)
                                : _OnTaptoAddProductinCart();
                          },
                          child: Center(
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.primaryColor),
                              child: Center(
                                child: Text(
                                  isProductinCart == true
                                      ? "View On Cart"
                                      : "Add To Basket",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
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
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.primaryColor),
                              child: Center(
                                child: Text(
                                  "Close",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
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
    );
  }

  Widget getImageHeaderWidget() {
    return Container(
        height: 250,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF3366FF).withOpacity(0.1),
                const Color(0xFF3366FF).withOpacity(0.09),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: /*Image(
        image: AssetImage(widget.groceryItem.imagePath),
      ),*/
            Image.network(
          groceryItem.ProductImage,
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
            return Icon(Icons.error);
          },
        ));
  }

  Widget getProductDataRowWidget(String label, {Widget customWidget}) {
    return InkWell(
      onTap: () {
        if (label == "Product Details") {
          groceryItem.Quantity = amount.toDouble();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen2(groceryItem)),
          );
        } else {
          showCommonDialogWithSingleOption(
              context,
              "Product : " +
                  groceryItem.ProductName +
                  "\n" +
                  "Product Specification : " +
                  groceryItem.ProductSpecification +
                  "\n" +
                  "Price : " +
                  groceryItem.UnitPrice.toString() +
                  " Unit : " +
                  groceryItem.Unit,
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

  Widget nutritionWidget() {
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

  double getTotalPrice() {
    var tot = amount * groceryItem.UnitPrice;
    print("sfjklfj" + tot.toString());
    setState(() {
      return amount * groceryItem.UnitPrice;
    });
  }

  _OnTaptoAddProductinCart() async {
    String name = groceryItem.ProductName;
    String Alias = groceryItem.ProductName;
    int ProductID = groceryItem.ProductID;
    int CustomerID = groceryItem.CustomerID;

    String Unit = groceryItem.Unit;
    String description = groceryItem.ProductSpecification;
    String ImagePath = groceryItem.ProductImage;
    int Qty = amount;
    double Amount = groceryItem.UnitPrice; //getTotalPrice();
    double DiscountPer = groceryItem.DiscountPer;
    String LoginUserID = groceryItem.LoginUserID;
    String CompanyID = groceryItem.ComapanyID;
    String ProductSpecification = groceryItem.ProductSpecification;
    String ProductImage = groceryItem.ProductImage;
    double Vat = groceryItem.Vat;

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

    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Cart"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    isProductinCart = true;
    setState(() {
      widget.arguments._groceryItem.IsInCart = isProductinCart;
      widget.arguments._isProductinCart = isProductinCart;
    });

    baseBloc.refreshScreen();

    Navigator.pop(context);
  }

  _OnTaptoAddProductinCartFavorit() async {
    String name = groceryItem.ProductName;
    String Alias = groceryItem.ProductName;
    int ProductID = groceryItem.ProductID;
    int CustomerID = groceryItem.CustomerID;

    String Unit = groceryItem.Unit;
    String description = groceryItem.ProductSpecification;
    String ImagePath = groceryItem.ProductImage;
    int Qty = amount;
    double Amount = groceryItem.UnitPrice; //getTotalPrice();
    double DiscountPer = groceryItem.DiscountPer;
    String LoginUserID = groceryItem.LoginUserID;
    String CompanyID = groceryItem.ComapanyID;
    String ProductSpecification = groceryItem.ProductSpecification;
    String ProductImage = groceryItem.ProductImage;
    double Vat = groceryItem.Vat;

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

    await OfflineDbHelper.getInstance()
        .insertProductToCartFavorit(productCartModel);

    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    //navigateTo(context, DashboardScreen.routeName,clearAllStack: true);
  }

  Future<void> _onTapOfDeleteContact() async {
    await OfflineDbHelper.getInstance()
        .deleteContactFavorit(groceryItem.ProductID);
    fToast.showToast(
      child: showCustomToast(Title: "Item Remove To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void chekforProductExist() {}

  void getproductFavoritelistfromdbMethod() async {
    await getproductductfavoritedetails();
  }

  getproductductfavoritedetails() async {
    await OfflineDbHelper.getInstance().getProductCartFavoritList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartFavoritList();
    for (int i = 0; i < groceryItemdb.length; i++) {
      if (groceryItemdb[i].ProductID == groceryItem.ProductID) {
        favorite = true;
        break;
      } else {
        favorite = false;
      }

      //print("FlagDeBIUG"+isProductinCart.toString() + " DBPRID " + groceryItemdb[i].ProductID.toString() + widget.groceryItem.ProductID.toString());

    }

    setState(() {});
  }
}
