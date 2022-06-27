import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/only_product_details.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/item_count_for_cart.dart';

class TabProductItemCardWidget extends StatefulWidget {
  final GroceryItem _item;
  final String _ProductGroupID;
  TabProductItemCardWidget(this._item, this._ProductGroupID);

  @override
  _TabProductItemCardWidgetState createState() =>
      _TabProductItemCardWidgetState();
}

class _TabProductItemCardWidgetState extends State<TabProductItemCardWidget> {
//class TabProductItemCardWidget extends StatelessWidget {
  // TabProductItemCardWidget({Key key, this.item}) : super(key: key);
  int amount = 1;
  bool isProductinCart = false;
  FToast fToast;

  final double width = 200;
  double height = 250;
  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 5;

  bool isAdd = false;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  bool favorite = false;
  BuildContext bootomsheetContext;
  PersistentBottomSheetController _bottomsheetcontroller; // instance variable

  TextEditingController _amount = TextEditingController();

  bool isopendilaog = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    getproductlistfromdbMethod();
    getproductFavoritelistfromdbMethod();
    print("ddjfjsfji898ere" + widget._item.ProductImage.toString());

    _amount.text = "\£" + widget._item.UnitPrice.toStringAsFixed(2);
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    await OfflineDbHelper.getInstance().getProductCartList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    for (int i = 0; i < groceryItemdb.length; i++) {
      if (groceryItemdb[i].ProductID == widget._item.ProductID) {
        amount = groceryItemdb[i].Quantity.toInt();
        getTotalPrice().toStringAsFixed(2);
        isProductinCart = true;
        break;
      } else {
        isProductinCart = false;
      }

      print("FlagDeBIUG" +
          isProductinCart.toString() +
          " DBPRID " +
          groceryItemdb[i].ProductID.toString() +
          widget._item.ProductID.toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(5),
      /*decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),*/
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //   Positioned(right: 0.00, top: 0.00, child: addWidget()),
          Center(
            child: InkWell(
                onTap: () {
                  // _bottomsheetcontroller.close;
                  // _bottomsheetcontroller.close();

                  if (SharedPrefHelper.instance.getBool("opendialog") ==
                      false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(widget._item)),
                    );
                  }

                  /* if (_bottomsheetcontroller == null) {

                  }
*/
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
                child: Container(
                  height: 100,
                  width: 100,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: borderColor,
                    ),
                    /*  gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.0),
              ])*/
                  ),
                  child: Image.network(
                    widget._item.ProductImage,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Image.asset(NO_IMAGE_FOUND);
                    },
                  ),
                )), //imageWidget()),
          ),
          SizedBox(
            height: 10,
          ),
          AppText(
            text: widget._item.ProductName.toUpperCase(),
            fontSize: 10,
            color: Colors.black,
          ),
          SizedBox(
            height: 5,
          ),
          AppText(
            text: "Price \£${widget._item.UnitPrice.toStringAsFixed(2)}",
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
                  setState(() {
                    isAdd = true;
                    isopendilaog = true;
                    SharedPrefHelper.instance.putBool("opendialog", true);

                    _bottomsheetcontroller = showBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          bootomsheetContext = bc;
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
                                                text: widget._item.ProductName,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Getirblue,
                                                /* style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),*/
                                              ),
                                              trailing: InkWell(
                                                  onTap: () {
                                                    SharedPrefHelper.instance
                                                        .putBool("opendialog",
                                                            false);
                                                    Navigator.pop(context);
                                                    /* setState(() {
                                                      favorite = !favorite;
                                                      if (favorite == true) {
                                                        _OnTaptoAddProductinCartFavorit();
                                                      } else {
                                                        _onTapOfDeleteContact();
                                                      }
                                                    });*/
                                                  },
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
                                                  )),
                                              /* FavoriteToggleIcon(
                                                          widget._item)),*/
                                              subtitle: AppText(
                                                text: widget
                                                    ._item.ProductSpecification,
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
                                                      getTotalPrice()
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
                                                "Product Details"),
                                            Divider(thickness: 1),
                                            getProductDataRowWidget("Unit",
                                                customWidget:
                                                    nutritionWidget()),

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
                                                    SharedPrefHelper.instance
                                                        .putBool("opendialog",
                                                            false);

                                                    _OnTaptoAddProductinCart();
                                                    /*isProductinCart == true
                                                        ? navigateTo(
                                                            context,
                                                            DynamicCartScreen
                                                                .routeName,
                                                            clearAllStack: true)
                                                        : _OnTaptoAddProductinCart();*/
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
                                                          "Add to Cart",
                                                          /*isProductinCart ==
                                                                  true
                                                              ? "View On Cart"
                                                              : "Add to Cart",*/
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
                                                    _OnTaptoAddProductinCartFavorit();
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
                                                          "Add to Favorite",
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
                      //isProductinCart == true ? "View" : "Add",
                      "Add",
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

  Widget imageWidget() {
    return AspectRatio(
      aspectRatio: 3 / 3,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget._item.ProductImage == ""
                    ? "https://www.ncenet.com/wp-content/uploads/2020/04/No-image-found.jpg"
                    : widget._item.ProductImage),
                fit: BoxFit.scaleDown)),
        child: Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
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

  Widget addWidget() {
    return InkWell(
      onTap: () {
        /* setState(() {
          isAdd = true;
          showBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return SafeArea(
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: GetirYellow,
                    ),
                    height: 300,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ProductDetailsScreen1(widget._item),
                  ),
                );
              });
        });*/
      },
      child: Container(
        height: 25,
        width: 42,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: colorWhite,
            ),
            color: Getirblue),
        child: Center(
          child: Text(
              "${removeTrailingZeros(widget._item.DiscountPer.toStringAsFixed(2))}\%",
              style: TextStyle(fontSize: 10, color: colorWhite)),
          /* Icon(
            Icons.add,
            color: Colors.deepPurple,
            size: 15,
          ),*/
        ),
      ),
    );
  }

  removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
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
          widget._item.ProductImage,
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
          widget._item.Quantity = amount.toDouble();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen2(widget._item)),
          );
        } else {
          showCommonDialogWithSingleOption(
              context,
              "Product : " +
                  widget._item.ProductName +
                  "\n" +
                  "Product Specification : " +
                  widget._item.ProductSpecification +
                  "\n" +
                  "Price : " +
                  widget._item.UnitPrice.toString() +
                  " Unit : " +
                  widget._item.Unit,
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
          text: widget._item.Unit,
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
    var tot = amount * widget._item.UnitPrice;
    print("sfjklfj" + tot.toString() + "Amount : " + amount.toString());
    _amount.text = "\£" + tot.toString();
    return amount * widget._item.UnitPrice;
  }

  _OnTaptoAddProductinCart() async {
    String name = widget._item.ProductName;
    String Alias = widget._item.ProductName;
    int ProductID = widget._item.ProductID;
    int CustomerID = widget._item.CustomerID;

    String Unit = widget._item.Unit;
    String description = widget._item.ProductSpecification;
    String ImagePath = widget._item.ProductImage;
    int Qty = amount;
    double Amount = widget._item.UnitPrice; //getTotalPrice();
    double DiscountPer = widget._item.DiscountPer;
    String LoginUserID = widget._item.LoginUserID;
    String CompanyID = widget._item.ComapanyID;
    String ProductSpecification = widget._item.ProductSpecification;
    String ProductImage = widget._item.ProductImage;

    double Vat = widget._item.Vat; //getTotalPrice();
    print("dksjflkf" + Vat.toString());

    await OfflineDbHelper.getInstance().getProductCartList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    bool isupdated = false;
    int updateQty = 0;
    int id123 = 0;

    for (int i = 0; i < groceryItemdb.length; i++) {
      if (ProductID == groceryItemdb[i].ProductID) {
        isupdated = true;
        updateQty = groceryItemdb[i].Quantity;
        id123 = groceryItemdb[i].id;
        break;
      }
    }

    if (isupdated == true) {
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
          Vat,
          id: id123);
      await OfflineDbHelper.getInstance().updateContact(productCartModel);
    } else {
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
    }

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

  _OnTaptoAddProductinCartFavorit() async {
    String name = widget._item.ProductName;
    String Alias = widget._item.ProductName;
    int ProductID = widget._item.ProductID;
    int CustomerID = widget._item.CustomerID;

    String Unit = widget._item.Unit;
    String description = widget._item.ProductSpecification;
    String ImagePath = widget._item.ProductImage;
    int Qty = amount;
    double Amount = widget._item.UnitPrice; //getTotalPrice();
    double DiscountPer = widget._item.DiscountPer;
    String LoginUserID = widget._item.LoginUserID;
    String CompanyID = widget._item.ComapanyID;
    String ProductSpecification = widget._item.ProductSpecification;
    String ProductImage = widget._item.ProductImage;
    double Vat = widget._item.Vat; //getTotalPrice();

    print("VatAmoutn" + " Vat : " + Vat.toString());

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

    await OfflineDbHelper.getInstance().getProductCartFavoritList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartFavoritList();
    bool isduplicate = false;

    for (int i = 0; i < groceryItemdb.length; i++) {
      if (ProductID == groceryItemdb[i].ProductID) {
        isduplicate = true;
        break;
      }
    }
    if (isduplicate == true) {
      fToast.showToast(
        child: showCustomToast(Title: "Item Already Added To Favorite"),
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      await OfflineDbHelper.getInstance()
          .insertProductToCartFavorit(productCartModel);

      fToast.showToast(
        child: showCustomToast(Title: "Item Added To Favorite"),
        gravity: ToastGravity.BOTTOM,
      );
    }

    //navigateTo(context, DashboardScreen.routeName,clearAllStack: true);
  }

  Future<void> _onTapOfDeleteContact() async {
    await OfflineDbHelper.getInstance()
        .deleteContactFavorit(widget._item.ProductID);
    fToast.showToast(
      child: showCustomToast(Title: "Item Remove To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void getproductFavoritelistfromdbMethod() async {
    await getproductductfavoritedetails();
  }

  getproductductfavoritedetails() async {
    await OfflineDbHelper.getInstance().getProductCartFavoritList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartFavoritList();
    for (int i = 0; i < groceryItemdb.length; i++) {
      if (groceryItemdb[i].ProductID == widget._item.ProductID) {
        favorite = true;
        break;
      } else {
        favorite = false;
      }

      //print("FlagDeBIUG"+isProductinCart.toString() + " DBPRID " + groceryItemdb[i].ProductID.toString() + widget.groceryItem.ProductID.toString());

    }

    setState(() {});
  }

  void gotoproductdetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen2(widget._item)),
    );
  }
}
