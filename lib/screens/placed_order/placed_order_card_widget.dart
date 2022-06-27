import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/order/order_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/Place_order/place_order_delete_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/common/globals.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/placed_order/place_order_product_list_screen.dart';
import 'package:grocery_app/screens/placed_order/placed_order_list_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class PlacedOrderWidgetArguments {
  GroceryItem groceryItem;
  PlacedOrderWidgetArguments(this.groceryItem);
}

class PlacedItemCardWidget extends BaseStatefulWidget {
  static const routeName = '/PlacedItemCardWidget';

  final GroceryItem arguments;

  PlacedItemCardWidget(this.arguments);

  @override
  _PlacedItemCardWidgetState createState() => _PlacedItemCardWidgetState();
}

class _PlacedItemCardWidgetState extends BaseState<PlacedOrderDetailsScreen>
    with BasicScreen, WidgetsBindingObserver {
  GroceryItem item;

  final double width = 174;
  final double height = 250;
  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 18;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  OrderScreenBloc productGroupBloc;

  double totalNetAmnt = 0.00;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    productGroupBloc = OrderScreenBloc(baseBloc);
    item = widget.arguments.groceryItem;
    totalNetAmnt = item.Quantity * item.UnitPrice;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc,
      child: BlocConsumer<OrderScreenBloc, OrderScreenStates>(
        builder: (BuildContext context, OrderScreenStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
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
          if (currentState is PlaceOrderDeleteResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: imageWidget(),
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
            SizedBox(
              height: 10,
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
                          productGroupBloc.add(PlaceOrderDeleteRequestEvent(
                              widget.arguments.groceryItem.pkID.toString(),
                              PlaceOrderDeleteRequest(CompanyId: CompanyID)));
                        },
                      );
                    },
                    child: addWidget())
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Container(
        child: //Image.asset(item.imagePath),
            //Image.network("http://122.169.111.101:206/productimages/beverages.png")
            Image.network(item.ProductImage,  frameBuilder: (context, child, frame,
                wasSynchronouslyLoaded) {
              return child;
            },
              loadingBuilder:
                  (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return CircularProgressIndicator();
                }
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return Icon(Icons.error);
              },));
  }

  Widget addWidget() {
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

  void placeOrderDeleteResponse(PlaceOrderDeleteResponseState state) async {
    await showCommonDialogWithSingleOption(
        Globals.context, state.response.details[0].column1,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, PlacedOrderListScreen.routeName, clearAllStack: true);
    });
  }
}
