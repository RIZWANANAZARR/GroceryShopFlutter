import 'package:flutter/material.dart';
import 'package:grocery_app/styles/colors.dart';

class ItemCounterWidget extends StatefulWidget {
  final Function onAmountChanged;

  const ItemCounterWidget({Key key, this.onAmountChanged}) : super(key: key);

  @override
  _ItemCounterWidgetState createState() => _ItemCounterWidgetState();
}

class _ItemCounterWidgetState extends State<ItemCounterWidget> {
  int amount = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget(Icons.remove,
              iconColor: AppColors.primaryColor, onPressed: decrementAmount),
          SizedBox(width: 5),
          Container(
              width: 10,
              height: 10,
              color: Colors.white,
              child: Center(
                  child: getText(
                      text: amount.toString(), fontSize: 10, isBold: true))),
          SizedBox(width: 5),
          iconWidget(Icons.add,
              iconColor: AppColors.primaryColor, onPressed: incrementAmount)
        ],
      ),
    );
  }

  void incrementAmount() {
    setState(() {
      amount = amount + 1;
      updateParent();
    });
  }

  void decrementAmount() {
    if (amount <= 0) return;
    setState(() {
      amount = amount - 1;
      updateParent();
    });
  }

  void updateParent() {
    if (widget.onAmountChanged != null) {
      widget.onAmountChanged(amount);
    }
  }

  Widget iconWidget(IconData iconData, {Color iconColor, onPressed}) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Color(0xffE2E2E2),
            ),
            color: Colors.white),
        child: Center(
          child: Icon(
            iconData,
            color: iconColor ?? Colors.black,
            size: 10,
          ),
        ),
      ),
    );
  }

  Widget getText(
      {String text,
      double fontSize,
      bool isBold = false,
      color = Colors.black}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color,
      ),
    );
  }
}
