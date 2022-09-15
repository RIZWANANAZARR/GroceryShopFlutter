import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/category_item.dart';
import 'package:grocery_app/ui/image_resource.dart';

class CategoryItemCardWidget extends StatelessWidget {
  CategoryItemCardWidget({Key key, this.item, this.color = Colors.blue})
      : super(key: key);
  final CategoryItem item;

  final height = 200.0;

  final width = 175.0;

  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 18;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.7),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            child: imageWidget(),
          ),
          SizedBox(
            height: 10,
          ),
          AppText(
            text: item.name,
            textAlign: TextAlign.center,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          /* SizedBox(
            height: 20,
            child: Center(
              child: AppText(
                text: item.name,
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget imageWidget() {
    print("djdsjd" + "Image : " + item.imagePath);
    return Container(
      child: /*Image.asset(
        item.imagePath,
        fit: BoxFit.contain,
      ),*/
          Image.network(
        item.imagePath,
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
      )
      /* Image.network(
        item.imagePath,
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
          return Icon(Icons.error);
        },
        height: 35,
        width: 35,
      )*/
      ,
      //Image.network(item.imagePath,fit: BoxFit.contain)
    );
  }
}
