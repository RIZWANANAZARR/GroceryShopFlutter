class TabProductGroupListResponse {
  List<TabProductGroupListResponseDetails> details;
  int totalCount;

  TabProductGroupListResponse({this.details, this.totalCount});

  TabProductGroupListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new TabProductGroupListResponseDetails.fromJson(v));
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

class TabProductGroupListResponseDetails {
  int brandID;
  String brandName;
  int productGroupID;
  String productGroupName;
  String productGroupImage;

  TabProductGroupListResponseDetails(
      {this.brandID,
      this.brandName,
      this.productGroupID,
      this.productGroupName,
      this.productGroupImage});

  TabProductGroupListResponseDetails.fromJson(Map<String, dynamic> json) {
    brandID = json['BrandID'] == null ? 0 : json['BrandID'];
    brandName = json['BrandName'] == null ? "" : json['BrandName'];
    productGroupID =
        json['ProductGroupID'] == null ? 0 : json['ProductGroupID'];
    productGroupName =
        json['ProductGroupName'] == null ? "" : json['ProductGroupName'];
    productGroupImage =
        json['ProductGroupImage'] == null ? "" : json['ProductGroupImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['ProductGroupID'] = this.productGroupID;
    data['ProductGroupName'] = this.productGroupName;
    data['ProductGroupImage'] = this.productGroupImage;
    return data;
  }
}
