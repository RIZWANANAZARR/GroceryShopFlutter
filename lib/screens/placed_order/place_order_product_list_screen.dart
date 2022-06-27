import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/bloc/others/order/order_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/Place_order/place_order_delete_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/common/globals.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/placed_order/placed_order_list_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class PlacedOrderDetailsScreenArguments {
  GroceryItem groceryItem;

  PlacedOrderDetailsScreenArguments(this.groceryItem);
}

class PlacedOrderDetailsScreen extends BaseStatefulWidget {
  static const routeName = '/PlacedOrderDetailsScreen';

  final PlacedOrderDetailsScreenArguments arguments;

  PlacedOrderDetailsScreen(this.arguments);

  @override
  _PlacedOrderDetailsScreenState createState() =>
      _PlacedOrderDetailsScreenState();
}

class _PlacedOrderDetailsScreenState extends BaseState<PlacedOrderDetailsScreen>
    with BasicScreen, WidgetsBindingObserver {
  int amount = 1;
  FToast fToast;
  bool favorite = false;
  OrderScreenBloc productGroupBloc;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  double totalNetAmnt = 0.00;

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
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    productGroupBloc = OrderScreenBloc(baseBloc);

    totalNetAmnt = widget.arguments.groceryItem.Quantity *
        widget.arguments.groceryItem.UnitPrice;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc,
      child: BlocConsumer<OrderScreenBloc, OrderScreenStates>(
        builder: (BuildContext context, OrderScreenStates state) {
          /*  if (state is OrderProductListResponseState) {
            productlistsuccess(state);
          }

          if (state is TokenListResponseState) {
            _OnTokenGetSucess(state);
          }*/

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is OrderProductListResponseState ||
              currentState is TokenListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, OrderScreenStates state) {
          /* if (state is OrderProductJsonSaveResponseState) {
            productSaveSucess(state);
          }

          if (state is PdfUploadResponseState) {
            uploadpdfSucess(state);
          }*/
          if (state is PlaceOrderDeleteResponseState) {
            placeOrderDeleteResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is OrderProductJsonSaveResponseState ||
              currentState is PdfUploadResponseState ||
              currentState is PlaceOrderDeleteResponseState) {
            return true;
          }
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
            text: widget.arguments.groceryItem.ProductName.toUpperCase(),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Getirblue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              getImageHeaderWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          widget.arguments.groceryItem.ProductName,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        subtitle: AppText(
                          text:
                              widget.arguments.groceryItem.ProductSpecification,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff7C7C7C),
                        ),
                        /*trailing: /*FavoriteToggleIcon()*/InkWell(
                          onTap: () {




                          },
                          child: Icon(
                            favorite ? Icons.favorite : Icons.favorite_border,
                            color: favorite ? Colors.red : Colors.blueGrey,
                            size: 30,
                          ),
                        ),*/
                      ),
                      SizedBox(
                        height: 10,
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
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Getirblue),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              "Quantity : " +
                                  widget.arguments.groceryItem.Quantity
                                      .toInt()
                                      .toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "\£${totalNetAmnt.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
                      AppButton(
                        label: "Delete",
                        onPressed: () {
                          showCommonDialogWithTwoOptions(
                            context,
                            "Do you want to Delete This Product?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                              Navigator.pop(context);
                              productGroupBloc.add(PlaceOrderDeleteRequestEvent(
                                  widget.arguments.groceryItem.pkID.toString(),
                                  PlaceOrderDeleteRequest(
                                      CompanyId: CompanyID)));
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        label: "Exit",
                        onPressed: () {
                          Navigator.pop(context);
                          // isProductinCart==true?navigateTo(context,DynamicCartScreen.routeName,clearAllStack: true): _OnTaptoAddProductinCart();

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
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
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
          widget.arguments.groceryItem.ProductImage,
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
        showCommonDialogWithSingleOption(
            context,
            "Product : " +
                widget.arguments.groceryItem.ProductName +
                "\n" +
                "Unit Price : " +
                widget.arguments.groceryItem.UnitPrice.toString() +
                " Unit : " +
                widget.arguments.groceryItem.Unit,
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: Row(
          children: [
            AppText(text: label, fontWeight: FontWeight.w600, fontSize: 16),
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
        text: widget.arguments.groceryItem.Unit,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Color(0xff7C7C7C),
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
    return amount * widget.arguments.groceryItem.UnitPrice;
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
      if (groceryItemdb[i].ProductID ==
          widget.arguments.groceryItem.ProductID) {
        favorite = true;
        break;
      } else {
        favorite = false;
      }

      //print("FlagDeBIUG"+isProductinCart.toString() + " DBPRID " + groceryItemdb[i].ProductID.toString() + widget.groceryItem.ProductID.toString());

    }

    setState(() {});
  }

  void placeOrderDeleteResponse(PlaceOrderDeleteResponseState state) async {
    await showCommonDialogWithSingleOption(
        Globals.context, state.response.details[0].column1,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, PlacedOrderListScreen.routeName, clearAllStack: true);
    });
  }
}
