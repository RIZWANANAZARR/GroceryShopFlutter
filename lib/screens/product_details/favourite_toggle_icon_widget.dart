import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';

class FavoriteToggleIcon extends StatefulWidget {
  final GroceryItem _item;
  const FavoriteToggleIcon(this._item);

  @override
  _FavoriteToggleIconState createState() => _FavoriteToggleIconState();
}

class _FavoriteToggleIconState extends State<FavoriteToggleIcon> {
  bool favorite = false;
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          favorite = !favorite;
          if (favorite == true) {
            _OnTaptoAddProductinCartFavorit();
          } else {
            _onTapOfDeleteContact();
          }
        });
      },
      child: Icon(
        favorite ? Icons.favorite : Icons.favorite_border,
        color: favorite ? Colors.red : Colors.blueGrey,
        size: 30,
      ),
    );
  }

  _OnTaptoAddProductinCartFavorit() async {
    String name = widget._item.ProductName;
    String Alias = widget._item.ProductName;
    int ProductID = widget._item.ProductID;
    int CustomerID = widget._item.CustomerID;

    String Unit = widget._item.Unit;
    String description = widget._item.ProductSpecification;
    String ImagePath = widget._item.ProductImage;
    int Qty = widget._item.Quantity.toInt();
    double Amount = widget._item.UnitPrice; //getTotalPrice();
    double DiscountPer = widget._item.DiscountPer;
    String LoginUserID = widget._item.LoginUserID;
    String CompanyID = widget._item.ComapanyID;
    String ProductSpecification = widget._item.ProductSpecification;
    String ProductImage = widget._item.ProductImage;
    double Vat = widget._item.Vat;

    print("dfjfdsff" + "Vat : " + widget._item.Vat.toString());

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

    await OfflineDbHelper.getInstance()
        .insertProductToCartFavorit(productCartModel);

    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    //navigateTo(context, DashboardScreen.routeName,clearAllStack: true);
  }

  Future<void> _onTapOfDeleteContact() async {
    await OfflineDbHelper.getInstance()
        .deleteContactFavorit(widget._item.ProductID);
    fToast.showToast(
      child: showCustomToast(Title: "Item Remove To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
