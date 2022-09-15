import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/database_models/InwardProductModel.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/inward_product_add_edit_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';

class AddProductListArgument {
  String inquiry_No;

  AddProductListArgument(this.inquiry_No);
}

class InquiryProductListScreen extends BaseStatefulWidget {
  static const routeName = '/InquiryProductListScreen';
  final AddProductListArgument arguments;
  InquiryProductListScreen(this.arguments);
  @override
  _InquiryProductListScreenState createState() =>
      _InquiryProductListScreenState();
}

class _InquiryProductListScreenState extends BaseState<InquiryProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<InWardProductModel> _productList = [];
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    if (widget.arguments != null) {
      print("GetINQNOFRomList" + widget.arguments.inquiry_No);
    }
    //getContacts();
    getProduct();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      color: colorWhite,
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorWhite),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Getirblue,
            title: Text(
              "Product List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _buildContactsListView(),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: colorPrimary,
                    onPressed: () async {
                      await navigateTo(
                        context,
                        AddInquiryProductScreen.routeName,
                      );
                      getProduct(); //right now calling again get contacts, later it can be optimized
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsListView() {
    if (_productList.length != 0) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);

          /* return Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID:${_productList[index].id}"),
                          Text("InquiryNo: ${_productList[index].InquiryNo}"),
                          Text("ProductID:${_productList[index].ProductID}"),
                          Text("ProductName: ${_productList[index].ProductName}"),
                          Text("Quantity: ${_productList[index].Quantity}"),
                          Text("UnitPrice: ${_productList[index].UnitPrice}"),

                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _onTapOfEditContact(index);
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  _onTapOfDeleteContact(index);
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      )
                    ],
                  )),
            );*/
        },
        shrinkWrap: true,
        itemCount: _productList.length,
      );
    } else {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ListSearchNotFound,
            height: 200,
          ),
          Text(
            "No Product List Found !",
            style: TextStyle(
                color: Getirblue, fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ));
    }
  }

  Future<void> getProduct() async {
    _productList.clear();
    _productList
        .addAll(await OfflineDbHelper.getInstance().getInwardProductList());
    setState(() {});
  }

  /* Future<void> _onTapOfEditContact(int index) async {
    await navigateTo(context, AddInquiryProductScreen.routeName,
        arguments: AddInquiryProductScreenArguments(_productList[index]));

    getProduct(); //right now calling again get contacts, later it can be optimized
  }*/

  Future<void> _onTapOfDeleteContact(int index) async {
    await OfflineDbHelper.getInstance()
        .deleteInwardProduct(_productList[index].id);
    setState(() {
      _productList.removeAt(index);
    });
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    InWardProductModel model = _productList[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,

          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
          leading: CircleAvatar(
              backgroundColor: Color(0xFF504F4F),
              child: Image.asset(
                PRODUCT_ICON,
                height: 48,
                width: 48,
              )), //Image.network("https://cdn-icons.flaticon.com/png/512/4785/premium/4785452.png?token=exp=1639741267~hmac=4fc9726eef0cf39128308a40039ea5ca", height: 35, fit: BoxFit.fill,width: 35,)),
          title: Text(
            model.ProductName,
            style: TextStyle(color: Colors.black),
          ),

          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Container(
                    margin: EdgeInsets.all(20),
                    child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Quantity.  ",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    model.Quantity == 0.00
                                                        ? "N/A"
                                                        : model.Quantity
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("UnitPrice",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    model.UnitRate == 0.00
                                                        ? "N/A"
                                                        : model.UnitRate
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Total Amount",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    model.NetAmount == 0.00
                                                        ? "N/A"
                                                        : model.NetAmount
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            ))
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))),
              ),
            ),
            ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                buttonHeight: 52.0,
                buttonMinWidth: 90.0,
                children: <Widget>[
                  GestureDetector(
                    /* shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),*/
                    onTap: () {
                      _onTapOfEditContact(index);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: colorPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Text(
                          'Edit',
                          style: TextStyle(color: colorPrimary),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    /* shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),*/
                    onTap: () {
                      _onTapOfDeleteContact(index);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: colorPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(color: colorPrimary),
                        ),
                      ],
                    ),
                  ),
                ]),
          ],
        ));
  }

  Future<void> _onTapOfEditContact(int index) async {
    await navigateTo(context, AddInquiryProductScreen.routeName,
        arguments: AddInquiryProductScreenArguments(_productList[index]));

    getProduct(); //right now calling again get contacts, later it can be optimized
  }
}
