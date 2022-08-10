import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/product/product_bloc.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_master_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_pagination_request.dart';
import 'package:grocery_app/models/api_response/Category/category_list_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/ExploreDashBoard/explore_dashboard_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/product_master/manage_product.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class AllProductSearch extends BaseStatefulWidget {
  static const routeName = '/AllProductSearch';
  @override
  _AllProductSearchState createState() => _AllProductSearchState();
}

class _AllProductSearchState extends BaseState<AllProductSearch>
    with BasicScreen, WidgetsBindingObserver {
  TextEditingController searchbar = TextEditingController();
  int title_color = 0xFF000000;
  int pageNo = 0;
  int selected = 0;
  ProductGroupBloc productGroupBloc;
  ProductPaginationResponse Response;
  CategoryListResponse categoryListResponse;
  CategoryListResponseDetails categoryListResponseDetails;
  ProductPaginationDetails details;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  List<CategoryListResponseDetails> arrcategoryListResponseDetails = [];

  @override
  void initState() {
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    productGroupBloc = ProductGroupBloc(baseBloc);
    searchbar.text = "";
    searchbar.addListener(searchlistner);

    /* productGroupBloc
      ..add(CategoryListRequestCallEvent(CategoryListRequest(
          BrandID: "",
          ProductGroupID: "",
          ProductID: "",
          SearchKey: "",
          CompanyId: CompanyID,
          ActiveFlag: "1")));*/

    productGroupBloc
      ..add(ProductMasterPaginationCallEvent(
          1, ProductPaginationRequest(CompanyId: CompanyID, ActiveFlag: "1")));
  }

  searchlistner() {
    productGroupBloc
      ..add(ProductMasterPaginationCallEvent(
          1,
          ProductPaginationRequest(
              CompanyId: CompanyID,
              SearchKey: searchbar.text,
              ActiveFlag: "1")));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc
        ..add(ProductMasterPaginationCallEvent(pageNo + 1,
            ProductPaginationRequest(CompanyId: CompanyID, ActiveFlag: "1"))),
      child: BlocConsumer<ProductGroupBloc, ProductStates>(
        builder: (BuildContext context, ProductStates state) {
          if (state is ProductMasterPaginationResponseState) {
            productlistsuccess(state);
          }
          if (state is ProductMasterPaginationSearchResponseState) {
            productsearchsuccess(state);
          }
          if (state is CategoryListResponseState) {
            _OnAllProductBrandGroupSearchSucess(state, context);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ProductMasterPaginationResponseState ||
              currentState is ProductMasterPaginationSearchResponseState ||
              currentState is CategoryListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ProductStates state) {
          if (state is ProductMasterPaginationSearchResponseState) {
            productsearchsuccess(state);
          }
          if (state is ProductMasterDeleteResponseState) {
            productdeletesuccess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ProductMasterPaginationSearchResponseState ||
              currentState is ProductMasterDeleteResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackpress,
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorWhite),
              onPressed: () => navigateTo(
                  context, ExploreDashBoardScreen.routeName,
                  clearAllStack: true)),
          backgroundColor: Getirblue,
          title: Text(
            "Product Search",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    searchbar.text = "";
                    productGroupBloc.add(ProductMasterPaginationCallEvent(
                        1,
                        ProductPaginationRequest(
                            CompanyId: CompanyID, ActiveFlag: "1")));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Column(
                      children: [
                        buildsearch(),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(child: _buildInquiryList()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildsearch() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Card(
        elevation: 5,
        color: colorLightGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 20, right: 20),
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                    controller: searchbar,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    //enabled: false,

                    //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                    decoration: InputDecoration(
                      hintText: "Tap To Search",
                      labelStyle: TextStyle(
                        color: Color(0xFF000000),
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF000000),
                    ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),
              ),
              Icon(Icons.search),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInquiryList() {
    if (Response == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(
            scrollInfo,
          )) {
            _onProductMasterPagination();
            return true;
          } else {
            return false;
          }
        },
        child: Response.details.length != 0
            ? ListView.builder(
                key: Key('selected $selected'),
                itemBuilder: (context, index) {
                  return _buildCustomerList(index);
                },
                shrinkWrap: true,
                itemCount: Response.details.length,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ListSearchNotFound,
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      searchbar.text == ""
                          ? " No Product Exist !"
                          : "Search Keyword Not Matched !",
                      style: TextStyle(
                          color: Getirblue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ));
  }

  Widget _buildCustomerList(int index) {
    return ExpantionCustomer(context, index);
  }

  void _onProductMasterPagination() {
    productGroupBloc.add(ProductMasterPaginationCallEvent(
        pageNo + 1, ProductPaginationRequest(CompanyId: CompanyID)));
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    // CategoryListResponseDetails PD = Response.details[index];

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: InkWell(
        onTap: () {
          GroceryItem groceryItem = GroceryItem();
          groceryItem.ProductName = Response.details[index].productName;
          groceryItem.ProductID = Response.details[index].pkID;
          groceryItem.ProductAlias = Response.details[index].productAlias;
          groceryItem.CustomerID = _offlineLogindetails.details[0].customerID;
          groceryItem.Unit = Response.details[index].unit;
          groceryItem.UnitPrice = Response.details[index].unitPrice;
          groceryItem.Quantity = 1.00;
          groceryItem.DiscountPer = Response.details[index].discountPercent;
          groceryItem.LoginUserID = LoginUserID;
          groceryItem.ComapanyID = CompanyID;
          groceryItem.ProductSpecification =
              Response.details[index].productSpecification;
          groceryItem.ProductImage = _offlineCompanydetails.details[0].siteURL +
              "/productimages/" +
              Response.details[index].productImage;
          print("ldjjfgjfdgjjg" + "Item Clicked");

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(groceryItem)),
          );
        },
        child: Card(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Row(
              children: [
                Container(
                  child: Response.details[index].productImage != "no-figure.png"
                      ? Image.network(
                          _offlineCompanydetails.details[0].siteURL +
                              "/productimages/" +
                              Response.details[index].productImage,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                          return child;
                        }, loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CircularProgressIndicator();
                          }
                        }, errorBuilder: (BuildContext context,
                              Object exception, StackTrace stackTrace) {
                          return Icon(Icons.error);
                        }, height: 42, width: 42, fit: BoxFit.cover)
                      : Image.asset(
                          NO_IMAGE_FOUND,
                          height: 48,
                          width: 48,
                        ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  Response.details[index].productName,
                  style: TextStyle(
                      fontSize: 12,
                      color: Getirblue,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );
    /*return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: InkWell(
                onTap: () {
                  GroceryItem groceryItem = GroceryItem();
                  groceryItem.ProductName = Response.details[index].productName;
                  groceryItem.ProductID = Response.details[index].pkID;
                  groceryItem.ProductAlias =
                      Response.details[index].productAlias;
                  groceryItem.CustomerID =
                      _offlineLogindetails.details[0].customerID;
                  groceryItem.Unit = Response.details[index].unit;
                  groceryItem.UnitPrice = Response.details[index].unitPrice;
                  groceryItem.Quantity = 1.00;
                  groceryItem.DiscountPer =
                      Response.details[index].discountPercent;
                  groceryItem.LoginUserID = LoginUserID;
                  groceryItem.ComapanyID = CompanyID;
                  groceryItem.ProductSpecification =
                      Response.details[index].productSpecification;
                  groceryItem.ProductImage =
                      _offlineCompanydetails.details[index].siteURL +
                          "/productimages/" +
                          Response.details[index].productImage;
                  print("ldjjfgjfdgjjg" + "Item Clicked");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(groceryItem)),
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Getirblue, width: 2.00),
                  ),
                  child: Text(Response.details[index].productName),
                )


                ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );*/
  }

  void productlistsuccess(ProductMasterPaginationResponseState state) {
    if (pageNo != state.newpage || state.newpage == 1) {
      //checking if new data is arrived
      if (state.newpage == 1) {
        //resetting search
        Response = state.response;
      } else {
        Response.details.addAll(state.response.details);
      }
      pageNo = state.newpage;
    }
  }

  void productsearchsuccess(ProductMasterPaginationSearchResponseState state) {
    Response = state.response;
  }

  void productdeletesuccess(ProductMasterDeleteResponseState state) {
    commonalertbox(state.response.details[0].column2, onTapofPositive: () {
      //Navigator.pop(context);
      // navigateTo(context, ProductPagination.routeName);
    });
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

  void _onTapOfDelete(productID) {
    showCommonDialogWithTwoOptions(
      context,
      "Do you want to Delete This Product?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.pop(context);
        productGroupBloc.add(ProductMasterDeleteCallEvent(
            productID, ProductPaginationDeleteRequest(CompanyId: CompanyID)));
      },
    );
  }

  void _onTapOfEditproduct(ProductPaginationDetails details) {
    navigateTo(context, ManageProduct.routeName,
        clearAllStack: true, arguments: EditProduct(details));
  }

  Future<bool> _onBackpress() {
    navigateTo(context, ExploreDashBoardScreen.routeName, clearAllStack: true);
    // Navigator.pop(context);
  }

  void _OnAllProductBrandGroupSearchSucess(
      CategoryListResponseState state, BuildContext context) {
    //categoryListResponse = state.response;
    //categoryListResponseDetails = state.response.details;
    arrcategoryListResponseDetails.clear();
    arrcategoryListResponseDetails.addAll(state.response.details);
  }
}
/**/

/*buildsearch(),
          SizedBox(height: 10,),
          Expanded(child: _buildInquiryList()),*/
