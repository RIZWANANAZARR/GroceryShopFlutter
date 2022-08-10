import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/cart/checkout_bottom_sheet.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/item_count_for_cart.dart';

class DynamicCartScreen extends BaseStatefulWidget {
  static const routeName = '/DynamicCartScreen';

  @override
  _DynamicCartScreenState createState() => _DynamicCartScreenState();
}

class _DynamicCartScreenState extends BaseState<DynamicCartScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<ProductCartModel> getproductlistfromdb = [];
  int amount = 1;
  double TotalAmount = 0;
  double tot = 0.00;

  TextEditingController tot_amnt = TextEditingController();
  FToast fToast;
  CategoryScreenBloc _categoryScreenBloc;

  List<CartModel> arrCartAPIList = [];

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  int CustomerID = 0;
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID;
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    tot_amnt.text = "";

    fToast = FToast();
    fToast.init(context);
    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    getproductlistfromdbMethod();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is InquiryProductSaveResponseState) {
            _onCategoryResponse(state, context);
          }
          if (state is CartDeleteResponseState) {
            _OnCartDeleteRequest(state, context);
          }
          /*if(state is ProductCartResponseState)
            {


              _onCartListResponse(state,context);
            }*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is InquiryProductSaveResponseState ||
                  currentState is CartDeleteResponseState
              /* currentState is ProductCartResponseState*/
              ) {
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        getproductlistfromdbMethod();
        // navigateTo(context, ShopDashBoard.routeName, clearAllStack: true);
        navigateTo(context, TabHomePage.routeName, clearAllStack: true);
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorWhite,
          leading: InkWell(
              onTap: () {
                _categoryScreenBloc.add(CartDeleteRequestCallEvent(
                    CustomerID, CartDeleteRequest(CompanyID: CompanyID)));

                getproductlistfromdbMethod();
                navigateTo(context, TabHomePage.routeName, clearAllStack: true);

                // navigateTo(context, TabHomePage.routeName, clearAllStack: true);
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                size: 35,
                color: Getirblue,
              )),
          title: Text(
            "My Cart",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Getirblue,
            ),
          ),
          actions: [
            InkWell(
                onTap: () async {
                  showCommonDialogWithTwoOptions(
                    context,
                    "Do you want to Delete All Products?",
                    negativeButtonTitle: "No",
                    positiveButtonTitle: "Yes",
                    onTapOfPositiveButton: () async {
                      Navigator.pop(context);

                      baseBloc.emit(ShowProgressIndicatorState(true));

                      await OfflineDbHelper.getInstance().deleteContactTable();

                      _categoryScreenBloc.add(CartDeleteRequestCallEvent(
                          CustomerID, CartDeleteRequest(CompanyID: CompanyID)));

                      setState(() {
                        getproductlistfromdb.clear();
                        TotalAmount = 0.00;
                        //invisibleAfterDeleteAllTap = false;
                      });

                      baseBloc.emit(ShowProgressIndicatorState(false));
                    },
                  );
                },
                child: getproductlistfromdb.length != 0
                    ? DeleteAll()
                    : Container())
          ],
        ),
        body: getproductlistfromdb.length != 0
            ? Container(
                padding: EdgeInsets.only(
                  left: 5 /*DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2*/,
                  right: 5 /*DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2*/,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (getproductlistfromdb.length != 0)
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _buildInquiryListItem(index);
                                },
                                shrinkWrap: true,
                                itemCount: getproductlistfromdb.length,
                              )
                            else
                              Center(
                                child: Image.asset(
                                  EMPTYCART,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    /* if (getproductlistfromdb.length != 0)
                  Align(
                      alignment: Alignment.bottomRight,
                      child: getButtonPriceWidget())
                else
                  Container(),
                if (getproductlistfromdb.length != 0)
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: getCheckoutButton(context))
                else
                  Container()*/
                    getproductlistfromdb.length != 0
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1, child: getButtonPriceWidget()),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                    flex: 2, child: getCheckoutButton(context))
                              ],
                            ))
                        : Container(),
                  ],
                ),
              )
            : Center(
                child: Image.asset(
                  EMPTYCART,
                ),
              ),
      ),
    );
  }

  Widget _buildInquiryListItem(int index) {
    ProductCartModel productCartModel = getproductlistfromdb[index];

    if (productCartModel.ProductImage.toString() ==
        "http://122.169.111.101:306//productimages/no-figure.png") {
      productCartModel.ProductImage = "";
    }

    print('QTY4334' + productCartModel.ProductImage.toString());
    int ItemWiseQTY = 0;
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                showCommonDialogWithTwoOptions(
                  context,
                  "Do you want to Delete This Product?",
                  negativeButtonTitle: "No",
                  positiveButtonTitle: "Yes",
                  onTapOfPositiveButton: () {
                    Navigator.pop(context);

                    _onTapOfDeleteContact(index);
                    fToast.showToast(
                      child: showCustomToast(Title: "Item Deleted !"),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: Duration(seconds: 2),
                    );
                  },
                );
              },
              child: Icon(
                Icons.delete,
                color: Getirblue,
                size: 30,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              GroceryItem groceryItem = GroceryItem();
              groceryItem.ProductName = getproductlistfromdb[index].ProductName;
              groceryItem.ProductID = getproductlistfromdb[index].ProductID;
              groceryItem.ProductAlias =
                  getproductlistfromdb[index].ProductName;
              groceryItem.CustomerID = 1;
              groceryItem.Unit = getproductlistfromdb[index].Unit;
              groceryItem.UnitPrice = getproductlistfromdb[index].UnitPrice;
              groceryItem.Quantity =
                  getproductlistfromdb[index].Quantity.toDouble();
              groceryItem.DiscountPer =
                  getproductlistfromdb[index].DiscountPercent;
              groceryItem.LoginUserID = LoginUserID;
              groceryItem.ComapanyID = CompanyID;
              groceryItem.ProductSpecification =
                  getproductlistfromdb[index].ProductSpecification;
              groceryItem.ProductImage = getproductlistfromdb[index]
                  .ProductImage; //getproductlistfromdb[index].ProductImage==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+ getproductlistfromdb[index].ProductImage;

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(groceryItem)),
              );
            },
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              /* mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.stretch,*/
              children: [
                //imageWidget(productCartModel.imagePath),
                // Image.asset(productCartModel.imagePath,width: 100,height: 100,),

                Image.network(
                  getproductlistfromdb[index].ProductImage,
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
                    return Image.asset(
                      NO_IMAGE_FOUND,
                      height: 80,
                      width: 80,
                    );
                  },
                  width: 80,
                  height: 80,
                ),

                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* AppText(
                      text: productCartModel.ProductName,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),*/
                    Text(
                      productCartModel.ProductName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    /* ItemCounterWidget(
                       onAmountChanged: (newAmount) {
                         setState(() {
                           amount = newAmount;
                           //ItemWiseQTY = newAmount;
                         });
                       }
                   )*/
                    ItemCounterWidgetForCart(
                      onAmountChanged: (newAmount) async {
                        setState(() {
                          //tot_amnt.text = TotalAmount.toStringAsFixed(2);
                          productCartModel.Quantity = newAmount;

                          /* TotalAmount -= productCartModel.price * newAmount;
                         TotalAmount += productCartModel.price * newAmount;*/

                          // getproductlistfromdb[getproductlistfromdb.indexWhere((i) => i.price == productCartModel.price)] = productCartModel;
                          // getproductlistfromdb[getproductlistfromdb.indexWhere((i) => i.Qty == productCartModel.Qty)] = productCartModel;
                          UpdateItems(productCartModel, index, newAmount);

                          //ItemWiseQTY = newAmount;
                        });
                      },
                      amount: productCartModel.Quantity,
                    )
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              alignment: Alignment.bottomRight,
              child: AppText(
                text:
                    "Price : \£${getPrice(productCartModel.UnitPrice, productCartModel.Quantity, productCartModel, index).toStringAsFixed(2)}",
                fontSize: 15,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Future<void> _onTapOfDeleteContact(int index) async {
    await OfflineDbHelper.getInstance()
        .deleteContact(getproductlistfromdb[index].id);
    setState(() {
      getproductlistfromdb.removeAt(index);
      TotalAmount = 0.00;
      for (int i = 0; i < getproductlistfromdb.length; i++) {
        TotalAmount += (getproductlistfromdb[i].UnitPrice *
            getproductlistfromdb[i].Quantity);
      }

      // navigateTo(context, DynamicCartScreen.routeName,clearAllStack: true);
    });
  }

  Future<void> _onTapOfDeleteALL() async {
    await OfflineDbHelper.getInstance().deleteContactTable();
  }

  Widget imageWidget(String imagePath) {
    return Container(
      width: 100,
      child: Image.asset(imagePath),
    );
  }

  double getPrice(double price, int itemWiseQTY,
      ProductCartModel productCartModel, int index) {
    // TotalAmount = TotalAmount + (price * itemWiseQTY);

    // TotalAmount +=  (price * itemWiseQTY);
    //  tot = tot +  productCartModel.price * newAmount;
    tot = price * itemWiseQTY;

    // TotalAmount = TotalAmount - tot;
    double Tot1 = 0.00;

    // Tot1 += getproductlistfromdb[index].price * itemWiseQTY;
    //  TotalAmount += Tot1;

    print("GettTotal" +
        "Price : " +
        price.toStringAsFixed(2) +
        " QTY : " +
        itemWiseQTY.toString() +
        " Total Amount : " +
        Tot1.toStringAsFixed(2));

    return price * itemWiseQTY;
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    arrCartAPIList.clear();
    getproductlistfromdb.clear();
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    getproductlistfromdb.addAll(Tempgetproductlistfromdb);
    for (int i = 0; i < getproductlistfromdb.length; i++) {
      TotalAmount += (getproductlistfromdb[i].UnitPrice *
          getproductlistfromdb[i].Quantity);
    }

    if (getproductlistfromdb.isNotEmpty) {
      _categoryScreenBloc.add(CartDeleteRequestCallEvent(
          CustomerID, CartDeleteRequest(CompanyID: CompanyID)));
      arrCartAPIList.clear();

      for (int i = 0; i < getproductlistfromdb.length; i++) {
        CartModel cartModel = CartModel();
        cartModel.ProductName = getproductlistfromdb[i].ProductName;
        cartModel.ProductAlias = getproductlistfromdb[i].ProductAlias;
        cartModel.ProductID = getproductlistfromdb[i].ProductID;
        cartModel.CustomerID = _offlineLogindetails.details[0].customerID;
        cartModel.Unit = getproductlistfromdb[i].Unit;
        cartModel.UnitPrice = getproductlistfromdb[i].UnitPrice;
        cartModel.Quantity = getproductlistfromdb[i].Quantity.toDouble();
        cartModel.DiscountPercent =
            getproductlistfromdb[i].DiscountPercent == null
                ? 0.00
                : getproductlistfromdb[i].DiscountPercent;
        cartModel.LoginUserID = getproductlistfromdb[i].LoginUserID;
        cartModel.CompanyId = CompanyID;
        cartModel.ProductSpecification =
            getproductlistfromdb[i].ProductSpecification;
        cartModel.ProductImage = getproductlistfromdb[i].ProductImage;
        // "http://122.169.111.101:206/productimages/no-figure.png"; //getproductlistfromdb[i].ProductImage;

        print("ldkjkd" +
            "ProductImage : " +
            getproductlistfromdb[i].ProductImage);

        arrCartAPIList.add(cartModel);
      }

      if (LoginUserID != "dummy") {
        _categoryScreenBloc.add(InquiryProductSaveCallEvent(arrCartAPIList));
      }
    }

    setState(() {});
  }

  Widget getCheckoutButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: AppButton(
        roundness: 5,
        label: "Place Order",
        fontWeight: FontWeight.w600,
        padding: EdgeInsets.symmetric(vertical: 20),
        // trailingWidget: getButtonPriceWidget(),
        onPressed: () {
          if (LoginUserID != "dummy") {
            showBottomSheet(context);
          } else {
            navigateTo(context, LoginScreen.routeName, clearAllStack: true);
          }
        },
      ),
    );
  }

  Widget commonalertbox(String msg,
      {GestureTapCallback onTapofPositive, bool useRootNavigator = true}) {
    showDialog(
        context: context,
        builder: (BuildContext ab) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 10,
            actions: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Getirblue, width: 2.00),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Alert!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Getirblue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.center,
                //margin: EdgeInsets.only(left: 10),
                child: Text(
                  msg,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 1.00,
                thickness: 2.00,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: onTapofPositive ??
                    () {
                      Navigator.of(context, rootNavigator: useRootNavigator)
                          .pop();
                    },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  Widget getButtonPriceWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        // color: Getirblue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Amount to be paid", style: TextStyle(fontSize: 12)),
            Text(
              "\£" + TotalAmount.toStringAsFixed(2),
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: colorBlack, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return CheckoutBottomSheet();
        });
  }

  Future<void> UpdateItems(
      ProductCartModel productCartModel, int index, newAmount) async {
    // List<ProductCartModel> tempforTotal = await OfflineDbHelper.getInstance().getProductCartList();
    TotalAmount = 0.00;
    for (int i = 0; i < getproductlistfromdb.length; i++) {
      /*if(index==i)
        {*/
      // TotalAmount = TotalAmount - tempforTotal[i].price;
      TotalAmount +=
          getproductlistfromdb[i].UnitPrice * getproductlistfromdb[i].Quantity;

      /* }*/

    }
    String name = productCartModel.ProductName;
    String Alias = productCartModel.ProductName;
    int ProductID = productCartModel.ProductID;
    int CustomerID = productCartModel.CustomerID;

    String Unit = productCartModel.Unit;
    String description = productCartModel.ProductSpecification;
    String ImagePath = productCartModel.ProductImage;

    double Amount = productCartModel.UnitPrice; //getTotalPrice();
    double DiscountPer = productCartModel.DiscountPercent;
    String LoginUserID = productCartModel.LoginUserID;
    String CompanyID = productCartModel.CompanyId;
    String ProductSpecification = productCartModel.ProductSpecification;
    String ProductImage = productCartModel.ProductImage;
    double vat = productCartModel.vat;

    print("ProductQNTY" + "QTY : " + productCartModel.Quantity.toString());
    // ProductCartModel productCartModel123 = new ProductCartModel(productCartModel.name,productCartModel.description,productCartModel.price,productCartModel.Qty,productCartModel.Nutritions,productCartModel.imagePath,id:getproductlistfromdb[index].id );
    ProductCartModel productCartModel12345 = new ProductCartModel(
        name,
        Alias,
        ProductID,
        CustomerID,
        Unit,
        Amount,
        productCartModel.Quantity,
        DiscountPer,
        LoginUserID,
        CompanyID,
        ProductSpecification,
        ProductImage,
        vat,
        id: getproductlistfromdb[index].id);
    await OfflineDbHelper.getInstance().updateContact(productCartModel12345);

    print("Tot_Amnt456" +
        "TotAfterNetAmnout : " +
        TotalAmount.toStringAsFixed(2));
  }

  Widget DeleteAll() {
    return Container(
      margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Getirblue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: AppText(
        text: "Delete All",
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: colorWhite,
      ),
    );
  }

  void _onCategoryResponse(
      InquiryProductSaveResponseState state, BuildContext context) {
    print("CartSaveResponse" +
        " Details " +
        state.inquiryProductSaveResponse.details[0].column2);
  }

  void _OnCartDeleteRequest(
      CartDeleteResponseState state, BuildContext context) {
    print("CartSaveResponse" +
        " Details " +
        state.cartDeleteResponse.details[0].column1.toString());
  }

  /* void _onCartListResponse(ProductCartResponseState state, BuildContext context) async {
    await OfflineDbHelper.getInstance().deleteContactTable();
    setState(() {
      getproductlistfromdb.clear();

    });

    for(int i=0;i<state.cartDeleteResponse.details.length;i++)
      {
        String name = state.cartDeleteResponse.details[i].productName;
        String Alias =state.cartDeleteResponse.details[i].productName;
        int ProductID=state.cartDeleteResponse.details[i].productID;
        int CustomerID = state.cartDeleteResponse.details[i].customerID;

        String Unit = state.cartDeleteResponse.details[i].unit;
        int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
        double Amount =state.cartDeleteResponse.details[i].unitPrice;//getTotalPrice();
        double DiscountPer = state.cartDeleteResponse.details[i].discountPercent;
        String LoginUserID =state.cartDeleteResponse.details[i].l;
        String CompanyID = widget.groceryItem.ComapanyID;
        String ProductSpecification = widget.groceryItem.ProductSpecification;
        String ProductImage = widget.groceryItem.ProductImage;

        ProductCartModel productCartModel = new ProductCartModel(name,Alias,ProductID,CustomerID,Unit,Amount,Qty,DiscountPer,LoginUserID,CompanyID,
            ProductSpecification,ProductImage
        );


        await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);

      }

  }*/
}
