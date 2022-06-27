import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/models/api_request/BestSelling/best_selling_list_request.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_request/Exclusive_Offer/exclusive_offer_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/best_selling/best_selling_list_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/exclusive_offer/exclusive_offer_list_screen.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';

import 'grocery_featured_Item_widget.dart';
import 'home_banner_widget.dart';

class HomeScreen extends BaseStatefulWidget {
  static const routeName = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen>
    with BasicScreen, WidgetsBindingObserver {
  String Address =
      "Test Address"; /*SharedPrefHelper.instance.getSignUpData().Address == null
      ? ""
      : SharedPrefHelper.instance.getSignUpData().Address;*/

  int _count = 0;

  Future<int> _getCat() async {
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartList();

    //List<AllAccounts> x = await _dbHelper.getCategory();
    // _allaccounts = x;

    _count = Tempgetproductlistfromdb.length;
    // print(_count);
    return _count;
  }

  CategoryScreenBloc _categoryScreenBloc;

  List<GroceryItem> SchoolApp = [];
  List<GroceryItem> CRM = [];
  List<GroceryItem> AllProducts = [];
  List<GroceryItem> ExclusiveProducts = [];
  List<GroceryItem> BestSellingProducts = [];
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
//inside initState method

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    getproductlistfromdbMethod();

    _categoryScreenBloc = CategoryScreenBloc(baseBloc);
    _categoryScreenBloc
      ..add(CategoryListRequestCallEvent(CategoryListRequest(
          BrandID: "",
          ProductGroupID: "",
          ProductID: "",
          CompanyId: CompanyID,
          ActiveFlag: "1")));
    _categoryScreenBloc
      ..add(ExclusiveOfferListRequestCallEvent(ExclusiveOfferListRequest(
          PercentTo: "01", PercentFrom: "30", CompanyId: CompanyID)));
    _categoryScreenBloc
      ..add(BestSellingListRequestCallEvent(
          BestSellingListRequest(Top10: "10", CompanyId: CompanyID)));
    //_categoryScreenBloc.add(ProductCartDetailsRequestCallEvent(ProductCartDetailsRequest(CompanyId: CompanyID,CustomerID: CustomerID)));
    //_categoryScreenBloc.add(ProductFavoriteDetailsRequestCallEvent(ProductCartDetailsRequest(CompanyId: CompanyID,CustomerID: CustomerID)));

    _getCat();
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    _count = Tempgetproductlistfromdb.length;
    print("dkfkdf" + "Count : " + _count.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is CategoryListResponseState) {
            _onCategoryResponse(state, context);
          }

          if (state is ExclusiveOfferListResponseState) {
            _onExclusiveOfferListResponse(state, context);
          }

          if (state is BestSellingListResponseState) {
            _onBestSellingListResponse(state, context);
          }
          /* if(state is ProductCartResponseState)
            {


              _onCartListResponse(state,context);
            }*/
          /*if(state is ProductFavoriteResponseState)
          {


            _onFavoriteListResponse(state,context);
          }*/

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CategoryListResponseState ||
                  currentState is ExclusiveOfferListResponseState ||
                  currentState is BestSellingListResponseState
              /* currentState is ProductCartResponseState ||
              currentState is ProductFavoriteResponseState*/
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: RefreshIndicator(
            onRefresh: () async {
              _categoryScreenBloc
                ..add(CategoryListRequestCallEvent(CategoryListRequest(
                    BrandID: "",
                    ProductGroupID: "",
                    ProductID: "",
                    CompanyId: CompanyID,
                    ActiveFlag: "1")));
            },
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        navigateTo(context, DynamicCartScreen.routeName);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Badge(
                            padding: EdgeInsets.all(5.0),
                            badgeContent: Text(
                              _count.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(Icons.shopping_cart),
                          ), /*Icon(Icons.shopping_cart),*/
                        ),
                      ),
                    ),
                    SvgPicture.asset("assets/icons/app_icon_color.svg"),
                    SizedBox(
                      height: 5,
                    ),
                    padded(locationWidget()),
                    SizedBox(
                      height: 15,
                    ),
                    // padded(SearchBarWidget()),
                    SizedBox(
                      height: 25,
                    ),
                    padded(InkWell(
                        onTap: () {
                          /* navigateTo(context, CategoryItemsScreen.routeName,
                                  arguments:
                                      AddUpdateCategoryItemsScreenArguments(""))
                              .then((value) {});*/
                        },
                        child: HomeBanner())),
                    SizedBox(
                      height: 25,
                    ),
                    padded(subTitle("Exclusive Offer")),
                    getHorizontalItemSlider(ExclusiveProducts),
                    SizedBox(
                      height: 15,
                    ),
                    padded(subTitle("Best Selling")),
                    getHorizontalItemSlider(BestSellingProducts),
                    SizedBox(
                      height: 15,
                    ),
                    padded(subTitle("Groceries")),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: true,
                      child: Container(
                        height: 105,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GroceryFeaturedCard(
                              groceryFeaturedItems[0],
                              color: Color(0xffF8A44C),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GroceryFeaturedCard(
                              groceryFeaturedItems[1],
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getHorizontalItemSlider(AllProducts),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget padded(Widget widget) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: widget,
    );
  }

  Widget getHorizontalItemSlider(List<GroceryItem> items) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 250,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onItemClicked(context, items[index]);
            },
            child: GroceryItemCardWidget(
              item: items[index],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 20,
          );
        },
      ),
    );
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(groceryItem)),
    );
  }

  Widget subTitle(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            if (text == "Exclusive Offer") {
              navigateTo(context, ExclusiveOfferListScreen.routeName);
            }
            if (text == "Best Selling") {
              navigateTo(context, BestSellingListScreen.routeName);
            }
            if (text == "Groceries") {
              /*navigateTo(context, CategoryItemsScreen.routeName,
                      arguments: AddUpdateCategoryItemsScreenArguments(""))
                  .then((value) {});*/
            }

            //navigateTo(context, CategoryItemsScreen.routeName).
          },
          child: Text(
            "See All",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget locationWidget() {
    String locationIconPath = "assets/icons/location_icon.svg";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          locationIconPath,
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            Address,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }

  _list() => Expanded(
        child: FutureBuilder<int>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              child: Text(
                _count.toString(),
                style: TextStyle(color: Colors.white),
              ),
            );
          },
          future: _getCat(),
        ),
      );

  void _onCategoryResponse(
      CategoryListResponseState state, BuildContext context) {
    SchoolApp.clear();
    CRM.clear();
    AllProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      print("CategoryProduct" + state.response.details[i].productName);
      /* String name;
   String description;
   double price;
   String Nutritions;
   String imagePath;*/
      if (state.response.details[i].productGroupID == 1) {
        GroceryItem groceryItem = GroceryItem();
        groceryItem.ProductName = state.response.details[i].productName;
        groceryItem.ProductID = state.response.details[i].productID;
        groceryItem.ProductAlias = state.response.details[i].productName;
        groceryItem.CustomerID = 1;
        groceryItem.Unit = state.response.details[i].unit;
        groceryItem.UnitPrice = state.response.details[i].unitPrice;
        groceryItem.Quantity = 0.00;
        groceryItem.DiscountPer = 0.00;
        groceryItem.LoginUserID = LoginUserID;
        groceryItem.ComapanyID = CompanyID;
        groceryItem.ProductSpecification =
            state.response.details[i].productSpecification;
        groceryItem.ProductImage = "http://122.169.111.101:206/" +
            state.response.details[i].productImage;
        ;
        SchoolApp.add(groceryItem);
      }

      if (state.response.details[i].productGroupID == 2) {
        GroceryItem groceryItem = GroceryItem();
        groceryItem.ProductName = state.response.details[i].productName;
        groceryItem.ProductID = state.response.details[i].productID;
        groceryItem.ProductAlias = state.response.details[i].productName;
        groceryItem.CustomerID = 1;
        groceryItem.Unit = state.response.details[i].unit;
        groceryItem.UnitPrice = state.response.details[i].unitPrice;
        groceryItem.Quantity = 0.00;
        groceryItem.DiscountPer = 0.00;
        groceryItem.LoginUserID = LoginUserID;
        groceryItem.ComapanyID = CompanyID;
        groceryItem.ProductSpecification =
            state.response.details[i].productSpecification;
        groceryItem.ProductImage = "http://122.169.111.101:206/" +
            state.response.details[i].productImage;
        ;
        CRM.add(groceryItem);
      }
      GroceryItem groceryItem = GroceryItem();
      /* groceryItem.name = state.response.details[i].productName;
      groceryItem.price = state.response.details[i].unitPrice;
      groceryItem.description = "";
      groceryItem.Nutritions = state.response.details[i].unit;
    // groceryItem.imagePath = "http://122.169.111.101:206/"+state.response.details[i].productImage;//"http://122.169.111.101:206/productimages/beverages.png";
      groceryItem.imagePath = state.response.details[i].productImage==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+state.response.details[i].productImage;
*/
      groceryItem.ProductName = state.response.details[i].productName;
      groceryItem.ProductID = state.response.details[i].productID;
      groceryItem.ProductAlias = state.response.details[i].productName;
      groceryItem.CustomerID = 1;
      groceryItem.Unit = state.response.details[i].unit;
      groceryItem.UnitPrice = state.response.details[i].unitPrice;
      groceryItem.Quantity = 0.00;
      groceryItem.DiscountPer = 0.00;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification =
          state.response.details[i].productSpecification;
      groceryItem.ProductImage = state.response.details[i].productImage == ""
          ? "https://img.icons8.com/bubbles/344/no-image.png"
          : "http://122.169.111.101:206/" +
              state.response.details[i].productImage;

      AllProducts.add(groceryItem);
    }
  }

  void _onExclusiveOfferListResponse(
      ExclusiveOfferListResponseState state, BuildContext context) {
    ExclusiveProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      /*GroceryItem groceryItem = GroceryItem();
        groceryItem.name = state.response.details[i].productName;
        groceryItem.price = state.response.details[i].unitPrice;
        groceryItem.description = "";
        groceryItem.Nutritions = state.response.details[i].unit;
        // groceryItem.imagePath = "http://122.169.111.101:206/"+state.response.details[i].productImage;//"http://122.169.111.101:206/productimages/beverages.png";
        groceryItem.imagePath = state.response.details[i].productImage==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+state.response.details[i].productImage;
*/
      GroceryItem groceryItem = GroceryItem();
      groceryItem.ProductName = state.response.details[i].productName;
      groceryItem.ProductID = state.response.details[i].productID;
      groceryItem.ProductAlias = state.response.details[i].productName;
      groceryItem.CustomerID = 1;
      groceryItem.Unit = state.response.details[i].unit;
      groceryItem.UnitPrice = state.response.details[i].unitPrice;
      groceryItem.Quantity = 0.00;
      groceryItem.DiscountPer = 0.00;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification =
          state.response.details[i].productSpecification;
      groceryItem.ProductImage = state.response.details[i].productImage == ""
          ? "https://img.icons8.com/bubbles/344/no-image.png"
          : "http://122.169.111.101:206/" +
              state.response.details[i].productImage;

      ExclusiveProducts.add(groceryItem);
    }
  }

  void _onBestSellingListResponse(
      BestSellingListResponseState state, BuildContext context) {
    BestSellingProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      /*GroceryItem groceryItem = GroceryItem();
      groceryItem.name = state.response.details[i].bestSellingProductName;
      groceryItem.price = state.response.details[i].unitPrice;
      groceryItem.description = "";
      groceryItem.Nutritions = state.response.details[i].unit;
      // groceryItem.imagePath = "http://122.169.111.101:206/"+state.response.details[i].productImage;//"http://122.169.111.101:206/productimages/beverages.png";
      groceryItem.imagePath = state.response.details[i].productImage==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+state.response.details[i].productImage;
*/
      GroceryItem groceryItem = GroceryItem();
      groceryItem.ProductName =
          state.response.details[i].bestSellingProductName;
      groceryItem.ProductID = state.response.details[i].productID;
      groceryItem.ProductAlias =
          state.response.details[i].bestSellingProductName;
      groceryItem.CustomerID = 1;
      groceryItem.Unit = state.response.details[i].unit;
      groceryItem.UnitPrice = state.response.details[i].unitPrice;
      groceryItem.Quantity = state.response.details[i].bestSellingQuantity;
      groceryItem.DiscountPer = state.response.details[i].discountPercent;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification =
          state.response.details[i].productSpecification;
      groceryItem.ProductImage = state.response.details[i].productImage == ""
          ? "https://img.icons8.com/bubbles/344/no-image.png"
          : "http://122.169.111.101:206/" +
              state.response.details[i].productImage;

      BestSellingProducts.add(groceryItem);
    }
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _count = 0;
  }

  void _onFavoriteListResponse(
      ProductFavoriteResponseState state, BuildContext context) async {
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartFavoritList();

    /* for (int i = 0; i < state.cartDeleteResponse.details.length; i++)
      {
        if(Tempgetproductlistfromdb.isNotEmpty)
          {
            if(Tempgetproductlistfromdb[0].CustomerID.toString()!=CustomerID)
              {
                await OfflineDbHelper.getInstance().deleteContactTableFavorit();
                String name = state.cartDeleteResponse.details[i].productName;
                String Alias = state.cartDeleteResponse.details[i].productName;
                int ProductID = state.cartDeleteResponse.details[i].productID;
                int CustomerID = state.cartDeleteResponse.details[i].customerID;

                String Unit = state.cartDeleteResponse.details[i].unit;
                int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
                double Amount = state.cartDeleteResponse.details[i]
                    .unitPrice; //getTotalPrice();
                double DiscountPer = state.cartDeleteResponse.details[i]
                    .discountPercent;

                String ProductSpecification = "";
                String ProductImage = "http://122.169.111.101:206/productimages/no-figure.png";

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
                    ProductImage
                );


                await OfflineDbHelper.getInstance().insertProductToCartFavorit(
                    productCartModel);
              }
          }
        else
          {
            String name = state.cartDeleteResponse.details[i].productName;
            String Alias = state.cartDeleteResponse.details[i].productName;
            int ProductID = state.cartDeleteResponse.details[i].productID;
            int CustomerID = state.cartDeleteResponse.details[i].customerID;

            String Unit = state.cartDeleteResponse.details[i].unit;
            int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
            double Amount = state.cartDeleteResponse.details[i]
                .unitPrice; //getTotalPrice();
            double DiscountPer = state.cartDeleteResponse.details[i]
                .discountPercent;

            String ProductSpecification = "";
            String ProductImage = "http://122.169.111.101:206/productimages/no-figure.png";

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
                ProductImage
            );


            await OfflineDbHelper.getInstance().insertProductToCartFavorit(
                productCartModel);
          }
      }*/

    /* if(Tempgetproductlistfromdb.isNotEmpty)
    {
      if(Tempgetproductlistfromdb[0].CustomerID.toString()!=CustomerID) {
        await OfflineDbHelper.getInstance().deleteContactTableFavorit();
        for (int i = 0; i < state.cartDeleteResponse.details.length; i++) {
          String name = state.cartDeleteResponse.details[i].productName;
          String Alias = state.cartDeleteResponse.details[i].productName;
          int ProductID = state.cartDeleteResponse.details[i].productID;
          int CustomerID = state.cartDeleteResponse.details[i].customerID;

          String Unit = state.cartDeleteResponse.details[i].unit;
          int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
          double Amount = state.cartDeleteResponse.details[i]
              .unitPrice; //getTotalPrice();
          double DiscountPer = state.cartDeleteResponse.details[i]
              .discountPercent;

          String ProductSpecification = "";
          String ProductImage = "http://122.169.111.101:206/productimages/no-figure.png";

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
              ProductImage
          );


          await OfflineDbHelper.getInstance().insertProductToCartFavorit(
              productCartModel);
        }
      }

    }
*/
    /* else
    {
      if(Tempgetproductlistfromdb[0].CustomerID.toString()!=CustomerID)
        {
          await OfflineDbHelper.getInstance().deleteContactTableFavorit();

        }


    }
*/
  }
}
