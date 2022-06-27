import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';

class AboutUsDialogue extends StatelessWidget {
  static const routeName = '/AboutUsDialogue';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      insetPadding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
        ),
        height: 600.0,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            /* Spacer(
              flex: 10,
            ),*/
            /* Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
              ),
              child: Image(
                  image: AssetImage("assets/images/order_failed_image.png")),
            ),
            Spacer(
              flex: 5,
            ),*/
            AppText(
              text: "SK Spices",
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            Spacer(
              flex: 2,
            ),
            AppText(
              text: "\n-  Spare more with Sk Spices! We give you the most minimal costs on the entirety of your grocery needs." +
                  "\n\n- SK Spices is a low-cost online general store that gets items crosswise over classifications like grocery, natural products and vegetables, excellence and health, family unit care, infant care, pet consideration, and meats and fish conveyed to your doorstep." +
                  "\n\n- Browse more than 5,000 items at costs lower than markets each day!" +
                  "\n\n- Calendar conveyance according to your benefit.",
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff7C7C7C),
            ),
            Spacer(
              flex: 8,
            ),
            /* AppButton(
              label: "Please Try Again",
              fontWeight: FontWeight.w600,
              onPressed: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return OrderAcceptedScreen();
                  },
                ));
              },
            ),
            Spacer(
              flex: 4,
            ),*/
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: AppText(
                text: "Back To Home",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
