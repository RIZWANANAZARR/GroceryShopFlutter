import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class FavoriteItemsScreen extends BaseStatefulWidget {
  static const routeName = '/FavoriteItemsScreen';

  @override
  _FavoriteItemsScreenState createState() => _FavoriteItemsScreenState();
}

class _FavoriteItemsScreenState extends BaseState<FavoriteItemsScreen>
    with BasicScreen, WidgetsBindingObserver {
  CategoryScreenBloc _categoryScreenBloc;
  String _ProductGroupID;
  List<GroceryItem> AllProducts = [];

  String ProductGroupName = "";
  BaseBloc baseBloc;
  final double width = 174;

  final double height = 250;

  final Color borderColor = Color(0xffE2E2E2);

  final double borderRadius = 18;

  FToast fToast;

  List<CartModel> arrCartAPIList = [];

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  int CustomerID = 0;
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

    getproductFavoritelistfromdbMethod();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID;
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', '');
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    AllProducts.clear();

    baseBloc = BaseBloc();
    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    baseBloc.emit(ShowProgressIndicatorState(true));

    getproductFavoritelistfromdbMethod();

    baseBloc.emit(ShowProgressIndicatorState(false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is InquiryFavoriteProductSaveResponseState) {
            _onCategoryResponse(state, context);
          }
          if (state is FavoriteDeleteResponseState) {
            _OnCartDeleteRequest(state, context);
          }
          /*if(state is ProductCartResponseState)
            {


              _onCartListResponse(state,context);
            }*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is InquiryFavoriteProductSaveResponseState ||
                  currentState is FavoriteDeleteResponseState
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          title: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: AppText(
              text: "Favorite Items",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: AllProducts.length != 0
            ? GridView.count(
                crossAxisCount: 2,
                // I only need two card horizontally
                children: AllProducts.asMap().entries.map<Widget>((e) {
                  GroceryItem groceryItem = e.value;
                  return GestureDetector(
                      onTap: () {
                        onItemClicked(context, groceryItem);
                      },
                      child: /*Container(
                padding: EdgeInsets.all(10),
                child: GroceryFavoriteItemCardWidget(
                  item: groceryItem,
                ),
              ),*/
                          Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            borderRadius,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: imageWidget(groceryItem.ProductImage),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Text(groceryItem.ProductName,
                                  style: TextStyle(
                                      fontSize: 10,
                                      overflow: TextOverflow.ellipsis),
                                  textAlign: TextAlign.center),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  AppText(
                                    text:
                                        "\£${groceryItem.UnitPrice.toStringAsFixed(2)}",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () {
                                        _onTapOfDeleteContact(
                                            context, groceryItem.ProductID);
                                      },
                                      child: DeleteWidget()),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                }).toList(),

                mainAxisSpacing: 3.0,
                crossAxisSpacing: 0.0, // add some space
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    FAVORITE_EMPTY,
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    "You haven't added any product yet.",
                    style: TextStyle(
                        fontSize: 15,
                        color: Getirblue,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Click to Save Products",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Getirblue),
                    ),
                    onPressed: () {
                      //ontapofsave();
                      navigateTo(context, TabHomePage.routeName,
                          clearAllStack: true);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text(
                        "Find item to save",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )), //:Center(child: Text("No Item Available",style: TextStyle(fontSize: 20,color: colorBlack),),),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, TabHomePage.routeName, clearSingleStack: true);
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(groceryItem)),
    ).then((value) {
      // getproductFavoritelistfromdbMethod();

      getproductFavoritelistfromdbMethod();
    });

    /* navigateTo(context, AttendanceAdd_EditScreen.routeName,
              arguments: AddUpdateAttendanceArguments(
                  _selectedEvents, edt_AttendanceEmployeeID.text, PresentDate))
          .then((value) {*/
  }

  void getproductFavoritelistfromdbMethod() async {
    AllProducts.clear();

    AllProducts = await getproductductfavoritedetails();
    print("kldjdfjfdf" + " Length : " + AllProducts.length.toString());
    setState(() {});
  }

  getproductductfavoritedetails() async {
    arrCartAPIList.clear();
    await OfflineDbHelper.getInstance().getProductCartFavoritList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartFavoritList();
    List<GroceryItem> AllProducts123 = [];

    print("kldjdfj" + " Length : " + LoginUserID);

    /* if(groceryItemdb.isNotEmpty)
      {

      }*/
    for (int i = 0; i < groceryItemdb.length; i++) {
      GroceryItem groceryItem = GroceryItem();
      groceryItem.ProductName = groceryItemdb[i].ProductName;
      groceryItem.ProductID = groceryItemdb[i].ProductID;
      groceryItem.ProductAlias = groceryItemdb[i].ProductName;
      groceryItem.CustomerID = CustomerID;
      groceryItem.Unit = groceryItemdb[i].Unit;
      groceryItem.UnitPrice = groceryItemdb[i].UnitPrice;
      groceryItem.Quantity = groceryItemdb[i].Quantity.toDouble();
      groceryItem.DiscountPer = groceryItemdb[i].DiscountPercent;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification = groceryItemdb[i].ProductSpecification;
      groceryItem.ProductImage = groceryItemdb[i]
          .ProductImage; //==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+state.response.details[i].productImage;

      groceryItem.Vat = groceryItemdb[i].vat;
      AllProducts123.add(groceryItem);
    }

    if (groceryItemdb.isNotEmpty) {
      _categoryScreenBloc.add(FavoriteDeleteRequestCallEvent(
          CustomerID, CartDeleteRequest(CompanyID: CompanyID)));
      for (int i = 0; i < groceryItemdb.length; i++) {
        CartModel cartModel = CartModel();
        cartModel.ProductName = groceryItemdb[i].ProductName;
        cartModel.ProductAlias = groceryItemdb[i].ProductAlias;
        cartModel.ProductID = groceryItemdb[i].ProductID;
        cartModel.CustomerID = CustomerID;
        cartModel.Unit = groceryItemdb[i].Unit;
        cartModel.UnitPrice = groceryItemdb[i].UnitPrice;
        cartModel.Quantity = groceryItemdb[i].Quantity.toDouble();
        cartModel.DiscountPercent = groceryItemdb[i].DiscountPercent == null
            ? 0.00
            : groceryItemdb[i].DiscountPercent;
        cartModel.LoginUserID = LoginUserID;
        cartModel.CompanyId = groceryItemdb[i].CompanyId;
        cartModel.ProductSpecification = groceryItemdb[i].ProductSpecification;
        cartModel.ProductImage = groceryItemdb[i].ProductImage;

        arrCartAPIList.add(cartModel);
      }
      if (LoginUserID != "dummy") {
        _categoryScreenBloc
            .add(InquiryFavoriteProductSaveCallEvent(arrCartAPIList));
      }
    }

    return AllProducts123;
  }

  Widget imageWidget(String productImage) {
    return Container(
        child: //Image.asset(item.imagePath),
            //Image.network("http://122.169.111.101:206/productimages/beverages.png")
            Image.network(
      productImage,
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

  Widget DeleteWidget() {
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

  void _onTapOfDeleteContact(BuildContext context, int productID) async {
    fToast = FToast();
    fToast.init(context);

    await OfflineDbHelper.getInstance().deleteContactFavorit(productID);

    getproductFavoritelistfromdbMethod();

    fToast.showToast(
      child: showCustomToast(Title: "Item Remove To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void _onCategoryResponse(
      InquiryFavoriteProductSaveResponseState state, BuildContext context) {
    print("FavoriteSaveResponse" +
        " Details " +
        state.inquiryProductSaveResponse.details[0].column2);
  }

  void _OnCartDeleteRequest(
      FavoriteDeleteResponseState state, BuildContext context) {
    print("FavoriteSaveResponse" +
        " Details " +
        state.cartDeleteResponse.details[0].column1.toString());
  }
}

/*
class GroceryFavoriteItemCardWidget extends StatefulWidget {
  GroceryFavoriteItemCardWidget({Key key, this.item}) : super(key: key);
  final GroceryItem item;

  @override
  State<GroceryFavoriteItemCardWidget> createState() => _GroceryFavoriteItemCardWidgetState();
}*/

/*class _GroceryFavoriteItemCardWidgetState extends State<GroceryFavoriteItemCardWidget> {
  final double width = 174;

  final double height = 250;

  final Color borderColor = Color(0xffE2E2E2);

  final double borderRadius = 18;

  FToast fToast;

  @override
  Widget build(BuildContext context) {


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
              text: widget.item.ProductName,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            AppText(

              text: widget.item.ProductSpecification,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7C7C7C),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                AppText(
                  text: "\$${widget.item.UnitPrice.toStringAsFixed(2)}",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                Spacer(),

                InkWell(
                    onTap: (){

                      _onTapOfDeleteContact(context);
                    },
                    child: DeleteWidget())
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
        Image.network(widget.item.ProductImage)
    );
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
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }

  Widget DeleteWidget() {
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

  void _onTapOfDeleteContact(BuildContext context) async{
    fToast = FToast();
    fToast.init(context);

    await OfflineDbHelper.getInstance().deleteContactFavorit(widget.item.ProductID);

    fToast.showToast(
      child: showCustomToast(Title: "Item Remove To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

  }
}*/
