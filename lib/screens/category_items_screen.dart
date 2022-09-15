import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';

class AddUpdateCategoryItemsScreenArguments {
  String ProductGroupID;
  String ProductBrandID;
  AddUpdateCategoryItemsScreenArguments(
      this.ProductGroupID, this.ProductBrandID);
}

class CategoryItemsScreen extends BaseStatefulWidget {
  static const routeName = '/CategoryItemsScreen';
  final AddUpdateCategoryItemsScreenArguments arguments;
  CategoryItemsScreen(this.arguments);

  @override
  _CategoryItemsScreenState createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends BaseState<CategoryItemsScreen>
    with BasicScreen, WidgetsBindingObserver {
  CategoryScreenBloc _categoryScreenBloc;
  String _ProductGroupID;
  String _ProdcutBrandID;

  List<GroceryItem> AllProducts = [];

  String ProductGroupName = "";

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

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
    _ProdcutBrandID = widget.arguments.ProductBrandID;
    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    _ProductGroupID = widget.arguments.ProductGroupID;
    _categoryScreenBloc
      ..add(CategoryListRequestCallEvent(CategoryListRequest(
          BrandID: _ProdcutBrandID,
          ProductGroupID: _ProductGroupID,
          ProductID: "",
          SearchKey: "",
          CompanyId: CompanyID,
          ActiveFlag: "1")));
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
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CategoryListResponseState) {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 25),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
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
            text: ProductGroupName,
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
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: GroceryItemCardWidget(
                      item: groceryItem,
                    ),
                  ),
                );
              }).toList(),
              /* staggeredTiles:
                  AllProducts.map<StaggeredTile>((_) => StaggeredTile.fit(2))
                      .toList(),*/
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 0.0, // add some space
            )
          : Center(
              child: Image.asset(
                NO_DASHBOARD,
                width: 250,
              ),
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

  void _onCategoryResponse(
      CategoryListResponseState state, BuildContext context) {
    AllProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      if (_ProductGroupID == "") {
        ProductGroupName = "All Items";
      } else {
        ProductGroupName = state.response.details[i].productGroupName;
      }
      print("CategoryProduct12254545" + state.response.details[i].productImage);
      /*GroceryItem groceryItem = GroceryItem();
      groceryItem.name = state.response.details[i].productName;
      groceryItem.price = state.response.details[i].unitPrice;
      groceryItem.description = "";
      groceryItem.Nutritions = state.response.details[i].unit;
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
      groceryItem
              .ProductImage = /*state.response.details[i].productImage == ""
          ? "https://img.icons8.com/bubbles/344/no-image.png"
          : */
          _offlineCompanydetails.details[0].siteURL +
              "/productimages/" +
              state.response.details[i].productImage;
      groceryItem.Vat = state.response.details[i].Vat;
      AllProducts.add(groceryItem);
    }
  }
}
