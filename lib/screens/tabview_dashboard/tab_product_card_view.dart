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
  final GroceryItem itemm;
  final String ProductGroupID;
  final VoidCallback voidCallback;
  final Function(int) onCountChanged;

  TabProductItemCardWidget(
      {this.itemm,
      this.ProductGroupID,
      this.voidCallback,
      this.onCountChanged});

  // method() => createState().methodInPage2();

  @override
  _TabProductItemCardWidgetState createState() =>
      _TabProductItemCardWidgetState(
          voidCallback: voidCallback, onCountChanged: onCountChanged);
}

class _TabProductItemCardWidgetState extends State<TabProductItemCardWidget> {
  final VoidCallback voidCallback;
  final Function(int) onCountChanged;

  _TabProductItemCardWidgetState({this.voidCallback, this.onCountChanged});

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
    print("ddjfjsfji898ere" + widget.itemm.ProductImage.toString());

    _amount.text = "\£" + widget.itemm.UnitPrice.toStringAsFixed(2);
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    await OfflineDbHelper.getInstance().getProductCartList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    for (int i = 0; i < groceryItemdb.length; i++) {
      if (groceryItemdb[i].ProductID == widget.itemm.ProductID) {
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
          widget.itemm.ProductID.toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
                onTap: () {
                  if (SharedPrefHelper.instance.getBool("opendialog") ==
                      false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(widget.itemm)),
                    );
                  }
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
                  ),
                  child: Image.network(
                    widget.itemm.ProductImage,
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
            text: widget.itemm.ProductName.toUpperCase(),
            fontSize: 10,
            color: Colors.black,
          ),
          SizedBox(
            height: 5,
          ),
          AppText(
            text: "Price \£${widget.itemm.UnitPrice.toStringAsFixed(2)}",
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            children: [
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
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
                                                text: widget.itemm.ProductName,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Getirblue,
                                              ),
                                              trailing: InkWell(
                                                  onTap: () {
                                                    SharedPrefHelper.instance
                                                        .putBool("opendialog",
                                                            false);
                                                    Navigator.pop(context);
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
                                              subtitle: AppText(
                                                text: widget
                                                    .itemm.ProductSpecification,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Getirblue,
                                              ),
                                            ),
                                            // Spacer(),
                                            Row(
                                              children: [
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

                                                Expanded(
                                                  child: TextField(
                                                    enabled: false,
                                                    controller: _amount,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    keyboardType:
                                                        TextInputType.text,
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                image: NetworkImage(widget.itemm.ProductImage == ""
                    ? "https://www.ncenet.com/wp-content/uploads/2020/04/No-image-found.jpg"
                    : widget.itemm.ProductImage),
                fit: BoxFit.scaleDown)),
        child: Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget addWidget() {
    return InkWell(
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
              "${removeTrailingZeros(widget.itemm.DiscountPer.toStringAsFixed(2))}\%",
              style: TextStyle(fontSize: 10, color: colorWhite)),
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
        child: Image.network(
          widget.itemm.ProductImage,
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
          widget.itemm.Quantity = amount.toDouble();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen2(widget.itemm)),
          );
        } else {
          showCommonDialogWithSingleOption(
              context,
              "Product : " +
                  widget.itemm.ProductName +
                  "\n" +
                  "Product Specification : " +
                  widget.itemm.ProductSpecification +
                  "\n" +
                  "Price : " +
                  widget.itemm.UnitPrice.toString() +
                  " Unit : " +
                  widget.itemm.Unit,
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
          text: widget.itemm.Unit,
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
    var tot = amount * widget.itemm.UnitPrice;
    print("sfjklfj" + tot.toString() + "Amount : " + amount.toString());
    _amount.text = "\£" + tot.toString();
    return amount * widget.itemm.UnitPrice;
  }

  _OnTaptoAddProductinCart() async {
    String name = widget.itemm.ProductName;
    String Alias = widget.itemm.ProductName;
    int ProductID = widget.itemm.ProductID;
    int CustomerID = widget.itemm.CustomerID;

    String Unit = widget.itemm.Unit;
    String description = widget.itemm.ProductSpecification;
    String ImagePath = widget.itemm.ProductImage;
    int Qty = amount;
    double Amount = widget.itemm.UnitPrice; //getTotalPrice();
    double DiscountPer = widget.itemm.DiscountPer;
    String LoginUserID = widget.itemm.LoginUserID;
    String CompanyID = widget.itemm.ComapanyID;
    String ProductSpecification = widget.itemm.ProductSpecification;
    String ProductImage = widget.itemm.ProductImage;

    double Vat = widget.itemm.Vat; //getTotalPrice();
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

    List<ProductCartModel> groceryItemdb123 =
        await OfflineDbHelper.getInstance().getProductCartList();
    int counttt = groceryItemdb123.length;

    setState(() {
      SharedPrefHelper.instance.putInt("CounterValue", counttt);
    });
    fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Cartfdfdf"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    isProductinCart = true;
    Navigator.of(context).pop(counttt);
  }

  _OnTaptoAddProductinCartFavorit() async {
    String name = widget.itemm.ProductName;
    String Alias = widget.itemm.ProductName;
    int ProductID = widget.itemm.ProductID;
    int CustomerID = widget.itemm.CustomerID;

    String Unit = widget.itemm.Unit;
    String description = widget.itemm.ProductSpecification;
    String ImagePath = widget.itemm.ProductImage;
    int Qty = amount;
    double Amount = widget.itemm.UnitPrice; //getTotalPrice();
    double DiscountPer = widget.itemm.DiscountPer;
    String LoginUserID = widget.itemm.LoginUserID;
    String CompanyID = widget.itemm.ComapanyID;
    String ProductSpecification = widget.itemm.ProductSpecification;
    String ProductImage = widget.itemm.ProductImage;
    double Vat = widget.itemm.Vat; //getTotalPrice();

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
        .deleteContactFavorit(widget.itemm.ProductID);
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
      if (groceryItemdb[i].ProductID == widget.itemm.ProductID) {
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
          builder: (context) => ProductDetailsScreen2(widget.itemm)),
    );
  }
}
