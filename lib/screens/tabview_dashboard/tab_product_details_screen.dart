import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/models/Model_for_dropdown/Model_for_list.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_group_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_view_product_item.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class AddTabProductScreenArguments {
  String ProductGroupID;

  AddTabProductScreenArguments(this.ProductGroupID);
}

class TabProductPage extends BaseStatefulWidget {
  static const routeName = '/TabProductPage';

  final AddTabProductScreenArguments arguments;
  TabProductPage(this.arguments);

  @override
  _TabProductPageState createState() => _TabProductPageState();
}

class _TabProductPageState extends BaseState<TabProductPage>
    with BasicScreen, WidgetsBindingObserver, TickerProviderStateMixin {
  String _ProductGroupID;

  List<String> data = [];
  List<String> Subdata = [];
  List<ALL_NAME_ID> Subdata1 = [];

  List<ALL_NAME_ID> data1 = [];

  int initPosition = 0;
  CategoryScreenBloc _categoryScreenBloc;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  List<GroceryItem> BestSellingProducts = [];

  List<String> tabsText = ["one", "two", "three"];
  List<String> secondTabsText = ["one", "two", "three"];
  TabController _controller1;
  TabController _childController1;
  List<Widget> tabContent = [];
  List<Tab> _tabs = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _ProductGroupID = widget.arguments.ProductGroupID;
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    _categoryScreenBloc = CategoryScreenBloc(baseBloc);
    _categoryScreenBloc.add(TabProductGroupListCallEvent(
        TabProductGroupListRequest(
            SearchKey: "",
            ActiveFlag: "1",
            CompanyId: CompanyID,
            BrandID: _ProductGroupID.toString())));

    _controller1 = TabController(length: data1.length, vsync: this);
    _childController1 =
        TabController(length: secondTabsText.length, vsync: this);

    print("Productffh" + "Prodjj " + _ProductGroupID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          /*if (state is ProductGroupListResponseState) {
            _onCategoryResponse(state, context);
          }*/
          if (state is TabProductGroupListResponseState) {
            _onBrandResponse(state, context);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (/*currentState is ProductGroupListResponseState ||*/
              currentState is TabProductGroupListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {
          /*if (state is TabProductGroupListResponseState) {
            _onProductGroupResponse(state, context);
          }*/

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is TabProductGroupListResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return data1.isNotEmpty
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: data1.isNotEmpty
                    ? CustomTabView(
                        initPosition: initPosition,
                        itemCount: data1.length,
                        tabBuilder: (context, index) =>
                            Tab(text: data1[index].Name),
                        pageBuilder: (context, index) => TabProductItemsScreen(
                            AddTabProductItemsScreenArguments(
                                data1[index].id.toString(), _ProductGroupID)),
                        onPositionChange: (index) {
                          print('current position: Brand ID : ' +
                              data1[index].id);

                          initPosition = index;
                        },
                        onScroll: (position) => print('$position'),
                      )
                    : Center(
                        child: Image.asset(
                          NO_DASHBOARD,
                          width: 250,
                        ),
                      )),
          )
        : Center(
            child: Image.asset(
              NO_DASHBOARD,
              width: 250,
            ),
          );
  }

  void _onBrandResponse(
      TabProductGroupListResponseState state, BuildContext context) {
    data.clear();
    data1.clear();
    _tabs.clear();
    //BestSellingProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      data.add(state.response.details[i].productGroupName);

      _tabs.add(Tab(child: Text(state.response.details[i].productGroupName)));

      ALL_NAME_ID all_name_id = ALL_NAME_ID();
      all_name_id.Name = state.response.details[i].productGroupName;
      all_name_id.id = state.response.details[i].productGroupID.toString();
      data1.add(all_name_id);
    }
  }
}

/// Implementation

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    this.itemCount,
    this.tabBuilder,
    this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController controller;
  TabController controller2;

  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            decoration: BoxDecoration(
              color: Getirbluelight,
              /*borderRadius: BorderRadius.circular(5),*/
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                TabBar(
                  indicator: BoxDecoration(
                      color: GetirYellow,
                      borderRadius: BorderRadius.circular(10.0)),
                  labelColor: Getirblue,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelColor: colorWhite,

                  isScrollable: true,
                  controller: controller,
                  // labelColor: Theme.of(context).primaryColor,
                  // unselectedLabelColor: Theme.of(context).hintColor,
                  /*indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),*/
                  tabs: List.generate(
                    widget.itemCount,
                    (index) => widget.tabBuilder(context, index),
                  ),
                ),
              ],
            )),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}
