import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';

class ProductDetailsScreen2 extends StatefulWidget {
  static const routeName = '/ProductDetailsScreen2';

  final GroceryItem groceryItem;

  const ProductDetailsScreen2(this.groceryItem);

  @override
  _ProductDetailsScreen2State createState() => _ProductDetailsScreen2State();
}

class _ProductDetailsScreen2State extends State<ProductDetailsScreen2> {
  int amount = 1;
  FToast fToast;
  bool isProductinCart = false;
  bool favorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getproductlistfromdbMethod();
    getproductFavoritelistfromdbMethod();

    print("QTYdff:" + widget.groceryItem.Quantity.toString());

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
          margin: EdgeInsets.only(left: 10, right: 10),
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
                        /*ItemCounterWidgetForCart(
                          onAmountChanged: (newAmount) async {
                            setState(() {
                              amount = newAmount;
                            });
                          },
                        ),*/

                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Getirblue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            "Quantity : " +
                                widget.groceryItem.Quantity.toInt().toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Getirblue,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\£${widget.groceryItem.Quantity.toInt() * widget.groceryItem.UnitPrice}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Getirblue,
                          ),
                        )
                        /*Text(
                          "QTY : 1",
                          style: TextStyle(
                            fontSize: 20,
                            color: Getirblue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "\$${"Price : " + getTotalPrice().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Getirblue,
                            fontWeight: FontWeight.bold,
                          ),
                        )*/
                      ],
                    ),
                    //Spacer(),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Unit Price : " +
                        widget.groceryItem.UnitPrice.toString()),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Unit",
                        customWidget: nutritionWidget()),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Product Specification"),
                    Divider(thickness: 1),
                    SizedBox(
                      height: 10,
                    ),
                    //Spacer(),

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
          widget.groceryItem.ProductImage,
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
        ));
  }

  Widget getProductDataRowWidget(String label, {Widget customWidget}) {
    return InkWell(
      onTap: () {
        if (label == "Product Specification") {
          showCommonDialogWithSingleOption(
              context,
              "Product Specification : " +
                  widget.groceryItem.ProductSpecification +
                  "\n",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        } else if (label == "Unit") {
          showCommonDialogWithSingleOption(
              context, "Product Unit : " + widget.groceryItem.Unit + "\n",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
          /*

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
                " Nutritions : " +
                widget.groceryItem.Unit,
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
            */
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
}
