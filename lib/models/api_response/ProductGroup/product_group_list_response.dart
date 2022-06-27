class ProductGroupListResponse {
  List<ProductGroupListResponseDetails> details;
  int totalCount;

  ProductGroupListResponse({this.details, this.totalCount});

  ProductGroupListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductGroupListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class ProductGroupListResponseDetails {
  int rowNum;
  int pkID;
  String productGroupName;
  bool activeFlag;
  String activeFlagDesc;
  String productGroupImage;
  String BrandName;
  int BrandID;

  ProductGroupListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.productGroupName,
      this.activeFlag,
      this.activeFlagDesc,
      this.productGroupImage,
      this.BrandName,
      this.BrandID});

  ProductGroupListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    productGroupName =
        json['ProductGroupName'] == null ? "" : json['ProductGroupName'];
    activeFlag = json['ActiveFlag'] == null ? false : json['ActiveFlag'];
    activeFlagDesc =
        json['ActiveFlagDesc'] == null ? "" : json['ActiveFlagDesc'];
    productGroupImage =
        json['ProductGroupImage'] == null ? "" : json['ProductGroupImage'];

    BrandName = json['BrandName'] == null ? "" : json['BrandName'];
    BrandID = json['BrandID'] == null ? 0 : json['BrandID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ProductGroupName'] = this.productGroupName;
    data['ActiveFlag'] = this.activeFlag;
    data['ActiveFlagDesc'] = this.activeFlagDesc;
    data['ProductGroupImage'] = this.productGroupImage;
    data['BrandName'] = this.BrandName;
    data['BrandID'] = this.BrandID;

    return data;
  }
}
