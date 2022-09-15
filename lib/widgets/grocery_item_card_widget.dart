import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/image_resource.dart';

class GroceryItemCardWidget extends StatelessWidget {
  GroceryItemCardWidget({Key key, this.item}) : super(key: key);
  final GroceryItem item;

  final double width = 174;
  final double height = 250;
  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 18;

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
              child: Container(
                child: Center(
                  child: imageWidget(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AppText(
              text: item.ProductName,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            /*AppText(
              text: item.ProductSpecification,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7C7C7C),
            ),*/
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                AppText(
                  text: "\£${item.UnitPrice.toStringAsFixed(2)}",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                Spacer(),
                addWidget()
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

          Image.network(
        item.ProductImage,
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
      ),
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
}
