class ProductGroupDropDownResponse {
  List<ProductGroupDropDownDetails> details;
  int totalCount;

  ProductGroupDropDownResponse({this.details, this.totalCount});

  ProductGroupDropDownResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductGroupDropDownDetails.fromJson(v));
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

class ProductGroupDropDownDetails {
  int productGroupID;
  String productGroupName;

  ProductGroupDropDownDetails({this.productGroupID, this.productGroupName});

  ProductGroupDropDownDetails.fromJson(Map<String, dynamic> json) {
    productGroupID = json['ProductGroupID'];
    productGroupName = json['ProductGroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductGroupID'] = this.productGroupID;
    data['ProductGroupName'] = this.productGroupName;
    return data;
  }
}
