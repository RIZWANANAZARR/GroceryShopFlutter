import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/product/product_bloc.dart';
import 'package:grocery_app/models/Model_for_dropdown/Model_for_list.dart';
import 'package:grocery_app/models/api_request/product_brand/brand_image_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/brand_upload_image_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_save_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_response.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_brand/product_brand_list.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/image_full_screen.dart';

class EditProductBrand {
  ProductBrandDetails detail;

  EditProductBrand(this.detail);
}

class ManageProductBrand extends BaseStatefulWidget {
  static const routeName = '/ManageProductBrand';
  EditProductBrand edit;

  ManageProductBrand(this.edit);

  @override
  _ManageProductBrandState createState() => _ManageProductBrandState();
}

class _ManageProductBrandState extends BaseState<ManageProductBrand>
    with BasicScreen, WidgetsBindingObserver {
  double height = 50;
  ProductGroupBloc productGroupBloc;
  int id = 0;
  List<ALL_NAME_ID> PG = [];
  List<ALL_NAME_ID> PB = [];

  TextEditingController brandname = TextEditingController();
  TextEditingController brandalias = TextEditingController();

  ProductBrandDetails PD;
  File _selectedImageFile;
  String fileName;
  String ImageURLFromListing = "";
  String GetImageNamefromEditMode = "";

  bool _isForUpdate = false;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  bool isImageDeleted = false;
  bool _isswitch = true;

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
    _isForUpdate = widget.edit != null;
    if (_isForUpdate) {
      PD = widget.edit.detail;
      filldata();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => productGroupBloc,
      child: BlocConsumer<ProductGroupBloc, ProductStates>(
        builder: (BuildContext context, ProductStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, ProductStates state) {
          if (state is ProductBrandSaveResponseState) {
            _onproductbrandsavesuccess(state);
          }
          if (state is BrandImageUploadResponseState) {
            _onBrnadImageUploadSucess(state);
          }
          if (state is BrandImageDeleteResponseState) {
            _onBrnadImageDeleteSucess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ProductBrandSaveResponseState ||
              currentState is BrandImageUploadResponseState ||
              currentState is BrandImageDeleteResponseState) {
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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorWhite),
            onPressed: () => navigateTo(
                context, ProductBrandPagination.routeName,
                clearAllStack: true),
          ),
          backgroundColor: Getirblue,
          title: Text(
            "Manage Product Brand",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 23),
                        child: Text("Brand Name",
                            style: TextStyle(
                              fontSize: 15,
                              color: Getirblue,
                            )),
                      ),
                    ), //heading
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 5,
                        color: colorLightGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                    controller: brandname,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    //enabled: false,

                                    //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                    decoration: InputDecoration(
                                      hintText: "Enter Product Brand",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 23),
                        child: Text("Brand Alias",
                            style: TextStyle(
                              fontSize: 15,
                              color: Getirblue,
                            )),
                      ),
                    ), //heading
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 5,
                        color: colorLightGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                    controller: brandalias,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    //enabled: false,

                                    //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                    decoration: InputDecoration(
                                      hintText: "Enter Product Brand Alias",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text("Product Status",
                            style: TextStyle(
                              fontSize: 15,
                              color: Getirblue,
                            )),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 10),
                      child: Switch(
                        value: _isswitch,
                        onChanged: switchchange,
                        activeColor: Colors.white,
                        activeTrackColor: Getirblue,
                        inactiveTrackColor: Colors.red,
                        inactiveThumbColor: Colors.white,
                      ),
                    ),
                    _isswitch ? activetext() : inactivetext(),
                    SizedBox(
                      height: 20,
                    ),
                    uploadImage(context),
                    SizedBox(
                      height: 20,
                    ),

                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Getirblue),
                      ),
                      onPressed: () {
                        ontapofsave();
                      },
                      child: Text(
                        "Save Brand",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ontapofsave() {
    if (brandname.text == "") {
      commonalertbox("Fill Product Brand Name.");
    } else if (brandalias.text == "") {
      commonalertbox("Fill Product Brand Alias.");
    } else {
      if (_selectedImageFile != null) {
        fileName = _selectedImageFile.path.split('/').last;
      } else {
        fileName = GetImageNamefromEditMode;
      }
      if (isImageDeleted == true) {
        fileName = "";
      }
      showCommonDialogWithTwoOptions(
        context,
        "Do You Want To Save This Details?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes",
        onTapOfPositiveButton: () {
          Navigator.pop(context);
          productGroupBloc.add(ProductBrandSaveCallEvent(
              id,
              ProductBrandSaveRequest(
                BrandAlias: brandalias.text.toString(),
                BrandName: brandname.text.toString(),
                ActiveFlag: _isswitch == true ? 1 : 0,
                CompanyId: CompanyID,
                LoginUserID: LoginUserID,
              )));
        },
      );
    }
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

  void _onproductbrandsavesuccess(ProductBrandSaveResponseState state) {
    if (state.response.details[0].column2 == "Brand Added Successfully" ||
        state.response.details[0].column2 == "Brand Updated Successfully") {
      if (isImageDeleted == true) {
        productGroupBloc.add(BrandImageDeleteCallEvent(
            id, BrandImageDeleteRequest(CompanyId: CompanyID.toString())));
      }

      if (_selectedImageFile != null) {
        productGroupBloc.add(BrandUploadImageRequestEvent(
            state.response.details[0].column2,
            _selectedImageFile,
            BrandUploadImageRequest(
              pkID: state.response.details[0].column3.toString(),
              CompanyId: CompanyID.toString(),
              FileName: /*fileName*/ DateTime.now().microsecond.toString() +
                  ".png",
              LoginUserID: LoginUserID,
            )));
      } else {
        commonalertbox(state.response.details[0].column2,
            onTapofPositive: () async {
          Navigator.pop(context);
          navigateTo(context, ProductBrandPagination.routeName,
              clearSingleStack: true);
        });
      }
    } else {
      commonalertbox(state.response.details[0].column2,
          onTapofPositive: () async {
        Navigator.pop(context);
        //navigateTo(context, ProductPagination.routeName, clearSingleStack: true);
      });
    }
  }

  void filldata() {
    id = PD.pkID;
    brandname.text = PD.brandName.toString();
    brandalias.text = PD.brandAlias.toString();
    setState(() {
      if (PD.activeFlag == false) {
        setState(() {
          _isswitch = false;
        });
      } else if (PD.activeFlag == true) {
        setState(() {
          _isswitch = true;
        });
      }
    });

    if (PD.brandImage != null) {
      ImageURLFromListing = "";

      var splitert = _offlineCompanydetails.details[0].siteURL.split("/");

      print("djfsdfj" +
          splitert[0] +
          " 2nd " +
          splitert[1] +
          " 3nd " +
          splitert[2]);

      /*ImageURLFromListing = "http://" +
          splitert[2] +
          "/productimages/" +
          PD.productImage.toString().trim();*/

      ImageURLFromListing =
          _offlineCompanydetails.details[0].siteURL.toString().trim() +
              "productbrandimages/" +
              PD.brandImage.toString();

      if (PD.brandImage.toString() == "null" ||
          PD.brandImage.toString() == "") {
        ImageURLFromListing = "";
      } else {
        ImageURLFromListing =
            _offlineCompanydetails.details[0].siteURL.toString().trim() +
                "productbrandimages/" +
                PD.brandImage.toString();
      }
      print("ImageURLFromListing" +
          "ImageURLFromListing : " +
          ImageURLFromListing);
      GetImageNamefromEditMode = PD.brandImage.toString();
      print("ImageURLFromListing1235" +
          "ImageURLFromListing : " +
          GetImageNamefromEditMode);
    } else {
      ImageURLFromListing = "";
    }
  }

  Widget uploadImage(BuildContext context123) {
    return Column(
      children: [
        _selectedImageFile == null
            ? _isForUpdate //edit mode or not
                ? Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ImageURLFromListing.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white60,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: ImageFullScreenWrapperWidget(
                                  child: Image.network(
                                    ImageURLFromListing,
                                    frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) {
                                      return child;
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                    height: 125,
                                    width: 125,
                                  ),
                                  dark: true,
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    // padding: const EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white60,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
/*
                                    margin: EdgeInsets.only(left: 180),
*/
                                    child: GestureDetector(
                                      onTap: () {
                                        showCommonDialogWithTwoOptions(context,
                                            "Are you sure you want to delete this Image ?",
                                            negativeButtonTitle: "No",
                                            positiveButtonTitle: "Yes",
                                            onTapOfPositiveButton: () {
                                          _isForUpdate = false;
                                          isImageDeleted = true;
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete_forever,
                                        size: 32,
                                        color: colorPrimary,
                                      ),
                                    ),
                                  )),
                            ],
                          )
                        : Container())
                : Container()
            : Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageFullScreenWrapperWidget(
                    child: Image.file(
                      _selectedImageFile,
                      height: 125,
                      width: 125,
                    ),
                    dark: true,
                  ),
                ),
              ),
        getCommonButton(baseTheme, () {
          pickImage(context, onImageSelection: (file) {
            final bytes = file.readAsBytesSync().lengthInBytes;
            final kb = bytes / 1024;
            final mb = kb / 1024;

            if (mb < 5) {
              _selectedImageFile = file;
              isImageDeleted = false;
            } else {
              commonalertbox("The Maximum Size \nFor File Upload Is 4 MB !");
            }

            baseBloc.refreshScreen();
          });
        }, "Upload Image", backGroundColor: Colors.indigoAccent)
      ],
    );
  }

  Future<bool> _onBackpress() {
    navigateTo(context, ProductBrandPagination.routeName, clearAllStack: true);
  }

  void _onBrnadImageUploadSucess(BrandImageUploadResponseState state) {
    commonalertbox(state.headerMsg, onTapofPositive: () {
      // Navigator.pop(context);
      navigateTo(context, ProductBrandPagination.routeName,
          clearSingleStack: true);
    });
  }

  switchchange(value) {
    if (_isswitch) {
      setState(() {
        _isswitch = !_isswitch;
      });
    } else if (!_isswitch) {
      setState(() {
        _isswitch = true;
      });
    }
  }

  Widget activetext() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20),
      child: Text(
        "Active",
        style: TextStyle(
            fontSize: 15, color: Getirblue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget inactivetext() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20),
      child: Text(
        "Inactive",
        style: TextStyle(
            fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _onBrnadImageDeleteSucess(BrandImageDeleteResponseState state) {
    _isForUpdate = false;
    isImageDeleted = true;
    setState(() {});
  }
}
