import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/item_count_for_cart.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/ProductDetailsScreen';

  final GroceryItem groceryItem;

  const ProductDetailsScreen(this.groceryItem);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int amount = 1;
  FToast fToast;
  bool isProductinCart = false;
  bool favorite = false;
  TextEditingController _amount = TextEditingController();
  LoginResponse _offlineLogindetails;
  String LoginUserID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _amount.text = "1";
    getproductlistfromdbMethod();
    getproductFavoritelistfromdbMethod();
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();

    print("sdjfjkf" + widget.groceryItem.ProductImage);

    //amount = widget.groceryItem.Quantity.toInt();
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    await OfflineDbHelper.getInstance().getProductCartList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    for (int i = 0; i < groceryItemdb.length; i++) {
      if (groceryItemdb[i].ProductID == widget.groceryItem.ProductID) {
        amount = groceryItemdb[i].Quantity.toInt();
        print("Itemmd" + amount.toString());

        _amount.text = groceryItemdb[i].Quantity.toInt().toString();
        isProductinCart = true;
        break;
      } else {
        isProductinCart = false;
      }

      print("FlagDeBIUG" +
          isProductinCart.toString() +
          " DBPRID " +
          groceryItemdb[i].ProductID.toString() +
          widget.groceryItem.ProductID.toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            //navigateTo(context, TabHomePage.routeName, clearAllStack: true);
            Navigator.pop(context);
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
            text: widget.groceryItem.ProductName.toUpperCase(),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Getirblue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getImageHeaderWidget(),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: AppText(
                          text: widget.groceryItem.ProductName.toUpperCase(),
                          fontSize: 24,
                          color: Getirblue,
                          fontWeight: FontWeight.bold
                          /* style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),*/
                          ),
                      subtitle: AppText(
                        text: widget.groceryItem.ProductAlias,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Getirblue,
                      ),
                      trailing: /*FavoriteToggleIcon()*/ InkWell(
                        onTap: () {
                          if (LoginUserID != "dummy") {
                            setState(() {
                              favorite = !favorite;
                              if (favorite == true) {
                                _OnTaptoAddProductinCartFavorit();
                              } else {
                                _onTapOfDeleteContact();
                              }
                            });
                          } else {
                            navigateTo(context, LoginScreen.routeName,
                                clearAllStack: true);
                          }
                        },
                        child: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: favorite ? Colors.red : Colors.blueGrey,
                          size: 30,
                        ),
                      ),
                    ),

                    // Spacer(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        /* ItemCounterWidget(
                                onAmountChanged: (newAmount) {
                                  setState(() {
                                    amount = newAmount;
                                  });
                                },
                              ),*/
                        isProductinCart == false
                            ? ItemCounterWidgetForCart(
                                onAmountChanged: (newAmount) async {
                                  setState(() {
                                    amount = newAmount;
                                    //getTotalPrice().toStringAsFixed(2);
                                  });
                                },
                                amount: getnumber(),
                              )
                            : Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Getirblue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Text(
                                  "Quantity : " + amount.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Getirblue,
                                  ),
                                ),
                              ),
                        Spacer(),
                        /*SizedBox(
                          width: 20,
                        ),*/
                        Text(
                          "\£${getTotalPrice().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            color: Getirblue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    //Spacer(),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Product Details"),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Unit",
                        customWidget: nutritionWidget()),
                    Divider(thickness: 1),
                    SizedBox(
                      height: 10,
                    ),
                    //Spacer(),
                    AppButton(
                      label: isProductinCart == true
                          ? "View On Cart"
                          : "Add to Cart",
                      onPressed: () {
                        isProductinCart == true
                            ? navigateTo(context, DynamicCartScreen.routeName,
                                clearAllStack: true)
                            : _OnTaptoAddProductinCart();

                        /* Fluttertoast.showToast(
                                    msg: "Item Added To Cart",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );*/
                        //
                      },
                    ),
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

            widget.groceryItem.ProductImage ==
                        "http://122.169.111.101:306//productimages/no-figure.png" ||
                    widget.groceryItem.ProductImage == "" ||
                    widget.groceryItem.ProductImage.toString() == "null"
                ? Image.asset(
                    NO_IMAGE_FOUND,
                    height: 100,
                    width: 100,
                  )
                : Image.network(widget.groceryItem.ProductImage));
  }

  Widget getProductDataRowWidget(String label, {Widget customWidget}) {
    return InkWell(
      onTap: () {
        if (label == "Product Details") {
          showCommonDialogWithSingleOption(
              context,
              "Product : " +
                  widget.groceryItem.ProductName +
                  "\n" +
                  "Product Specification : " +
                  widget.groceryItem.ProductSpecification +
                  "\n" +
                  "Price : " +
                  widget.groceryItem.UnitPrice.toString() +
                  " Unit : " +
                  widget.groceryItem.Unit,
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Row(
          children: [
            AppText(
              text: label,
              fontWeight: FontWeight.w600,
              fontSize: 16,
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
            )
          ],
        ),
      ),
    );
  }

  Widget nutritionWidget() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(5),
      ),
      child: AppText(
        text: widget.groceryItem.Unit,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Getirblue,
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
    print("dfhjdf" +
        "amnt : " +
        amount.toString() +
        " Unit Price " +
        widget.groceryItem.UnitPrice.toString());
    return amount * widget.groceryItem.UnitPrice;
  }

  _OnTaptoAddProductinCart() async {
    String name = widget.groceryItem.ProductName;
    String Alias = widget.groceryItem.ProductName;
    int ProductID = widget.groceryItem.ProductID;
    int CustomerID = widget.groceryItem.CustomerID;

    String Unit = widget.groceryItem.Unit;
    String description = widget.groceryItem.ProductSpecification;
    String ImagePath = widget.groceryItem.ProductImage;
    int Qty = amount;
    double Amount = widget.groceryItem.UnitPrice; //getTotalPrice();
    double DiscountPer = widget.groceryItem.DiscountPer;
    String LoginUserID = widget.groceryItem.LoginUserID;
    String CompanyID = widget.groceryItem.ComapanyID;
    String ProductSpecification = widget.groceryItem.ProductSpecification;
    String ProductImage = widget.groceryItem.ProductImage;
    double Vat = widget.groceryItem.Vat;

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
    navigateTo(context, TabHomePage.routeName, clearAllStack: true);
  }

  _OnTaptoAddProductinCartFavorit() async {
    String name = widget.groceryItem.ProductName;
    String Alias = widget.groceryItem.ProductName;
    int ProductID = widget.groceryItem.ProductID;
    int CustomerID = widget.groceryItem.CustomerID;

    String Unit = widget.groceryItem.Unit;
    String description = widget.groceryItem.ProductSpecification;
    String ImagePath = widget.groceryItem.ProductImage;
    int Qty = amount;
    double Amount = widget.groceryItem.UnitPrice; //getTotalPrice();
    double DiscountPer = widget.groceryItem.DiscountPer;
    String LoginUserID = widget.groceryItem.LoginUserID;
    String CompanyID = widget.groceryItem.ComapanyID;
    String ProductSpecification = widget.groceryItem.ProductSpecification;
    String ProductImage = widget.groceryItem.ProductImage;
    double Vat = widget.groceryItem.Vat;

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
        .deleteContactFavorit(widget.groceryItem.ProductID);
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
      if (groceryItemdb[i].ProductID == widget.groceryItem.ProductID) {
        favorite = true;
        break;
      } else {
        favorite = false;
      }

      //print("FlagDeBIUG"+isProductinCart.toString() + " DBPRID " + groceryItemdb[i].ProductID.toString() + widget.groceryItem.ProductID.toString());

    }

    setState(() {});
  }

  getnumber() {
    int amnt = int.parse(_amount.text);
    return amnt;
  }
}
